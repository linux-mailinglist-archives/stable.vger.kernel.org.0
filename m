Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DF524DCD3
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgHURIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728208AbgHUQRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:17:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E6DD208DB;
        Fri, 21 Aug 2020 16:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026662;
        bh=vl8oRoCeWLKb4mHXsDMNYnDGq4+Zf3obi0yoFIYb55k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGFjH+BOOmLsmdSokfPJ9p+tiQw1MA0D1oMHBfiTOYEU+zxPHgRLdpqxsndPwFy3H
         sXPJYlK45RQeIcEiYTEGLhbznVsezaS3spJ+K4Juk7XJNED89QZwXd7MYF90EuQWO1
         z+N1qucZlgZHAEGxS8CURr2WYwnJPqQuLWQPpDZE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 29/48] ARM: dts: ls1021a: output PPS signal on FIPER2
Date:   Fri, 21 Aug 2020 12:16:45 -0400
Message-Id: <20200821161704.348164-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161704.348164-1-sashal@kernel.org>
References: <20200821161704.348164-1-sashal@kernel.org>
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
index 63d9f4a066e38..5a8e58b663420 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -753,7 +753,7 @@ ptp_clock@2d10e00 {
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

