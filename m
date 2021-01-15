Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4582F7A1C
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387489AbhAOMiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:38:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731786AbhAOMiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8886623884;
        Fri, 15 Jan 2021 12:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714242;
        bh=fyikLbb/LEAHZwVIuursngZ7vEyKxGaizjk4UMcZPyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwOpgfIBrtaZHOlAtV5/y6nNibg9zZ13Y2AQOItSSUlmJZnqMKuKlmOZrJFC0vj/W
         n2rsuxiGHxFps6B/h4xJfqVYVoXTYgYFc1wUakUhMyVjiQZ/wEbS0Or+Dph0EWcPQI
         HXbwXkqIoPHnm7Db87jwFEHiGCUa3Oopdhk5ShCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 048/103] scsi: lpfc: Fix variable vport set but not used in lpfc_sli4_abts_err_handler()
Date:   Fri, 15 Jan 2021 13:27:41 +0100
Message-Id: <20210115122008.383318449@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <james.smart@broadcom.com>

commit 6998ff4e21619d47ebf4f5eb4cafa65c65856221 upstream.

Remove vport variable that is assigned but not used in
lpfc_sli4_abts_err_handler().

Link: https://lore.kernel.org/r/20201119203407.121913-1-james.smart@broadcom.com
Fixes: e7dab164a9aa ("scsi: lpfc: Fix scheduling call while in softirq context in lpfc_unreg_rpi")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_sli.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10459,7 +10459,6 @@ lpfc_sli4_abts_err_handler(struct lpfc_h
 			   struct lpfc_nodelist *ndlp,
 			   struct sli4_wcqe_xri_aborted *axri)
 {
-	struct lpfc_vport *vport;
 	uint32_t ext_status = 0;
 
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
@@ -10469,7 +10468,6 @@ lpfc_sli4_abts_err_handler(struct lpfc_h
 		return;
 	}
 
-	vport = ndlp->vport;
 	lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 			"3116 Port generated FCP XRI ABORT event on "
 			"vpi %d rpi %d xri x%x status 0x%x parameter x%x\n",


