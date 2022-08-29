Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19095A4AB8
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiH2Ltn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiH2LtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:49:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521978A1EA;
        Mon, 29 Aug 2022 04:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 246B7B80EF1;
        Mon, 29 Aug 2022 11:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA95C433D7;
        Mon, 29 Aug 2022 11:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771777;
        bh=Hm7ck0pyFkIzWB8bOJExwUSf4WH/YCxW04iZeChVs9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvz8Ir8BhHIUrfAcwYqMqZjfe2fNxFVeSaO1k1aAp5lk5o3Chc+C3DlCgiMz0VIOu
         7rVmL66btoeBaX4ENkfXp0ef1awamWzyCnE+b66P9wu2Spkmj3yD6oQCS5qDfPc6ua
         1IV75AJK80XuEQHFm3B4sk81s8dZt9lTJpNXmJ3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.19 095/158] btrfs: replace: drop assert for suspended replace
Date:   Mon, 29 Aug 2022 12:59:05 +0200
Message-Id: <20220829105813.046797635@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Anand Jain <anand.jain@oracle.com>

commit 59a3991984dbc1fc47e5651a265c5200bd85464e upstream.

If the filesystem mounts with the replace-operation in a suspended state
and try to cancel the suspended replace-operation, we hit the assert. The
assert came from the commit fe97e2e173af ("btrfs: dev-replace: replace's
scrub must not be running in suspended state") that was actually not
required. So just remove it.

 $ mount /dev/sda5 /btrfs

    BTRFS info (device sda5): cannot continue dev_replace, tgtdev is missing
    BTRFS info (device sda5): you may cancel the operation after 'mount -o degraded'

 $ mount -o degraded /dev/sda5 /btrfs <-- success.

 $ btrfs replace cancel /btrfs

    kernel: assertion failed: ret != -ENOTCONN, in fs/btrfs/dev-replace.c:1131
    kernel: ------------[ cut here ]------------
    kernel: kernel BUG at fs/btrfs/ctree.h:3750!

After the patch:

 $ btrfs replace cancel /btrfs

    BTRFS info (device sda5): suspended dev_replace from /dev/sda5 (devid 1) to <missing disk> canceled

Fixes: fe97e2e173af ("btrfs: dev-replace: replace's scrub must not be running in suspended state")
CC: stable@vger.kernel.org # 5.0+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/dev-replace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -1128,8 +1128,7 @@ int btrfs_dev_replace_cancel(struct btrf
 		up_write(&dev_replace->rwsem);
 
 		/* Scrub for replace must not be running in suspended state */
-		ret = btrfs_scrub_cancel(fs_info);
-		ASSERT(ret != -ENOTCONN);
+		btrfs_scrub_cancel(fs_info);
 
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {


