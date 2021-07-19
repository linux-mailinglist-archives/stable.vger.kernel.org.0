Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937C83CE4C2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbhGSPqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346547AbhGSPmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32B3E61408;
        Mon, 19 Jul 2021 16:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711714;
        bh=bTYqlpNdoAoSEPSHIyiL4RKxHJprX5EKA4dt7923Zoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGN4jeeMByawNi36zwtTMfjAPpO3P6aOTNAHird+4YLtZqf4cRtTqk52TshVBvVKN
         9sCAdlbwI72jSoB45Ah0SuQ8YIWtefLhn0dMXM9/gFAaj1HnzVGckGSI6Ac+zFGY+o
         12r8eq3nVs/ZoH/XPy78I7hO7JwxpZjAri5cG4jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Koby Elbaz <kelbaz@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 105/292] habanalabs/gaudi: set the correct rc in case of err
Date:   Mon, 19 Jul 2021 16:52:47 +0200
Message-Id: <20210719144945.949262227@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koby Elbaz <kelbaz@habana.ai>

[ Upstream commit 1f7ef4bf41c7c2abad3d21b8c69db11fc3ebc4f5 ]

fix the following smatch warnings:
gaudi_internal_cb_pool_init() warn: missing error code 'rc'

Signed-off-by: Koby Elbaz <kelbaz@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 0c6092ebbc04..894056da22cf 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -8070,8 +8070,10 @@ static int gaudi_internal_cb_pool_init(struct hl_device *hdev,
 			HL_VA_RANGE_TYPE_HOST, HOST_SPACE_INTERNAL_CB_SZ,
 			HL_MMU_VA_ALIGNMENT_NOT_NEEDED);
 
-	if (!hdev->internal_cb_va_base)
+	if (!hdev->internal_cb_va_base) {
+		rc = -ENOMEM;
 		goto destroy_internal_cb_pool;
+	}
 
 	mutex_lock(&ctx->mmu_lock);
 	rc = hl_mmu_map_contiguous(ctx, hdev->internal_cb_va_base,
-- 
2.30.2



