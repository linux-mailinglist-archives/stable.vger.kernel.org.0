Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617A6420E15
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbhJDNV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235176AbhJDNT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:19:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E29461BB4;
        Mon,  4 Oct 2021 13:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352905;
        bh=LgmcMSkTSwcv4p1NplrD8Mju0sljwNQnbuNZC9W459Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zc9mMwBkgf5/bxGC33b9i9T/4VlFEGJzB/VaJqaK7vMrpshRlRMlg+VLJrppydRhH
         fe4G5dARrEv5dUJzcLihujcjuDp/nOIYBDM2BXJh0UmyGi0TlD+ixQiuZaJRbt0FNK
         Am45L69gEDEIXA4zQz+gbbvfIdQ6iGek4+CR9J2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jonathan Hsu <jonathan.hsu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 14/93] scsi: ufs: Fix illegal offset in UPIU event trace
Date:   Mon,  4 Oct 2021 14:52:12 +0200
Message-Id: <20211004125035.044011344@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Hsu <jonathan.hsu@mediatek.com>

commit e8c2da7e329ce004fee748b921e4c765dc2fa338 upstream.

Fix incorrect index for UTMRD reference in ufshcd_add_tm_upiu_trace().

Link: https://lore.kernel.org/r/20210924085848.25500-1-jonathan.hsu@mediatek.com
Fixes: 4b42d557a8ad ("scsi: ufs: core: Fix wrong Task Tag used in task management request UPIUs")
Cc: stable@vger.kernel.org
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jonathan Hsu <jonathan.hsu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshcd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -318,8 +318,7 @@ static void ufshcd_add_query_upiu_trace(
 static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 		const char *str)
 {
-	int off = (int)tag - hba->nutrs;
-	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[off];
+	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[tag];
 
 	trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->req_header,
 			&descp->input_param1);


