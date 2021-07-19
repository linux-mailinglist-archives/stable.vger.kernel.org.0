Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28183CE20B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347274AbhGSP2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349252AbhGSP0U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:26:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14229600EF;
        Mon, 19 Jul 2021 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710819;
        bh=y0siVCioxQt1MRdFUZk2fcAkg8rd4AoXgobUunfCOSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKjG7U/MOqJT5ufL4Zfr9Awy0eS069DvbX/MwPqCQkc0+l5JXB3KfwljgvZcpJmak
         oZI3AynrIBZfLL3NpDqgvsTOyc3mVFgJYMPidChfyf5w9gVt4XlG2dLJY+VH/KIRVA
         XloHTy9MB37yPftnlEq6J5X/SLMXVdbEbziWoyTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Koby Elbaz <kelbaz@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 120/351] habanalabs/gaudi: set the correct rc in case of err
Date:   Mon, 19 Jul 2021 16:51:06 +0200
Message-Id: <20210719144948.454091255@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index d4f764da013c..b7b281ae8d5a 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -8307,8 +8307,10 @@ static int gaudi_internal_cb_pool_init(struct hl_device *hdev,
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



