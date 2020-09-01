Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECEB259989
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbgIAQkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730357AbgIAP2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:28:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F29F2100A;
        Tue,  1 Sep 2020 15:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974091;
        bh=cOs6hkEis3MMWFlqoXr5LZziZMthQpLZImQjdLCdOCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Clwvq4rEXsoh3FT6AGBQfZUxNBKNOo7jvikWRz/f5NXUhnCiTB0t5nmbet96WilNR
         wsDow2k+v7gAAlJ16tKImbBjvl53HPzqI5vUcsECDVT18J+GHQ7JDHGoPtFtO7+7cM
         aYhOi0kGjto3rXst9XmzXAKT07GPHrL1ZQyJGPUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/214] ARM: dts: ls1021a: output PPS signal on FIPER2
Date:   Tue,  1 Sep 2020 17:08:41 +0200
Message-Id: <20200901150954.931991391@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
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
index 63d9f4a066e38..5a8e58b663420 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -753,7 +753,7 @@
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



