Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03590498EEB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350243AbiAXTtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354759AbiAXThv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:37:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F1CC0085BD;
        Mon, 24 Jan 2022 11:17:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B13E56131D;
        Mon, 24 Jan 2022 19:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D45C340E5;
        Mon, 24 Jan 2022 19:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051851;
        bh=MVcReX3W2UATrsEc/FCbBHApTKVMcOq6AMGjgtU5CP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJocDCPBDEdIOz8mb18qcqcXQoWCfRbwohMsxnW1k7S1bzTiKMo+P0tMdSpiQ/LA/
         NexNgklJVF/Uzwvcyfm5Mt2dU6Z0k177UJPrKqyehVSAp+6L8BrCvS5wL7ApFVmLWh
         hkzokrZ9qgoF4t1m4h2v/iBhTBGpC2jm057/uiVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/239] crypto: stm32/cryp - fix double pm exit
Date:   Mon, 24 Jan 2022 19:41:52 +0100
Message-Id: <20220124183945.477087875@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>

[ Upstream commit 6c12e742785bf9333faf60bfb96575bdd763448e ]

Delete extraneous lines in probe error handling code: pm was
disabled twice.

Fixes: 65f9aa36ee47 ("crypto: stm32/cryp - Add power management support")

Reported-by: Marek Vasut <marex@denx.de>
Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 23b0b7bd64c7f..b3b49dce11369 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -2036,8 +2036,6 @@ err_engine1:
 	list_del(&cryp->list);
 	spin_unlock(&cryp_list.lock);
 
-	pm_runtime_disable(dev);
-	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
 
-- 
2.34.1



