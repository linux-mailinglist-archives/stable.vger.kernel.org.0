Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853C340E708
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351154AbhIPR1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:27:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348339AbhIPRZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:25:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28EA761350;
        Thu, 16 Sep 2021 16:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810689;
        bh=RbQK7DXt1AUNw7ujUS0IVL77fwIheGxdH1R23y+YR30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOGG54b4DpHrkHN9fUj5FDxX/0ygLFZFVV21gkNu9PVFygm5/Wyav0/pDqEY33xg3
         k7DJvd87AEQY3b3ZUgbud7VuJ/X7UHWgIMNPZUxY0D8BA/p0+XyU0jKxmcBdCFXei8
         yqcpBa3s6PCiXSOP+alXAaEbywPieoJYE1ANHTN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 200/432] staging: hisilicon,hi6421-spmi-pmic.yaml: fix patternProperties
Date:   Thu, 16 Sep 2021 17:59:09 +0200
Message-Id: <20210916155817.588173520@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 334201d503d5903f38f6e804263fc291ce8f451a ]

The regex at the patternProperties is wrong, although this was
not reported as the DT schema was not enforcing properties.

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Link: https://lore.kernel.org/r/46b2f30df235481cb1404913380e45706dfd8253.1626515862.git.mchehab+huawei@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/hikey9xx/hisilicon,hi6421-spmi-pmic.yaml | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/hikey9xx/hisilicon,hi6421-spmi-pmic.yaml b/drivers/staging/hikey9xx/hisilicon,hi6421-spmi-pmic.yaml
index 8e355cddd437..6c348578e4a2 100644
--- a/drivers/staging/hikey9xx/hisilicon,hi6421-spmi-pmic.yaml
+++ b/drivers/staging/hikey9xx/hisilicon,hi6421-spmi-pmic.yaml
@@ -41,6 +41,8 @@ properties:
   regulators:
     type: object
 
+    additionalProperties: false
+
     properties:
       '#address-cells':
         const: 1
@@ -49,11 +51,13 @@ properties:
         const: 0
 
     patternProperties:
-      '^ldo[0-9]+@[0-9a-f]$':
+      '^(ldo|LDO)[0-9]+$':
         type: object
 
         $ref: "/schemas/regulator/regulator.yaml#"
 
+        unevaluatedProperties: false
+
 required:
   - compatible
   - reg
-- 
2.30.2



