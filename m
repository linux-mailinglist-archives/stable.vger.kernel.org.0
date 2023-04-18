Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D65B6E633F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbjDRMjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbjDRMjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:39:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBE119A4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:39:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26020632C2
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38632C433D2;
        Tue, 18 Apr 2023 12:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821541;
        bh=gJleLW6bg7ntG8ihwYxRUcJ0eA9AqXpPFHotb/8krJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIUSlWpJCMcUtA//XIzi44njz2tM8LEgW4lApFT0rXVsacBnpdHxHCLmD5OBSZ+8X
         a1TyMmJb6G41IdXiYzzOUxZEvvkw2sG80ro47McyDexOURJSQGFv9KyB2bA3LenH4X
         imsXIpcyDaUBy/+0ioJ2D/6JpERNqjVeN5KjmSIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 10/91] btrfs: print checksum type and implementation at mount time
Date:   Tue, 18 Apr 2023 14:21:14 +0200
Message-Id: <20230418120305.904694785@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit c8a5f8ca9a9c7d5c5bc31d54f47ea9d86f93ed69 upstream.

Per user request, print the checksum type and implementation at mount
time among the messages. The checksum is user configurable and the
actual crypto implementation is useful to see for performance reasons.
The same information is also available after mount in
/sys/fs/FSID/checksum file.

Example:

  [25.323662] BTRFS info (device vdb): using sha256 (sha256-generic) checksum algorithm

Link: https://github.com/kdave/btrfs-progs/issues/483
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2318,6 +2318,9 @@ static int btrfs_init_csum_hash(struct b
 
 	fs_info->csum_shash = csum_shash;
 
+	btrfs_info(fs_info, "using %s (%s) checksum algorithm",
+			btrfs_super_csum_name(csum_type),
+			crypto_shash_driver_name(csum_shash));
 	return 0;
 }
 


