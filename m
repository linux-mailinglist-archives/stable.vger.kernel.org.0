Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9AF25600C
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 19:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgH1RxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 13:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgH1RxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 13:53:00 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8640C061264
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 10:52:59 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mt12so73325pjb.4
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 10:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TaLyrMTePWVx74K5m0rdCA2b0TFlH+5Xa8M4cBzzyq0=;
        b=bBf0smygn5B750CNCE6aEw4sTSJvpJcC4XmjR91NRPmt913oj9IXessLnrX4d8iity
         97chqNZaCfGLJ6GxdM0tAxCLjb16pTovK6QX6c4BpOPb+1VeDn4tkpb7DzTuThVDsgrP
         frdAW4RVzcB+gZN5Q9NT7+0dJ3wSvhYpZ62V4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TaLyrMTePWVx74K5m0rdCA2b0TFlH+5Xa8M4cBzzyq0=;
        b=Ku3EzDvVyvXcA+5BkyPaPFCh4yLfORylyPuyIN9dFhxKazal5ggDUxkdIBDhuulZ9I
         pAf62ecW78legqe4hEGmQmaiktM5+ejKLu0ZLwvR2YtUhYl3immeUiAeXE7HA8SEJM1Y
         3VpoA9WNGwELKhT2RxGhpqkL+hZ7aFSEV2AHA8u9gcQGTk4FIstAbnoWQb2Pz2Wx/zgP
         cFes3GDxBtDGqVHBESn1jz77TMa2WQn/tujQWpEpz9qnhAz/96k6kpKOUeVyXQtq2GXr
         i6GVVGGm/P4RXCH4ZzQvEs1lw8gKyGahK80HUw9Z+26zW7MX1zBbDQb10YQ00DQDmGhG
         UDPg==
X-Gm-Message-State: AOAM531V52wjeW5XV9gFqRYZo2Y4jmz0Lh23BnO+fVkpaQq1ttHCJ7mr
        eBbDoeZQV0znhvcCF1q5mkFAfQ==
X-Google-Smtp-Source: ABdhPJxgbw+whp2PM9JQ9X/3HtyrZZyrGDzS5/zqgFF1v5EHZtWcbZRIqaBqlBeZP6L7HyBh1zdRMw==
X-Received: by 2002:a17:90a:ca0e:: with SMTP id x14mr133668pjt.217.1598637178963;
        Fri, 28 Aug 2020 10:52:58 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a7sm28195pfd.194.2020.08.28.10.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 10:52:58 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     james.smart@broadcom.com
Cc:     stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 1/4] lpfc: Fix setting irq affinity with an empty cpu mask.
Date:   Fri, 28 Aug 2020 10:52:47 -0700
Message-Id: <20200828175250.130249-2-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200828175250.130249-1-james.smart@broadcom.com>
References: <20200828175250.130249-1-james.smart@broadcom.com>
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

