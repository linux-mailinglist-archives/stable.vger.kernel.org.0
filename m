Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D31111E31
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfLCW4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:56:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730335AbfLCW4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:56:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CA9220656;
        Tue,  3 Dec 2019 22:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413780;
        bh=DVaKPiUmHGKWMJgDHNMiWfSzaP1Ywwb9Top1BdaLCeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fackK0Pzl1sDQ8ERjI7u5YA/say3tSKm9p3GxSOr37KYsEnssm9uQCdDs5G0e7i4Q
         g6TJfJMmd9AWHbFgc1Th+VVwZY1Z7JfUrzgAKZY4RW83bhvZyM9suY+IuOQW0ZjsxX
         qvxyOnolZfrRlwr65fThkQuOF6dOSt63XQeJDJx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 220/321] gpu: ipu-v3: pre: dont trigger update if buffer address doesnt change
Date:   Tue,  3 Dec 2019 23:34:46 +0100
Message-Id: <20191203223438.564186639@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit eb0200a4357da100064971689d3a0e9e3cf57f33 ]

On a NOP double buffer update where current buffer address is the same
as the next buffer address, the SDW_UPDATE bit clears too late. As we
are now using this bit to determine when it is safe to signal flip
completion to userspace this will delay completion of atomic commits
where one plane doesn't change the buffer by a whole frame period.

Fix this by remembering the last buffer address and just skip the
double buffer update if it would not change the buffer address.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
[p.zabel@pengutronix.de: initialize last_bufaddr in ipu_pre_configure]
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/ipu-v3/ipu-pre.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-pre.c b/drivers/gpu/ipu-v3/ipu-pre.c
index 2f8db9d625514..4a28f3fbb0a28 100644
--- a/drivers/gpu/ipu-v3/ipu-pre.c
+++ b/drivers/gpu/ipu-v3/ipu-pre.c
@@ -106,6 +106,7 @@ struct ipu_pre {
 	void			*buffer_virt;
 	bool			in_use;
 	unsigned int		safe_window_end;
+	unsigned int		last_bufaddr;
 };
 
 static DEFINE_MUTEX(ipu_pre_list_mutex);
@@ -185,6 +186,7 @@ void ipu_pre_configure(struct ipu_pre *pre, unsigned int width,
 
 	writel(bufaddr, pre->regs + IPU_PRE_CUR_BUF);
 	writel(bufaddr, pre->regs + IPU_PRE_NEXT_BUF);
+	pre->last_bufaddr = bufaddr;
 
 	val = IPU_PRE_PREF_ENG_CTRL_INPUT_PIXEL_FORMAT(0) |
 	      IPU_PRE_PREF_ENG_CTRL_INPUT_ACTIVE_BPP(active_bpp) |
@@ -242,7 +244,11 @@ void ipu_pre_update(struct ipu_pre *pre, unsigned int bufaddr)
 	unsigned short current_yblock;
 	u32 val;
 
+	if (bufaddr == pre->last_bufaddr)
+		return;
+
 	writel(bufaddr, pre->regs + IPU_PRE_NEXT_BUF);
+	pre->last_bufaddr = bufaddr;
 
 	do {
 		if (time_after(jiffies, timeout)) {
-- 
2.20.1



