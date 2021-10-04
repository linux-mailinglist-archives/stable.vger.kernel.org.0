Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FAE420F3B
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbhJDNc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237572AbhJDNae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9F4261B93;
        Mon,  4 Oct 2021 13:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353228;
        bh=mSdQYmdyDXhgidCiTMRMJVTPZZlgblIqLnLzCOIIHH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDfyYTuMeSZTtU9D56Am+9wsCGlvEHG5kJOpbsLlnnACpf5n01uSay8XIWm3yDoQo
         iYSP/b/MkPgpXDYVjUZu1WXiN0X+JUNXzttOa9yrqmMtElCoJlo8v9mn5FXfKXP/WL
         mHZRgDBZ4V7GawkZk/2JjWr5KYPWiuHYHfY7X7kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jonathan Hsu <jonathan.hsu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.14 045/172] scsi: ufs: Fix illegal offset in UPIU event trace
Date:   Mon,  4 Oct 2021 14:51:35 +0200
Message-Id: <20211004125046.448203254@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
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
@@ -330,8 +330,7 @@ static void ufshcd_add_query_upiu_trace(
 static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 				     enum ufs_trace_str_t str_t)
 {
-	int off = (int)tag - hba->nutrs;
-	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[off];
+	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[tag];
 
 	if (!trace_ufshcd_upiu_enabled())
 		return;


