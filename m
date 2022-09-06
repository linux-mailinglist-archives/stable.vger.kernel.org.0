Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185D15AF384
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 20:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiIFSWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 14:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiIFSWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 14:22:44 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730749F772
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:22:41 -0700 (PDT)
Received: from localhost.localdomain (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 5BBAA40737D2;
        Tue,  6 Sep 2022 18:22:39 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org, Jiri Slaby <jirislaby@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+cf155def4e717db68a12@syzkaller.appspotmail.com>,
        stable <stable@kernel.org>
Subject: [PATCH 5.10 1/2] tty: n_gsm: initialize more members at gsm_alloc_mux()
Date:   Tue,  6 Sep 2022 21:22:11 +0300
Message-Id: <20220906182212.25261-2-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906182212.25261-1-pchelkin@ispras.ru>
References: <20220906182212.25261-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 4bb1a53be85fcb1e24c14860e326a00cdd362c28 upstream.

syzbot is reporting use of uninitialized spinlock at gsmld_write() [1], for
commit 32dd59f ("tty: n_gsm: fix race condition in gsmld_write()")
allows accessing gsm->tx_lock before gsm_activate_mux() initializes it.

Since object initialization should be done right after allocation in order
to avoid accessing uninitialized memory, move initialization of
timer/work/waitqueue/spinlock from gsmld_open()/gsm_activate_mux() to
gsm_alloc_mux().

Link: https://syzkaller.appspot.com/bug?extid=cf155def4e717db68a12 [1]
Fixes: 32dd59f ("tty: n_gsm: fix race condition in gsmld_write()")
Reported-by: syzbot <syzbot+cf155def4e717db68a12@syzkaller.appspotmail.com>
Tested-by: syzbot <syzbot+cf155def4e717db68a12@syzkaller.appspotmail.com>
Cc: stable <stable@kernel.org>
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/r/2110618e-57f0-c1ce-b2ad-b6cacef3f60e@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
5.10: no kick_timer

 drivers/tty/n_gsm.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index cb5ed4155a8d..c2212f52a603 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2200,11 +2200,6 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
 {
 	struct gsm_dlci *dlci;
 
-	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
-	init_waitqueue_head(&gsm->event);
-	spin_lock_init(&gsm->control_lock);
-	spin_lock_init(&gsm->tx_lock);
-
 	if (gsm->encoding == 0)
 		gsm->receive = gsm0_receive;
 	else
@@ -2306,6 +2301,10 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	mutex_init(&gsm->mutex);
 	kref_init(&gsm->ref);
 	INIT_LIST_HEAD(&gsm->tx_list);
+	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
+	init_waitqueue_head(&gsm->event);
+	spin_lock_init(&gsm->control_lock);
+	spin_lock_init(&gsm->tx_lock);
 
 	gsm->t1 = T1;
 	gsm->t2 = T2;
-- 
2.25.1

