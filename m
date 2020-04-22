Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910BA1B4255
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgDVKCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgDVKCK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:02:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA73C2076C;
        Wed, 22 Apr 2020 10:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549730;
        bh=qo1XiaGrM/lXuq9vYY4i7BcKmhXgjNcRBrvpB4dm4uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcB/KKjL1CRM28w6ujXEGR3C8t+dWM7+t/FZ+gb9TB40eqyF0Gjc6XlSLtwexJVu/
         4qjftLXS/wJQ2EBtq+BBW5YXFTx/TRK+AoB6rz2/LVorQ+zc8wI4w1f1QKfc4P4d10
         Bvkbb162q6cMGz4OFhZpCBKmLloNpeYrsrO2XaiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Erhard F." <erhard_f@mailbox.org>,
        Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 083/100] of: unittest: kmemleak in of_unittest_platform_populate()
Date:   Wed, 22 Apr 2020 11:56:53 +0200
Message-Id: <20200422095037.982396842@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Rowand <frank.rowand@sony.com>

[ Upstream commit 216830d2413cc61be3f76bc02ffd905e47d2439e ]

kmemleak reports several memory leaks from devicetree unittest.
This is the fix for problem 2 of 5.

of_unittest_platform_populate() left an elevated reference count for
grandchild nodes (which are platform devices).  Fix the platform
device reference counts so that the memory will be freed.

Fixes: fb2caa50fbac ("of/selftest: add testcase for nodes with same name and address")
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 1ee2474fa8fbb..109497dbfba08 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -816,10 +816,13 @@ static void __init of_unittest_platform_populate(void)
 
 	of_platform_populate(np, match, NULL, &test_bus->dev);
 	for_each_child_of_node(np, child) {
-		for_each_child_of_node(child, grandchild)
-			unittest(of_find_device_by_node(grandchild),
+		for_each_child_of_node(child, grandchild) {
+			pdev = of_find_device_by_node(grandchild);
+			unittest(pdev,
 				 "Could not create device for node '%s'\n",
 				 grandchild->name);
+			of_dev_put(pdev);
+		}
 	}
 
 	of_platform_depopulate(&test_bus->dev);
-- 
2.20.1



