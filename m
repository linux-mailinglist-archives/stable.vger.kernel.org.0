Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D251AC340
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898086AbgDPNkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897794AbgDPNkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:40:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21C7B20732;
        Thu, 16 Apr 2020 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044417;
        bh=QVBcO6KeYtquzdd5qot5Cuo/sCycin6IH4MGp/WfrLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhGK2WUd2NifEmu9/5Cva4uj2wA21ypfg3IznesqiYDKSfKpYHOxRtAyfejfF6Grg
         uDFcPPCvIW0NS2/TmSCx6RjQWWYPvzHXEWgUFiy9aCJ8A3R9yUJkyGSNNuiiu4GQl/
         E2ss/Rpb/ia/os8nSb/8r/8+JSefKozWAVHeYiN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.5 168/257] remoteproc: qcom_q6v5_mss: Reload the mba region on coredump
Date:   Thu, 16 Apr 2020 15:23:39 +0200
Message-Id: <20200416131347.463958577@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

commit d96f2571dc84d128cacf1944f4ecc87834c779a6 upstream.

On secure devices after a wdog/fatal interrupt, the mba region has to be
refreshed in order to prevent the following errors during mba load.

Err Logs:
remoteproc remoteproc2: stopped remote processor 4080000.remoteproc
qcom-q6v5-mss 4080000.remoteproc: PBL returned unexpected status -284031232
qcom-q6v5-mss 4080000.remoteproc: PBL returned unexpected status -284031232
....
qcom-q6v5-mss 4080000.remoteproc: PBL returned unexpected status -284031232
qcom-q6v5-mss 4080000.remoteproc: MBA booted, loading mpss

Fixes: 7dd8ade24dc2a ("remoteproc: qcom: q6v5-mss: Add custom dump function for modem")
Cc: stable@vger.kernel.org
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20200304194729.27979-4-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/qcom_q6v5_mss.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -916,6 +916,23 @@ static void q6v5_mba_reclaim(struct q6v5
 	}
 }
 
+static int q6v5_reload_mba(struct rproc *rproc)
+{
+	struct q6v5 *qproc = rproc->priv;
+	const struct firmware *fw;
+	int ret;
+
+	ret = request_firmware(&fw, rproc->firmware, qproc->dev);
+	if (ret < 0)
+		return ret;
+
+	q6v5_load(rproc, fw);
+	ret = q6v5_mba_load(qproc);
+	release_firmware(fw);
+
+	return ret;
+}
+
 static int q6v5_mpss_load(struct q6v5 *qproc)
 {
 	const struct elf32_phdr *phdrs;
@@ -1074,7 +1091,7 @@ static void qcom_q6v5_dump_segment(struc
 
 	/* Unlock mba before copying segments */
 	if (!qproc->dump_mba_loaded) {
-		ret = q6v5_mba_load(qproc);
+		ret = q6v5_reload_mba(rproc);
 		if (!ret) {
 			/* Reset ownership back to Linux to copy segments */
 			ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,


