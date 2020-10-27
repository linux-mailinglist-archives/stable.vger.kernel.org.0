Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F78429BB21
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796598AbgJ0P5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1803119AbgJ0PwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:52:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7A9E2065C;
        Tue, 27 Oct 2020 15:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813936;
        bh=V0ZJwjpvmxLxdgmCAShBpCLixlunH3qE1AqsH1rqABA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrGcCUQ+9i9/iFPlEhYh/sNGzvgAzHiHSuojso4Uttj7TuqJ1KyU1KA9a/gscY3HM
         PSTdezMW5LWsOYJyGqF10Fh4sycfltgxp1AFNjxQvKe9/PnDpVEhRM8BjxfBuYHV1n
         +0nUkxig2X3Pegc0DEY2Vb1KIdUvw7rBjeqaJU+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 721/757] scsi: qedf: Return SUCCESS if stale rport is encountered
Date:   Tue, 27 Oct 2020 14:56:11 +0100
Message-Id: <20201027135524.328684516@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 10aff62fab263ad7661780816551420cea956ebb ]

If SUCCESS is not returned, error handling will escalate. Return SUCCESS
similar to other conditions in this function.

Link: https://lore.kernel.org/r/20200907121443.5150-6-jhasan@marvell.com
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 5ca424df355c1..bc30e3e039dd2 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -726,7 +726,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 	rdata = fcport->rdata;
 	if (!rdata || !kref_get_unless_zero(&rdata->kref)) {
 		QEDF_ERR(&qedf->dbg_ctx, "stale rport, sc_cmd=%p\n", sc_cmd);
-		rc = 1;
+		rc = SUCCESS;
 		goto out;
 	}
 
-- 
2.25.1



