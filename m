Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA32913E39E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388600AbgAPRDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:03:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388593AbgAPRDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:03:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0DB62081E;
        Thu, 16 Jan 2020 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194191;
        bh=Ts3IgJnZsIlHY5jIp5i4hscpO1qrooJOL1dufIMv008=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRhiZcQ/8XAAA+nrzXCXLlxrPN1P966wpy9nd5LSJfZTpHwNW6fQXzuXyBKEeXbsy
         9XlbujtHtw+85nhsbNSr0Y69xmEOscQOqNbqL3rRYwVeIVmkgMyn8RuyGls4Y6LLj6
         7C8k+Jfwxfwo3HxwVxYLZ/TFtfwaD1sFRyZeo+KQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 263/671] soc: qcom: cmd-db: Fix an error code in cmd_db_dev_probe()
Date:   Thu, 16 Jan 2020 11:52:52 -0500
Message-Id: <20200116165940.10720-146-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 93b260528020792032e50725383f27a27897bb0f ]

The memremap() function doesn't return error pointers, it returns NULL.
This code is returning "ret = PTR_ERR(NULL);" which is success, but it
should return -ENOMEM.

Fixes: 312416d9171a ("drivers: qcom: add command DB driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/cmd-db.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/cmd-db.c b/drivers/soc/qcom/cmd-db.c
index a6f646295f06..78d73ec587e1 100644
--- a/drivers/soc/qcom/cmd-db.c
+++ b/drivers/soc/qcom/cmd-db.c
@@ -283,8 +283,8 @@ static int cmd_db_dev_probe(struct platform_device *pdev)
 	}
 
 	cmd_db_header = memremap(rmem->base, rmem->size, MEMREMAP_WB);
-	if (IS_ERR_OR_NULL(cmd_db_header)) {
-		ret = PTR_ERR(cmd_db_header);
+	if (!cmd_db_header) {
+		ret = -ENOMEM;
 		cmd_db_header = NULL;
 		return ret;
 	}
-- 
2.20.1

