Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B01A540ED8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354245AbiFGSz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353692AbiFGSwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:52:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F83131F25;
        Tue,  7 Jun 2022 11:03:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E262618D3;
        Tue,  7 Jun 2022 18:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48DCC385A5;
        Tue,  7 Jun 2022 18:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654625014;
        bh=hNbRKfVqo+5QFr9vKzpLdRTCK4YVbnY0OIVNBR0p+64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DF5Tc2lwZTaerocK4ehyEQlwVCuHuuLQYJqa9YXtCZn/vgXsGPkzmU9GRMORdGX7X
         IPgo8XHih8pVLodXjsUcqPLjFAcnyJaDU3sVQWkS9j3Q9Dvj/GiInIhekK2R9c4raH
         NcysQuWfCFlpzz4dTUxSB0FzOum0+muDoFpi9AMVbB/u/VU9YYyTzilY548FDdSnxu
         m/jtBe180VDNQPMusO9yuOzsEIQKqqKrbfuxkSWJLCAcTEuHKYxOqdIMDawqvepEu9
         TM9zhl0DKdpXEPqhqLTsLkLow2seSXXwAav00RKkIzXLeIm0estRnCGqqFOa+56mpw
         KNs8zfoVcVoEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, mailhol.vincent@wanadoo.fr,
        cai.huoqing@linux.dev, chi.minghao@zte.com.cn,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/19] drivers: usb: host: Fix deadlock in oxu_bus_suspend()
Date:   Tue,  7 Jun 2022 14:03:03 -0400
Message-Id: <20220607180317.482354-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180317.482354-1-sashal@kernel.org>
References: <20220607180317.482354-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 4d378f2ae58138d4c55684e1d274e7dd94aa6524 ]

There is a deadlock in oxu_bus_suspend(), which is shown below:

   (Thread 1)              |      (Thread 2)
                           | timer_action()
oxu_bus_suspend()          |  mod_timer()
 spin_lock_irq() //(1)     |  (wait a time)
 ...                       | oxu_watchdog()
 del_timer_sync()          |  spin_lock_irq() //(2)
 (wait timer to stop)      |  ...

We hold oxu->lock in position (1) of thread 1, and use
del_timer_sync() to wait timer to stop, but timer handler
also need oxu->lock in position (2) of thread 2. As a result,
oxu_bus_suspend() will block forever.

This patch extracts del_timer_sync() from the protection of
spin_lock_irq(), which could let timer handler to obtain
the needed lock.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220417120305.64577-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/oxu210hp-hcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 2f48da0c0bb3..af5248f62c59 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -3491,8 +3491,10 @@ static int oxu_bus_suspend(struct usb_hcd *hcd)
 		}
 	}
 
+	spin_unlock_irq(&oxu->lock);
 	/* turn off now-idle HC */
 	del_timer_sync(&oxu->watchdog);
+	spin_lock_irq(&oxu->lock);
 	ehci_halt(oxu);
 	hcd->state = HC_STATE_SUSPENDED;
 
-- 
2.35.1

