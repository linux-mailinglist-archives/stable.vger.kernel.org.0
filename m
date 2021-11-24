Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA1745C15C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344875AbhKXNR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:17:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347100AbhKXNPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:15:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD59061ABC;
        Wed, 24 Nov 2021 12:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757839;
        bh=DXPJin+CE2xZp1acdbPmxh1Z4QPChmnWizcEkUFwARI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o71NbiCQKtFyDvr68CDwv+Glqn0V/xD3Eq4ZHmaRc+gGGbnGu6XTOKye+6EtmBkJD
         WCVdfXARj/q0m7k9ampwmvCfxzJkjJ5sxSIvJcyvlfOg/ZRC8Lu8/g9lwP2X++5g/n
         LbDo1wGWiPuTOdDnB/he6Z5EdgWtx6nVtfSySKEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 261/323] scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()
Date:   Wed, 24 Nov 2021 12:57:31 +0100
Message-Id: <20211124115727.701496602@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index 40d6537e64dd6..e72fc88aeb40e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -19171,6 +19171,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 					fail_msg,
 					piocbq->iotag, piocbq->sli4_xritag);
 			list_add_tail(&piocbq->list, &completions);
+			fail_msg = NULL;
 		}
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	}
-- 
2.33.0



