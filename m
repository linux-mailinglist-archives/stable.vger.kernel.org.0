Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E0E45101B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242455AbhKOSlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242590AbhKOSiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:38:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A94361B3F;
        Mon, 15 Nov 2021 18:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999432;
        bh=kK5tDRbndhep6n5Iqnd7fMS2DINuPz4m/80CJwB7Krk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i977bPR0JOSP7pblk/K3kgHSfIqpPIEdHywllLA30y/ejZWs80yKrY0owIfZAqgqX
         2Gh+JvWU87TwE2/MyRIp/+r8JgE2BH5is5Eznjop9t3KVpLWbl2TFhSKY4GTpOHk2l
         PwG1UunwDrffxEA/YXxssofG5txdRww/aFCBSSyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuri Savinykh <s02190703@gse.cs.msu.ru>,
        Nadezda Lutovinova <lutovinova@ispras.ru>,
        Michael Tretter <m.tretter@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 295/849] media: allegro: ignore interrupt if mailbox is not initialized
Date:   Mon, 15 Nov 2021 17:56:18 +0100
Message-Id: <20211115165430.239358463@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Tretter <m.tretter@pengutronix.de>

[ Upstream commit 1ecda6393db4be44aba27a243e648dc98c9b92e3 ]

The mailbox is initialized after the interrupt handler is installed. As
the firmware is loaded and started even later, it should not happen that
the interrupt occurs without the mailbox being initialized.

As the Linux Driver Verification project (linuxtesting.org) keeps
reporting this as an error, add a check to ignore interrupts before the
mailbox is initialized to fix this potential null pointer dereference.

Reported-by: Yuri Savinykh <s02190703@gse.cs.msu.ru>
Reported-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/allegro-dvt/allegro-core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/allegro-dvt/allegro-core.c b/drivers/media/platform/allegro-dvt/allegro-core.c
index 887b492e4ad1c..14a119b43bca0 100644
--- a/drivers/media/platform/allegro-dvt/allegro-core.c
+++ b/drivers/media/platform/allegro-dvt/allegro-core.c
@@ -2185,6 +2185,15 @@ static irqreturn_t allegro_irq_thread(int irq, void *data)
 {
 	struct allegro_dev *dev = data;
 
+	/*
+	 * The firmware is initialized after the mailbox is setup. We further
+	 * check the AL5_ITC_CPU_IRQ_STA register, if the firmware actually
+	 * triggered the interrupt. Although this should not happen, make sure
+	 * that we ignore interrupts, if the mailbox is not initialized.
+	 */
+	if (!dev->mbox_status)
+		return IRQ_NONE;
+
 	allegro_mbox_notify(dev->mbox_status);
 
 	return IRQ_HANDLED;
-- 
2.33.0



