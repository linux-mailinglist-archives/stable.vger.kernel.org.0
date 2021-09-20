Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C61412594
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383452AbhITSq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383234AbhITSoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 355CA61AFD;
        Mon, 20 Sep 2021 17:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159148;
        bh=1aStcyYa0yll05I7CgTX2aAWnzcLR8tVVLBn72rmAJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeDAfSVUpMOfMcPP1+565Y5OOkWgyTvfdXlzLTHHCxKqqtyPZh5UjKIwBMJs5w3n/
         1fHyEIO4e4jlaSLic38hPfwfbhViBrtkYlo4AnDhm9MKqxzbzHEywCtBdfpxM9Xfpo
         qXZTtLWEQkY92xjP0vuhFjIiLPCmM3YErjFH1mxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 066/168] qed: Handle management FW error
Date:   Mon, 20 Sep 2021 18:43:24 +0200
Message-Id: <20210920163923.807959108@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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
@@ -3368,6 +3368,7 @@ qed_mcp_get_nvm_image_att(struct qed_hwf
 			  struct qed_nvm_image_att *p_image_att)
 {
 	enum nvm_image_type type;
+	int rc;
 	u32 i;
 
 	/* Translate image_id into MFW definitions */
@@ -3396,7 +3397,10 @@ qed_mcp_get_nvm_image_att(struct qed_hwf
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


