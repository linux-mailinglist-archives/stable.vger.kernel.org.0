Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A273613034
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiJaGOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJaGOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:14:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0864524C
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:14:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95B8360FCE
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942C4C433D6;
        Mon, 31 Oct 2022 06:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667196856;
        bh=pZ3oTStRX3nILQg3y6PAAzqUcCL9rE+Pm8lLm21e3Yc=;
        h=Subject:To:Cc:From:Date:From;
        b=NoJIQqV2WX3jEVRSJllWyRevsmz6P2ZF9lxP4pxZG6NprHd75doaha1WUuxwM9LjY
         9ryO3PWTveRZ/sD4k5LsYIVHjgXEVAhzAZOflN9CnCS3hiNJ6AA2wffFj6+egw068y
         lXi3vh6+4BeCIcg2+M8yDckYt/gYhQSKOnTOTdmw=
Subject: FAILED: patch "[PATCH] exec: Copy oldsighand->action under spin-lock" failed to apply to 5.4-stable tree
To:     bernd.edlinger@hotmail.de, keescook@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:15:12 +0100
Message-ID: <166719691229179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

5bf2fedca8f5 ("exec: Copy oldsighand->action under spin-lock")
021691559245 ("exec: Factor unshare_sighand out of de_thread and call it separately")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5bf2fedca8f59379025b0d52f917b9ddb9bfe17e Mon Sep 17 00:00:00 2001
From: Bernd Edlinger <bernd.edlinger@hotmail.de>
Date: Mon, 7 Jun 2021 15:54:27 +0200
Subject: [PATCH] exec: Copy oldsighand->action under spin-lock

unshare_sighand should only access oldsighand->action
while holding oldsighand->siglock, to make sure that
newsighand->action is in a consistent state.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/AM8PR10MB470871DEBD1DED081F9CC391E4389@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM

diff --git a/fs/exec.c b/fs/exec.c
index 349a5da91efe..32dc8cf5fceb 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1197,11 +1197,11 @@ static int unshare_sighand(struct task_struct *me)
 			return -ENOMEM;
 
 		refcount_set(&newsighand->count, 1);
-		memcpy(newsighand->action, oldsighand->action,
-		       sizeof(newsighand->action));
 
 		write_lock_irq(&tasklist_lock);
 		spin_lock(&oldsighand->siglock);
+		memcpy(newsighand->action, oldsighand->action,
+		       sizeof(newsighand->action));
 		rcu_assign_pointer(me->sighand, newsighand);
 		spin_unlock(&oldsighand->siglock);
 		write_unlock_irq(&tasklist_lock);

