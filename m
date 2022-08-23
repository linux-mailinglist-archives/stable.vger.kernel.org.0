Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3E059D4D9
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346658AbiHWIme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242061AbiHWIkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:40:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1D44BD06;
        Tue, 23 Aug 2022 01:18:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6B32B81C26;
        Tue, 23 Aug 2022 08:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A874C433C1;
        Tue, 23 Aug 2022 08:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242642;
        bh=MmA8+czNp1+q5KyrKW/oAit6SlhxwV+dRrfMMv9Mlwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mfTpyFDaRvfVz4m4mUS7AzQHSgLGYeBtwMIOEUsRLV/AIlfIS6lUt53C2iKTGGPgv
         TzDttE/gCTwMvuuZVqbxSk9kZOLGLkCtEm/exYxRMt2DaKpyDB6RmdfTj4PKVhc+3i
         PqIuUnE84BzBWXxlRndsG1+p8d6v0xSNxoUaf2xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 151/365] atm: idt77252: fix use-after-free bugs caused by tst_timer
Date:   Tue, 23 Aug 2022 10:00:52 +0200
Message-Id: <20220823080124.546175111@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
@@ -3752,6 +3752,7 @@ static void __exit idt77252_exit(void)
 		card = idt77252_chain;
 		dev = card->atmdev;
 		idt77252_chain = card->next;
+		del_timer_sync(&card->tst_timer);
 
 		if (dev->phy->stop)
 			dev->phy->stop(dev);


