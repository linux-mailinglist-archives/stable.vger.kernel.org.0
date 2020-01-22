Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBA41456BB
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgAVN32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:29:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730879AbgAVN1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:27:20 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 008A0205F4;
        Wed, 22 Jan 2020 13:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699639;
        bh=1Db3lYeWizfiMaW+Ghe6xbopy16WjdgWkpy59aWx5q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bniotb0FL/vM+Qwg83xOdS0sT7HOuV3/yW61I27MyHCBrf5IklSikkEv3kVIX9GLd
         0CQOiQudNOQNZgo8HYdxN1fIIVFIO9MFFmtzudXfowbQ5n6ZO0EXtj8ncycAIKvfjh
         RYBfD1tkrkorLmVy+qPx9ssnvwe3rwFtx90QCmOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.4 205/222] scsi: lpfc: fix: Coverity: lpfc_get_scsi_buf_s3(): Null pointer dereferences
Date:   Wed, 22 Jan 2020 10:29:51 +0100
Message-Id: <20200122092848.379097881@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 6f23f8c5c9f1be4eb17c035129c80e49000c18a7 upstream.

Coverity reported the following:

---
 drivers/scsi/lpfc/lpfc_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -719,7 +719,7 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *ph
 	iocb->ulpLe = 1;
 	iocb->ulpClass = CLASS3;
 
-	if (lpfc_ndlp_check_qdepth(phba, ndlp)) {
+	if (lpfc_ndlp_check_qdepth(phba, ndlp) && lpfc_cmd) {
 		atomic_inc(&ndlp->cmd_pending);
 		lpfc_cmd->flags |= LPFC_SBUF_BUMP_QDEPTH;
 	}


