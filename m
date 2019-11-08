Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A9BF466D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389922AbfKHLmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:42:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389918AbfKHLmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 855A921D82;
        Fri,  8 Nov 2019 11:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213340;
        bh=UVs0BQCbS7l7vr5KRG0CBnk8B8+YWO9XidSyUtzdbGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpS7NcA4rWPErAQrChahRyjeUYE9568cg43eAnhpqPO6cfBy7MM7O15s6Lk6iDLzI
         9Km6+k2fcRxcAZ9N4E5sCDQqMOPp6BLsMp8pJah8XSiY8dlXlrYX9Qr0sB+5MSmLsK
         PWVb4/95kprkb39vGBI8CcyABleik3w10J6xP94w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 177/205] soc: qcom: apr: Avoid string overflow
Date:   Fri,  8 Nov 2019 06:37:24 -0500
Message-Id: <20191108113752.12502-177-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@linaro.org>

[ Upstream commit 4fadb26574cb74e5de079dd384f25f44f4fb3ec3 ]

'adev->name' is used as a NUL-terminated string, but using strncpy() with the
length equal to the buffer size may result in lack of the termination:

In function 'apr_add_device',
    inlined from 'of_register_apr_devices' at drivers//soc/qcom/apr.c:264:7,
    inlined from 'apr_probe' at drivers//soc/qcom/apr.c:290:2:
drivers//soc/qcom/apr.c:222:3: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
   strncpy(adev->name, np->name, APR_NAME_SIZE);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This changes it to use the safer strscpy() instead.

Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/apr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/apr.c b/drivers/soc/qcom/apr.c
index 57af8a5373325..ee9197f5aae96 100644
--- a/drivers/soc/qcom/apr.c
+++ b/drivers/soc/qcom/apr.c
@@ -219,9 +219,9 @@ static int apr_add_device(struct device *dev, struct device_node *np,
 	adev->domain_id = id->domain_id;
 	adev->version = id->svc_version;
 	if (np)
-		strncpy(adev->name, np->name, APR_NAME_SIZE);
+		strscpy(adev->name, np->name, APR_NAME_SIZE);
 	else
-		strncpy(adev->name, id->name, APR_NAME_SIZE);
+		strscpy(adev->name, id->name, APR_NAME_SIZE);
 
 	dev_set_name(&adev->dev, "aprsvc:%s:%x:%x", adev->name,
 		     id->domain_id, id->svc_id);
-- 
2.20.1

