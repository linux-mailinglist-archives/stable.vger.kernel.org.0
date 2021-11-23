Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEF045A95D
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhKWRAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 12:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhKWRAE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 12:00:04 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4B0C061574;
        Tue, 23 Nov 2021 08:56:56 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u11so17601502plf.3;
        Tue, 23 Nov 2021 08:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4jfREHhQfHfchkJQh8IIRAP+3wdyDF5UxUF7zmYQcvo=;
        b=hxcNcX3zdG4UiEkjZgIM7QQItefQNLSewahYth75HBYiEZ39lZPQ9TEQqIZAvr2wkh
         Qhi6lQ6bd/H2e/gbL6p1TgKIepC6OGbD3HCM9uJ4Xg2j99VQ5LObzUzA9Poae0+hjolI
         g/BZFTR06McgHEonxa7oeV8p13VpK1HZEBhwLqheDvPfzRDzM2EIpCs+2uNia1no5t1T
         3e7KK3jGgb0p2cyI4K8/j3edLjX9Akco6eAfUZ4/t71usI9o0eCobnd7+fki8cFuA2I7
         s8HP4oYTi3NxDoaObvm5aeSYwMtJfQVUKPfa3CUOxo/wNeGLwsCDKlvhTc70m/mhVIAx
         V8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4jfREHhQfHfchkJQh8IIRAP+3wdyDF5UxUF7zmYQcvo=;
        b=3l40d3Rlk1bEJojtJKWk4SXLcxzps+1S2gJIyYC2D1JCVm16W48KjFvFq36zjYTKl2
         0DnpRvjIza9D9p/CZjZHDDvwTu2+4zIph32KyKimkejVbgITnausJlPHxvXDnCi2MD+z
         RePZQfFkvs7IywyFs31C5kCOneiZxTijsmJ+K1yBwtDRbMPEWS/F017y9e78U/khUYyd
         onLhfgYW285ZVBXFtSODQU+wQYQlWaf9s9FdvRqSFMTt+Z46FRxiIP6NWsbkF7w9lxDx
         +gmLhMdu7Rys4QdW38HniPKfX4ntO5iNZPgaHdQ0QqWQ23ILD77o4sy4lZSEwdLDSJfo
         lTKA==
X-Gm-Message-State: AOAM5331Vye8YNntTHZ3I7D1K0jo2knFmIdZRN5QB/QVS0gJNDE3e9RV
        ekSg8wNQ0x012ty1ZfOs9I93M63XT7k=
X-Google-Smtp-Source: ABdhPJzSEZAqv/XoTgmp00/yYPUY9k4Ie3dEiKTCgNvCbj5dWc4H6hbkemNj/ADGpkFLw2XqAMLkDg==
X-Received: by 2002:a17:902:8e85:b0:142:7621:e3b3 with SMTP id bg5-20020a1709028e8500b001427621e3b3mr8096849plb.84.1637686615948;
        Tue, 23 Nov 2021 08:56:55 -0800 (PST)
Received: from mail-ash-it-01.broadcom.com ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id b23sm9359197pgg.73.2021.11.23.08.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 08:56:55 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Paul Ely <paul.ely@broadcom.com>
Subject: [PATCH] lpfc: Fix nonrecovery of remote ports following an unsolicited LOGO
Date:   Tue, 23 Nov 2021 08:56:46 -0800
Message-Id: <20211123165646.62740-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A commit introduced formal regstration of all Fabric nodes to the SCSI
transport as well as REG/UNREG RPI mailbox requests. The commit
introduced the NLP_RELEASE_RPI flag for rports  set in the
lpfc_cmpl_els_logo_acc() routine to help clean up the RPIs. This new
code caused the driver to release the RPI value used for the remote port
and marked the RPI invalid.  When the driver later attempted to re-login,
it would use the invalid RPI and the adapter rejected the PLOGI request.
As no login occurred, the devloss timer on the rport expired and
connectivity was lost.

This patch corrects the code by removing the snippet that requests the
rpi to be unregistered. This change only occurs on a node that is already
marked to be rediscovered. This puts the code back to its original
behavior, preserving the already-assigned rpi value (registered or not)
which can be used on the re-login attempts.

Fixes: fe83e3b9b422 ("scsi: lpfc: Fix node handling for Fabric Controller and Domain Controller")
Cc: <stable@vger.kernel.org> # v5.14+
Co-developed-by: Paul Ely <paul.ely@broadcom.com>
Signed-off-by: Paul Ely <paul.ely@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b940e0268f96..e83453bea2ae 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5095,14 +5095,9 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* NPort Recovery mode or node is just allocated */
 		if (!lpfc_nlp_not_used(ndlp)) {
 			/* A LOGO is completing and the node is in NPR state.
-			 * If this a fabric node that cleared its transport
-			 * registration, release the rpi.
+			 * Just unregister the RPI because the node is still
+			 * required.
 			 */
-			spin_lock_irq(&ndlp->lock);
-			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			if (phba->sli_rev == LPFC_SLI_REV4)
-				ndlp->nlp_flag |= NLP_RELEASE_RPI;
-			spin_unlock_irq(&ndlp->lock);
 			lpfc_unreg_rpi(vport, ndlp);
 		} else {
 			/* Indicate the node has already released, should
-- 
2.26.2

