Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4856226B559
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgIOXmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgIOOei (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:34:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB05A21D80;
        Tue, 15 Sep 2020 14:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179328;
        bh=5wG56LdaQbiFS+Ocf2zZ7D+B6WkKUwF9hxlX/ka52qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYa7r3Vd2ISy0KnTS4eNfSwvtETWb7Mt0Ilm/w3rnInAQuekAChdAZNu0tlBm4pJs
         Il1bbAd4xGTWtSVJ/L1k93Puc3iix+MdSsF07r0A9QwEB3BtlzbsohFdygU2XQ0kiE
         oYoHKSFY+xb8xyujAm3q8LPdQ8f/AUyZi3Gr5dUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/78] ARC: HSDK: wireup perf irq
Date:   Tue, 15 Sep 2020 16:12:42 +0200
Message-Id: <20200915140634.421430857@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -83,6 +83,8 @@
 
 	arcpct: pct {
 		compatible = "snps,archs-pct";
+		interrupt-parent = <&cpu_intc>;
+		interrupts = <20>;
 	};
 
 	/* TIMER0 with interrupt for clockevent */
-- 
2.25.1



