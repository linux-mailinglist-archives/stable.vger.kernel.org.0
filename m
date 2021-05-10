Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3498F3785F7
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbhEJLC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234773AbhEJK5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CF11619B8;
        Mon, 10 May 2021 10:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643746;
        bh=uTK8HGueOD6uoKeikRLj8soEF7E1dnT7JsTGS6SVlDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSVOTo64pfqQezDKA+hqhSjzHUcl4y4FHIXiFqIGyft0tC2CQEQsOiYFTXAReLoKl
         ZMeMnBzhdzzXq45/gsDdgyMngaW0KnC86srfzMbKqjFnOqfZJp56Je52mvX7BaPom4
         qPZLTcjq3f6ma+oNQU8eK2dC6JSIgtkwrBAqxExI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 142/342] scsi: lpfc: Fix pt2pt connection does not recover after LOGO
Date:   Mon, 10 May 2021 12:18:52 +0200
Message-Id: <20210510102014.773626382@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit bd4f5100424d17d4e560d6653902ef8e49b2fc1f ]

On a pt2pt setup, between 2 initiators, if one side issues a a LOGO, there
is no relogin attempt. The FC specs are grey in this area on which port
(higher wwn or not) is to re-login.

As there is no spec guidance, unconditionally re-PLOGI after the logout to
ensure a login is re-established.

Link: https://lore.kernel.org/r/20210301171821.3427-8-jsmart2021@gmail.com
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index fcf44cd6d5b7..779c7712090f 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -901,9 +901,14 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 	} else if ((!(ndlp->nlp_type & NLP_FABRIC) &&
 		((ndlp->nlp_type & NLP_FCP_TARGET) ||
-		!(ndlp->nlp_type & NLP_FCP_INITIATOR))) ||
+		(ndlp->nlp_type & NLP_NVME_TARGET) ||
+		(vport->fc_flag & FC_PT2PT))) ||
 		(ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
-		/* Only try to re-login if this is NOT a Fabric Node */
+		/* Only try to re-login if this is NOT a Fabric Node
+		 * AND the remote NPORT is a FCP/NVME Target or we
+		 * are in pt2pt mode. NLP_STE_ADISC_ISSUE is a special
+		 * case for LOGO as a response to ADISC behavior.
+		 */
 		mod_timer(&ndlp->nlp_delayfunc,
 			  jiffies + msecs_to_jiffies(1000 * 1));
 		spin_lock_irq(&ndlp->lock);
-- 
2.30.2



