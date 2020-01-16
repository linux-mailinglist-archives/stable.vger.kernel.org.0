Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244AA13F8DB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbgAPQxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:53:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731125AbgAPQxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D2C62192A;
        Thu, 16 Jan 2020 16:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193623;
        bh=WXCaPjnC5n8092lCR4qvX+3Qu9dptx/7Dko2kgnzxA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1/YzSdf/dsDuEjr6/2vRmpb0dNV1aIINX2WIy48QZoRNEaK3zdCV15nLn3X3fK+7
         XEnmFaJwKAaVCuaWaBWmQXYtqLC6G2RycfWnGOhL6Tjh4YUl04Ai6Tic1TVb8n7Pl6
         12a2Vn56B6mvmeVuz7cQ4Kl/kExVjRv5LFNxlKhM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 158/205] scsi: target: core: Fix a pr_debug() argument
Date:   Thu, 16 Jan 2020 11:42:13 -0500
Message-Id: <20200116164300.6705-158-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c941e0d172605731de9b4628bd4146d35cf2e7d6 ]

Print the string for which conversion failed instead of printing the
function name twice.

Fixes: 2650d71e244f ("target: move transport ID handling to the core")
Cc: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20191107215525.64415-1-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_fabric_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 3c79411c4cd0..6b4b354c88aa 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -118,7 +118,7 @@ static int srp_get_pr_transport_id(
 	memset(buf + 8, 0, leading_zero_bytes);
 	rc = hex2bin(buf + 8 + leading_zero_bytes, p, count);
 	if (rc < 0) {
-		pr_debug("hex2bin failed for %s: %d\n", __func__, rc);
+		pr_debug("hex2bin failed for %s: %d\n", p, rc);
 		return rc;
 	}
 
-- 
2.20.1

