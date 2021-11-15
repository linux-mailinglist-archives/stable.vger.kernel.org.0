Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C78451E00
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350849AbhKPAen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344238AbhKOTYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E4146364F;
        Mon, 15 Nov 2021 18:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002458;
        bh=qxUr999i7qnJXWkfTK010TUMBBQMf/apU2AH8OvuQTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjcNbrKUW1I03iXI03cK9eBy0hKTvJf3Tc8CrlsTnRPO1X5Va/6CueuANTLGY2njn
         gQMAdBL7DZ4LtxrPkdK42BdI2ZlFU7bFHlNQ2Fv0VrxnjVu2xJC38/tQ9tgDOHaNUo
         t57FWzQbnldUwafmQxnBY5TnIsmhtUtHwCADGApc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 575/917] scsi: lpfc: Fix NVMe I/O failover to non-optimized path
Date:   Mon, 15 Nov 2021 18:01:10 +0100
Message-Id: <20211115165448.276191322@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit b507357f79171fb4fb4e732ca43a1f30bc5aab1d ]

Currently, we hold off unregistering with NVMe transport layer until GID_FT
or ADISC completes upon receipt of RSCN. In the ADISC discovery routine,
for nodes not found in the GID_FT response, the nodes are unregistered from
the SCSI transport but not UNREG_RPI'd. Meaning outstanding WQEs continue
to be outstanding and were not failed back to the OS. If an NVMe device,
this mean there wasn't initial termination of the I/Os so they could be
issued on a different NVMe path.

Fix by unregistering the RPI so that I/O is cancelled.

Link: https://lore.kernel.org/r/20210910233159.115896-8-jsmart2021@gmail.com
Fixes: 0614568361b0 ("scsi: lpfc: Delay unregistering from transport until GIDFT or ADISC completes")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0a68e565147a7..666b0a1b558ac 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6215,6 +6215,7 @@ lpfc_els_disc_adisc(struct lpfc_vport *vport)
 			 * from backend
 			 */
 			lpfc_nlp_unreg_node(vport, ndlp);
+			lpfc_unreg_rpi(vport, ndlp);
 			continue;
 		}
 
-- 
2.33.0



