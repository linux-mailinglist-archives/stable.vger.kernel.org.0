Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D61C3E7F76
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhHJRkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:40:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235228AbhHJRj1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D91F6113E;
        Tue, 10 Aug 2021 17:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617023;
        bh=6CtMMWY43tOrknqGuMDP0XoXH39Ui/QQiMYCBapgyNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOEKUCVhGiFS/ClxdMKSknZ8T7+Z+aXLjEUJYKztqERzDluvlNUqhA1VjKWhHeWS0
         vfL6i+BEJNRckGenJt7hKKU7nMF6QPEQU8tPT2oVOs5A1+biTea9L1G8UidXCR88Iy
         E2sjjtQxbk+o0jw3Ujhy9x/QpbYnIC6cQQdpOWSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/135] ARM: imx: fix missing 3rd argument in macro imx_mmdc_perf_init
Date:   Tue, 10 Aug 2021 19:29:05 +0200
Message-Id: <20210810172956.056400324@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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



