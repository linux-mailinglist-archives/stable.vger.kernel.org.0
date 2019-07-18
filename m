Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 152806C598
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390598AbfGRDIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390595AbfGRDIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:08:02 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D61D02053B;
        Thu, 18 Jul 2019 03:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419281;
        bh=v0pOiJG1mOvtjYpbErT3N6sGzx26BLv+XJTj6VVqERc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GiSpIIGY9q9fFlVoggV5IaitlU636xftM89VqImaUzvT5J/0pXFu609JZvVUnydRe
         Cbw8cBG5PiU7aeUZu5Ptj0fnqrCAGUSTSBlHIt6QPy01fPoW53C3p0J/bDQ3gek43y
         r8DyZw0AociDHqajRmQ0028O6E5br4FLp0sUSov0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Jinyoung Park <jinyoungp@nvidia.com>,
        Venkat Reddy Talla <vreddytalla@nvidia.com>,
        Mark Zhang <markz@nvidia.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 43/47] regmap-irq: do not write mask register if mask_base is zero
Date:   Thu, 18 Jul 2019 12:01:57 +0900
Message-Id: <20190718030052.402102574@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030045.780672747@linuxfoundation.org>
References: <20190718030045.780672747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@nvidia.com>

commit 7151449fe7fa5962c6153355f9779d6be99e8e97 upstream.

If client have not provided the mask base register then do not
write into the mask register.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Jinyoung Park <jinyoungp@nvidia.com>
Signed-off-by: Venkat Reddy Talla <vreddytalla@nvidia.com>
Signed-off-by: Mark Zhang <markz@nvidia.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regmap-irq.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -91,6 +91,9 @@ static void regmap_irq_sync_unlock(struc
 	 * suppress pointless writes.
 	 */
 	for (i = 0; i < d->chip->num_regs; i++) {
+		if (!d->chip->mask_base)
+			continue;
+
 		reg = d->chip->mask_base +
 			(i * map->reg_stride * d->irq_reg_stride);
 		if (d->chip->mask_invert) {
@@ -526,6 +529,9 @@ int regmap_add_irq_chip(struct regmap *m
 	/* Mask all the interrupts by default */
 	for (i = 0; i < chip->num_regs; i++) {
 		d->mask_buf[i] = d->mask_buf_def[i];
+		if (!chip->mask_base)
+			continue;
+
 		reg = chip->mask_base +
 			(i * map->reg_stride * d->irq_reg_stride);
 		if (chip->mask_invert)


