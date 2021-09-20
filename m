Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161D7411EC2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351477AbhITReI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:34:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351113AbhITRcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A07861B07;
        Mon, 20 Sep 2021 17:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157490;
        bh=ScLrpRUppZUYlk2j8RlpCnqSSEMdCX38PCo7UBItcbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=keZkecct2KDdNOYTdMxLJXrtlZ12UGv+Zm7geGqowfm4RLl4zeFMTBm1//SbHaZUA
         l1RrCk5he8hfOtjmnwBf0+hzs/H+5e05EhPX0/vCBS/rRx38yMYIN9zfuO8G42qh2p
         gBwtj/wKJtZz6Sa3tB4yURq0WzilVkFL1fLnzXTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.19 015/293] ARM: imx: fix missing 3rd argument in macro imx_mmdc_perf_init
Date:   Mon, 20 Sep 2021 18:39:37 +0200
Message-Id: <20210920163933.783996706@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-imx/mmdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-imx/mmdc.c
+++ b/arch/arm/mach-imx/mmdc.c
@@ -545,7 +545,7 @@ pmu_free:
 
 #else
 #define imx_mmdc_remove NULL
-#define imx_mmdc_perf_init(pdev, mmdc_base) 0
+#define imx_mmdc_perf_init(pdev, mmdc_base, mmdc_ipg_clk) 0
 #endif
 
 static int imx_mmdc_probe(struct platform_device *pdev)


