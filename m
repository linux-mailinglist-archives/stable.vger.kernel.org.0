Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22FA12C7D4
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbfL2Rq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:46:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731171AbfL2Rq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:46:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8513206A4;
        Sun, 29 Dec 2019 17:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641617;
        bh=2yZc04posTSVs0CwfNQ6Y3zi8VBEufXGYCSUmYmhmPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W99hGXpvlu1lT2I/wffoY4MAOOiVoVfZROY4qEROMd8cPmOQMmlAWDmLZHGfDcyGL
         BH0z2gnzmOHRS99mC5xwAyRBzkKFVOqGICvavRrAGacwrNSjyWto/zBpnaZukK4oJ1
         XTTpV9/rbZ2LrUPln/4S0j2jhn1oBAMiDdaJHg0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/434] extcon: sm5502: Reset registers during initialization
Date:   Sun, 29 Dec 2019 18:23:12 +0100
Message-Id: <20191229172710.959997760@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 6942635032cfd3e003e980d2dfa4e6323a3ce145 ]

On some devices (e.g. Samsung Galaxy A5 (2015)), the bootloader
seems to keep interrupts enabled for SM5502 when booting Linux.
Changing the cable state (i.e. plugging in a cable) - until the driver
is loaded - will therefore produce an interrupt that is never read.

In this situation, the cable state will be stuck forever on the
initial state because SM5502 stops sending interrupts.
This can be avoided by clearing those pending interrupts after
the driver has been loaded.

One way to do this is to reset all registers to default state
by writing to SM5502_REG_RESET. This ensures that we start from
a clean state, with all interrupts disabled.

Suggested-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-sm5502.c | 4 ++++
 drivers/extcon/extcon-sm5502.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/extcon/extcon-sm5502.c b/drivers/extcon/extcon-sm5502.c
index dc43847ad2b0..b3d93baf4fc5 100644
--- a/drivers/extcon/extcon-sm5502.c
+++ b/drivers/extcon/extcon-sm5502.c
@@ -65,6 +65,10 @@ struct sm5502_muic_info {
 /* Default value of SM5502 register to bring up MUIC device. */
 static struct reg_data sm5502_reg_data[] = {
 	{
+		.reg = SM5502_REG_RESET,
+		.val = SM5502_REG_RESET_MASK,
+		.invert = true,
+	}, {
 		.reg = SM5502_REG_CONTROL,
 		.val = SM5502_REG_CONTROL_MASK_INT_MASK,
 		.invert = false,
diff --git a/drivers/extcon/extcon-sm5502.h b/drivers/extcon/extcon-sm5502.h
index 9dbb634d213b..ce1f1ec310c4 100644
--- a/drivers/extcon/extcon-sm5502.h
+++ b/drivers/extcon/extcon-sm5502.h
@@ -237,6 +237,8 @@ enum sm5502_reg {
 #define DM_DP_SWITCH_UART			((DM_DP_CON_SWITCH_UART <<SM5502_REG_MANUAL_SW1_DP_SHIFT) \
 						| (DM_DP_CON_SWITCH_UART <<SM5502_REG_MANUAL_SW1_DM_SHIFT))
 
+#define SM5502_REG_RESET_MASK			(0x1)
+
 /* SM5502 Interrupts */
 enum sm5502_irq {
 	/* INT1 */
-- 
2.20.1



