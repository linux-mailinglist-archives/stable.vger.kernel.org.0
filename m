Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB8E1B2E24
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgDURTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:19:01 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:47685 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726245AbgDURTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:19:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id D4B001940776;
        Tue, 21 Apr 2020 13:09:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:09:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4nlw8r
        /WIWd0dgpuBsggW4EUb7kJS5KXfhh7RdvEx6c=; b=288ywJbmkewNDiJrSsiXwA
        eeWVDeiehNPYL0XGQnhpaGns7HwPrMGB9TFYyZVWCfhFG9bwZiGwSuiBXDF9pYgO
        RocZQAAXkyJVCMVyy1N/eYmsrROQFMIji7tt5jr/zWSz7HdAmkQqmmIssVH/zR3Q
        IfeCtsmhrIdUHnX8YB8ehw074F7lXh4fAT0ih+bK1z+dvC2BnU6tQPzVSsszNhun
        RCb4egt2Nbb7mFCQZntuyUwYGtvvKMm3gfk8tFZPAbV8QH6hkk7dj/8YCyeEJvuE
        rA4QkpplWkM0cK0Bj4g7sS/PkpmUk5WEie51xMQ3ITVVSW3/Za9vIM9dwJ3NvF9w
        ==
X-ME-Sender: <xms:2yifXrECDlt-_NL211RRx2el5IZtH869eHRIkYGM99Skic7Nk_ko6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2yifXskgs_UDYHJ1SuzuA6zrY9VSskXx-PZDREiA4A20F6YTRRu_qw>
    <xmx:2yifXoJ4sNVOtITUHRK3b_cclw5S7L68o6sCIWHDMisWYz3TCGxgLg>
    <xmx:2yifXtYkP2sO-6SwLeBHahwo8yrEeaRNbzBHGQ43DmAjq1MAbvampQ>
    <xmx:2yifXn14CtcLlg-oYfOpdsMeJqceWBrVC_OnPtdmwbsccDyvp9RN2w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6BB083065C73;
        Tue, 21 Apr 2020 13:09:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] of: unittest: kmemleak in of_unittest_platform_populate()" failed to apply to 4.4-stable tree
To:     frank.rowand@sony.com, erhard_f@mailbox.org, robh@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:09:38 +0200
Message-ID: <158748897816258@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

