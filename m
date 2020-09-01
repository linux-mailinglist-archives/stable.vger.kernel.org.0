Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1809925934C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbgIAPXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729873AbgIAPXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:23:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CD7F207D3;
        Tue,  1 Sep 2020 15:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973827;
        bh=bX7XiqBS73yjRhJ4glUiSibVHoSMDj+twc0vbGM8lxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvpeZXDiots1YLs4N+qNgRU82BzfVkZJbUzObOVbLpqx1TdQG6kkowA5UdmDXdPcl
         OMA5mOCti5+lwsEckhKmz4p795yqL3KTmzFtyoFyUpx8r9cej4kXq4uQG1SO97FT65
         e3f8pd2UNpHBLa5Mj2+eyuykYa1raXdtyGpe9CGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/125] ARM: dts: ls1021a: output PPS signal on FIPER2
Date:   Tue,  1 Sep 2020 17:09:47 +0200
Message-Id: <20200901150936.134730930@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 074b4ec520c63..d18c043264440 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -609,7 +609,7 @@
 			fsl,tmr-prsc    = <2>;
 			fsl,tmr-add     = <0xaaaaaaab>;
 			fsl,tmr-fiper1  = <999999995>;
-			fsl,tmr-fiper2  = <99990>;
+			fsl,tmr-fiper2  = <999999995>;
 			fsl,max-adj     = <499999999>;
 		};
 
-- 
2.25.1



