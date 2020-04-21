Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09C71B2E20
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgDURTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:19:00 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:41905 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbgDURS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:18:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B74151940860;
        Tue, 21 Apr 2020 13:09:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QSfnAl
        hwJ02VWKwn7bTBI818q/MJjAu4MEeS1EkJ95s=; b=WzhADi2EeJxScN/asmq6N9
        N9XcZYp6S33smaI48LFolUv0Pn2tRFA2BSr7ct36EL/NXG8FLjGI1YW65ofm/fTP
        ffOaUBWydnMSz7GcAO0cmYWc1LMs01J8lf5X+uFLFvltY67Xyoss886W7saYPxe5
        gkxyoKGZyMk4WoIppzCNah50epH7/nHZE4gCiYOySqqo5LWEyOIKtaJXWVI02L0I
        XG+oYKknOnYT9pkNBRfVdsshSEyr8SBYqsV9WJ1E4SjYXN6yRYoYxm/up0EbfXy7
        JHgNqEwPbPuM1/pyRqMo+SZgDmYy0MCc4c/bCmQ8E5WFSgTfG5KydRD7WG42I+BQ
        ==
X-ME-Sender: <xms:0yifXtM0q0smv27TZ1EGiCdelBt1pA5gxfu_g_wEHhTk6_UMy-wFQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0yifXkMFBFerNUSMgmfn5MFUPgYHhrzpy92rUw7usFwSlmeRWJCf1w>
    <xmx:0yifXnRc314OKxONhNePeGOXtITJ0uJGKrrw9kAAn8dZ7cugtVPlYQ>
    <xmx:0yifXuCeGfQuX5oT4m1aiS9ewLbj2CVP3yY7dWIS7_KyjsX3sOdBwQ>
    <xmx:0yifXq8oo-UbT4gQdYG1aa-f3nr69AZGCVhP1jnvuRsTyGfcERdLlw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB5283280069;
        Tue, 21 Apr 2020 13:09:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] of: unittest: kmemleak in of_unittest_platform_populate()" failed to apply to 4.14-stable tree
To:     frank.rowand@sony.com, erhard_f@mailbox.org, robh@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:09:37 +0200
Message-ID: <1587488977126108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

