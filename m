Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0BE41740A
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345121AbhIXNCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344832AbhIXNAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 017C4613BD;
        Fri, 24 Sep 2021 12:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488018;
        bh=HFyDbrDTMZFx3zThDMJHdKI66wVixn7evMzn/DJ5jDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvbrXS/sb2mgn/7Lknt4qiVr052OgF6qGapPGQcM72UE9b0UTpmZJMyWnGpAFMnGS
         UjcUYLpwT0nRUFc/P2MXS5TMlzQ4h3HOFYXSQzBl9lpLmdSG/K8TLRTHBL0K0Jkk23
         alAoSvMIDfL6xpMxCC3XV9mNlngWANyTlL/yFAmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        Andre Muller <andre.muller@web.de>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 052/100] of: property: Disable fw_devlink DT support for X86
Date:   Fri, 24 Sep 2021 14:44:01 +0200
Message-Id: <20210924124343.182273832@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 4a48b66b3f52aa1a8aaa8a8863891eed35769731 ]

Andre reported fw_devlink=on breaking OLPC XO-1.5 [1].

OLPC XO-1.5 is an X86 system that uses a mix of ACPI and OF to populate
devices. The root cause seems to be ISA devices not setting their fwnode
field. But trying to figure out how to fix that doesn't seem worth the
trouble because the OLPC devicetree is very sparse/limited and fw_devlink
only adds the links causing this issue. Considering that there aren't many
users of OF in an X86 system, simply fw_devlink DT support for X86.

[1] - https://lore.kernel.org/lkml/3c1f2473-92ad-bfc4-258e-a5a08ad73dd0@web.de/

Fixes: ea718c699055 ("Revert "Revert "driver core: Set fw_devlink=on by default""")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Cc: Andre Muller <andre.muller@web.de>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-by: Andre Müller <andre.muller@web.de>
Link: https://lore.kernel.org/r/20210910011446.3208894-1-saravanak@google.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/property.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 6c028632f425..0b9c2fb843e7 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1434,6 +1434,9 @@ static int of_fwnode_add_links(struct fwnode_handle *fwnode)
 	struct property *p;
 	struct device_node *con_np = to_of_node(fwnode);
 
+	if (IS_ENABLED(CONFIG_X86))
+		return 0;
+
 	if (!con_np)
 		return -EINVAL;
 
-- 
2.33.0



