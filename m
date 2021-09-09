Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFECC404A5B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239995AbhIILqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236659AbhIILna (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:43:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30565611C5;
        Thu,  9 Sep 2021 11:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187725;
        bh=RbQK7DXt1AUNw7ujUS0IVL77fwIheGxdH1R23y+YR30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nh5+2H37NZ301CTnzRJd1ZS79NMFICAEqSsyXecv86ZaTogCZyFQ1fiCDyJoNM+Ke
         siPGtt4tonwf/kzanFZ8mTUZxw5Hc2ADS0J0hNFtDkFii4vY3DMd4IQhJ8A/p/Xm3O
         BkIHigh30KWP5UFUuv9QVapW5JiOuSiEd2eOXM0qN4+6g5wlr92PLt+JGLW3QRdzKu
         cv6E3HE8LB+RUnQ7UCj6WY3ePkaFt4H8rVAahIxlzqAopBDv67MQjpyRuAQF3qPEds
         OercuzPjGCqB9IHpizXV8RRfO4JG/lkHsvxf4E+nVsTENJvxyPml4addKaJOZ4tj9q
         drbMdtOTALusg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.14 046/252] staging: hisilicon,hi6421-spmi-pmic.yaml: fix patternProperties
Date:   Thu,  9 Sep 2021 07:37:40 -0400
Message-Id: <20210909114106.141462-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

