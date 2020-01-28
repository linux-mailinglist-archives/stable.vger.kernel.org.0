Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E46114AD20
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 01:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgA1AX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 19:23:28 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46603 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA1AX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 19:23:28 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so13918461wrl.13;
        Mon, 27 Jan 2020 16:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6X3pSVYOmaLrFZPz8SdTynEueBTKozoNc/ti5/zEvSk=;
        b=etE/b1Z9Z+UdI8bGUZixu10a9qqINFkJTJSWvCmJ4WnahZzy5XMk6kjhwwlK2BtbOS
         jUU2NDN3fscVAUrAVjPR7uFAuneDajIpayvFdlUeiJCgjPxNhEQHvZAtY3VCYKm+N8oi
         wf5TYbN8G8iplfGh0ld5PFHdKYTh+oW4wpuZCWv82WGHCi+PER8rcE12LuT2V2lz0gpq
         DESiXUWrBH5P/rp9HaAfvzfdF7Ts6kB/xgrufAcw5u2p3nvNxZ+/1Rakkl1X7nf1yXSG
         +JDmNzGhlxhCRgrZ5DJwt0mL5KoPBl7vljQ4UHsM5j83duijq2gVWrBNq1rDV303MrRI
         b3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6X3pSVYOmaLrFZPz8SdTynEueBTKozoNc/ti5/zEvSk=;
        b=I4cXHmyNHnFD7EWbPSjJcYs3Bptr+7JsgtjH5u2Up0AKCGGxWAoZjfunoqp0nuyqtg
         EK7VtnicLApMq0mmBNm0RYzCJzg0x53L937t2aEZLkbfzwhYTGF06HrQNhVaOcgo4Ps7
         zsEfhi/0T8AZ3sv6jBcQmlo/jaleNdIYOrsgqjut+odmZ+7tbViOmwKsB2PKrd7ZxPxH
         SY/MMVZvDWHxd1t1u5v/PtodiQ3y9toj6SXecKXpkP7jBohPpjHOblAM+hUhmnQy+8Dy
         5wDWVMSVX/QAfCPkwRAG2m5LQd9h89ykT69/eUkDP/kNJjDKeHVaAx8tHoYFGQgTAnyO
         Htig==
X-Gm-Message-State: APjAAAWc7pRtq1S9uWRL8/B/dFxP+lt0UuLN8TA09i8t+cBY1Yzcfs4f
        ZL8zrRp5UvVPT+HMVZHwOsuxf/sR
X-Google-Smtp-Source: APXvYqw8gFfJD4V0czsrTnhsNoO/yhUKjKpAjr3fYq5lH0KS7Zs0UZQC83RhNVvdJ7ss+2vUN78mJw==
X-Received: by 2002:adf:dfd2:: with SMTP id q18mr26105138wrn.152.1580171005865;
        Mon, 27 Jan 2020 16:23:25 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm583769wmi.43.2020.01.27.16.23.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 16:23:25 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 02/12] lpfc: Fix lpfc_io_buf resource leak in lpfc_get_scsi_buf_s4 error path
Date:   Mon, 27 Jan 2020 16:23:02 -0800
Message-Id: <20200128002312.16346-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200128002312.16346-1-jsmart2021@gmail.com>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a call to lpfc_get_cmd_rsp_buf_per_hdwq returns NULL (memory
allocation failure), a previously allocated lpfc_io_buf resource is
leaked.

Fix by releasing the lpfc_io_buf resource in the failure path.

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 2c7e0b22db2f..96ac4a154c58 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -671,8 +671,10 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	lpfc_cmd->prot_data_type = 0;
 #endif
 	tmp = lpfc_get_cmd_rsp_buf_per_hdwq(phba, lpfc_cmd);
-	if (!tmp)
+	if (!tmp) {
+		lpfc_release_io_buf(phba, lpfc_cmd, lpfc_cmd->hdwq);
 		return NULL;
+	}
 
 	lpfc_cmd->fcp_cmnd = tmp->fcp_cmnd;
 	lpfc_cmd->fcp_rsp = tmp->fcp_rsp;
-- 
2.13.7

