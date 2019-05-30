Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 081F02EFF6
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbfE3DSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731500AbfE3DSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:17 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 518902478C;
        Thu, 30 May 2019 03:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186297;
        bh=CyXpFkhPtCpn5HBsylNRtK+07vkAfzZQlN9o58ObyZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5ExCscYvGwBYPGBKEr9hQ8MNqW2uh3bEFlmA3meB0E8TQZ15ybOuXObTIm1V9/ZK
         DB6Pcxvw6QiaVRu0NcCwECF6JSPG1izFFnPQxBBgaA2wm3wH7xeV8dT2ca2ovYub8l
         oTdNFOGD5YgLf5Hu8tuxGYsWJJN1mR/2XcdORt7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 260/276] scsi: lpfc: Fix FDMI manufacturer attribute value
Date:   Wed, 29 May 2019 20:06:58 -0700
Message-Id: <20190530030541.450330586@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d67f935b79a76ac9d86dde1a27bdd413feb5d987 ]

The FDMI manufacturer value being reported on Linux is inconsistent with
other OS's.

Set the value to "Emulex Corporation" for consistency.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 1a964e71582f4..06621a438cade 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1762,6 +1762,9 @@ lpfc_fdmi_hba_attr_manufacturer(struct lpfc_vport *vport,
 	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
 	memset(ae, 0, 256);
 
+	/* This string MUST be consistent with other FC platforms
+	 * supported by Broadcom.
+	 */
 	strncpy(ae->un.AttrString,
 		"Emulex Corporation",
 		       sizeof(ae->un.AttrString));
-- 
2.20.1



