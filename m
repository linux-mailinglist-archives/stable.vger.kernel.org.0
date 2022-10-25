Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2A260D773
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJYW6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbiJYW6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:14 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D83C96E9
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:13 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id t25so9337636qkm.2
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqusEjDlhfOlous8HjYW7+6sYSlLfA4VZ0372HfuoUA=;
        b=Sr4QDqsbgY/QKajcTx9YeUaoLhp67Ani+wyNdqhqGw8smTVZvEXdOP9nTin0AJyyE4
         /0J/tQUErSWoErp9cY7FYVnlz+Az5VoEBQox+IxRXW/+Uowtbn/7rH3Gxv9UwKzOY/BA
         QcyurmScFwMezCIcjKfqLHHbXi/JFIcUg7ot9aXOp8TlSzngaWwJTh1Fi2QVEyxd3RAw
         IZzyZijAUsF9y5WpfV+qT8XkZgWfgfsiAXkhd8QI6+YDK5GWnDhI5uWVWWYzOCEzvTYd
         xSR2Xchdzle1t0sEzAiDgPgTYkgXMh0f4UBy6BzqCwwtYfWa8q0O8sbAO42JCayeP4u0
         KD+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zqusEjDlhfOlous8HjYW7+6sYSlLfA4VZ0372HfuoUA=;
        b=8FEz12xv9sYgjBPqKiok/KvJtebchKu8cHUlfjx4/P9G0W5j2UZOoUJSPaisUopJ09
         14E3fxUHyaWFNEGY5UtFb474v8bk/3BCSnU5qu+lw/HWlXzFL7tMTqwgLgp5nlsuoAlb
         tuW8pxbXewoB41TfJlFvBy99U+OejK4v80n4/CXpDg9YiHl2HoDUaYyIULZ4gQkGTiER
         qG2lbCoLeP3WfmkvhcAo/YCjSF0UMJ0pOphwKNR0A2yt338pPTvCf5KF97A269mdmIpc
         5mxjuTq8ES8mUtgsfuUJnl1OCBOe9+1K3v/AbmFH69KG+WoZHE50ZwTnnHjl3yzISObz
         epQA==
X-Gm-Message-State: ACrzQf3hmAtn/n4Bi3GorM1Z03oSp4OkqSuugeQUjjshbDel90EIHafF
        9bxOH7r8rGKA38yxr5dXQSvdg+Hrx3g=
X-Google-Smtp-Source: AMsMyM6XkpJozw7s/hfVz4gXX+QRQqXeT75n66GZjJEi9TZB0JcMb6gkqHxXz9o5TJkc/wlsYVNITw==
X-Received: by 2002:a05:620a:4487:b0:6ee:bcfd:bd38 with SMTP id x7-20020a05620a448700b006eebcfdbd38mr28352648qkp.468.1666738692462;
        Tue, 25 Oct 2022 15:58:12 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:12 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org
Subject: [PATCH 02/33] Revert "scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()"
Date:   Tue, 25 Oct 2022 15:57:08 -0700
Message-Id: <20221025225739.85182-3-jsmart2021@gmail.com>
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

This reverts commit 6e99860de6f4e286c386f533c4d35e7e283803d4.
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 85de54ba444b..400039c0e076 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1384,7 +1384,7 @@ static void
 __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	struct lpfc_sglq *sglq;
-	size_t start_clean = offsetof(struct lpfc_iocbq, wqe);
+	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
 	unsigned long iflag = 0;
 	struct lpfc_sli_ring *pring;
 
-- 
2.35.3

