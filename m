Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B4E5072C
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbfFXKFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729849AbfFXKFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:05:01 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BF57205ED;
        Mon, 24 Jun 2019 10:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370700;
        bh=9ykm63z15zp473jDZU4n8PDwcq4XFKrkWMWhtYDOEbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxsbnbThI0OqyBsyJfgGeGO2SimlT3gA/Xo25yFTEYLxVXab7zfMopA4tEPnN+eBJ
         9BTvFKS7sJidZH4NKFVvmyf5ntPFFUgCX6rrCKWx60hxt+5NJT5cVrr/lPxMzL+bM0
         yMo8H3LEPWFuDCNELy88ZvCnHVFvMCj1tQsoDClc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 60/90] scsi: ufs: Check that space was properly alloced in copy_query_response
Date:   Mon, 24 Jun 2019 17:56:50 +0800
Message-Id: <20190624092318.074966155@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
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
index 3183fa8c5857..b8b59cfeacd1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1914,7 +1914,8 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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



