Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 548906254C
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732296AbfGHPPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732293AbfGHPPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:15:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FD2B21707;
        Mon,  8 Jul 2019 15:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598914;
        bh=6IS7yag5Kq91JMu5mditVnadffV0jOGNuCoFUBSN9Cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzVWp3WhPvBDP1qfQGRVaHbie4C8CcH5xA634vPcnpBmwBEPX+h+3CwjeebapN+4Z
         V4tgp45RWhOzXczJWnPm1o1XA1RG106BFdvRuRBFSUuRpXGocAAZngWRqcE9wJllhX
         wATkYThPs/x/lZSm9A4DhBwRwjT5cyjGchugDOqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 16/73] scsi: ufs: Check that space was properly alloced in copy_query_response
Date:   Mon,  8 Jul 2019 17:12:26 +0200
Message-Id: <20190708150520.208278905@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1c90836f70f9a8ef7b7ad9e1fdd8961903e6ced6 ]

struct ufs_dev_cmd is the main container that supports device management
commands. In the case of a read descriptor request, we assume that the
proper space was allocated in dev_cmd to hold the returning descriptor.

This is no longer true, as there are flows that doesn't use dev_cmd for
device management requests, and was wrong in the first place.

Fixes: d44a5f98bb49 (ufs: query descriptor API)
Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Acked-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7322a17660d1..b140e81c4f7d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -853,7 +853,8 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	memcpy(&query_res->upiu_res, &lrbp->ucd_rsp_ptr->qr, QUERY_OSF_SIZE);
 
 	/* Get the descriptor */
-	if (lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
+	if (hba->dev_cmd.query.descriptor &&
+	    lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
 		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr +
 				GENERAL_UPIU_REQUEST_SIZE;
 		u16 resp_len;
-- 
2.20.1



