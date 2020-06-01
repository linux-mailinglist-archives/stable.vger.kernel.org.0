Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B37C1EAD90
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729492AbgFASIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729873AbgFASIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:08:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0686A2068D;
        Mon,  1 Jun 2020 18:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034928;
        bh=kqof40ecBX80pUsHJ6pC97CnbYA97VwGgQaoy9LYEf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSNlwatmJHT48Hi/Cv6dC5vdHy02QMFvBWagA+lCFavJ9YusVlNcBIkz8tgzqUaT2
         G/R2Nok1eH22RWrSUh0lGG4B014xTc7ZOrXHXui/4BkMLSy0li0dnHcLIHmK47CZQr
         fnsGDT/sQ1M7m7lGxdZ2zh/tWqXESb6+PVttwYNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/142] arm64: dts: mt8173: fix vcodec-enc clock
Date:   Mon,  1 Jun 2020 19:53:54 +0200
Message-Id: <20200601174045.806029181@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 3b1f6c5e4dfaf767f6f2f120cd93b347b5a9f1aa ]

Fix the assigned-clock-parents to higher frequency clock to avoid h264
encode timeout:

[  134.763465] mtk_vpu 10020000.vpu: vpu ipi 4 ack time out !
[  134.769008] [MTK_VCODEC][ERROR][18]: vpu_enc_send_msg() vpu_ipi_send msg_id c002 len 32 fail -5
[  134.777707] [MTK_VCODEC][ERROR][18]: vpu_enc_encode() AP_IPIMSG_ENC_ENCODE 0 fail

venc_sel is the clock used by h264 encoder, and venclt_sel is the clock
used by vp8 encoder. Assign venc_sel to vcodecpll_ck and venclt_sel to
vcodecpll_370p5.

    vcodecpll                         1482000000
       vcodecpll_ck                    494000000
          venc_sel                     494000000
...
       vcodecpll_370p5                 370500000
          venclt_sel                   370500000

Fixes: fbbad0287cec ("arm64: dts: Using standard CCF interface to set vcodec clk")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Link: https://lore.kernel.org/r/20200504124442.208004-1-hsinyi@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index 15f1842f6df3..5891b7151432 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -1397,8 +1397,8 @@
 				      "venc_lt_sel";
 			assigned-clocks = <&topckgen CLK_TOP_VENC_SEL>,
 					  <&topckgen CLK_TOP_VENC_LT_SEL>;
-			assigned-clock-parents = <&topckgen CLK_TOP_VENCPLL_D2>,
-						 <&topckgen CLK_TOP_UNIVPLL1_D2>;
+			assigned-clock-parents = <&topckgen CLK_TOP_VCODECPLL>,
+						 <&topckgen CLK_TOP_VCODECPLL_370P5>;
 		};
 
 		vencltsys: clock-controller@19000000 {
-- 
2.25.1



