Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01C639484E
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 23:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhE1VYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 17:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhE1VYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 17:24:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8A6C061574;
        Fri, 28 May 2021 14:22:45 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f3-20020a17090a4a83b02901619627235bso1130075pjh.1;
        Fri, 28 May 2021 14:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AAm/Rd7QC3VUgd2WvOibfK1HCay8pvSqKwkU5G4j4T0=;
        b=HJZ24VQ9l40CQjL8gFSf3KKuxMp3kX2Nb64DSrWe8CcSWAtibw7i43zvDkPaC5mBiw
         YOwuRAkEmQ3tWmTTM4eZSpDNgQeEHIcokpqRyWAG7ptRWSxHWNrrZLedWVOhDZmJyOZS
         D1YTAMuAQmK2xKD2cnAslogcNXIhn8KO92aA3NiDbH+cQMM/ACc1mu7ao8PsXmPhe+fk
         lCj7utUr6U/7uTBkfDKT2Y41Khai0NHueXnZVi6AbQAOBDfC3Y71S6zKVasgqxYCW45v
         RthhCMTQ2Tg3cdBu7d3IqSBFyGWDSUQDdLfQQtxb6Zwz7oNE+PzXMA+lmfBD5lHEusDI
         +YNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AAm/Rd7QC3VUgd2WvOibfK1HCay8pvSqKwkU5G4j4T0=;
        b=ZrGNUMOBnwat+/6Nhb45MX5VkBaVgRxWnw61H3d/iiAnZMANh9ifirp688sI5yllzl
         hzggUgnhFIwjsCB33MIyq0/ehTT+BwLSASI5TIPTNe2K0NvQHpD2iU3npy1nxNYZu9bf
         1AiI/HpIbvwJiyZN+oLJvjF8gw6sRpVGFe13deIbJ7/MdVfvw98HtT/r+0UxdyevLrY8
         3L+N3/VzXS1qcSBafkgsrmkvvGJuHTqI4UFgKFB4jOvKEMizknIFzoQK0xL566FVVSdS
         XZ09WhXrZp01IK83vZ6G5FnENC3wzoJaufZxaYbsPBi7J4JL07vrC55Kz3FH3WWwnrZP
         PVdA==
X-Gm-Message-State: AOAM530p1A05GJzKO6RbaHlhg/9C2S0ASOb9tyC6BX8vGIyUYhHqVdj/
        lbS7L/6jI9ErgkyzawICZmeGQvO2IHE=
X-Google-Smtp-Source: ABdhPJyK+fhRlRrLD4VvoADZ7f6+VUatYYoMCobg7Dt+DxwN+YE70QTdJpt2w3WeLs3nzL4RXac4mw==
X-Received: by 2002:a17:90a:b88d:: with SMTP id o13mr6581897pjr.207.1622236965076;
        Fri, 28 May 2021 14:22:45 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o6sm5169734pfb.126.2021.05.28.14.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 14:22:44 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] lpfc: Fix failure to transmit ABTS on FC link
Date:   Fri, 28 May 2021 14:22:40 -0700
Message-Id: <20210528212240.11387-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The abort_cmd_ia flag in an abort wqe describes whether an ABTS basic
link service should be transmitted on the FC link or not.
Code added in lpfc_sli4_issue_abort_iotag() set the abort_cmd_ia flag
incorrectly, surpressing ABTS transmission.

A previous LPFC change to build an abort wqe inverted prior logic that
determined whether an ABTS was to be issued on the FC link.

Revert this logic to its proper state.

Fixes: db7531d2b377 ("scsi: lpfc: Convert abort handling to SLI-3 and SLI-4 handlers")
Cc: <stable@vger.kernel.org> # v5.11+
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1ad1beb2a8a8..e2cfb86f7e61 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20615,10 +20615,8 @@ lpfc_sli4_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	abtswqe = &abtsiocb->wqe;
 	memset(abtswqe, 0, sizeof(*abtswqe));
 
-	if (lpfc_is_link_up(phba))
+	if (!lpfc_is_link_up(phba))
 		bf_set(abort_cmd_ia, &abtswqe->abort_cmd, 1);
-	else
-		bf_set(abort_cmd_ia, &abtswqe->abort_cmd, 0);
 	bf_set(abort_cmd_criteria, &abtswqe->abort_cmd, T_XRI_TAG);
 	abtswqe->abort_cmd.rsrvd5 = 0;
 	abtswqe->abort_cmd.wqe_com.abort_tag = xritag;
-- 
2.26.2

