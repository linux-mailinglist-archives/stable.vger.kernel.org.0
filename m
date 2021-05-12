Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A868537CB17
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241556AbhELQec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241460AbhELQ1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AADED619D5;
        Wed, 12 May 2021 15:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834768;
        bh=lbLlXqX3YtybH6qd0q3igLZ5+TgrbRNgyvscB2m4y2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xf8PDKpOc1c0HROrjjCPWlFP5uZ29PTJ1LyHPu8nUFq4gEjYsuHFOjPZL1GtCn3as
         bwCfV0CXLlRDm+dfg7iSMXTfeAG0AHAD/eFeCgrUZkYI016msqfPG4oQMSgKfDg4md
         +s5b1lLgq4ri4Eem64/yJuZHT9dOkQsiXDQNIezE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.12 041/677] iio: sx9310: Fix write_.._debounce()
Date:   Wed, 12 May 2021 16:41:27 +0200
Message-Id: <20210512144838.574443686@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gwendal Grignou <gwendal@chromium.org>

commit fc948409ccc1e8afe8655cee77c686eedbfbee60 upstream.

Check input to be sure it matches Semtech sx9310 specification and
can fit into debounce register.
Compare argument writen to thresh_.._period with read from same
sysfs attribute:

Before:                   Afer:
write   |  read           write   |  read
-1      |     8           -1 fails: -EINVAL
0       |     8           0       |     0
1       |     0           1       |     0
2..15   |  2^log2(N)      2..15   |  2^log2(N)
16      |     0           >= 16 fails: -EINVAL

Fixes: 1b6872015f0b ("iio: sx9310: Support setting debounce values")
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Cc: stable@vger.kernel.org
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210331182222.219533-1-gwendal@chromium.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/sx9310.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/iio/proximity/sx9310.c
+++ b/drivers/iio/proximity/sx9310.c
@@ -763,7 +763,11 @@ static int sx9310_write_far_debounce(str
 	int ret;
 	unsigned int regval;
 
-	val = ilog2(val);
+	if (val > 0)
+		val = ilog2(val);
+	if (!FIELD_FIT(SX9310_REG_PROX_CTRL10_FAR_DEBOUNCE_MASK, val))
+		return -EINVAL;
+
 	regval = FIELD_PREP(SX9310_REG_PROX_CTRL10_FAR_DEBOUNCE_MASK, val);
 
 	mutex_lock(&data->mutex);
@@ -780,7 +784,11 @@ static int sx9310_write_close_debounce(s
 	int ret;
 	unsigned int regval;
 
-	val = ilog2(val);
+	if (val > 0)
+		val = ilog2(val);
+	if (!FIELD_FIT(SX9310_REG_PROX_CTRL10_CLOSE_DEBOUNCE_MASK, val))
+		return -EINVAL;
+
 	regval = FIELD_PREP(SX9310_REG_PROX_CTRL10_CLOSE_DEBOUNCE_MASK, val);
 
 	mutex_lock(&data->mutex);


