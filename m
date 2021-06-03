Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724CA39A822
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbhFCRNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:13:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232613AbhFCRMn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:12:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 954D96141A;
        Thu,  3 Jun 2021 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740217;
        bh=JLdSWqiYrCHncAX7+bhLXxXV1Bi+qVVaxZPyIU50QHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6xm78oYwvPGLNv0ZypCbPEFRhpE0pWtYB5Y7FM2jx2+ur3jyAgrMSPHQYKEl2QZL
         72GMj5RZAvfkOFnmS95TwAC8suzexttW+N1Md0qsOX8eVsT6Mks4womHcoXdbou42a
         g0zw1JduWGq/TJRop5pznqtB5uoNHqACxFVX8g8/AtCETlJv/sODRT9RBdhDutJeKG
         t1lQb4RWvbG2JDPr7k95FJmoYxIojxmA+rEblMvKEnEEBXnRwfo6HPdieG7xO+dJM/
         N61MUobDNiH2e2LGaPMhdi9ppbAovnS5ayXF+4P7OFzhS5TR0rpq5t8Wqz4IVwotlf
         WRxNfBiwylN0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/23] scsi: bnx2fc: Return failure if io_req is already in ABTS processing
Date:   Thu,  3 Jun 2021 13:09:50 -0400
Message-Id: <20210603170959.3169420-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170959.3169420-1-sashal@kernel.org>
References: <20210603170959.3169420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit 122c81c563b0c1c6b15ff76a9159af5ee1f21563 ]

Return failure from bnx2fc_eh_abort() if io_req is already in ABTS
processing.

Link: https://lore.kernel.org/r/20210519061416.19321-1-jhasan@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index bc9f2a2365f4..5d89cc30bf30 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1218,6 +1218,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		   was a result from the ABTS request rather than the CLEANUP
 		   request */
 		set_bit(BNX2FC_FLAG_IO_CLEANUP,	&io_req->req_flags);
+		rc = FAILED;
 		goto done;
 	}
 
-- 
2.30.2

