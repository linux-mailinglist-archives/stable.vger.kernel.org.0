Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F6060D78F
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbiJYW6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbiJYW6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:54 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C7FCAE6C
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:53 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id g16so8741735qtu.2
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIMAnO1j/ZuQcSPP6xDiLexY4ZEy1Wa00dnZBJeKxyc=;
        b=iARM+m9IR2shPbpMundVYZ6s+O62lJLv0DZmEAOm3aiuj9K17+bxArde2EIQ6pHv3v
         fopw3fMHU0qRuwjwJC2eSDfj64NrWtaymgJ2xyPbUuCj+BWbk8t78weZNQfovbSf/ow0
         PNwsPhTL2jlJ7MVXtRAyAl5YLEcmLMpomH3D4U3rEEOqWMKte8TbzWu9vacklM9dTUJH
         12vXT0wY0dBUTapCndE16vRkzS5CvwZbHeK+IaX4b4ynovZo/dO8Hu3oqDvTCLo+sD/G
         0j4C9HYK7rq8tbwWICfnIuc9yBPHAm2f3F8NufbTTEiBAB/H58jQNUBRgZWHUpjb0O3E
         U61A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rIMAnO1j/ZuQcSPP6xDiLexY4ZEy1Wa00dnZBJeKxyc=;
        b=IP+6Hgw+XKSEcH0jmtMOXccdLmxrFWAhdIKvbdFpUjkTcbcNN588w1m/dWud62Mvvv
         p3WVkU8zdu8fQwIvICqRtdVyYHsrbJzINV7s0JRqFlKubXlxpZYf/kBNeuLqj38SCzQp
         VC9Yus+gNZ+O3nAm8Qk3YbvYzZhS1qss5q1PTtHTnHm2t0vjqiOqGP3jI3fwsgWNm0nX
         YZHGQYhNlRr4JKtVl+TM8tFFDcspnZeBZXGY2B+NB4EMAPWDqnoI7Li7HQ0ewaJ2coy0
         HeDnxft+r/Au96YDKFkvSPJeyPg6R8czXTjq+q3OdbEvWrts8Kxs8Qhs/DfDagseyQsH
         ZDlQ==
X-Gm-Message-State: ACrzQf0edbB066NJQVgRv9vGHIXsDbwsBp3LgOSnnjmMpSPuEu4+P6Vj
        jFcl9QSLMBeaToUkHGcF3KZtfhPPitg=
X-Google-Smtp-Source: AMsMyM4SxE7IHbfr3hLbKfMh6TGgAuNvbcWOzyG4vuFcxt0LFVn/moKrNn+juCZo4I7LnQmkahfdJQ==
X-Received: by 2002:a05:622a:41:b0:39c:e2d6:b9ea with SMTP id y1-20020a05622a004100b0039ce2d6b9eamr33599410qtw.58.1666738732229;
        Tue, 25 Oct 2022 15:58:52 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:51 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 30/33] scsi: lpfc: Fix dmabuf ptr assignment in lpfc_ct_reject_event()
Date:   Tue, 25 Oct 2022 15:57:36 -0700
Message-Id: <20221025225739.85182-31-jsmart2021@gmail.com>
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

Upon driver receipt of a CT cmd for type = 0xFA (Management Server) and
subtype = 0x11 (Fabric Device Management Interface), the driver is
responding with garbage CT cmd data when it should send a properly formed
RJT.

The __lpfc_prep_xmit_seq64_s4() routine was using the wrong buffer for the
reject.

Fix by converting the routine to use the buffer specified in the bde within
the wqe rather than the ill-set bmp element.

Link: https://lore.kernel.org/r/20220506035519.50908-6-jsmart2021@gmail.com
Fixes: 61910d6a5243 ("scsi: lpfc: SLI path split: Refactor CT paths")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f38ac537649b..c68aa7d48d22 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10798,24 +10798,15 @@ __lpfc_sli_prep_xmit_seq64_s4(struct lpfc_iocbq *cmdiocbq,
 {
 	union lpfc_wqe128 *wqe;
 	struct ulp_bde64 *bpl;
-	struct ulp_bde64_le *bde;
 
 	wqe = &cmdiocbq->wqe;
 	memset(wqe, 0, sizeof(*wqe));
 
 	/* Words 0 - 2 */
 	bpl = (struct ulp_bde64 *)bmp->virt;
-	if (cmdiocbq->cmd_flag & (LPFC_IO_LIBDFC | LPFC_IO_LOOPBACK)) {
-		wqe->xmit_sequence.bde.addrHigh = bpl->addrHigh;
-		wqe->xmit_sequence.bde.addrLow = bpl->addrLow;
-		wqe->xmit_sequence.bde.tus.w = bpl->tus.w;
-	} else {
-		bde = (struct ulp_bde64_le *)&wqe->xmit_sequence.bde;
-		bde->addr_low = cpu_to_le32(putPaddrLow(bmp->phys));
-		bde->addr_high = cpu_to_le32(putPaddrHigh(bmp->phys));
-		bde->type_size = cpu_to_le32(bpl->tus.f.bdeSize);
-		bde->type_size |= cpu_to_le32(ULP_BDE64_TYPE_BDE_64);
-	}
+	wqe->xmit_sequence.bde.addrHigh = bpl->addrHigh;
+	wqe->xmit_sequence.bde.addrLow = bpl->addrLow;
+	wqe->xmit_sequence.bde.tus.w = bpl->tus.w;
 
 	/* Word 5 */
 	bf_set(wqe_ls, &wqe->xmit_sequence.wge_ctl, last_seq);
-- 
2.35.3

