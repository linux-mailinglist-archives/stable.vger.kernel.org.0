Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868351B3D9A
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgDVKQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729687AbgDVKQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:16:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 778662075A;
        Wed, 22 Apr 2020 10:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550595;
        bh=rWyMJ9/5BvPz5zxCT7OMcSHFKQEbZj3LzdGRHpnuOQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFJwtdJ8z4UqaKBhdwhJJ2Ls+iqC76uc6OypNdyqaHW833nMQGlXkGggb7pYIFg5x
         0CPI5llb77fH/sLhcQyniBQj6fG2jo8j9SN1nj1+WA0YrFDyCa684scvhWXhh/IXXp
         QhboE4znyA3Ksh4xeBn3UZJfx12qbFczHk54/l5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Erhard F." <erhard_f@mailbox.org>,
        Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 016/118] of: unittest: kmemleak in of_unittest_platform_populate()
Date:   Wed, 22 Apr 2020 11:56:17 +0200
Message-Id: <20200422095034.228127725@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
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
@@ -1065,10 +1065,13 @@ static void __init of_unittest_platform_
 
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


