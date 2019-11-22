Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BBF1064FB
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfKVGUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:20:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbfKVFwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 143672073B;
        Fri, 22 Nov 2019 05:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401953;
        bh=DVaKPiUmHGKWMJgDHNMiWfSzaP1Ywwb9Top1BdaLCeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxuUXIo/dVhzdK+qgDJHdYtJXTqnHMjp2yum9t9gl3dcES2MmpIJBovzDmD9vmaUU
         dhpVrOlUtb12lNWrQ3AB5yf9gyHCMNHkapll/MegtW2QVQGI9JrDx7l48jsK3XDd88
         IMuDBFTMbTz9N7rsWUlUrDf5IAFAEqdJdw6svvhI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 176/219] gpu: ipu-v3: pre: don't trigger update if buffer address doesn't change
Date:   Fri, 22 Nov 2019 00:48:28 -0500
Message-Id: <20191122054911.1750-169-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

