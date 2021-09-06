Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20783402178
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 01:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhIFX3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 19:29:32 -0400
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:56412 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhIFX3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 19:29:32 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 186NSP9g018178; Tue, 7 Sep 2021 08:28:26 +0900
X-Iguazu-Qid: 34trSLAaBUf4iRoNdJ
X-Iguazu-QSIG: v=2; s=0; t=1630970905; q=34trSLAaBUf4iRoNdJ; m=k0nqQviaHAGOM0ZxlOQQUL6foy2fJbaNjhwZxSkC5qg=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1511) id 186NSPZ8005829
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 7 Sep 2021 08:28:25 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id 5A0561000F3
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 08:28:25 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 186NSPSK031977
        for <stable@vger.kernel.org>; Tue, 7 Sep 2021 08:28:25 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 2/2 for 4.19.y] ARM: imx: fix missing 3rd argument in macro imx_mmdc_perf_init
Date:   Tue,  7 Sep 2021 08:28:19 +0900
X-TSB-HOP: ON
Message-Id: <20210906232819.2950209-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 20fb73911fec01f06592de1cdbca00b66602ebd7 upstream.

The function imx_mmdc_perf_init recently had a 3rd argument added to
it but the equivalent macro was not updated and is still the older
2 argument version. Fix this by adding in the missing 3rd argumement
mmdc_ipg_clk.

Fixes: f07ec8536580 ("ARM: imx: add missing clk_disable_unprepare()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 arch/arm/mach-imx/mmdc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/mmdc.c b/arch/arm/mach-imx/mmdc.c
index ba830be0b53102..14be73ca107a5e 100644
--- a/arch/arm/mach-imx/mmdc.c
+++ b/arch/arm/mach-imx/mmdc.c
@@ -545,7 +545,7 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
 
 #else
 #define imx_mmdc_remove NULL
-#define imx_mmdc_perf_init(pdev, mmdc_base) 0
+#define imx_mmdc_perf_init(pdev, mmdc_base, mmdc_ipg_clk) 0
 #endif
 
 static int imx_mmdc_probe(struct platform_device *pdev)
-- 
2.33.0


