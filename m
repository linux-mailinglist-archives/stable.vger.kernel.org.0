Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A36256011
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 19:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgH1Rxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 13:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgH1Rxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 13:53:40 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C7AC06121B
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 10:53:40 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p37so794274pgl.3
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 10:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TaLyrMTePWVx74K5m0rdCA2b0TFlH+5Xa8M4cBzzyq0=;
        b=D5qQtWiwb69a2Gw9BKdHYEFd/x4winMN3rqV1gJPX5IfI7zYDdjdjMvcia/WQdAXwq
         ogh8TkWo06jzAAc47yO670gAPUFadf3hDprvLZ7xefbXFMIaIfFOlffuA6PLnvCyB/XO
         hzHy8C868P1iZfB+qG7TS/6spmXpe8VrDVpW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TaLyrMTePWVx74K5m0rdCA2b0TFlH+5Xa8M4cBzzyq0=;
        b=TEyyFqWkOqgFZBo5oF2EPkpAwi8hZjyGXXrKjCXMFVi1CpBmprKspj9ixOIH85dASK
         6xWCSguN/8YRxmxKz7kMBLCwDYcksmnrO5VJMD7ylME5mKdhXU8aXexaM929jZiUI4qJ
         9bhT3fYWFenUiBl0X4Di1SpLGMK0oGaCTFgNubiI0sJFJEdSWOwQ2pcLHf/i2qfcVpnm
         IF2yQqa097VkDKh4gFNv5GaxNP4sMA0kwWbc5bTc/L42O0cEcQ1/ossXjVUB/t6dHMuh
         +ezoEDw20R9qZ1U7hwEJC7AG4ekF6Vr0jm9mhgnUFhcBn+HWquzw48h5pu+oJjzBbPD4
         btCg==
X-Gm-Message-State: AOAM532ws3cW8cjq9D9VPzQfwQ/TEahB7oJxZto+6G9okf9UOEWLPQN2
        03KDl2dojzvTcm8KZ7KAH+LS6g==
X-Google-Smtp-Source: ABdhPJyGSColFTLeHAgD8EbB5Ju9TVHlnVPlDbHBtRmBjeMxGYxkdp5KYHntohkuQpTKLaz7V74Qlg==
X-Received: by 2002:aa7:838d:: with SMTP id u13mr147684pfm.158.1598637219750;
        Fri, 28 Aug 2020 10:53:39 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e65sm88734pjk.45.2020.08.28.10.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 10:53:39 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 1/4] lpfc: Fix setting irq affinity with an empty cpu mask.
Date:   Fri, 28 Aug 2020 10:53:29 -0700
Message-Id: <20200828175332.130300-2-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200828175332.130300-1-james.smart@broadcom.com>
References: <20200828175332.130300-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some systems are reporting the following log message during driver
unload or system shutdown:
  ics_rtas_set_affinity: No online cpus in the mask

A prior commit introduced the writing of an empty affinity mask in calls
to irq_set_affinity_hint() when disabling interrupts or when there are
no remaining online cpus to service an eq interrupt. At least some ppc64
systems are checking whether affinity masks are empty or not.

Fix: Do not call irq_set_affinity_hint() with an empty cpu mask.

Fixes: dcaa21367938 ("scsi: lpfc: Change default IRQ model on AMD architectures")
Cc: <stable@vger.kernel.org> # v5.5+

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
 drivers/scsi/lpfc/lpfc_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 05ace6916b66..89c3ba0a0df9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11376,7 +11376,6 @@ lpfc_irq_clear_aff(struct lpfc_hba_eq_hdl *eqhdl)
 {
 	cpumask_clear(&eqhdl->aff_mask);
 	irq_clear_status_flags(eqhdl->irq, IRQ_NO_BALANCING);
-	irq_set_affinity_hint(eqhdl->irq, &eqhdl->aff_mask);
 }
 
 /**
-- 
2.26.2

