Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C729E220C86
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 13:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgGOL5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 07:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgGOL5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 07:57:15 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7742C061755
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 04:57:14 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f18so2417309wrs.0
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 04:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=1q9naME8Z7fmnrPEUn5qBaqeLMpv52pRM581fmdSY7c=;
        b=HceaeT5SkJBXastxBbxkXNZezkiagXJcModZgYqEU0T2+ZCWFLS3RFPOdzAVIBJXu8
         8Jr3yD52ugxKUkXX7dOcBHN+UNruga1HjyPBjX8Lwun9ihdKi8i5A0AbD7i8j/G2Z6/7
         K1NetkkTfL3kQWHlQm+UwSZun6PVRM1udx5QM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1q9naME8Z7fmnrPEUn5qBaqeLMpv52pRM581fmdSY7c=;
        b=TgOL457fXF2PLeqaydHHSIOu9Bkedt1vh7mxdKhYz/uDUP/i47V1NxfUEHAiJWVuVg
         q0pqOqsh7/aDO1cGORaMeilT1N2s9DORVlT2oGN+Jva3v++YivX+6MG8Va78TNbhXAhV
         G7WCl4wY5PlHHTz6evuNFvPaRvuIiTPIbKj5TCpAv+97GEc4P+dI0TPGiTOMtQ5K8BEu
         pxml3HqSqhBHLhTUs8sinzoOq8ROEGBX38G2yZl3CGD7YIGCG5PPtWHroIh0xWM8tlJD
         3xN5AcD7VIXX9uN6ouQCbTxoT4A/VPOOzk2hbnpVZVJuZ+fgzmf9v+Rss/SB8NmnxfBg
         maug==
X-Gm-Message-State: AOAM533ewncXxdXpSf+e1VNQo3fDsUPMmsvOgwsAYk4cFGZOTneRExpr
        4Bzg1WQWNLzQmrVqgRSr2+oA3Q==
X-Google-Smtp-Source: ABdhPJyCtOz1rYYnzKaEj4Z8wwim/BOf/wV+tvVNvTaOVVWQwxNhPY6mD8RCgZdZ1jYCaO6Zivf7hQ==
X-Received: by 2002:a5d:6a90:: with SMTP id s16mr10827194wru.8.1594814233306;
        Wed, 15 Jul 2020 04:57:13 -0700 (PDT)
Received: from it_dev_server1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a84sm3024163wmh.47.2020.07.15.04.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 04:57:12 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     ckpatil121@gmail.com
Cc:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        "# v5 . 3+" <stable@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH] megaraid_sas: remove undefined ENABLE_IRQ_POLL macro
Date:   Wed, 15 Jul 2020 17:27:01 +0530
Message-Id: <20200715115701.19518-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.9.5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Issue:
As ENABLE_IRQ_POLL macro is undefined, the check for ENABLE_IRQ_POLL
macro in ISR will always be false leads to irq polling non-functional.

Fix:
Remove ENABLE_IRQ_POLL check from isr

Fixes: a6ffd5bf6819 ("scsi: megaraid_sas: Call disable_irq from process IRQ")
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index bb34278..0824410 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3740,10 +3740,8 @@ static irqreturn_t megasas_isr_fusion(int irq, void *devp)
 	if (instance->mask_interrupts)
 		return IRQ_NONE;
 
-#if defined(ENABLE_IRQ_POLL)
 	if (irq_context->irq_poll_scheduled)
 		return IRQ_HANDLED;
-#endif
 
 	if (!instance->msix_vectors) {
 		mfiStatus = instance->instancet->clear_intr(instance);
-- 
2.9.5

