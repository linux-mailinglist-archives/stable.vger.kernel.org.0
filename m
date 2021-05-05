Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A305B3739E1
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhEEMGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233148AbhEEMGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:06:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EFC66139A;
        Wed,  5 May 2021 12:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216304;
        bh=7zBl4EIAVNR20EP6ls5/bQ2Jju7ioIbZm3YpvLkbXgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxYZLgm0/fBZa4ttqBazpsx2JeI7M18lr2ObUk84Q/RSEg/ANvXCcWzwXxq1hxv8S
         CweLjYVCZa3lBlpvmrplDABVnRJR+NPmmX5l8o6ZD4+ZpJvpoYC1R1fsc4Y7CpYwMI
         FbdAOZHiOj04p0C11WbURRu0jkUQTTJl1D1gzyzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 19/21] scsi: ufs: Unlock on a couple error paths
Date:   Wed,  5 May 2021 14:04:33 +0200
Message-Id: <20210505112325.358920378@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
References: <20210505112324.729798712@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit bb14dd1564c90d333f51e69dd6fc880b8233ce11 upstream.

We introduced a few new error paths, but we can't return directly, we first
have to unlock "hba->clk_scaling_lock" first.

Fixes: a276c19e3e98 ("scsi: ufs: Avoid busy-waiting by eliminating tag conflicts")
Link: https://lore.kernel.org/r/20191213104828.7i64cpoof26rc4fw@kili.mountain
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshcd.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2639,8 +2639,10 @@ static int ufshcd_exec_dev_cmd(struct uf
 	 * the maximum wait time is bounded by SCSI request timeout.
 	 */
 	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		goto out_unlock;
+	}
 	tag = req->tag;
 	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
@@ -2668,6 +2670,7 @@ static int ufshcd_exec_dev_cmd(struct uf
 
 out_put_tag:
 	blk_put_request(req);
+out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
 }
@@ -5842,8 +5845,10 @@ static int ufshcd_issue_devman_upiu_cmd(
 	down_read(&hba->clk_scaling_lock);
 
 	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		goto out_unlock;
+	}
 	tag = req->tag;
 	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
@@ -5920,6 +5925,7 @@ static int ufshcd_issue_devman_upiu_cmd(
 	}
 
 	blk_put_request(req);
+out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
 }


