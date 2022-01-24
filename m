Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7825E499A9B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573581AbiAXVpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:45:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48206 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378062AbiAXVio (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:38:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B55CEB81188;
        Mon, 24 Jan 2022 21:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EB0C340E4;
        Mon, 24 Jan 2022 21:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060321;
        bh=AZdeogpZIVfXj08F3oNVbYOQIuzVXxnygZlttam14NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zl1T89EY4+98IcslDj/QAVT/46j/Agx3z1hkgNjSyKaxLdM05hunVmXfymHEaevvn
         X/7jSkAF3OqdGtl2S1Pin4QZKmr4d3foZBa6ys6Z54jUDp+zeTl3B7o5/uEdGOXrpo
         y8tEtUTS7YWhXE7IjP0c1rgABfBL/E1XDZbv9c9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0866/1039] scsi: lpfc: Fix lpfc_force_rscn ndlp kref imbalance
Date:   Mon, 24 Jan 2022 19:44:15 +0100
Message-Id: <20220124184154.404731249@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 7576d48c64f36f6fea9df2882f710a474fa35f40 upstream.

Issuing lpfc_force_rscn twice results in an ndlp kref use-after-free call
trace.

A prior patch reworked the get/put handling by ensuring nlp_get was done
before WQE submission and a put was done in the completion path.
Unfortunately, the issue_els_rscn path had a piece of legacy code that did
a nlp_put, causing an imbalance on the ref counts.

Fixed by removing the unnecessary legacy code snippet.

Link: https://lore.kernel.org/r/20211204002644.116455-4-jsmart2021@gmail.com
Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taking")
Cc: <stable@vger.kernel.org> # v5.11+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_els.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3538,11 +3538,6 @@ lpfc_issue_els_rscn(struct lpfc_vport *v
 		return 1;
 	}
 
-	/* This will cause the callback-function lpfc_cmpl_els_cmd to
-	 * trigger the release of node.
-	 */
-	if (!(vport->fc_flag & FC_PT2PT))
-		lpfc_nlp_put(ndlp);
 	return 0;
 }
 


