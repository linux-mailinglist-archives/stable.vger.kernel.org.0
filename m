Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31E45A49C1
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiH2L3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbiH2L24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:28:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F1472EEF;
        Mon, 29 Aug 2022 04:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4228761202;
        Mon, 29 Aug 2022 11:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43461C433C1;
        Mon, 29 Aug 2022 11:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771367;
        bh=U/ohPyKzMC5biUBBcQAdl0use6FTjPDXkyxBV1VQ5NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duFAUbYweamS9J+Y3lIVd3/bfzdeX6UKLhxzbsz6/qU5DP7AbPXluzcb9yHBF+D46
         j9hjT7i9Pvu3mS0HC+q9cLZwCrNpkc+5OVZF981Zt3jEQv02BdNWoQWdrlihw5DT1t
         ucTOBCETXYGe/U3WUK9LXp/VW0FoR7HNKktouXSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 096/136] btrfs: replace: drop assert for suspended replace
Date:   Mon, 29 Aug 2022 12:59:23 +0200
Message-Id: <20220829105808.603626030@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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
@@ -1151,8 +1151,7 @@ int btrfs_dev_replace_cancel(struct btrf
 		up_write(&dev_replace->rwsem);
 
 		/* Scrub for replace must not be running in suspended state */
-		ret = btrfs_scrub_cancel(fs_info);
-		ASSERT(ret != -ENOTCONN);
+		btrfs_scrub_cancel(fs_info);
 
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {


