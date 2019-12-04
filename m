Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27FEF113405
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbfLDSGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:06:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730024AbfLDSG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:06:28 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B2D620833;
        Wed,  4 Dec 2019 18:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482787;
        bh=m46hbcDViVWHgP9ujJrVxd/nsrnZXJ5GEUJVDJ3t0e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmbCPz05r2JuORJNQdc/y4Tnxi/VKpw3DOW3TuG+/D39ktQHz2wEO+JglIVaKeUqu
         koGAthXDKtUTzKRsvlP2+ZDS3OlXv531QJZvE5ICsuUIPYXVf7fHcCEhoYpUPQ9aAh
         jsC0lgxhg6sCB/LdS7MzP53UWOTiyPlt1kIij2HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 132/209] gpu: ipu-v3: pre: dont trigger update if buffer address doesnt change
Date:   Wed,  4 Dec 2019 18:55:44 +0100
Message-Id: <20191204175332.267410745@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
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
index 1d1612e28854b..6fd4af647f599 100644
--- a/drivers/gpu/ipu-v3/ipu-pre.c
+++ b/drivers/gpu/ipu-v3/ipu-pre.c
@@ -102,6 +102,7 @@ struct ipu_pre {
 	void			*buffer_virt;
 	bool			in_use;
 	unsigned int		safe_window_end;
+	unsigned int		last_bufaddr;
 };
 
 static DEFINE_MUTEX(ipu_pre_list_mutex);
@@ -177,6 +178,7 @@ void ipu_pre_configure(struct ipu_pre *pre, unsigned int width,
 
 	writel(bufaddr, pre->regs + IPU_PRE_CUR_BUF);
 	writel(bufaddr, pre->regs + IPU_PRE_NEXT_BUF);
+	pre->last_bufaddr = bufaddr;
 
 	val = IPU_PRE_PREF_ENG_CTRL_INPUT_PIXEL_FORMAT(0) |
 	      IPU_PRE_PREF_ENG_CTRL_INPUT_ACTIVE_BPP(active_bpp) |
@@ -218,7 +220,11 @@ void ipu_pre_update(struct ipu_pre *pre, unsigned int bufaddr)
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



