Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C1E5AED42
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241966AbiIFO1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242326AbiIFOZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:25:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422D29082A;
        Tue,  6 Sep 2022 06:53:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 249AF61551;
        Tue,  6 Sep 2022 13:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDF7C433D6;
        Tue,  6 Sep 2022 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471810;
        bh=VCnY46J0wAINlRc9Ut3LDnIf3xk61iDEYzji7d64BDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXfVjPFaWLW9XsYFyChQxStXHEBJR7ZjtuAj/fkGPNQyU70YPACO2vh+j2du8rIxm
         3ysHmZcj2xznWI7U/ZdOeSLwCHsqSEQia/gmficvTI6im1Ee7q7QstCJcm2mIRkF7j
         WdhmQIPCwwUx/LwyHt1wWeYG6YH79rQIUggESp/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e696806ef96cdd2d87cd@syzkaller.appspotmail.com,
        Tom Herbert <tom@herbertland.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+9fc084a4348493ef65d2@syzkaller.appspotmail.com
Subject: [PATCH 5.19 047/155] kcm: fix strp_init() order and cleanup
Date:   Tue,  6 Sep 2022 15:29:55 +0200
Message-Id: <20220906132831.402404997@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 8fc29ff3910f3af08a7c40a75d436b5720efe2bf ]

strp_init() is called just a few lines above this csk->sk_user_data
check, it also initializes strp->work etc., therefore, it is
unnecessary to call strp_done() to cancel the freshly initialized
work.

And if sk_user_data is already used by KCM, psock->strp should not be
touched, particularly strp->work state, so we need to move strp_init()
after the csk->sk_user_data check.

This also makes a lockdep warning reported by syzbot go away.

Reported-and-tested-by: syzbot+9fc084a4348493ef65d2@syzkaller.appspotmail.com
Reported-by: syzbot+e696806ef96cdd2d87cd@syzkaller.appspotmail.com
Fixes: e5571240236c ("kcm: Check if sk_user_data already set in kcm_attach")
Fixes: dff8baa26117 ("kcm: Call strp_stop before strp_done in kcm_attach")
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/r/20220827181314.193710-1-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/kcm/kcmsock.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 71899e5a5a111..1215c863e1c41 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1412,12 +1412,6 @@ static int kcm_attach(struct socket *sock, struct socket *csock,
 	psock->sk = csk;
 	psock->bpf_prog = prog;
 
-	err = strp_init(&psock->strp, csk, &cb);
-	if (err) {
-		kmem_cache_free(kcm_psockp, psock);
-		goto out;
-	}
-
 	write_lock_bh(&csk->sk_callback_lock);
 
 	/* Check if sk_user_data is already by KCM or someone else.
@@ -1425,13 +1419,18 @@ static int kcm_attach(struct socket *sock, struct socket *csock,
 	 */
 	if (csk->sk_user_data) {
 		write_unlock_bh(&csk->sk_callback_lock);
-		strp_stop(&psock->strp);
-		strp_done(&psock->strp);
 		kmem_cache_free(kcm_psockp, psock);
 		err = -EALREADY;
 		goto out;
 	}
 
+	err = strp_init(&psock->strp, csk, &cb);
+	if (err) {
+		write_unlock_bh(&csk->sk_callback_lock);
+		kmem_cache_free(kcm_psockp, psock);
+		goto out;
+	}
+
 	psock->save_data_ready = csk->sk_data_ready;
 	psock->save_write_space = csk->sk_write_space;
 	psock->save_state_change = csk->sk_state_change;
-- 
2.35.1



