Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB0F404E02
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243026AbhIIMH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350273AbhIIMFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:05:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5885B615A7;
        Thu,  9 Sep 2021 11:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188045;
        bh=L/kYqinvZKgiNpnF/JFP/OdfPQwTZRg8Ij6fzHTyWUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sxd748i2dMGfwyJtqEYAGLNy+AGO6+CaS0Y+DCdmHsAixSt/pLeTvPRQPAmM9KXDB
         6ZJnfLn3yuUeR0DZOukvQXc7ffu+2qXleWnzALKsUd/XHePNNBj2Kb44aBZPFvljtA
         HL6LQZJHx1sxPIo3RZedZYLUAPpsZvU71OX/5d2Rk/2zEbai+RyOxIy16sdYv33NZk
         pGYGbsPsbYAGka/L9H6qy77/QgxLPaR7KFbCOM/wW2PGtXe8nWZmzzbsm/fu/yNMLX
         Id+j0oJa85Dxjero6kWckC30ervzlSiKG6YUZOvsH334+oPRzMwnHOM2LHizSocs8u
         zOFfN0XfckB1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.13 038/219] staging: hisilicon,hi6421-spmi-pmic.yaml: fix patternProperties
Date:   Thu,  9 Sep 2021 07:43:34 -0400
Message-Id: <20210909114635.143983-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 3b23ad56b31a..ef664b4458fb 100644
--- a/drivers/staging/hikey9xx/hisilicon,hi6421-spmi-pmic.yaml
+++ b/drivers/staging/hikey9xx/hisilicon,hi6421-spmi-pmic.yaml
@@ -42,6 +42,8 @@ properties:
   regulators:
     type: object
 
+    additionalProperties: false
+
     properties:
       '#address-cells':
         const: 1
@@ -50,11 +52,13 @@ properties:
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

