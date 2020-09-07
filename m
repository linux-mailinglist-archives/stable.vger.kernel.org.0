Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C1D260077
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731070AbgIGQtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730803AbgIGQfD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:35:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4074121941;
        Mon,  7 Sep 2020 16:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496503;
        bh=TRp+T/pAqQH1aSfGdNxlVrb79U0JdQ9CMrLL27xk2sg=;
        h=From:To:Cc:Subject:Date:From;
        b=XTIMpZwVVrTewp7v2XZhst+mGx15iclLN7VERD14sYYq+nltkhiHNIC8QN2COD5P2
         TUjaKU7cxE5xr+OpVO+O8/gkRD/tF48Kto4wbekHsl0pwV8yRL0r+z+EY4/bN9h20p
         a6agJ/nGkm/Ecv4eyl19P90QJH/qcwjwMxFqqShY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 01/17] ARC: HSDK: wireup perf irq
Date:   Mon,  7 Sep 2020 12:34:44 -0400
Message-Id: <20200907163500.1281543-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

[ Upstream commit fe81d927b78c4f0557836661d32e41ebc957b024 ]

Newer version of HSDK aka HSDK-4xD (with dual issue HS48x4 CPU) wired up
the perf interrupt, so enable that in DT.
This is OK for old HSDK where this irq is ignored because pct irq is not
wired up in hardware.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/boot/dts/hsdk.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arc/boot/dts/hsdk.dts b/arch/arc/boot/dts/hsdk.dts
index 57d81c6aa379d..aeacea148793c 100644
--- a/arch/arc/boot/dts/hsdk.dts
+++ b/arch/arc/boot/dts/hsdk.dts
@@ -79,6 +79,8 @@ idu_intc: idu-interrupt-controller {
 
 	arcpct: pct {
 		compatible = "snps,archs-pct";
+		interrupt-parent = <&cpu_intc>;
+		interrupts = <20>;
 	};
 
 	/* TIMER0 with interrupt for clockevent */
-- 
2.25.1

