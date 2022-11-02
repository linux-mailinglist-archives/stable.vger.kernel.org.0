Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09406157CF
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiKBCj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiKBCj0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:39:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2139FD1A
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:39:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FC06616DB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF3CC433D6;
        Wed,  2 Nov 2022 02:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356764;
        bh=eRSc2W+981hT/U3LH9JxiuNv+uqr72DBPmGy+mSGHQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PH/h3q+Na1e/N6VKeVKpnARDvj8TWUysvKx2oAQPA1/KVkhqKpICKdcoXxSOV9mPi
         2ONZHk0iuDQYm06ZZRj4anDb1QziIkh+x71lOEzkE1wIPsEZwOXVWEoaOqOnyf3bbG
         kQW8W9R5ZZF0Yhq8feFuCUZIDkjOXdLOn+We+34g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.0 055/240] exec: Copy oldsighand->action under spin-lock
Date:   Wed,  2 Nov 2022 03:30:30 +0100
Message-Id: <20221102022112.644828761@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernd Edlinger <bernd.edlinger@hotmail.de>

commit 5bf2fedca8f59379025b0d52f917b9ddb9bfe17e upstream.

unshare_sighand should only access oldsighand->action
while holding oldsighand->siglock, to make sure that
newsighand->action is in a consistent state.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/AM8PR10MB470871DEBD1DED081F9CC391E4389@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1196,11 +1196,11 @@ static int unshare_sighand(struct task_s
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


