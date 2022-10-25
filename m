Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF2460D788
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiJYW6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiJYW6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:43 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6BBCA8B8
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:43 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id hh9so8707202qtb.13
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gV9HAxDuAn3bWWQPeEw5phbLa9cQ9I+OW0nYbTgJcL4=;
        b=WcbQ3REBzTWbDoE11TkN0JudfrzPkypBjOF/TiBPJMuMl2eetwDbUFasXMeeP8Biw0
         WmA/HnzkFRkI0dLDK7hfbPx3qF0dybL0MeBhRHEArL4jW44f/RtRcVEVKt7Ya3rhcpRQ
         lmEosi+dkI5RpVXfmbzj7Mqw4FmiID66bkXYspa7BgsjPO4Je9QiU1xVsuz/W8wOZWgm
         1OQNdeL2FvLGc4TRR9eclg4jPZt8CxshiE4sRmJIt5aWiY+5h3U+NuuoSZAua9Qm6snt
         6jkiYWbZ4Mwg78ygMmHOaWgk6S8ohbp2rRVO2P/y5JWYCrJQRfQprWoc3/tyZxZ1A8Wd
         lkmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gV9HAxDuAn3bWWQPeEw5phbLa9cQ9I+OW0nYbTgJcL4=;
        b=yol7HaIxLgSQUIefYv7fmdQB3B1Od/TDzqQbzTUjZ9F2hTRnZPcDM6N0dIrQ/cnynX
         biTNmT3040/BNifHcgP8cJ4ENwBE3pLiPnYzWdNkcIhxe8smadh1gcdRugpv8rSbWZvg
         WZLXIjK1HaeFY7HzZtjAeXcshIR70E9yBw7821b2IjyPhRX9OJ48762BiMn8jIvErZpC
         68F/CivCT6MCWMo2OblZk5USdvTeRTav7bqk2ZNZ+kFDuAUae/T03Uu3GaVRknm44f3B
         VxncbutHXL4ugMbzMHWZhekFh3ACARSsOrcnaCEcJuC56S3M9FqVfSyW8aIIrdfHmxqJ
         jeeA==
X-Gm-Message-State: ACrzQf2rKd8gFvytZ5qWobFZjxssbc8DFXJnP/mdjoifbU0NmFZn2Vio
        Rhm9MnrwlO13nhCxSPkA/+jj5Ud1a/I=
X-Google-Smtp-Source: AMsMyM66w046dAgpZ5myAEgxhi3IAgif8S40o9l7iQRG9OrWCpefKot8zzBRul9wggRVvxt/y4+DUA==
X-Received: by 2002:ac8:59cb:0:b0:39a:dbc7:2424 with SMTP id f11-20020ac859cb000000b0039adbc72424mr33935123qtf.304.1666738722606;
        Tue, 25 Oct 2022 15:58:42 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:42 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 23/33] scsi: lpfc: Remove extra atomic_inc on cmd_pending in queuecommand after VMID
Date:   Tue, 25 Oct 2022 15:57:29 -0700
Message-Id: <20221025225739.85182-24-jsmart2021@gmail.com>
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

VMID introduced an extra increment of cmd_pending, causing double-counting
of the I/O. The normal increment ios performed in lpfc_get_scsi_buf.

Link: https://lore.kernel.org/r/20220701211425.2708-5-jsmart2021@gmail.com
Fixes: 33c79741deaf ("scsi: lpfc: vmid: Introduce VMID in I/O path")
Cc: <stable@vger.kernel.org> # v5.14+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c7505e57d5ff..ac25ba9dfd6a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5707,7 +5707,6 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 				cur_iocbq->cmd_flag |= LPFC_IO_VMID;
 		}
 	}
-	atomic_inc(&ndlp->cmd_pending);
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (unlikely(phba->hdwqstat_on & LPFC_CHECK_SCSI_IO))
-- 
2.35.3

