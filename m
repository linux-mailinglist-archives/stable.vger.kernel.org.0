Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E965960D775
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbiJYW6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiJYW6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:17 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98943CA899
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:16 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id g16so8740732qtu.2
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jg8czJf3zCz7SWPyfzmm6aVLKe4tk9/x2EKcv/kw0js=;
        b=Q3BR3gmuMToE64WvmI6J2HBagN1ho+tiSB+j5/kYWrxi46CVGiIWsjSDs+E901tP78
         cIEHy6BuBeunMbRvupApHc89wsEtL+F7Xn/cH4I3e7PMMav8S7Ehvt1vza91ed/zo+uw
         NXREyl4Hg2ccxyX+MRS46dIct88P9sIn6uftlUAdKGKy9q7iyzlVZE1Ldz/JOg45UZal
         z7sIPKNcfFDXzvM6FwaTSLJHpfy0b67O2XH06MtcKJFgvyceUeVKUqohDVjoX0a5D9Y1
         Td0bKS71yToSC3M/Zwk6zNqQofKfWTNrpb0E7NuLZK+gzrYZo3nOZ0Zgq+6ZuZpkIPqt
         sKuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jg8czJf3zCz7SWPyfzmm6aVLKe4tk9/x2EKcv/kw0js=;
        b=1nbF2zSyPlHI7EHn2b+kAvB+fFhLOlRC+Y61T8QrHbwFflu5ssFAIYoC0fVB8+Rs5E
         n1zHPahLNbzd4GdK0amu/NuPyiHDTs3ehxVZgux5oIwduQ62GJdYhgVEJVavyQVdmzRN
         tlKdhifSnPE44A8J3QmW+ml3lclflGp431eEHU+tJ83kyHqeSMZnDAeA1PBbdLtIqCLV
         STvqesNWBhgOH5StgjJHBvFX/3c15pykAYejPEoMXdkVAGC3xCdUqA29QVwtwDgtv0FR
         O/2nUFnGGhm2ONmLC7OPkbtAvAH84w0PM7QGcD2mhKaqX0It/JuVINKFUoVqUadxZ7/k
         6Ahw==
X-Gm-Message-State: ACrzQf0c0QooCTEzJ4e7uTNZq4AGiEpOA97k/YTYcGm1DyqgKK6E4gC/
        5NNXiapplD+pOxjbAphhNMpIZowaZSg=
X-Google-Smtp-Source: AMsMyM6CrAKBaU1PGXD5bl2dmfagKp4d5EP/Kic0O/t9W9Sv5BfQkELraGvUrJ7yEL4Q91kS9snmqA==
X-Received: by 2002:ac8:5a16:0:b0:39c:efc6:b370 with SMTP id n22-20020ac85a16000000b0039cefc6b370mr33582611qta.374.1666738695382;
        Tue, 25 Oct 2022 15:58:15 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:14 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org
Subject: [PATCH 04/33] Revert "scsi: lpfc: Remove extra atomic_inc on cmd_pending in queuecommand after VMID"
Date:   Tue, 25 Oct 2022 15:57:10 -0700
Message-Id: <20221025225739.85182-5-jsmart2021@gmail.com>
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

This reverts commit 2b5ef6430c217e2ae38e87d056cd1b6e37c447bb.
---
 drivers/scsi/lpfc/lpfc_scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 41313fcaf84a..4ada928ba45e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5707,6 +5707,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 				cur_iocbq->cmd_flag |= LPFC_IO_VMID;
 		}
 	}
+	atomic_inc(&ndlp->cmd_pending);
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (unlikely(phba->hdwqstat_on & LPFC_CHECK_SCSI_IO))
-- 
2.35.3

