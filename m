Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C081206644
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389453AbgFWVjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388545AbgFWUG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:06:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8AD52064B;
        Tue, 23 Jun 2020 20:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942816;
        bh=FXO53QtJUc5siOmGUW8VSn/nrIuQRdtWUM6y1auZLOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=19LoqtrcW4xsfPJt6BkR8ANIoH6ZE3S0855tYGDakXipMK8JgKK8tS4ippwNsiWTl
         I8Q4WKlsoZS9xhLUfrBjwcbuWMDIkK9Fq1nDwM7+uwsZdl2AG3VV8RxSBetQ+o5SKn
         KYrXMQX2kos88K/kTdJWDSDeQabIS8sNC60AZf5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Saravana Kannan <saravanak@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 147/477] of: property: Do not link to disabled devices
Date:   Tue, 23 Jun 2020 21:52:24 +0200
Message-Id: <20200623195414.548688121@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a8c2b13521b27..6dc542af5a70f 100644
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



