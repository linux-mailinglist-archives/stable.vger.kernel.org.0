Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802614FD424
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345154AbiDLHUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351744AbiDLHMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8483717045;
        Mon, 11 Apr 2022 23:52:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FE5061045;
        Tue, 12 Apr 2022 06:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2F6C385A6;
        Tue, 12 Apr 2022 06:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746325;
        bh=Tx2cWBmqfuUvRqNfdWN2a2/BKlydxGPZPMXIhiHkc6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E01osOvgC5MOD0XIu1acgLZzOjP/3/jC2OrJItPjymMfnQLXy+anZWpStyICN4C40
         w2pw7Gzd+i8e9GMg57F5tMCDKS1Al+uBPwZ+nnEbBovxypLBOcJMLaHdYU+HxoP16G
         UDYseO026582off8QPERb5rvV5MKjF7DfNUFT0LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Ethan Lien <ethanlien@synology.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 225/277] btrfs: fix qgroup reserve overflow the qgroup limit
Date:   Tue, 12 Apr 2022 08:30:28 +0200
Message-Id: <20220412062948.555052743@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ethan Lien <ethanlien@synology.com>

commit b642b52d0b50f4d398cb4293f64992d0eed2e2ce upstream.

We use extent_changeset->bytes_changed in qgroup_reserve_data() to record
how many bytes we set for EXTENT_QGROUP_RESERVED state. Currently the
bytes_changed is set as "unsigned int", and it will overflow if we try to
fallocate a range larger than 4GiB. The result is we reserve less bytes
and eventually break the qgroup limit.

Unlike regular buffered/direct write, which we use one changeset for
each ordered extent, which can never be larger than 256M.  For
fallocate, we use one changeset for the whole range, thus it no longer
respects the 256M per extent limit, and caused the problem.

The following example test script reproduces the problem:

  $ cat qgroup-overflow.sh
  #!/bin/bash

  DEV=/dev/sdj
  MNT=/mnt/sdj

  mkfs.btrfs -f $DEV
  mount $DEV $MNT

  # Set qgroup limit to 2GiB.
  btrfs quota enable $MNT
  btrfs qgroup limit 2G $MNT

  # Try to fallocate a 3GiB file. This should fail.
  echo
  echo "Try to fallocate a 3GiB file..."
  fallocate -l 3G $MNT/3G.file

  # Try to fallocate a 5GiB file.
  echo
  echo "Try to fallocate a 5GiB file..."
  fallocate -l 5G $MNT/5G.file

  # See we break the qgroup limit.
  echo
  sync
  btrfs qgroup show -r $MNT

  umount $MNT

When running the test:

  $ ./qgroup-overflow.sh
  (...)

  Try to fallocate a 3GiB file...
  fallocate: fallocate failed: Disk quota exceeded

  Try to fallocate a 5GiB file...

  qgroupid         rfer         excl     max_rfer
  --------         ----         ----     --------
  0/5           5.00GiB      5.00GiB      2.00GiB

Since we have no control of how bytes_changed is used, it's better to
set it to u64.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Ethan Lien <ethanlien@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -117,7 +117,7 @@ struct btrfs_bio_ctrl {
  */
 struct extent_changeset {
 	/* How many bytes are set/cleared in this operation */
-	unsigned int bytes_changed;
+	u64 bytes_changed;
 
 	/* Changed ranges */
 	struct ulist range_changed;


