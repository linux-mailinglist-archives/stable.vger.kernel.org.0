Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4A01AC458
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506784AbgDPN6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441867AbgDPN6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:58:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A4D02078B;
        Thu, 16 Apr 2020 13:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045495;
        bh=oK4EUs+DRClyG/3rKXZm1ZxXK0l4/9QJpxPizuGmNhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtS5JsZl4LSoFJxzGKlAkolwjdEJevdaKvWKKLXfxF5IHnL7qp1td04XXpmUbV2m9
         +kIxTOJaTd+HOuQWmnZB8sXcR606Y3Z6oA3I0pz8r2/NF5kXCUQOMok8GdvpXYRjXw
         nKh8eAtZUcAifQZCow/QMHul+py+94/I9ErIN2MA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sibi Sankar <sibis@codeaurora.org>
Subject: [PATCH 5.6 158/254] remoteproc: qcom_q6v5_mss: Dont reassign mpss region on shutdown
Date:   Thu, 16 Apr 2020 15:24:07 +0200
Message-Id: <20200416131346.381431027@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 900fc60df22748dbc28e4970838e8f7b8f1013ce upstream.

Trying to reclaim mpss memory while the mba is not running causes the
system to crash on devices with security fuses blown, so leave it
assigned to the remote on shutdown and recover it on a subsequent boot.

Fixes: 6c5a9dc2481b ("remoteproc: qcom: Make secure world call for mem ownership switch")
Cc: stable@vger.kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20200304194729.27979-2-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/qcom_q6v5_mss.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1001,11 +1001,6 @@ static void q6v5_mba_reclaim(struct q6v5
 		writel(val, qproc->reg_base + QDSP6SS_PWR_CTL_REG);
 	}
 
-	ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
-				      false, qproc->mpss_phys,
-				      qproc->mpss_size);
-	WARN_ON(ret);
-
 	q6v5_reset_assert(qproc);
 
 	q6v5_clk_disable(qproc->dev, qproc->reset_clks,
@@ -1095,6 +1090,14 @@ static int q6v5_mpss_load(struct q6v5 *q
 			max_addr = ALIGN(phdr->p_paddr + phdr->p_memsz, SZ_4K);
 	}
 
+	/**
+	 * In case of a modem subsystem restart on secure devices, the modem
+	 * memory can be reclaimed only after MBA is loaded. For modem cold
+	 * boot this will be a nop
+	 */
+	q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm, false,
+				qproc->mpss_phys, qproc->mpss_size);
+
 	mpss_reloc = relocate ? min_addr : qproc->mpss_phys;
 	qproc->mpss_reloc = mpss_reloc;
 	/* Load firmware segments */
@@ -1184,8 +1187,16 @@ static void qcom_q6v5_dump_segment(struc
 	void *ptr = rproc_da_to_va(rproc, segment->da, segment->size);
 
 	/* Unlock mba before copying segments */
-	if (!qproc->dump_mba_loaded)
+	if (!qproc->dump_mba_loaded) {
 		ret = q6v5_mba_load(qproc);
+		if (!ret) {
+			/* Reset ownership back to Linux to copy segments */
+			ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
+						      false,
+						      qproc->mpss_phys,
+						      qproc->mpss_size);
+		}
+	}
 
 	if (!ptr || ret)
 		memset(dest, 0xff, segment->size);
@@ -1196,8 +1207,14 @@ static void qcom_q6v5_dump_segment(struc
 
 	/* Reclaim mba after copying segments */
 	if (qproc->dump_segment_mask == qproc->dump_complete_mask) {
-		if (qproc->dump_mba_loaded)
+		if (qproc->dump_mba_loaded) {
+			/* Try to reset ownership back to Q6 */
+			q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
+						true,
+						qproc->mpss_phys,
+						qproc->mpss_size);
 			q6v5_mba_reclaim(qproc);
+		}
 	}
 }
 
@@ -1237,10 +1254,6 @@ static int q6v5_start(struct rproc *rpro
 	return 0;
 
 reclaim_mpss:
-	xfermemop_ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
-						false, qproc->mpss_phys,
-						qproc->mpss_size);
-	WARN_ON(xfermemop_ret);
 	q6v5_mba_reclaim(qproc);
 
 	return ret;


