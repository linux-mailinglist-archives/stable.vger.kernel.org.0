Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F24C1FE7D5
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgFRCnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbgFRBLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:11:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A68C221E6;
        Thu, 18 Jun 2020 01:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442683;
        bh=/bBd9Kcib72Nd6qfjvx5eG/CuEwIcQlkINsGTgx75Ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ns3rK1tZ6XHSDw7xXPPannKP8YoonB3nYh4YAD5zYmLw7jP9DD8n53aTuQAiRWwx1
         RDiwRgMPOmLfexCrFMv4wJkxXZy+35xWDq8JgWOM+9RJffwkbdc+5ARyNoDEUAf3q9
         fw2xJCj69vl8VlROJsd2LvseZmN+HG48I9D2x6iQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Saravana Kannan <saravanak@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 150/388] of: property: Do not link to disabled devices
Date:   Wed, 17 Jun 2020 21:04:07 -0400
Message-Id: <20200618010805.600873-150-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit 7456427af9def0fec5508dd8b861556038ee96a8 ]

When creating a consumer/supplier relationship between two devices,
make sure the supplier node is actually active. Otherwise this will
create a link relationship that will never be fulfilled. This, in the
worst case scenario, will hang the system during boot.

Note that, in practice, the fact that a device-tree represented
consumer/supplier relationship isn't fulfilled will not prevent devices
from successfully probing.

Fixes: a3e1d1a7f5fc ("of: property: Add functional dependency link from DT bindings")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/property.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index a8c2b13521b2..6dc542af5a70 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1045,8 +1045,20 @@ static int of_link_to_phandle(struct device *dev, struct device_node *sup_np,
 	 * Find the device node that contains the supplier phandle.  It may be
 	 * @sup_np or it may be an ancestor of @sup_np.
 	 */
-	while (sup_np && !of_find_property(sup_np, "compatible", NULL))
+	while (sup_np) {
+
+		/* Don't allow linking to a disabled supplier */
+		if (!of_device_is_available(sup_np)) {
+			of_node_put(sup_np);
+			sup_np = NULL;
+		}
+
+		if (of_find_property(sup_np, "compatible", NULL))
+			break;
+
 		sup_np = of_get_next_parent(sup_np);
+	}
+
 	if (!sup_np) {
 		dev_dbg(dev, "Not linking to %pOFP - No device\n", tmp_np);
 		return -ENODEV;
-- 
2.25.1

