Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EE24123F9
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378878AbhITS3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378883AbhITS0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:26:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B91F632D6;
        Mon, 20 Sep 2021 17:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158762;
        bh=r2MxMQfax9AZlYGwWJanIe6mzDxRLMDqrXLsslA3azc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpGV1iWL7xRnPUvhK9t+Q3B6/6ig0OkOz8+rQQLgh93xOP9ZPgS5xVZZVxYvD3fWP
         iQ3mlA/b27evXTj/RWsXMNzXmGoh9xyrn+j8yph7XVFhaN3f+W1NNedLOKNqiQw0JR
         i7EMfrYCFGUB1PeMuzZ+T4y4SgHgnwHzENi1ew8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 044/122] qed: Handle management FW error
Date:   Mon, 20 Sep 2021 18:43:36 +0200
Message-Id: <20210920163917.237769778@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shai Malin <smalin@marvell.com>

commit 20e100f52730cd0db609e559799c1712b5f27582 upstream.

Handle MFW (management FW) error response in order to avoid a crash
during recovery flows.

Changes from v1:
- Add "Fixes tag".

Fixes: tag 5e7ba042fd05 ("qed: Fix reading stale configuration information")
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3376,6 +3376,7 @@ qed_mcp_get_nvm_image_att(struct qed_hwf
 			  struct qed_nvm_image_att *p_image_att)
 {
 	enum nvm_image_type type;
+	int rc;
 	u32 i;
 
 	/* Translate image_id into MFW definitions */
@@ -3404,7 +3405,10 @@ qed_mcp_get_nvm_image_att(struct qed_hwf
 		return -EINVAL;
 	}
 
-	qed_mcp_nvm_info_populate(p_hwfn);
+	rc = qed_mcp_nvm_info_populate(p_hwfn);
+	if (rc)
+		return rc;
+
 	for (i = 0; i < p_hwfn->nvm_info.num_images; i++)
 		if (type == p_hwfn->nvm_info.image_att[i].image_type)
 			break;


