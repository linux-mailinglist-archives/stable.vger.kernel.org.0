Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC0F2A58B2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgKCUpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:45:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731019AbgKCUpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:45:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 413A722460;
        Tue,  3 Nov 2020 20:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436323;
        bh=hM4gr2k3fC+wGX4IlDAdOzXCFt31S22c7P6uWTdjAS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6cAjESQTW6wLHn0DtAHJr6mOmm3ugjkbu8Dw3xWf5NXQTVrVs9I1cC0bCLNu/iFS
         4pN9q9ANm7YnIc1O0q9lH9odyRAgyMAvcwcr4vbHX02hAUKK0dByBEPMQMXpW90x3N
         J/QBrTF5Oa7FtdcGCqCrxXoUvOfc0prCyGxJumcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Foreman <foremans@google.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.9 200/391] hwmon: (pmbus/max34440) Fix OC fault limits
Date:   Tue,  3 Nov 2020 21:34:11 +0100
Message-Id: <20201103203400.390269088@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Foreman <foremans@google.com>

commit 2b52278150c49559a472f2d6dd66f6f3b405378e upstream.

The max34* family have the IOUT_OC_WARN_LIMIT and IOUT_OC_CRIT_LIMIT
registers swapped.

Cc: stable@vger.kernel.org
Signed-off-by: Steve Foreman <foremans@google.com>
[groeck: Updated subject, use C comment style, tab after defines]
[groeck: Added missing break; statements (by alexandru.ardelean@analog.com)]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/pmbus/max34440.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/hwmon/pmbus/max34440.c
+++ b/drivers/hwmon/pmbus/max34440.c
@@ -31,6 +31,13 @@ enum chips { max34440, max34441, max3444
 #define MAX34440_STATUS_OT_FAULT	BIT(5)
 #define MAX34440_STATUS_OT_WARN		BIT(6)
 
+/*
+ * The whole max344* family have IOUT_OC_WARN_LIMIT and IOUT_OC_FAULT_LIMIT
+ * swapped from the standard pmbus spec addresses.
+ */
+#define MAX34440_IOUT_OC_WARN_LIMIT	0x46
+#define MAX34440_IOUT_OC_FAULT_LIMIT	0x4A
+
 #define MAX34451_MFR_CHANNEL_CONFIG	0xe4
 #define MAX34451_MFR_CHANNEL_CONFIG_SEL_MASK	0x3f
 
@@ -49,6 +56,14 @@ static int max34440_read_word_data(struc
 	const struct max34440_data *data = to_max34440_data(info);
 
 	switch (reg) {
+	case PMBUS_IOUT_OC_FAULT_LIMIT:
+		ret = pmbus_read_word_data(client, page, phase,
+					   MAX34440_IOUT_OC_FAULT_LIMIT);
+		break;
+	case PMBUS_IOUT_OC_WARN_LIMIT:
+		ret = pmbus_read_word_data(client, page, phase,
+					   MAX34440_IOUT_OC_WARN_LIMIT);
+		break;
 	case PMBUS_VIRT_READ_VOUT_MIN:
 		ret = pmbus_read_word_data(client, page, phase,
 					   MAX34440_MFR_VOUT_MIN);
@@ -115,6 +130,14 @@ static int max34440_write_word_data(stru
 	int ret;
 
 	switch (reg) {
+	case PMBUS_IOUT_OC_FAULT_LIMIT:
+		ret = pmbus_write_word_data(client, page, MAX34440_IOUT_OC_FAULT_LIMIT,
+					    word);
+		break;
+	case PMBUS_IOUT_OC_WARN_LIMIT:
+		ret = pmbus_write_word_data(client, page, MAX34440_IOUT_OC_WARN_LIMIT,
+					    word);
+		break;
 	case PMBUS_VIRT_RESET_POUT_HISTORY:
 		ret = pmbus_write_word_data(client, page,
 					    MAX34446_MFR_POUT_PEAK, 0);


