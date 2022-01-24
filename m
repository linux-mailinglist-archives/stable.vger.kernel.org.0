Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53E84990A3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347157AbiAXUCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359784AbiAXUAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:00:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EE8C055A87;
        Mon, 24 Jan 2022 11:28:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4050FB8121B;
        Mon, 24 Jan 2022 19:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F353C340E5;
        Mon, 24 Jan 2022 19:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052503;
        bh=d9OmUHPKQrZ6Natp9JukyqTsw+yMgXrciAtgaRtw1yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEM0u6kRT1DHFNCejlgqNV54VPrPlb9P8OqADzV2ci4FVMwqzxsMSTRj8IoZXFPxJ
         eTLubtEwCzl77r3AfdVfaNhBSq0efKlkecnKuQkDZJIpAIGwOmMORZTtobBMZ7zR7j
         DJvMZyKNC4G2+zMaqVP1qaafzPsPoSUxFNVv0hSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/320] crypto: stm32/cryp - fix double pm exit
Date:   Mon, 24 Jan 2022 19:41:04 +0100
Message-Id: <20220124183956.457673340@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 92472a48c0454..c41e66211c5b4 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -2034,8 +2034,6 @@ err_engine1:
 	list_del(&cryp->list);
 	spin_unlock(&cryp_list.lock);
 
-	pm_runtime_disable(dev);
-	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
 
-- 
2.34.1



