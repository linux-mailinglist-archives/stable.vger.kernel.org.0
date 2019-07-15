Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933B768E4A
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388105AbfGOOFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388097AbfGOOFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:05:08 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D1352081C;
        Mon, 15 Jul 2019 14:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199508;
        bh=qhF90JaRN9H/Mne/RCsZbQjhkZdpVTzKKYmO16uQJ0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kukJPrLra4Z1yMxFlUEwL6GtGFFjW8i++vPXMH/LKFkdT/q/21Xa/un1FiBoELseb
         /yVfoJwEcQIDWYBcI9yILudMtS6+MxJnmtn+/1ySUtTtGUoBkeEBai/FP6939bQ8oR
         Sp8InhZhyAXo4rv7lfkpJiWsAAEVezd8TmnYP4TM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wen.yang99@zte.com.cn>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 026/219] media: venus: firmware: fix leaked of_node references
Date:   Mon, 15 Jul 2019 10:00:27 -0400
Message-Id: <20190715140341.6443-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

[ Upstream commit 2c41cc0be07b5ee2f1167f41cd8a86fc5b53d82c ]

The call to of_parse_phandle returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
drivers/media/platform/qcom/venus/firmware.c:90:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 82, but without a corresponding object release within this function.
drivers/media/platform/qcom/venus/firmware.c:94:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 82, but without a corresponding object release within this function.
drivers/media/platform/qcom/venus/firmware.c:128:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 82, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/firmware.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 6cfa8021721e..f81449b400c4 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -87,11 +87,11 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
 
 	ret = of_address_to_resource(node, 0, &r);
 	if (ret)
-		return ret;
+		goto err_put_node;
 
 	ret = request_firmware(&mdt, fwname, dev);
 	if (ret < 0)
-		return ret;
+		goto err_put_node;
 
 	fw_size = qcom_mdt_get_size(mdt);
 	if (fw_size < 0) {
@@ -125,6 +125,8 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
 	memunmap(mem_va);
 err_release_fw:
 	release_firmware(mdt);
+err_put_node:
+	of_node_put(node);
 	return ret;
 }
 
-- 
2.20.1

