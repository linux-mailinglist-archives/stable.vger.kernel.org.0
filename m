Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F49FF205
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbfKPQQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:16:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729573AbfKPPq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:59 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E34520B7C;
        Sat, 16 Nov 2019 15:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919218;
        bh=O4jI/UD5cwgEfztd/WN3i8vXnYRkU/s8BThrOIUqah0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gab8qWMzy30WpCcUr+EWBSmSilrx/XJ48h8zW+cJe/HQs11qmaBAP1iAVjsySzvf4
         driQa7BU9WVBDc1vGogbVQn3NQdqzfdPn8ds25MZwex72MyhhBXIy+AoG43VZe1y6G
         9YqCycosLVwiagTsjJ4IFb8kUajxlqqFu/zfcfHg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Rowand <frank.rowand@sony.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Alan Tull <atull@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 224/237] of: unittest: initialize args before calling of_*parse_*()
Date:   Sat, 16 Nov 2019 10:40:59 -0500
Message-Id: <20191116154113.7417-224-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Rowand <frank.rowand@sony.com>

[ Upstream commit eeb07c573ec307c53fe2f6ac6d8d11c261f64006 ]

Callers of of_irq_parse_one() blindly use the pointer args.np
without checking whether of_irq_parse_one() had an error and
thus did not set the value of args.np.  Initialize args to
zero so that using the format "%pOF" to show the value of
args.np will show "(null)" when of_irq_parse_one() has an
error.  This prevents the dereference of a random value.

Make the same fix for callers of of_parse_phandle_with_args()
and of_parse_phandle_with_args_map().

Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Alan Tull <atull@kernel.org>
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index e8997cdb228cb..68f52966bbc04 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -375,6 +375,7 @@ static void __init of_unittest_parse_phandle_with_args(void)
 	for (i = 0; i < 8; i++) {
 		bool passed = true;
 
+		memset(&args, 0, sizeof(args));
 		rc = of_parse_phandle_with_args(np, "phandle-list",
 						"#phandle-cells", i, &args);
 
@@ -428,6 +429,7 @@ static void __init of_unittest_parse_phandle_with_args(void)
 	}
 
 	/* Check for missing list property */
+	memset(&args, 0, sizeof(args));
 	rc = of_parse_phandle_with_args(np, "phandle-list-missing",
 					"#phandle-cells", 0, &args);
 	unittest(rc == -ENOENT, "expected:%i got:%i\n", -ENOENT, rc);
@@ -436,6 +438,7 @@ static void __init of_unittest_parse_phandle_with_args(void)
 	unittest(rc == -ENOENT, "expected:%i got:%i\n", -ENOENT, rc);
 
 	/* Check for missing cells property */
+	memset(&args, 0, sizeof(args));
 	rc = of_parse_phandle_with_args(np, "phandle-list",
 					"#phandle-cells-missing", 0, &args);
 	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
@@ -444,6 +447,7 @@ static void __init of_unittest_parse_phandle_with_args(void)
 	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
 
 	/* Check for bad phandle in list */
+	memset(&args, 0, sizeof(args));
 	rc = of_parse_phandle_with_args(np, "phandle-list-bad-phandle",
 					"#phandle-cells", 0, &args);
 	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
@@ -452,6 +456,7 @@ static void __init of_unittest_parse_phandle_with_args(void)
 	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
 
 	/* Check for incorrectly formed argument list */
+	memset(&args, 0, sizeof(args));
 	rc = of_parse_phandle_with_args(np, "phandle-list-bad-args",
 					"#phandle-cells", 1, &args);
 	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
@@ -502,6 +507,7 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 	for (i = 0; i < 8; i++) {
 		bool passed = true;
 
+		memset(&args, 0, sizeof(args));
 		rc = of_parse_phandle_with_args_map(np, "phandle-list",
 						    "phandle", i, &args);
 
@@ -559,21 +565,25 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 	}
 
 	/* Check for missing list property */
+	memset(&args, 0, sizeof(args));
 	rc = of_parse_phandle_with_args_map(np, "phandle-list-missing",
 					    "phandle", 0, &args);
 	unittest(rc == -ENOENT, "expected:%i got:%i\n", -ENOENT, rc);
 
 	/* Check for missing cells,map,mask property */
+	memset(&args, 0, sizeof(args));
 	rc = of_parse_phandle_with_args_map(np, "phandle-list",
 					    "phandle-missing", 0, &args);
 	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
 
 	/* Check for bad phandle in list */
+	memset(&args, 0, sizeof(args));
 	rc = of_parse_phandle_with_args_map(np, "phandle-list-bad-phandle",
 					    "phandle", 0, &args);
 	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
 
 	/* Check for incorrectly formed argument list */
+	memset(&args, 0, sizeof(args));
 	rc = of_parse_phandle_with_args_map(np, "phandle-list-bad-args",
 					    "phandle", 1, &args);
 	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
@@ -783,7 +793,7 @@ static void __init of_unittest_parse_interrupts(void)
 	for (i = 0; i < 4; i++) {
 		bool passed = true;
 
-		args.args_count = 0;
+		memset(&args, 0, sizeof(args));
 		rc = of_irq_parse_one(np, i, &args);
 
 		passed &= !rc;
@@ -804,7 +814,7 @@ static void __init of_unittest_parse_interrupts(void)
 	for (i = 0; i < 4; i++) {
 		bool passed = true;
 
-		args.args_count = 0;
+		memset(&args, 0, sizeof(args));
 		rc = of_irq_parse_one(np, i, &args);
 
 		/* Test the values from tests-phandle.dtsi */
@@ -860,6 +870,7 @@ static void __init of_unittest_parse_interrupts_extended(void)
 	for (i = 0; i < 7; i++) {
 		bool passed = true;
 
+		memset(&args, 0, sizeof(args));
 		rc = of_irq_parse_one(np, i, &args);
 
 		/* Test the values from tests-phandle.dtsi */
-- 
2.20.1

