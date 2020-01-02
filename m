Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2781F12F162
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbgABWNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:13:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727614AbgABWNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:13:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D35F222C3;
        Thu,  2 Jan 2020 22:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003187;
        bh=ws1QO4IrZHu0wTXH+sAb39oQGJd62dPx1z4rY6Bnpz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmcFG0qZZmOojpodNbZjdVXEnCUnh3lbbfF0Jqde/yxf0pfAAuHu4QlHa9I2oR7wH
         Z2sRnNBARbC/1VhTeNhrj4Ap6NMihM7JMwdeXmdW1LGGMbfna1CfSp5t7nFn9tFvkj
         i5uJU9rDJg2htlbAH4lmiArx6d1htd08q8o8i5f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Barry Song <Baohua.Song@csr.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/191] mfd: mfd-core: Honour Device Trees request to disable a child-device
Date:   Thu,  2 Jan 2020 23:05:37 +0100
Message-Id: <20200102215835.819082035@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit 6b5c350648b857047b47acf74a57087ad27d6183 ]

Until now, MFD has assumed all child devices passed to it (via
mfd_cells) are to be registered. It does not take into account
requests from Device Tree and the like to disable child devices
on a per-platform basis.

Well now it does.

Link: https://www.spinics.net/lists/arm-kernel/msg366309.html
Link: https://lkml.org/lkml/2019/8/22/1350

Reported-by: Barry Song <Baohua.Song@csr.com>
Reported-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mfd-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 23276a80e3b4..b0afefdc9eac 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -174,6 +174,11 @@ static int mfd_add_device(struct device *parent, int id,
 	if (parent->of_node && cell->of_compatible) {
 		for_each_child_of_node(parent->of_node, np) {
 			if (of_device_is_compatible(np, cell->of_compatible)) {
+				if (!of_device_is_available(np)) {
+					/* Ignore disabled devices error free */
+					ret = 0;
+					goto fail_alias;
+				}
 				pdev->dev.of_node = np;
 				pdev->dev.fwnode = &np->fwnode;
 				break;
-- 
2.20.1



