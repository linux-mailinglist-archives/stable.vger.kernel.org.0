Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A936563B6C
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 23:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiGAVPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 17:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiGAVPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 17:15:05 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A40D3DA7E;
        Fri,  1 Jul 2022 14:15:04 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id k20so2737831qkj.1;
        Fri, 01 Jul 2022 14:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ml8XjwjvMkMwTwAoX1zwruG2L+bKOmRzQ5SRpWvEs80=;
        b=cBo7uHkDzRO8To6pZnDBu9WCiAuBtbjp+ZgGufT+nnBYL3cWfABAqzojz3gt34EDQ8
         q5lQIkJzTahu4HG8h7zeCXxe63+npfRfi1FHJX+cG/XZGwtLS4y5V/4BUaSTslBQ8ivD
         VSnHqYmcEHDrE50enV569VcvXvzlMj19fxuiil3pGj9/qg5i/+2dvuq973DTFT1ax4Vs
         qPSAEm+eZHkPfACPlI58uOPXP+H0K5Ra3DYa5VT3KtpxNZd3SQH02Jml8ynb5yfGO6Ua
         uqDt+lHUUiBT7OL4XpMgRR5UfCO+ozBARN4j5o0eusDWwGPShJoOoNjZaRIsCsDyHeGs
         6Z+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ml8XjwjvMkMwTwAoX1zwruG2L+bKOmRzQ5SRpWvEs80=;
        b=aN7Yz7QgUasZmb4BR7ZeyeoxhCyxeV5hjvv54N7iEG9ERWDxa+UibkQLe/OaU3dKVx
         dQmMkWxO4cQGW23ISpQR7pKfCfP9sn8SDNvcS/qJRhiZZTfsFWZ3pTFxNfbc0iOFyP/P
         Hym4/hVNoiuvoH/tmc6Ed5X0sKd779ekenxvvWJBMoSL12PwUc3GlM2dgmLeM6baAm0R
         i3gukqX2XYsYCxJ44Ud9VF58uuVu+egcRhq4Tkep4Mqvm0o7LMhn+mnVBPyLRA/gS406
         lZ80tI9J7vvN+ql8Tj0ei2So4FoIY5rgntlku3RVMIWi47a+/tiGXKxyrH2cf2EB5FjA
         LFiw==
X-Gm-Message-State: AJIora9Oumw8qXlBGZ6xG+0nk21LQegnJ5vNGKv1e+CgyhBzxMmiOoU1
        fnO0ceEnfJgDaV+DuTKWGD2lDDfoZI0=
X-Google-Smtp-Source: AGRyM1srUbyvR26ejSGKX/iRG1zg07WI01EJdntoPpYmWnmpeplpoqiL7Vog3UtVEqPAUsXSsdKqTQ==
X-Received: by 2002:a05:620a:4412:b0:6b2:52d0:e3e2 with SMTP id v18-20020a05620a441200b006b252d0e3e2mr5133452qkp.12.1656710103484;
        Fri, 01 Jul 2022 14:15:03 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6-20020ac842c6000000b00317ccc66971sm14584509qtm.52.2022.07.01.14.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:15:02 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 04/12] lpfc: Remove extra atomic_inc on cmd_pending in queuecommand after VMID
Date:   Fri,  1 Jul 2022 14:14:17 -0700
Message-Id: <20220701211425.2708-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220701211425.2708-1-jsmart2021@gmail.com>
References: <20220701211425.2708-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VMID introduced an extra increment of cmd_pending, causing
double-counting of the I/O. The normal increment ios performed in
lpfc_get_scsi_buf.

Fixes: 33c79741deaf ("scsi: lpfc: vmid: Introduce VMID in I/O path")
Cc: <stable@vger.kernel.org> # v5.14+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ba5e4016262e..084c0f9fdc3a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5456,7 +5456,6 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 				cur_iocbq->cmd_flag |= LPFC_IO_VMID;
 		}
 	}
-	atomic_inc(&ndlp->cmd_pending);
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (unlikely(phba->hdwqstat_on & LPFC_CHECK_SCSI_IO))
-- 
2.26.2

