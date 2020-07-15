Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA67220C85
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 13:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgGOL4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 07:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgGOL4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 07:56:42 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457E3C061755
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 04:56:42 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id c80so5316704wme.0
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 04:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=1q9naME8Z7fmnrPEUn5qBaqeLMpv52pRM581fmdSY7c=;
        b=QEMzKuoLFsynzB47/yjJOiQhAgbXlq/anP84MAYVFdL+YK5atFwUh23/4HHwfjcdum
         uLfBP6NffyM4XUA8tT8bBOMWI1SiHB2t4e4v3kR0HeJ75/3Tfx2hs7gR/wyJ71Q0ql9g
         GeQ40JmNOgD5HPks3p7At0jjrUHbXfzXDg8kA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1q9naME8Z7fmnrPEUn5qBaqeLMpv52pRM581fmdSY7c=;
        b=dhZSHna9Xjjmhb0rATPTennONIsxma+f3MbhM1KecIMlojbwJdsBJD30uQcx628KZT
         XCLz98pKXOiUSDA4BAAn7FAEc6HXngESKlgYgVDfbrLGe760JVT1lWw0YbXoZQxmGJmb
         BbgGVDh0ondj9jO+xV9hK9PSYrndpDC3U9utaLSKrl//yUAkpj23toHneUhE1IWxNazQ
         cM60Ultmmko6bcWgjnlh26i1SgjcvQOrasucvN022Bhu414ZBq8lQIz91dBYIj/d+R0y
         OkrWCqKGB0J+saVlQxj9jmOWIEwN5Za9Xhp4Im0uDYMZuOzSQEaqmeBTbz1DTRQfJ1Dy
         jIfg==
X-Gm-Message-State: AOAM533awb7egk66joYT3UWWB/m3NbpTLiyfY5ffXUlSZ5TZu9Ivcfmp
        j1XmlsrGGEHpkpHhoVxoaY8OBw==
X-Google-Smtp-Source: ABdhPJy4DDN7r7KAK0nMHP+PUFXbEEO50LLaIdwLz0WUEPyjNKaW4Yj7OPhZipx3kwiSFGCqP34XEQ==
X-Received: by 2002:a1c:28a:: with SMTP id 132mr8256297wmc.109.1594814200808;
        Wed, 15 Jul 2020 04:56:40 -0700 (PDT)
Received: from it_dev_server1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h199sm3202988wme.42.2020.07.15.04.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 04:56:40 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     chandrakanth.patil@broadcom.com
Cc:     "# v5 . 3+" <stable@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH] megaraid_sas: remove undefined ENABLE_IRQ_POLL macro
Date:   Wed, 15 Jul 2020 17:26:30 +0530
Message-Id: <20200715115630.19457-1-chandrakanth.patil@broadcom.com>
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

