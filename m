Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4933A2600C8
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbgIGQy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730752AbgIGQe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:34:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FC8021927;
        Mon,  7 Sep 2020 16:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496468;
        bh=DKoXo4tvSQmxbIbWcILLyoXUHQbE/wQjIh3NwvRhzKM=;
        h=From:To:Cc:Subject:Date:From;
        b=2BtRgZXRmiKSP4gJM/HSGauoWpHsZ+7Z0iriiugfQjf98O9kCxY+WOhH70qqxJ4me
         CFuwl7IQgMh/myP1VjLawp1YO1iwKQWNb3JnZL1M9GYDwmQR4wTmqrYt/Gb5SNBLW9
         vJpW2amlFl8DYwMiQj0oCxnH2b2yACDIP9oAJYUU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 01/26] ARC: HSDK: wireup perf irq
Date:   Mon,  7 Sep 2020 12:34:01 -0400
Message-Id: <20200907163426.1281284-1-sashal@kernel.org>
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
index d131c54acd3ec..ab01b75bfa67d 100644
--- a/arch/arc/boot/dts/hsdk.dts
+++ b/arch/arc/boot/dts/hsdk.dts
@@ -83,6 +83,8 @@ idu_intc: idu-interrupt-controller {
 
 	arcpct: pct {
 		compatible = "snps,archs-pct";
+		interrupt-parent = <&cpu_intc>;
+		interrupts = <20>;
 	};
 
 	/* TIMER0 with interrupt for clockevent */
-- 
2.25.1

