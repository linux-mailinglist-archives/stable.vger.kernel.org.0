Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1944F2F49E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbfE3DMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729073AbfE3DMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:31 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8219123DE3;
        Thu, 30 May 2019 03:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185950;
        bh=9jbZ3tWmo4f+41dvxaWShrVDZE/qIna4Gtth6lY+ooA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aaQ2FySW4eEjAJx47+4Ff9MUM0xJWoxoEibUamaBVlE+E+vWdOPMaUVzCojx2d+Z8
         2hCS3zQtMt7YFzOZcEO+ioN4VUJkXKHO632klEwRhuexH/FWLzKqvmLyUyoe9EFEst
         kmBVNZFcZpcOSz3Ue4oR/WjV2AoSP/D+OsBIzUgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 362/405] scsi: lpfc: Fix FDMI manufacturer attribute value
Date:   Wed, 29 May 2019 20:06:00 -0700
Message-Id: <20190530030558.922171783@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
 drivers/scsi/lpfc/lpfc_ct.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 2e3949c6cd071..2e0ba206c084c 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2005,8 +2005,11 @@ lpfc_fdmi_hba_attr_manufacturer(struct lpfc_vport *vport,
 	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
 	memset(ae, 0, 256);
 
+	/* This string MUST be consistent with other FC platforms
+	 * supported by Broadcom.
+	 */
 	strncpy(ae->un.AttrString,
-		"Broadcom Inc.",
+		"Emulex Corporation",
 		       sizeof(ae->un.AttrString));
 	len = strnlen(ae->un.AttrString,
 			  sizeof(ae->un.AttrString));
-- 
2.20.1



