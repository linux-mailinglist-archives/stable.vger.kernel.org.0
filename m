Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46575AEC72
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241534AbiIFOOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241731AbiIFON6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:13:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B69895D9;
        Tue,  6 Sep 2022 06:48:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A07DA61520;
        Tue,  6 Sep 2022 13:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC05BC433C1;
        Tue,  6 Sep 2022 13:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472116;
        bh=2x4gxUdQIJg67nB1mfwUsfFq+F++aq5xL1H4TQZC3Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TDqRWQN7wYBEx1VaTXysMEVnc2hu9PHph65Fh1G7/fi1CvjvebAp79J8nvXyw3BF
         6rhI/liKh51Tl1q1H7149uSm3fQ+qc8VwTiWY0TsE2U7/zq3rBUJSeft7nsOIcqKcp
         UdA/g4HZXX3KJVmDo4IbklgucQboF0yRzoxQZNO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+cf155def4e717db68a12@syzkaller.appspotmail.com>,
        stable <stable@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 5.19 153/155] tty: n_gsm: initialize more members at gsm_alloc_mux()
Date:   Tue,  6 Sep 2022 15:31:41 +0200
Message-Id: <20220906132835.860724113@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 4bb1a53be85fcb1e24c14860e326a00cdd362c28 upstream.

syzbot is reporting use of uninitialized spinlock at gsmld_write() [1], for
commit 32dd59f96924f45e ("tty: n_gsm: fix race condition in gsmld_write()")
allows accessing gsm->tx_lock before gsm_activate_mux() initializes it.

Since object initialization should be done right after allocation in order
to avoid accessing uninitialized memory, move initialization of
timer/work/waitqueue/spinlock from gsmld_open()/gsm_activate_mux() to
gsm_alloc_mux().

Link: https://syzkaller.appspot.com/bug?extid=cf155def4e717db68a12 [1]
Fixes: 32dd59f96924f45e ("tty: n_gsm: fix race condition in gsmld_write()")
Reported-by: syzbot <syzbot+cf155def4e717db68a12@syzkaller.appspotmail.com>
Tested-by: syzbot <syzbot+cf155def4e717db68a12@syzkaller.appspotmail.com>
Cc: stable <stable@kernel.org>
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/r/2110618e-57f0-c1ce-b2ad-b6cacef3f60e@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2501,13 +2501,6 @@ static int gsm_activate_mux(struct gsm_m
 	if (dlci == NULL)
 		return -ENOMEM;
 
-	timer_setup(&gsm->kick_timer, gsm_kick_timer, 0);
-	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
-	INIT_WORK(&gsm->tx_work, gsmld_write_task);
-	init_waitqueue_head(&gsm->event);
-	spin_lock_init(&gsm->control_lock);
-	spin_lock_init(&gsm->tx_lock);
-
 	if (gsm->encoding == 0)
 		gsm->receive = gsm0_receive;
 	else
@@ -2612,6 +2605,12 @@ static struct gsm_mux *gsm_alloc_mux(voi
 	kref_init(&gsm->ref);
 	INIT_LIST_HEAD(&gsm->tx_ctrl_list);
 	INIT_LIST_HEAD(&gsm->tx_data_list);
+	timer_setup(&gsm->kick_timer, gsm_kick_timer, 0);
+	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
+	INIT_WORK(&gsm->tx_work, gsmld_write_task);
+	init_waitqueue_head(&gsm->event);
+	spin_lock_init(&gsm->control_lock);
+	spin_lock_init(&gsm->tx_lock);
 
 	gsm->t1 = T1;
 	gsm->t2 = T2;
@@ -2947,10 +2946,6 @@ static int gsmld_open(struct tty_struct
 
 	gsmld_attach_gsm(tty, gsm);
 
-	timer_setup(&gsm->kick_timer, gsm_kick_timer, 0);
-	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
-	INIT_WORK(&gsm->tx_work, gsmld_write_task);
-
 	return 0;
 }
 


