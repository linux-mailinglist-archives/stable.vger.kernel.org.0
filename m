Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6ACD591A8F
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239238AbiHMNWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbiHMNWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:22:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65EF37F96
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 06:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C18860DD3
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 13:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E7CC433D6;
        Sat, 13 Aug 2022 13:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660396967;
        bh=PZYD2dJRjoT2uCkrh91vJ5R7Uo06tJycfGF7/PhJTSE=;
        h=Subject:To:Cc:From:Date:From;
        b=Ye/wPkDeMEXJgopW60ELgddUbxnY+MlZl5EmnHIbBrTIXxCTHqGKmwUr6jl5pEauF
         irMbib30MyQjLsx0Zey7SsGS/kN2EbudKzxy+kJEf0vzLk7nA/LlaFw08XlhUW59qg
         abKlEp+glSiumrsFqT2YM4w0l2TvEJ/M8/0kNs5s=
Subject: FAILED: patch "[PATCH] mtd: core: check partition before dereference" failed to apply to 5.19-stable tree
To:     penguin-kernel@I-love.SAKURA.ne.jp, oliver.sang@intel.com,
        richard@nod.at,
        syzbot+fe013f55a2814a9e8cfd@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 15:22:45 +0200
Message-ID: <16603969654870@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7ec4cdb321738d44ae5d405e7b6ac73dfbf99caa Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 25 Jul 2022 22:49:25 +0900
Subject: [PATCH] mtd: core: check partition before dereference

syzbot is reporting NULL pointer dereference at mtd_check_of_node() [1],
for mtdram test device (CONFIG_MTD_MTDRAM) is not partition.

Link: https://syzkaller.appspot.com/bug?extid=fe013f55a2814a9e8cfd [1]
Reported-by: syzbot <syzbot+fe013f55a2814a9e8cfd@syzkaller.appspotmail.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: ad9b10d1eaada169 ("mtd: core: introduce of support for dynamic partitions")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: stable@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 6fafea80fd98..a9b8be9f40dc 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -559,6 +559,8 @@ static void mtd_check_of_node(struct mtd_info *mtd)
 		return;
 
 	/* Check if a partitions node exist */
+	if (!mtd_is_partition(mtd))
+		return;
 	parent = mtd->parent;
 	parent_dn = dev_of_node(&parent->dev);
 	if (!parent_dn)

