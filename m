Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CACC1B2E25
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgDURTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:19:01 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:57019 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728735AbgDURTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:19:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 345AE1940726;
        Tue, 21 Apr 2020 13:09:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LCUbzu
        UKiu4C5k1fXdeiX3CYU9aCgMxIL7YM+VIFN48=; b=eZ/0BYgNicA5rWh/tkxGLm
        5/QRcOq5wbW8iR/de5SGOMUhvxf+5WPeq3GULdH3fwYcPCH8V9YUaAwvUUVlB+jP
        mWxPZ1Ibord7TStuTFcdk6jvqVnmJ0dpIkBLa9np9tH/SUI4FLlB3qH7Gbg1Vh/g
        HN5UJpcyP3TzeDxwIm/M7VR9uwuMKMWvQRZ0J+MdFWt2IOQSPUYvEutOhQnQJEfS
        ncugPrQe7sMYtRa/dfPo/gN+2BL4vftR45ifVHERbQLfN7o/mpfcGYnYrW5lKqnl
        tAGmVJOMaZouqcvczQo2pEtUBj65bP7r9C+fQtoEop9d5Z7N1XgD8mIU3ioqGw4A
        ==
X-ME-Sender: <xms:3SifXs8eSb7GOg2BmKkvLGv16RkjpXH3Nes9kzB-i8-YAOisX7m5yw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:3SifXgrX6OhiVCk3zScUwufjcEzEc_SB8kglNiUmcBIhMFbVWoPfLQ>
    <xmx:3SifXoIncAhIOpBgo9-uIQgoBgUucAr7oDDqBi0ibit93o2py0gSEg>
    <xmx:3SifXi13vaXGzctOA-s8cteoodobL6hCz32zdGejeoQSmvARVDOZHA>
    <xmx:3SifXnIn9cUHbpM_-0QafwNxgHSYblJDCbpeZHXkSrznlBiLnKJssA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C76173280063;
        Tue, 21 Apr 2020 13:09:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] of: unittest: kmemleak in of_unittest_platform_populate()" failed to apply to 4.9-stable tree
To:     frank.rowand@sony.com, erhard_f@mailbox.org, robh@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:09:38 +0200
Message-ID: <1587488978204151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 216830d2413cc61be3f76bc02ffd905e47d2439e Mon Sep 17 00:00:00 2001
From: Frank Rowand <frank.rowand@sony.com>
Date: Thu, 16 Apr 2020 16:42:47 -0500
Subject: [PATCH] of: unittest: kmemleak in of_unittest_platform_populate()

kmemleak reports several memory leaks from devicetree unittest.
This is the fix for problem 2 of 5.

of_unittest_platform_populate() left an elevated reference count for
grandchild nodes (which are platform devices).  Fix the platform
device reference counts so that the memory will be freed.

Fixes: fb2caa50fbac ("of/selftest: add testcase for nodes with same name and address")
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Rob Herring <robh@kernel.org>

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 20ff2dfc3143..4c7818276857 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1247,10 +1247,13 @@ static void __init of_unittest_platform_populate(void)
 
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

