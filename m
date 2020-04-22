Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5041B3F67
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgDVKhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729728AbgDVKW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:22:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D57C42076E;
        Wed, 22 Apr 2020 10:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550948;
        bh=RKJ7Yog8jQWWRje6qQ+jbTWQkqvorlLM1SYf3LrHV7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pATepj8vynOvrcNCJyb2+Oeq1tOJ5FIzRoFqQemtKEjBsX79rgQPx6thSSWoWQhaq
         V5ilHoZlSW1+Yr5ngA7JWm4j+DemLD1CARv60qmPYqokaK7jHLbnzh9FW3PgDuu4Ym
         Ukq9JleXO/TByzdsvK5DnwoVEzPKkMYgLtavD+/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Erhard F." <erhard_f@mailbox.org>,
        Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.6 022/166] of: unittest: kmemleak in of_unittest_platform_populate()
Date:   Wed, 22 Apr 2020 11:55:49 +0200
Message-Id: <20200422095050.910886620@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Rowand <frank.rowand@sony.com>

commit 216830d2413cc61be3f76bc02ffd905e47d2439e upstream.

kmemleak reports several memory leaks from devicetree unittest.
This is the fix for problem 2 of 5.

of_unittest_platform_populate() left an elevated reference count for
grandchild nodes (which are platform devices).  Fix the platform
device reference counts so that the memory will be freed.

Fixes: fb2caa50fbac ("of/selftest: add testcase for nodes with same name and address")
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/of/unittest.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1155,10 +1155,13 @@ static void __init of_unittest_platform_
 
 	of_platform_populate(np, match, NULL, &test_bus->dev);
 	for_each_child_of_node(np, child) {
-		for_each_child_of_node(child, grandchild)
-			unittest(of_find_device_by_node(grandchild),
+		for_each_child_of_node(child, grandchild) {
+			pdev = of_find_device_by_node(grandchild);
+			unittest(pdev,
 				 "Could not create device for node '%pOFn'\n",
 				 grandchild);
+			of_dev_put(pdev);
+		}
 	}
 
 	of_platform_depopulate(&test_bus->dev);


