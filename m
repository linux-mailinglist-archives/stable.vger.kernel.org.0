Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3568315C444
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgBMPpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:45:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729398AbgBMP11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:27 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DFBE2168B;
        Thu, 13 Feb 2020 15:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607647;
        bh=xtM+YC0fsXmRTgOGiXE3QIqZjxM4PwqTDLgPxouqRsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sI5SUgUK0KIkpc+zFJpDXygJUVJrMQB7TzrbxZ2jViK9WQ1JOzC4MSPeKN8260Bhi
         fUYLc5t98bcp0qMnc2qz2DRpJbmRT2CXNOu/2Iustj9PYpFs5uohN4X2XqeOdnqwwI
         s+gIcdla8CorPAUBPPjp+PxwAiiCeOZOC6P1pJZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 40/96] platform/x86: intel_mid_powerbtn: Take a copy of ddata
Date:   Thu, 13 Feb 2020 07:20:47 -0800
Message-Id: <20200213151854.799686466@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 5e0c94d3aeeecc68c573033f08d9678fecf253bd upstream.

The driver gets driver_data from memory that is marked as const (which
is probably put to read-only memory) and it then modifies it. This
likely causes some sort of fault to happen.

Fix this by taking a copy of the structure.

Fixes: c94a8ff14de3 ("platform/x86: intel_mid_powerbtn: make mid_pb_ddata const")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/intel_mid_powerbtn.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/intel_mid_powerbtn.c
+++ b/drivers/platform/x86/intel_mid_powerbtn.c
@@ -146,9 +146,10 @@ static int mid_pb_probe(struct platform_
 
 	input_set_capability(input, EV_KEY, KEY_POWER);
 
-	ddata = (struct mid_pb_ddata *)id->driver_data;
+	ddata = devm_kmemdup(&pdev->dev, (void *)id->driver_data,
+			     sizeof(*ddata), GFP_KERNEL);
 	if (!ddata)
-		return -ENODATA;
+		return -ENOMEM;
 
 	ddata->dev = &pdev->dev;
 	ddata->irq = irq;


