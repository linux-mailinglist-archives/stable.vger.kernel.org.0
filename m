Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7FAEB77E
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 19:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfJaSqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 14:46:38 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45676 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729383AbfJaSqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 14:46:38 -0400
Received: by mail-pl1-f193.google.com with SMTP id y24so3075953plr.12
        for <stable@vger.kernel.org>; Thu, 31 Oct 2019 11:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WuFs+AMjdDKhamzQV8PIhDJ9khhpt9bix4gVbxAEv5k=;
        b=xb5T9zfHZejq85gO7jFd2zwpcyRjEnFCa9jXw/a1BGYBwqiwPHqwXTp9crC//hhHBa
         P5W8qYXn5P38liorEw8r1uSL0xAUNDvmDxyV+IVzflal+6BpyC+0RAJnGsV9zkXPiSV3
         NX3O2JYP5+8nsz4MK9QAd6yQZBiDXV1dsxyAWjiOPlDrwyipQhs4yUn3P8XJnLyou9Le
         oaQvShGAI9coypED6Vks17iWdIGWBU2/ZB9RbsWxUc0skHGl4Q3zuT6JWaQBQBh7/W3g
         hVni+YYwokAHkK52tCBKlRATf5xhM3BGYzJ1whHDf8BZuN4gW5CxqdtN5W01iF31EAgG
         Th0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WuFs+AMjdDKhamzQV8PIhDJ9khhpt9bix4gVbxAEv5k=;
        b=tbSg06MqWfSItL5T1qDN2ppQ9vtsbVe9KZx4f3hNZKpbzEiiaIfecHm+6NMmFwQNnG
         JkLOXc2AKUSUM/3tTryu5vnGdv5b2R0pR83e2ST5PhajJqbI4RTvFRJkPJtYj/r0Anm1
         qxL/InDv7ra/eNG+ZxeOjSf4jsbCNsyX8mjj7vRsus3Un+BT1flFnNDIv1soopPT9W7t
         cKLZpzUgihZbaSRMAPlhc33y0LnSy2k1tPf54rjE7ld4r1z53uUWv1bEfEmMgpCOfoo0
         oSz8EOoJWVLkIFU+5OZW3lGSzInbOy7gzFmtcFkXZbmzKtty5GchhjOeexXoRqSCt8ES
         40EQ==
X-Gm-Message-State: APjAAAWb+qIoEvdGptgkfpLmhPU8T4RYKyS0zarERCJKrpVKT7ecq91g
        Z2ME2RigXXpFAl2LwrQp0wEKqQ==
X-Google-Smtp-Source: APXvYqxKWUYn0+yrgxpPU2r080t3eP3XdoiS3bDXrFSoHsxoPngV5s+zNQngefMMk3otTAvzQpcJow==
X-Received: by 2002:a17:902:b612:: with SMTP id b18mr7933212pls.309.1572547597107;
        Thu, 31 Oct 2019 11:46:37 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id b82sm3950874pfb.33.2019.10.31.11.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 11:46:36 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Avaneesh Kumar Dwivedi <akdwived@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeffrey Hugo <jhugo@codeaurora.org>,
        Sibi Sankar <sibis@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] remoteproc: qcom_q6v5_mss: Don't reassign mpss region on shutdown
Date:   Thu, 31 Oct 2019 11:46:31 -0700
Message-Id: <20191031184632.2938295-2-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191031184632.2938295-1-bjorn.andersson@linaro.org>
References: <20191031184632.2938295-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Trying to reclaim mpss memory while the mba is not running causes the
system to crash on devices with security fuses blown, so leave it
assigned to the remote on shutdown and recover it on a subsequent boot.

Fixes: 6c5a9dc2481b ("remoteproc: qcom: Make secure world call for mem ownership switch")
Cc: stable@vger.kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index de919f2e8b94..f4a02105d539 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -875,11 +875,6 @@ static void q6v5_mba_reclaim(struct q6v5 *qproc)
 		writel(val, qproc->reg_base + QDSP6SS_PWR_CTL_REG);
 	}
 
-	ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
-				      false, qproc->mpss_phys,
-				      qproc->mpss_size);
-	WARN_ON(ret);
-
 	q6v5_reset_assert(qproc);
 
 	q6v5_clk_disable(qproc->dev, qproc->reset_clks,
@@ -969,6 +964,10 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
 			max_addr = ALIGN(phdr->p_paddr + phdr->p_memsz, SZ_4K);
 	}
 
+	/* Try to reset ownership back to Linux */
+	q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm, false,
+				qproc->mpss_phys, qproc->mpss_size);
+
 	mpss_reloc = relocate ? min_addr : qproc->mpss_phys;
 	qproc->mpss_reloc = mpss_reloc;
 	/* Load firmware segments */
@@ -1111,10 +1110,6 @@ static int q6v5_start(struct rproc *rproc)
 	return 0;
 
 reclaim_mpss:
-	xfermemop_ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
-						false, qproc->mpss_phys,
-						qproc->mpss_size);
-	WARN_ON(xfermemop_ret);
 	q6v5_mba_reclaim(qproc);
 
 	return ret;
-- 
2.23.0

