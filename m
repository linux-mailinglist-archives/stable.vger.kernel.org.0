Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAD946813D
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 01:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354484AbhLDAaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 19:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354465AbhLDAaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 19:30:17 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13690C061751;
        Fri,  3 Dec 2021 16:26:53 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i12so4395348pfd.6;
        Fri, 03 Dec 2021 16:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xt4I0hFpcTJ+06LRJTbR8pOWcg/Rgjcqw9G3A/8QWVY=;
        b=NB2aSL/UaQ34PKQCx8Q1fjvBwXBD+2royM7CgCzBILFJyI4KNNpoI4oziud9tDhe9Q
         FlbKbm9O9810kcM+bN4bycWXIl9zq0GYnCnRySGDF5wTYzzQOXBnaO5NQFNXQ60Yh7Bw
         N/XFBz9rv+7r69SiMNhRFag157vGLKzPGM+2h7PHcqX8hKqiQsVQ8y1byMlFAKeRgN/t
         nKLeG1KrU4PTVsQXq0MbRpWIbEksfXj7KwfBfvWHIKzg7l02FDwTBVEA9QuOusbTQtEP
         UBINWWDq3a0Y36nkWRm0wkk8a/Wi/F6iQ10Xajh8vJoz0t8x/e9vKCutrgBjMt63O/yo
         AApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xt4I0hFpcTJ+06LRJTbR8pOWcg/Rgjcqw9G3A/8QWVY=;
        b=y/Rsz6WtJfnhSSN34vGNtLpqZLYkb+Y2aCqhSVh37u/8f52uoRrFQkgrKlmtxwr/R/
         rJ82+7prbqqt7Qfi4tSQkY5BJMfHWtQC+Jt1deqflJ+f5aVaL24Z322zXMx1N5kpLz2C
         MxB9mGvBJn7TV4BJxBw7wQCXmdULmPi8fxKZCPK9fuvrFStZnd2NHOmTGMBAhghqYtwK
         owaIKnURCf5uR7bQvbChch66Dq0aLKSYKlS9Nz34KGpSK5G0VmXVHOwe4IprRWt3SdeL
         sL/as0LgbCLDgTlCmD5YM1OoASM7c3NovvIXLoaUWU6WrEsDJE9cacRtgzvQ5iRQj8DR
         gTug==
X-Gm-Message-State: AOAM5317D/UEKkXo2iausmKNU3LUhuEqYacywSWQLgoZpWnCFDAIyfVi
        fDJhxKgVYGUhe1Xa2mwKQIGpV5z1MmU=
X-Google-Smtp-Source: ABdhPJy8CO5kC/1SnRRJXIPtONAsqVPcnD/drmDwKq3cK4+l6DU70/8bTAWFiAtcKzB1Ay6nKmHFEQ==
X-Received: by 2002:a63:6b44:: with SMTP id g65mr7223945pgc.502.1638577612477;
        Fri, 03 Dec 2021 16:26:52 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q17sm4970707pfu.117.2021.12.03.16.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:26:52 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 3/9] lpfc: Fix lpfc_force_rscn ndlp kref imbalance
Date:   Fri,  3 Dec 2021 16:26:38 -0800
Message-Id: <20211204002644.116455-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211204002644.116455-1-jsmart2021@gmail.com>
References: <20211204002644.116455-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Issuing lpfc_force_rscn twice results in an ndlp kref use-after-free call
trace.

A prior patch reworked the get/put handling by ensuring nlp_get was done
before WQE submission and a put was done in the completion path.
Unfortunately, the issue_els_rscn path had a piece of legacy code that
did a nlp_put, causing an imbalance on the ref counts.

Fixed by removing the unnecessary legacy code snippet.

Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taking")
Cc: <stable@vger.kernel.org> # v5.11+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 5c10416c1c75..78024f11b794 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3538,11 +3538,6 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
 		return 1;
 	}
 
-	/* This will cause the callback-function lpfc_cmpl_els_cmd to
-	 * trigger the release of node.
-	 */
-	if (!(vport->fc_flag & FC_PT2PT))
-		lpfc_nlp_put(ndlp);
 	return 0;
 }
 
-- 
2.26.2

