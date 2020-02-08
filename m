Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23DA15670D
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbgBHS3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33422 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727509AbgBHS3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:32 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrC-0003a6-QN; Sat, 08 Feb 2020 18:29:30 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrB-000CJF-KP; Sat, 08 Feb 2020 18:29:29 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Krzysztof Kozlowski" <krzk@kernel.org>
Date:   Sat, 08 Feb 2020 18:19:10 +0000
Message-ID: <lsq.1581185940.511416157@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 011/148] pinctrl: samsung: Fix device node refcount
 leaks in S3C24xx wakeup controller init
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 6fbbcb050802d6ea109f387e961b1dbcc3a80c96 upstream.

In s3c24xx_eint_init() the for_each_child_of_node() loop is used with a
break to find a matching child node.  Although each iteration of
for_each_child_of_node puts the previous node, but early exit from loop
misses it.  This leads to leak of device node.

Fixes: af99a7507469 ("pinctrl: Add pinctrl-s3c24xx driver")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
[bwh: Backported to 3.16: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pinctrl/pinctrl-s3c24xx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-s3c24xx.c
+++ b/drivers/pinctrl/pinctrl-s3c24xx.c
@@ -497,8 +497,10 @@ static int s3c24xx_eint_init(struct sams
 		return -ENODEV;
 
 	eint_data = devm_kzalloc(dev, sizeof(*eint_data), GFP_KERNEL);
-	if (!eint_data)
+	if (!eint_data) {
+		of_node_put(eint_np);
 		return -ENOMEM;
+	}
 
 	eint_data->drvdata = d;
 
@@ -510,6 +512,7 @@ static int s3c24xx_eint_init(struct sams
 		irq = irq_of_parse_and_map(eint_np, i);
 		if (!irq) {
 			dev_err(dev, "failed to get wakeup EINT IRQ %d\n", i);
+			of_node_put(eint_np);
 			return -ENXIO;
 		}
 
@@ -517,6 +520,7 @@ static int s3c24xx_eint_init(struct sams
 		irq_set_chained_handler(irq, handlers[i]);
 		irq_set_handler_data(irq, eint_data);
 	}
+	of_node_put(eint_np);
 
 	bank = d->ctrl->pin_banks;
 	for (i = 0; i < d->ctrl->nr_banks; ++i, ++bank) {

