Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4EE4CFA6B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238961AbiCGKQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239298AbiCGKPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:15:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F4B7C145;
        Mon,  7 Mar 2022 01:57:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5123460A23;
        Mon,  7 Mar 2022 09:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414CEC340E9;
        Mon,  7 Mar 2022 09:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646999;
        bh=5F5auzfzkdMpSUKFR4bTjbWgfqjhnAg35Vq0NJ55ko8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0rxXZcetrxZGoMye9mP4K9WMGkikbjOBuiX70RcbcIfcj1l8YvdMTivYT8YB3hpl
         Qv19zXJIJX9B3CGMx9u+svKIghZpN30inRuuLJ3hxOfw4K2Ts055C3EihrZoFN1mzj
         g2VmZFXvEzVUMkteQNHMb/w+3MSah59XELImTxCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 161/186] ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments
Date:   Mon,  7 Mar 2022 10:19:59 +0100
Message-Id: <20220307091658.577485153@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>

[ Upstream commit 90f8f4c0e3cebd541deaa45cf0e470bb9810dd4f ]

In ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime."), the
ns adjustment was written to the FPGA register, so the clock could
accurately perform adjustments.

However, the adjtime() call passes in a s64, while the clock adjustment
registers use a s32.  When trying to perform adjustments with a large
value (37 sec), things fail.

Examine the incoming delta, and if larger than 1 sec, use the original
(coarse) adjustment method.  If smaller than 1 sec, then allow the
FPGA to fold in the changes over a 1 second window.

Fixes: 6d59d4fa1789 ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime.")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20220228203957.367371-1-jonathan.lemon@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 0f1b5a7d2a89..17ad5f0d13b2 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -607,7 +607,7 @@ ptp_ocp_settime(struct ptp_clock_info *ptp_info, const struct timespec64 *ts)
 }
 
 static void
-__ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u64 adj_val)
+__ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u32 adj_val)
 {
 	u32 select, ctrl;
 
@@ -615,7 +615,7 @@ __ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u64 adj_val)
 	iowrite32(OCP_SELECT_CLK_REG, &bp->reg->select);
 
 	iowrite32(adj_val, &bp->reg->offset_ns);
-	iowrite32(adj_val & 0x7f, &bp->reg->offset_window_ns);
+	iowrite32(NSEC_PER_SEC, &bp->reg->offset_window_ns);
 
 	ctrl = OCP_CTRL_ADJUST_OFFSET | OCP_CTRL_ENABLE;
 	iowrite32(ctrl, &bp->reg->ctrl);
@@ -624,6 +624,22 @@ __ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u64 adj_val)
 	iowrite32(select >> 16, &bp->reg->select);
 }
 
+static void
+ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, u64 delta_ns)
+{
+	struct timespec64 ts;
+	unsigned long flags;
+	int err;
+
+	spin_lock_irqsave(&bp->lock, flags);
+	err = __ptp_ocp_gettime_locked(bp, &ts, NULL);
+	if (likely(!err)) {
+		timespec64_add_ns(&ts, delta_ns);
+		__ptp_ocp_settime_locked(bp, &ts);
+	}
+	spin_unlock_irqrestore(&bp->lock, flags);
+}
+
 static int
 ptp_ocp_adjtime(struct ptp_clock_info *ptp_info, s64 delta_ns)
 {
@@ -631,6 +647,11 @@ ptp_ocp_adjtime(struct ptp_clock_info *ptp_info, s64 delta_ns)
 	unsigned long flags;
 	u32 adj_ns, sign;
 
+	if (delta_ns > NSEC_PER_SEC || -delta_ns > NSEC_PER_SEC) {
+		ptp_ocp_adjtime_coarse(bp, delta_ns);
+		return 0;
+	}
+
 	sign = delta_ns < 0 ? BIT(31) : 0;
 	adj_ns = sign ? -delta_ns : delta_ns;
 
-- 
2.34.1



