Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78BB59D617
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243500AbiHWI1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344319AbiHWI0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:26:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB64D6C770;
        Tue, 23 Aug 2022 01:14:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B6F0B81C20;
        Tue, 23 Aug 2022 08:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC8EC433D6;
        Tue, 23 Aug 2022 08:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242474;
        bh=29gV5ywJ765JIYijCbxFwS+rCez41jCO8sOYnCHIWMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfNYlUZj6hskW+Kt0OeEuEzLDQQYNyCe/MtsKOumv2Xad8TTp7Fdo/X2iAAZvurb8
         ELeihNlhz5Q1wypMXWcnSv36E0xysqtKGGv2Bp9xQETTszBRdvxytZWVyu3UwjdOZS
         piXeH4bOpr1A3ZehU2FpAJs87i9Ujd88tPxguf1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 077/101] atm: idt77252: fix use-after-free bugs caused by tst_timer
Date:   Tue, 23 Aug 2022 10:03:50 +0200
Message-Id: <20220823080037.518434534@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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
@@ -3777,6 +3777,7 @@ static void __exit idt77252_exit(void)
 		card = idt77252_chain;
 		dev = card->atmdev;
 		idt77252_chain = card->next;
+		del_timer_sync(&card->tst_timer);
 
 		if (dev->phy->stop)
 			dev->phy->stop(dev);


