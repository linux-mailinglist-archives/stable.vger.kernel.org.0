Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAEB59E200
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354822AbiHWMMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354702AbiHWML1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:11:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9801EE2C5D;
        Tue, 23 Aug 2022 02:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9334BCE1B57;
        Tue, 23 Aug 2022 09:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924D4C433C1;
        Tue, 23 Aug 2022 09:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247515;
        bh=BcWBC/MwhJc8WD0lLAzvzWux7J51PZtC2jJpLFzKH1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrlIFDpaxovyMLE3JWNQJmkaj1w8zJavdI+MymOQkikqAwwMyK+4nBxHGQdwvkpN+
         cfZtImK3+3CTQ/LdcB9eYFM27cABjCoHy5r1wJ2+CrxmuiNsiRTtybWAC5hubcqRWL
         E0iQ72d1P4PTO53ogUtyf0nzuKuELJoMKVP4A7Gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 060/158] atm: idt77252: fix use-after-free bugs caused by tst_timer
Date:   Tue, 23 Aug 2022 10:26:32 +0200
Message-Id: <20220823080048.503060932@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

commit 3f4093e2bf4673f218c0bf17d8362337c400e77b upstream.

There are use-after-free bugs caused by tst_timer. The root cause
is that there are no functions to stop tst_timer in idt77252_exit().
One of the possible race conditions is shown below:

    (thread 1)          |        (thread 2)
                        |  idt77252_init_one
                        |    init_card
                        |      fill_tst
                        |        mod_timer(&card->tst_timer, ...)
idt77252_exit           |  (wait a time)
                        |  tst_timer
                        |
                        |    ...
  kfree(card) // FREE   |
                        |    card->soft_tst[e] // USE

The idt77252_dev is deallocated in idt77252_exit() and used in
timer handler.

This patch adds del_timer_sync() in idt77252_exit() in order that
the timer handler could be stopped before the idt77252_dev is
deallocated.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220805070008.18007-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/atm/idt77252.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -3767,6 +3767,7 @@ static void __exit idt77252_exit(void)
 		card = idt77252_chain;
 		dev = card->atmdev;
 		idt77252_chain = card->next;
+		del_timer_sync(&card->tst_timer);
 
 		if (dev->phy->stop)
 			dev->phy->stop(dev);


