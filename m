Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B011440E78E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349093AbhIPRd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347463AbhIPRby (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:31:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0C9D6120F;
        Thu, 16 Sep 2021 16:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810841;
        bh=4F/FtUHaVA8ntObtQdHZamsH2x118d5OxzvWksJvNb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1xdnUvM6NVGKjh4zytYO4YP6G+HughujGvUv3tU2ueZeL/bIzl8JRkXLmKNcQcYl
         a3coFrIeYQ/mvpG6QUGzIBos+p50CADlCOxbOtZIfD4gjZS0Dipp08WV8XP7NknDtK
         J7lIeAC91w/NTlIgD1J7u+FN5nHMs7DimA28Z9Wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Aiuto <fabioaiuto83@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 287/432] staging: rtl8723bs: fix right side of condition
Date:   Thu, 16 Sep 2021 18:00:36 +0200
Message-Id: <20210916155820.543379663@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Aiuto <fabioaiuto83@gmail.com>

[ Upstream commit e3678dc1ea40425b7218c20e2fe7b00a72f23a41 ]

TxNum value is compared against ODM_RF_PATH_D,
which is inconsistent. Compare it against
RF_MAX_TX_NUM, as in other places in the same file.

Signed-off-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Link: https://lore.kernel.org/r/147631fe6f4f5de84cc54a62ba71d739b92697be.1628329348.git.fabioaiuto83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/hal/hal_com_phycfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
index bb7941aee0c4..fcf31f6d4b36 100644
--- a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
+++ b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
@@ -463,7 +463,7 @@ static void PHY_StoreTxPowerByRateNew(
 	if (RfPath > ODM_RF_PATH_D)
 		return;
 
-	if (TxNum > ODM_RF_PATH_D)
+	if (TxNum > RF_MAX_TX_NUM)
 		return;
 
 	for (i = 0; i < rateNum; ++i) {
-- 
2.30.2



