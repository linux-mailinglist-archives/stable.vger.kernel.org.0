Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C349E37B44
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 19:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfFFRls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 13:41:48 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37021 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbfFFRls (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 13:41:48 -0400
Received: by mail-ed1-f67.google.com with SMTP id w13so4517979eds.4;
        Thu, 06 Jun 2019 10:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ep+lClRkBZiSpttevvAOjGUX9zV5Sv5RO5bhSwT85Pk=;
        b=KkiW/xNCXMwCGoC0JNOZVCNnHMbJ/x14FhvcKNzpcJUKcIjeNtiHET8JVhVAjuwMdJ
         31dggq3pab3WtEQzLRDJY2PiXEeEcQvbLaGQv9goeQNKJQNR1c2kyOFx7liWBwrUWbTP
         +yLr+kPukq/L9Y0PD88z/gRmmLnkT8h/OoOxrG67otwhdlVEkxvBfxgCFSYWrA3an1WP
         PzFCAOXYQ0JRM4evxnZXGdDgP5wSOrNpDOFOXkVcQG8HzQf3g/cAf6Xyyf8t4T0Vfsvp
         nKo42//+mE0Ef85esn1p1MCFrToWh6tX9jBLIJOxLOtHELeomS4yyqF+dS6wfFKLzVr9
         sX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ep+lClRkBZiSpttevvAOjGUX9zV5Sv5RO5bhSwT85Pk=;
        b=tNsLARheiUV7zuJeWEOsMxahDmN940nrGuqGJ037d96JYuMSt1FS4tENmTG3j7mIhp
         pjTCkCfyGsQXWIyZyCzZDLXzUtA0W6ux+AcUgpnIuEboIMyl8Wkt4ie9LgpxSZRSWAD0
         WuILQpProTX0AycOkxQlU5NfDLN5xl25byvQZem49SbD/YaMwfKIHy0WJmmDPr/0R6YY
         R6l9zcdYoBtR4wHxiu3lk5gpBrDSQlzrEG1iMM61pKnU7uDQ40bEa4MBvU8pSV7qvkte
         I/FD5sLRVdi77ZOyfsP0q3WJOn1ygUP/TR0LBaA4zDPyN8H9ekYoy05G+MRwtHHUpVGh
         7KPQ==
X-Gm-Message-State: APjAAAWumJTqmNUUl1nTIV0dXmLPzxzES7XzREieYSo8KNudm4YwJmwq
        UjScKyrl4nmiZh8iWnGZVFA=
X-Google-Smtp-Source: APXvYqzEuo34x7u2AlbsVWYtHPQrMq+07rEWRuM0DtQYflaYgwqqQUbgeZvv9EtRXwXcvI/T8PcrKg==
X-Received: by 2002:a17:906:13c7:: with SMTP id g7mr43293906ejc.1.1559842906721;
        Thu, 06 Jun 2019 10:41:46 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id w5sm617172edd.19.2019.06.06.10.41.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 10:41:46 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: lpfc: Fix backport of faf5a744f4f8 ("scsi: lpfc: avoid uninitialized variable warning")
Date:   Thu,  6 Jun 2019 10:41:25 -0700
Message-Id: <20190606174125.4277-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0.rc3
In-Reply-To: <20190606165346.GB3249@kroah.com>
References: <20190606165346.GB3249@kroah.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prior to commit 4c47efc140fa ("scsi: lpfc: Move SCSI and NVME Stats to
hardware queue structures") upstream, we allocated a cstat structure in
lpfc_nvme_create_localport. When commit faf5a744f4f8 ("scsi: lpfc: avoid
uninitialized variable warning") was backported, it was placed after the
allocation so we leaked memory whenever this function was called and
that conditional was true (so whenever CONFIG_NVME_FC is disabled).

Move the IS_ENABLED if statement above the allocation since it is not
needed when the condition is true.

Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 099f70798fdd..645ffb5332b4 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2477,14 +2477,14 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 	lpfc_nvme_template.max_sgl_segments = phba->cfg_nvme_seg_cnt + 1;
 	lpfc_nvme_template.max_hw_queues = phba->cfg_nvme_io_channel;
 
+	if (!IS_ENABLED(CONFIG_NVME_FC))
+		return ret;
+
 	cstat = kmalloc((sizeof(struct lpfc_nvme_ctrl_stat) *
 			phba->cfg_nvme_io_channel), GFP_KERNEL);
 	if (!cstat)
 		return -ENOMEM;
 
-	if (!IS_ENABLED(CONFIG_NVME_FC))
-		return ret;
-
 	/* localport is allocated from the stack, but the registration
 	 * call allocates heap memory as well as the private area.
 	 */
-- 
2.22.0.rc3

