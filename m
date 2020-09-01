Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BDB259723
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731335AbgIAPh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbgIAPh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:37:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B44B2205F4;
        Tue,  1 Sep 2020 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974648;
        bh=z08zS9fdCbZEek5MarOJHv6P9oDI3fRckVQBcMExBLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxFNZWqOtedFrxpXn2FbaLL8HsijHhaSQdy0oNb9qstrgG4g7kDNVz/o07bL9/Fmo
         n7esJsYpOBB0u8kkaa0lZ2ipaWDKOH9ufT/a9HF7jdjarV7Lo3nxHmI3O3e1y2rvAL
         +2uOKPqa+ZDe8/rfGto5Giua3lCIiHBlo0cOwIWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 041/255] ARM: dts: ls1021a: output PPS signal on FIPER2
Date:   Tue,  1 Sep 2020 17:08:17 +0200
Message-Id: <20200901151002.717933305@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
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
index 760a68c163c83..b2ff27af090ec 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -772,7 +772,7 @@
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



