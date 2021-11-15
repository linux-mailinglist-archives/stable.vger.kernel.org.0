Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402E7450C25
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbhKORfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:35:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238188AbhKORdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:33:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DD3363236;
        Mon, 15 Nov 2021 17:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996926;
        bh=6nX/dfiY7hWluABLzRyGgf7pLQA5f2Y1HaiWVAPAnTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZJMQYzG866aGVuwQGbKNNF6E3I/thv1uhZgxhMZuiw5CjMF9skn0SoUR0KC8N+k6
         ktvV4cxOLgAFDOH46xuhBtrJmWcAbfuywA4jqk6xh4mUsz9MLCBgNAvna5rHlL94Sp
         GSEZe9aUegIfz6JTNR62Hka291QnYB0i0dCbg4as=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 276/355] scsi: csiostor: Uninitialized data in csio_ln_vnp_read_cbfn()
Date:   Mon, 15 Nov 2021 18:03:20 +0100
Message-Id: <20211115165322.661215089@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f4875d509a0a78ad294a1a538d534b5ba94e685a ]

This variable is just a temporary variable, used to do an endian
conversion.  The problem is that the last byte is not initialized.  After
the conversion is completely done, the last byte is discarded so it doesn't
cause a problem.  But static checkers and the KMSan runtime checker can
detect the uninitialized read and will complain about it.

Link: https://lore.kernel.org/r/20211006073242.GA8404@kili
Fixes: 5036f0a0ecd3 ("[SCSI] csiostor: Fix sparse warnings.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/csiostor/csio_lnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index 23cbe4cda760e..c3bf590f5d685 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -619,7 +619,7 @@ csio_ln_vnp_read_cbfn(struct csio_hw *hw, struct csio_mb *mbp)
 	struct fc_els_csp *csp;
 	struct fc_els_cssp *clsp;
 	enum fw_retval retval;
-	__be32 nport_id;
+	__be32 nport_id = 0;
 
 	retval = FW_CMD_RETVAL_G(ntohl(rsp->alloc_to_len16));
 	if (retval != FW_SUCCESS) {
-- 
2.33.0



