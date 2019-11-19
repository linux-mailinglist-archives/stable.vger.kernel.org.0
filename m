Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106AD101857
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbfKSFcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:32:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727717AbfKSFcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:32:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42A9F21783;
        Tue, 19 Nov 2019 05:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141574;
        bh=UVs0BQCbS7l7vr5KRG0CBnk8B8+YWO9XidSyUtzdbGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEiXGqY3qOQA0wrGiRflfQbjYLtWEM6inFY5WCDinad8bNvH6RklwZCAEMpmbD8xs
         HOUbUn3iDGOrbqiCt/mwMskc0WqDcE2EmF4Ku22KaM2v+OF7fOhsDIRbNoefZmYeFZ
         YgkRy+x3LPFF0qRhcZ3WNv9BNzA1GBmWvDFBuuBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 207/422] soc: qcom: apr: Avoid string overflow
Date:   Tue, 19 Nov 2019 06:16:44 +0100
Message-Id: <20191119051412.003391715@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



