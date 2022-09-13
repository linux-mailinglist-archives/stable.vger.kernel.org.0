Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29E65B736D
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbiIMPLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235818AbiIMPJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:09:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B27B7675D;
        Tue, 13 Sep 2022 07:32:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13DD1614E4;
        Tue, 13 Sep 2022 14:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E2BC433D7;
        Tue, 13 Sep 2022 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079409;
        bh=Qd9969KoNnkbTMb5ceNyswXbNKwxQESb7HfOPM1t9yI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYcpsqFPNckEP8zb2Jb1Qdc3tRRLUcM2l9Zjza8KCHc5bV6wc6puCH54urK3wVYTX
         6o3pc0EWmn4C5ZVZHnFExmlEbZDAYk3TyplzJwVUPYhk8fQsJag0VUU97RFB9kOK+2
         q2BYYbBp3Pbj6i8vXBXGmrDohI6xRWeLjJRKtEzg=
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
Subject: [PATCH 4.19 15/79] kcm: fix strp_init() order and cleanup
Date:   Tue, 13 Sep 2022 16:06:33 +0200
Message-Id: <20220913140349.595770855@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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
index b919db02c7f9e..ef2543a4c1fc5 100644
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
 
 	/* Check if sk_user_data is aready by KCM or someone else.
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



