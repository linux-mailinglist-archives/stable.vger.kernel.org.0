Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F2F24DD76
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgHURQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728090AbgHUQQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:16:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 722E222BEB;
        Fri, 21 Aug 2020 16:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026594;
        bh=NZ1zbKrwo5IZCErTAktS1k3LZeAW/QGyONeoRh3BaGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0AolvIssbvG74Ggc0PO63MYwlCtD2QjBmJTrIGPgwz7DAwvKUCs7QCW+kaUroLPB
         zJr/klGu6px2mldQwHY4G2dmmXb/zBlNekscWFH8aCprUVw5Q0br6EKVW+4F0AXmCR
         py2+QWbXahfBV7K1CqI6alU9/621IyOS5WaCj8oc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 38/61] ARM: dts: ls1021a: output PPS signal on FIPER2
Date:   Fri, 21 Aug 2020 12:15:22 -0400
Message-Id: <20200821161545.347622-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161545.347622-1-sashal@kernel.org>
References: <20200821161545.347622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>

[ Upstream commit 5656bb3857c4904d1dec6e1b8f876c1c0337274e ]

The timer fixed interval period pulse generator register
is used to generate periodic pulses. The down count
register loads the value programmed in the fixed period
interval (FIPER). At every tick of the timer accumulator
overflow, the counter decrements by the value of
TMR_CTRL[TCLK_PERIOD]. It generates a pulse when the down
counter value reaches zero. It reloads the down counter
in the cycle following a pulse.

To use the TMR_FIPER register to generate desired periodic
pulses. The value should programmed is,
desired_period - tclk_period

Current tmr-fiper2 value is to generate 100us periodic pulses.
(But the value should have been 99995, not 99990. The tclk_period is 5.)
This patch is to generate 1 second periodic pulses with value
999999995 programmed which is more desired by user.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ls1021a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ls1021a.dtsi b/arch/arm/boot/dts/ls1021a.dtsi
index 760a68c163c83..b2ff27af090ec 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -772,7 +772,7 @@ ptp_clock@2d10e00 {
 			fsl,tmr-prsc    = <2>;
 			fsl,tmr-add     = <0xaaaaaaab>;
 			fsl,tmr-fiper1  = <999999995>;
-			fsl,tmr-fiper2  = <99990>;
+			fsl,tmr-fiper2  = <999999995>;
 			fsl,max-adj     = <499999999>;
 			fsl,extts-fifo;
 		};
-- 
2.25.1

