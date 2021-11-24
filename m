Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1E145BA5D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240618AbhKXMKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:10:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238943AbhKXMIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:08:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A5E2610A1;
        Wed, 24 Nov 2021 12:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755501;
        bh=AF5rWGo5YP66H58UWowbIAxu4mTrCMaInaWsDvMma0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkJ7DS+BcDQjLux5yhdTAiI2x4Y8IYT7SZdF1C7aQGtO40qZV/WTdw4P2e/91Ebei
         +vRqjeOVcy3tzQEelCE7r9Ue5Z1PZGVZM86QFTBeFMFkjMkg0+pLQLQAzXiCnj8CPA
         czfJnuXWtI7ZiPakrhZiSbD0oqsZiaDwzC+oQuBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 117/162] scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()
Date:   Wed, 24 Nov 2021 12:57:00 +0100
Message-Id: <20211124115702.099488764@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 99154581b05c8fb22607afb7c3d66c1bace6aa5d ]

When parsing the txq list in lpfc_drain_txq(), the driver attempts to pass
the requests to the adapter. If such an attempt fails, a local "fail_msg"
string is set and a log message output.  The job is then added to a
completions list for cancellation.

Processing of any further jobs from the txq list continues, but since
"fail_msg" remains set, jobs are added to the completions list regardless
of whether a wqe was passed to the adapter.  If successfully added to
txcmplq, jobs are added to both lists resulting in list corruption.

Fix by clearing the fail_msg string after adding a job to the completions
list. This stops the subsequent jobs from being added to the completions
list unless they had an appropriate failure.

Link: https://lore.kernel.org/r/20210910233159.115896-2-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9055a8fce3d4a..2087125922a11 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -17071,6 +17071,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 					fail_msg,
 					piocbq->iotag, piocbq->sli4_xritag);
 			list_add_tail(&piocbq->list, &completions);
+			fail_msg = NULL;
 		}
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	}
-- 
2.33.0



