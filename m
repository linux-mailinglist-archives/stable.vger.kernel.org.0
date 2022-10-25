Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE0260D790
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbiJYW6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiJYW6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:54 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A98BD77C1
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:54 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id r19so8747365qtx.6
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=24kbqEwZlbca56VbzdWLQuQZEBQZRG7XjRPV/Hzg4gM=;
        b=p01x+S2mq7EgaBjJHYt9MgAQgYTOi1bxqVMVkxEZxAxWeAbqpIZgxs6jHlR6kTlV0s
         5O44/r1DMPIRfd3wTUiGslW0aHC9jX/vn5nHXdX95G0ynEjq5Q1exf1k8MjQy0ERBTKC
         PIAQO+5AHgg3U0KSsfLPCXlPf0Dhy/LVe2sOPzZ7GVqxogfwq0467Knf8ncF3ZU+p6mX
         MsgDreGu4gxH8CgVEE8akkdS6ZvTWmgKm6X1uWodPWo7APtVojqqDJkGFuOyFxGasE5k
         VzoW3E6zP9jLgoOBaceRJg4SqyjtKlpT8D32NVJWKkvPsFTwIujxW7zqbXbEoERhK+TV
         UVgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=24kbqEwZlbca56VbzdWLQuQZEBQZRG7XjRPV/Hzg4gM=;
        b=TDEK9ntAjyE/CQ9PmsZrCUdkqwFpWNcD0IUuGP1ZBv3pvzPM+Sq7+J0OSN10uXobld
         YYPUgIeJp4187rjZ+FAqfF71ZB36eyPisjcRDP/lNvTQE5L9aYt1BcsY7sqkIQ4Yf0Np
         N7Gay+dmW05DlJOzbZ0rdkgac2oZE99+PRQS+GFfOAHTPggK2ttaNSLUJouRwrg13eM3
         EL7pLBY7IjzY+fX9pVupOBuCg8nv/jZeZ1tMLMc6Oil6hdD9MncAHIkVOCE49fXzfzo9
         VjzTg+esGZ9ioB5Rpr0TWzxU3AWvR3sc9hCIyzkRaw8fbVQqK+n8zRLTbZm5BqG3DYEx
         gvqA==
X-Gm-Message-State: ACrzQf1QAdKB98XJwQbYKI3x2XkopdZJVDGSbLDEAV65lPtWxDkFAxyK
        0UVcGSTI/Yij9xKQuvLey/5TtLJzwdE=
X-Google-Smtp-Source: AMsMyM56ZB12A91MYSAMKeENTkMXFwYRxryhf4/p0qTtwapXafAZzej4TvvtaeGyih3ch/OfT5r8Ww==
X-Received: by 2002:a05:622a:14d0:b0:39c:ce79:55f3 with SMTP id u16-20020a05622a14d000b0039cce7955f3mr33765624qtx.215.1666738733386;
        Tue, 25 Oct 2022 15:58:53 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:53 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 31/33] scsi: lpfc: Correct BDE type for XMIT_SEQ64_WQE in lpfc_ct_reject_event()
Date:   Tue, 25 Oct 2022 15:57:37 -0700
Message-Id: <20221025225739.85182-32-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221025225739.85182-1-jsmart2021@gmail.com>
References: <20221025225739.85182-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A previous commit assumed all XMIT_SEQ64_WQEs are prepped with the correct
BDE type in word 0-2.  However, lpfc_ct_reject_event() routine was missed
and is still filling out the incorrect BDE type.

Fix lpfc_ct_reject_event() routine so that type BUFF_TYPE_BDE_64 is set
instead of BUFF_TYPE_BLP_64.

Link: https://lore.kernel.org/r/20220603174329.63777-2-jsmart2021@gmail.com
Fixes: 596fc8adb171 ("scsi: lpfc: Fix dmabuf ptr assignment in lpfc_ct_reject_event()")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 31f185a11bcb..799607fee51f 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -197,7 +197,7 @@ lpfc_ct_reject_event(struct lpfc_nodelist *ndlp,
 	memset(bpl, 0, sizeof(struct ulp_bde64));
 	bpl->addrHigh = le32_to_cpu(putPaddrHigh(mp->phys));
 	bpl->addrLow = le32_to_cpu(putPaddrLow(mp->phys));
-	bpl->tus.f.bdeFlags = BUFF_TYPE_BLP_64;
+	bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 	bpl->tus.f.bdeSize = (LPFC_CT_PREAMBLE - 4);
 	bpl->tus.w = le32_to_cpu(bpl->tus.w);
 
-- 
2.35.3

