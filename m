Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D0449A8FD
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1321829AbiAYDTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:19:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38346 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348252AbiAXTsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:48:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF7D9B811F3;
        Mon, 24 Jan 2022 19:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EB3C340E7;
        Mon, 24 Jan 2022 19:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053723;
        bh=SW3LaOTkedTk7adcIdVcisEywFdafNAxlRBLboYCbE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVlkDS7q14p6OMljUSKcEZMsX+qlyQXnl9Z9XclEV+AlhAFGw7IUx4VvLhMg5BBs4
         pNKbbnA8oE6QLFpj8jhtG0zB9+pseEc4knOrMRMDDTBDHZxULWMbRiU9F9OonsneIl
         48eYAcl1F/K2uV/m6g2JcMnwmtGKUB72iYnSKq2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/563] crypto: stm32/cryp - fix double pm exit
Date:   Mon, 24 Jan 2022 19:38:42 +0100
Message-Id: <20220124184029.822661198@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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



