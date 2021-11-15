Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A28450D82
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbhKOR7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:59:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239300AbhKOR4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:56:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B009632C4;
        Mon, 15 Nov 2021 17:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997658;
        bh=SzQNO/O358U0WtjF0OqVvLkH383vxKiZIXVDUXTmgEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGuXfskID+bxKvNf0b0IRWS2q2drQUbNSrJMI6JGBg7tLeWSPqsslH5cZNcOUceiY
         fl4wqCJ7yiGRJz9VWV2d+tcuT4IhE1UgRnTLEu0PwIBnMRnhiIln7KuBU44E+7iAsI
         TH+PHpFe+U5AB2xTO0V+vwtJ0zFS8jaGo+KdL8qA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuri Savinykh <s02190703@gse.cs.msu.ru>,
        Nadezda Lutovinova <lutovinova@ispras.ru>,
        Michael Tretter <m.tretter@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/575] media: allegro: ignore interrupt if mailbox is not initialized
Date:   Mon, 15 Nov 2021 17:59:14 +0100
Message-Id: <20211115165351.645786402@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
 drivers/staging/media/allegro-dvt/allegro-core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/staging/media/allegro-dvt/allegro-core.c b/drivers/staging/media/allegro-dvt/allegro-core.c
index 640451134072b..28b6ba895ccd5 100644
--- a/drivers/staging/media/allegro-dvt/allegro-core.c
+++ b/drivers/staging/media/allegro-dvt/allegro-core.c
@@ -1802,6 +1802,15 @@ static irqreturn_t allegro_irq_thread(int irq, void *data)
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



