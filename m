Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5162EDB2
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732554AbfE3DVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732539AbfE3DVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:21:23 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02D9F249BA;
        Thu, 30 May 2019 03:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186483;
        bh=B7VPF/oMt7zL3kPuuXld1bWvfaY8Io0vsSaCC6cL27E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWmVStkTae6IWvDGw9YjgQfu5QDZnDK8nIXZUqklIeVBfWoyGJrcFrOwFIGjG9fDH
         mxRj6odPizn3Mm4cObPRtpLGoaoqM9mv457CAFVzcjVIABw/WzvgBkNOryS5RZABYP
         ewllpKDXRvbpqcNCwcf4ExhV1usXfkzKqRpotLmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 121/128] scsi: lpfc: Fix FDMI manufacturer attribute value
Date:   Wed, 29 May 2019 20:07:33 -0700
Message-Id: <20190530030456.248152223@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
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
index 4ac03b16d17f5..52afbcff362f9 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1561,6 +1561,9 @@ lpfc_fdmi_hba_attr_manufacturer(struct lpfc_vport *vport,
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



