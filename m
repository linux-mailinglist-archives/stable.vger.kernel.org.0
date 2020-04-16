Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA481AC667
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409207AbgDPOCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409612AbgDPOCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:02:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 066F7217D8;
        Thu, 16 Apr 2020 14:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045731;
        bh=xwwvXdkTLkHv6AGvthi0kajQIzbM5WF2VxClMmRruQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwGyR0prAc+ugjSfi7Ivq5Ym5PVrycFSmjv9w5V+Dgc6KUbb6RdYlsCZFcmfVWCdA
         KCxGmztZvE/VZL7kBiVdb9036f2EXEYTbJK+Js70hKbicgPp6+vzaKqfdgVsz+nR24
         QvZoRsDvwZMY7YC1jEhIPvYU1vgj/xRMQObLLaQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.6 227/254] clk: ingenic/TCU: Fix round_rate returning error
Date:   Thu, 16 Apr 2020 15:25:16 +0200
Message-Id: <20200416131354.136094206@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit edcc42945dee85e9dec3737f3dbf59d917ae5418 upstream.

When requesting a rate superior to the parent's rate, it would return
-EINVAL instead of simply returning the parent's rate like it should.

Fixes: 4f89e4b8f121 ("clk: ingenic: Add driver for the TCU clocks")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lkml.kernel.org/r/20200213161952.37460-2-paul@crapouillou.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/ingenic/tcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/ingenic/tcu.c
+++ b/drivers/clk/ingenic/tcu.c
@@ -189,7 +189,7 @@ static long ingenic_tcu_round_rate(struc
 	u8 prescale;
 
 	if (req_rate > rate)
-		return -EINVAL;
+		return rate;
 
 	prescale = ingenic_tcu_get_prescale(rate, req_rate);
 


