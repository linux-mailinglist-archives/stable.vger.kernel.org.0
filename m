Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7D1499A81
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573167AbiAXVoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454658AbiAXVdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:33:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADACC07597E;
        Mon, 24 Jan 2022 12:21:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28A15B810BD;
        Mon, 24 Jan 2022 20:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E284C340E5;
        Mon, 24 Jan 2022 20:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055688;
        bh=SW3LaOTkedTk7adcIdVcisEywFdafNAxlRBLboYCbE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXPpyzJ9mywxfMFGO6nV8jmT85jAL4BXrzpeokYkCW4EQxWo3iGB7b4E7e3U/E9pV
         N6DwnoLAo1VJmnWXCeHKLWbSZT8+4DKtej6eFrKuz3vd00/mSMei2Ju3pB7NlH1lwp
         2HOckG9r4oB2pbVd+aSoWRm0keRaWZefZc7i/hFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 234/846] crypto: stm32/cryp - fix double pm exit
Date:   Mon, 24 Jan 2022 19:35:51 +0100
Message-Id: <20220124184109.003431232@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index fd7fb73a4d450..061db567908ae 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -2134,8 +2134,6 @@ err_engine1:
 	list_del(&cryp->list);
 	spin_unlock(&cryp_list.lock);
 
-	pm_runtime_disable(dev);
-	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
 
-- 
2.34.1



