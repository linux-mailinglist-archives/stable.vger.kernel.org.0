Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEC21480DE
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731323AbgAXLPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:15:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390252AbgAXLPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:15:15 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEF6A20708;
        Fri, 24 Jan 2020 11:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864514;
        bh=DWHxIEmlcXQtbk9/JbT7Rb496vClcmVlnlGlJ4BO0WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rckyuJ/WZ5EWnhip+6bQBAPCv7AW14TXuYqUEo5zBwPr31RajviOHhgCdpxHtW0e
         yVGQKW2ucperd7QoA7qVa2k4VQFF1S8cKYHGetYaCYs8VRQWXxBuddfVI3vkkbKbJ1
         YvmqHHXyaFVShOXjHTUYHjh9JRaf+skOoSmTFHkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 279/639] soc: qcom: cmd-db: Fix an error code in cmd_db_dev_probe()
Date:   Fri, 24 Jan 2020 10:27:29 +0100
Message-Id: <20200124093121.775556132@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a6f646295f067..78d73ec587e11 100644
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



