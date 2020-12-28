Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6AD2E6887
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgL1M76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:59:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728898AbgL1M76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:59:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 050F0207C9;
        Mon, 28 Dec 2020 12:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160382;
        bh=uk0DM0zMWvCwM7+u/s74nhU1zvTRlz3ushlb/+OpKVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOJkxYDKm5LKlaFOFNE6vrseBO4qKp0aWipfRghPjcCuMGpCRePpdGs50IrBZJ3Xz
         F8z102rodVYGITL1EPVQDCFANKFCYmWgcxOnR3FgDD2rNwaEr6WaoQu7bHqNUkLy83
         ccCqi1fK0KFG6sXWGROEhB+Elw/aahVxhdp17YJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 033/175] scsi: mpt3sas: Increase IOCInit request timeout to 30s
Date:   Mon, 28 Dec 2020 13:48:06 +0100
Message-Id: <20201228124854.861668832@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 85dad327d9b58b4c9ce08189a2707167de392d23 ]

Currently the IOCInit request message timeout is set to 10s. This is not
sufficient in some scenarios such as during HBA FW downgrade operations.

Increase the IOCInit request timeout to 30s.

Link: https://lore.kernel.org/r/20201130082733.26120-1-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 601a93953307d..16716b2644020 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4477,7 +4477,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc)
 
 	r = _base_handshake_req_reply_wait(ioc,
 	    sizeof(Mpi2IOCInitRequest_t), (u32 *)&mpi_request,
-	    sizeof(Mpi2IOCInitReply_t), (u16 *)&mpi_reply, 10);
+	    sizeof(Mpi2IOCInitReply_t), (u16 *)&mpi_reply, 30);
 
 	if (r != 0) {
 		pr_err(MPT3SAS_FMT "%s: handshake failed (r=%d)\n",
-- 
2.27.0



