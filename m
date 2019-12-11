Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 357B711B1B4
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387948AbfLKPcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732958AbfLKP25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:28:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 274A724680;
        Wed, 11 Dec 2019 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078137;
        bh=DrqW3VBnqbEBqqgF7gTtPyfSthVTP9D9rl1FaytQWFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuJoRqT4zOnW7AiNtABDKCFgAu6k8MgObOC9LLF5Qqh1UtZXYNqeDQbj2lQ+Z0PtN
         1NAeVRweGzoJAYcPAAXkNKCM/C7HHp10JnkYgBAsTzUU/+/rDWDaNjo89U6bfsrlvz
         LVwfqAqZVuSoagAlBgZ184Vv3/7F6mXkQaOvE3Fk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>, Barry Song <Baohua.Song@csr.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 24/58] mfd: mfd-core: Honour Device Tree's request to disable a child-device
Date:   Wed, 11 Dec 2019 10:27:57 -0500
Message-Id: <20191211152831.23507-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152831.23507-1-sashal@kernel.org>
References: <20191211152831.23507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5c8ed2150c8bf..fae7bfe7a21a1 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -178,6 +178,11 @@ static int mfd_add_device(struct device *parent, int id,
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

