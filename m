Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B405AB0B0
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbiIBM6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238196AbiIBM4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:56:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC266B8D4;
        Fri,  2 Sep 2022 05:39:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC4B0620C5;
        Fri,  2 Sep 2022 12:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F84C433D7;
        Fri,  2 Sep 2022 12:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121699;
        bh=viyntUJVeoiLePXjjdQmgHgxrdmmNar39wGScCadoLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpI0XTIjBa4bKcMB2/9hMXr4BLtNptcVzgUoE4vbCsYGgpoU5nj5bhIZ62c6QairJ
         PHnH3k1K8EnuyP5JB1mTqEa24ewDTo0gM5RP96/GuBkQJfVNkP+cFjhXRz7YuZwPwX
         KBfLA/NYw6gLOl0hqb+prnsH7e6pHXXkZEsnfvfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 37/77] btrfs: replace: drop assert for suspended replace
Date:   Fri,  2 Sep 2022 14:18:46 +0200
Message-Id: <20220902121404.886346717@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
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
@@ -918,8 +918,7 @@ int btrfs_dev_replace_cancel(struct btrf
 		up_write(&dev_replace->rwsem);
 
 		/* Scrub for replace must not be running in suspended state */
-		ret = btrfs_scrub_cancel(fs_info);
-		ASSERT(ret != -ENOTCONN);
+		btrfs_scrub_cancel(fs_info);
 
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {


