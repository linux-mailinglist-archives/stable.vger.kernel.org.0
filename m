Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F48D3E80B3
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbhHJRv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237223AbhHJRuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC7B66127B;
        Tue, 10 Aug 2021 17:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617342;
        bh=6CtMMWY43tOrknqGuMDP0XoXH39Ui/QQiMYCBapgyNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0g9OxANZ7sQiCdJVXo1canVnoF2kgSqJPnkfj+faohOenxmoyLn4gDXAr03lVCux
         8eaHqz1j9/4Mg8V5z9gbu/RY0qAtYm/ybFZXVpq9xUhe62jhVZHZzfkRBfxKfRxlZY
         kPA/qVa+ou06RoDWcjAZ3vDmus+a523KTAOdKZ+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 017/175] ARM: imx: fix missing 3rd argument in macro imx_mmdc_perf_init
Date:   Tue, 10 Aug 2021 19:28:45 +0200
Message-Id: <20210810173001.516785962@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 20fb73911fec01f06592de1cdbca00b66602ebd7 ]

The function imx_mmdc_perf_init recently had a 3rd argument added to
it but the equivalent macro was not updated and is still the older
2 argument version. Fix this by adding in the missing 3rd argumement
mmdc_ipg_clk.

Fixes: f07ec8536580 ("ARM: imx: add missing clk_disable_unprepare()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/mmdc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/mmdc.c b/arch/arm/mach-imx/mmdc.c
index 4a6f1359e1e9..af12668d0bf5 100644
--- a/arch/arm/mach-imx/mmdc.c
+++ b/arch/arm/mach-imx/mmdc.c
@@ -534,7 +534,7 @@ pmu_free:
 
 #else
 #define imx_mmdc_remove NULL
-#define imx_mmdc_perf_init(pdev, mmdc_base) 0
+#define imx_mmdc_perf_init(pdev, mmdc_base, mmdc_ipg_clk) 0
 #endif
 
 static int imx_mmdc_probe(struct platform_device *pdev)
-- 
2.30.2



