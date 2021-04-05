Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14F0353ED1
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbhDEJIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:08:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238522AbhDEJH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:07:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A705613A7;
        Mon,  5 Apr 2021 09:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613671;
        bh=jotek+SRzaCEu9EnIxNa2yv3f/sIcUy3CNiFrA2f5Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShaYNX4g7UILuEMCSfMFkd+SNqd9XOrknGSinrgQ3KkkFDD5FhTdvLctkWcviEggE
         +JIFUuOG+robLaRIFHN6c+T1iN22tyGrCrtKkbICjcra0Bq/nXQ28QfGdaUYvRrx8w
         FuGQO2xG2exis4NAvr0XYgmaUlLIgR5g0MldjUXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/126] net: ipa: remove two unused register definitions
Date:   Mon,  5 Apr 2021 10:53:32 +0200
Message-Id: <20210405085032.690438949@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit d5bc5015eb9d64cbd14e467db1a56db1472d0d6c ]

We do not support inter-EE channel or event ring commands.  Inter-EE
interrupts are disabled (and never re-enabled) for all channels and
event rings, so we have no need for the GSI registers that clear
those interrupt conditions.  So remove their definitions.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi_reg.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 8e0e9350c383..42e5a8b8d324 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -48,16 +48,6 @@
 #define GSI_INTER_EE_N_SRC_EV_CH_IRQ_OFFSET(ee) \
 			(0x0000c01c + 0x1000 * (ee))
 
-#define GSI_INTER_EE_SRC_CH_IRQ_CLR_OFFSET \
-			GSI_INTER_EE_N_SRC_CH_IRQ_CLR_OFFSET(GSI_EE_AP)
-#define GSI_INTER_EE_N_SRC_CH_IRQ_CLR_OFFSET(ee) \
-			(0x0000c028 + 0x1000 * (ee))
-
-#define GSI_INTER_EE_SRC_EV_CH_IRQ_CLR_OFFSET \
-			GSI_INTER_EE_N_SRC_EV_CH_IRQ_CLR_OFFSET(GSI_EE_AP)
-#define GSI_INTER_EE_N_SRC_EV_CH_IRQ_CLR_OFFSET(ee) \
-			(0x0000c02c + 0x1000 * (ee))
-
 #define GSI_CH_C_CNTXT_0_OFFSET(ch) \
 		GSI_EE_N_CH_C_CNTXT_0_OFFSET((ch), GSI_EE_AP)
 #define GSI_EE_N_CH_C_CNTXT_0_OFFSET(ch, ee) \
-- 
2.30.1



