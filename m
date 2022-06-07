Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73460540AFB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351850AbiFGSZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351902AbiFGSQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A2313390E;
        Tue,  7 Jun 2022 10:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75B976146F;
        Tue,  7 Jun 2022 17:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD20C34115;
        Tue,  7 Jun 2022 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624205;
        bh=iBHXIOeiRVVBCYsNK7bbGrVtLssRBgvab2AS9555VOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHtcMydmV0YrSBB3YK0pPrF7IKKPHRFCGKJ+NaKr72ypz2DjK/5CVkTbMrHfUHK1B
         PvJyNBNFgkY5T396yAOTOuuH1duNcMJjXi9dEa+JDTXhScZ7Xfn6JFZa07iaJZaLga
         FutKE4zwvJJ6xVpf1NaOWzGrXE8NfDXWMfElkI7vVnYy0j312jPrFOx3ch5dHxBc7d
         L+uf1VsVIpp1HPDJJjbIhmMqI3Ef6sHSsqP/eTvaXz8yiEQ60sjPxQ6q0btL29cyU0
         tiz7i8Qn5G43/izNpsdswuOMQKi1oUxy1sxHYL8HQPLClB9AmpGGhHKWBTuNNyU1Co
         KVdWmVBg3k+7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, baihaowen@meizu.com,
        dan.carpenter@oracle.com, wjsota@gmail.com, len.baker@gmx.com,
        dave@stgolabs.net, edumazet@google.com, yangyingliang@huawei.com,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.18 12/68] drivers: staging: rtl8192e: Fix deadlock in rtllib_beacons_stop()
Date:   Tue,  7 Jun 2022 13:47:38 -0400
Message-Id: <20220607174846.477972-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
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

[ Upstream commit 9b6bdbd9337de3917945847bde262a34a87a6303 ]

There is a deadlock in rtllib_beacons_stop(), which is shown
below:

   (Thread 1)              |      (Thread 2)
                           | rtllib_send_beacon()
rtllib_beacons_stop()      |  mod_timer()
 spin_lock_irqsave() //(1) |  (wait a time)
 ...                       | rtllib_send_beacon_cb()
 del_timer_sync()          |  spin_lock_irqsave() //(2)
 (wait timer to stop)      |  ...

We hold ieee->beacon_lock in position (1) of thread 1 and
use del_timer_sync() to wait timer to stop, but timer handler
also need ieee->beacon_lock in position (2) of thread 2.
As a result, rtllib_beacons_stop() will block forever.

This patch extracts del_timer_sync() from the protection of
spin_lock_irqsave(), which could let timer handler to obtain
the needed lock.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220417141641.124388-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192e/rtllib_softmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index 4b6c2295a3cf..b5a38f0a8d79 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -651,9 +651,9 @@ static void rtllib_beacons_stop(struct rtllib_device *ieee)
 	spin_lock_irqsave(&ieee->beacon_lock, flags);
 
 	ieee->beacon_txing = 0;
-	del_timer_sync(&ieee->beacon_timer);
 
 	spin_unlock_irqrestore(&ieee->beacon_lock, flags);
+	del_timer_sync(&ieee->beacon_timer);
 
 }
 
-- 
2.35.1

