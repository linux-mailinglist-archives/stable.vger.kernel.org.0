Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AA65B71F2
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbiIMOpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbiIMOmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:42:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994A75FF4E;
        Tue, 13 Sep 2022 07:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D5C4B80F01;
        Tue, 13 Sep 2022 14:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E59BC433C1;
        Tue, 13 Sep 2022 14:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078955;
        bh=TDPwj3b/S3MexzapRQJ0/V6tRppIAPrvSk1VkTJLtCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrS9bI6gHqFyqfqR3nQKzz3nz/w1djOYlR+qCzBnXYbzlqVTBj0JwqXmUjurg4Fu6
         2o+8/EvZfu+CDbtLNoOl2ov6RBypw1BLZVKp4uX02Qp5hLpIn0h4GY3iC613ccnpBS
         LoT4NwKS8WlWl3CSGhKq+HzvzbhEgjHibSuMbfck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+cf155def4e717db68a12@syzkaller.appspotmail.com>,
        stable <stable@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.10 03/79] tty: n_gsm: initialize more members at gsm_alloc_mux()
Date:   Tue, 13 Sep 2022 16:04:08 +0200
Message-Id: <20220913140350.450170649@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2200,11 +2200,6 @@ static int gsm_activate_mux(struct gsm_m
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
@@ -2306,6 +2301,10 @@ static struct gsm_mux *gsm_alloc_mux(voi
 	mutex_init(&gsm->mutex);
 	kref_init(&gsm->ref);
 	INIT_LIST_HEAD(&gsm->tx_list);
+	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
+	init_waitqueue_head(&gsm->event);
+	spin_lock_init(&gsm->control_lock);
+	spin_lock_init(&gsm->tx_lock);
 
 	gsm->t1 = T1;
 	gsm->t2 = T2;


