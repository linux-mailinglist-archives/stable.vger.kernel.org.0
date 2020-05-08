Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563651CACCD
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbgEHM4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbgEHM4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:56:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A28224958;
        Fri,  8 May 2020 12:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942565;
        bh=W3z8GpEqUg7Gwz4mNu6eXk9h4W8cmjS7GxG53neu7o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNbR7qkZ6UWA8jIe+N7N9yS9d2FSpHOLDUz475KBLLToX69hSjqcG8+P/7iLpPQQa
         8iYB8Ce4y0jtB0SHLccSjHl/cdIck24gx7ifHUYynEwJW1k5ws5rE7rC6yxZHkOT0I
         LhOtdZEeDbwZ6sFgSTqFLab9BOcJgmAR8I5N1v64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.6 45/49] platform/x86: GPD pocket fan: Fix error message when temp-limits are out of range
Date:   Fri,  8 May 2020 14:36:02 +0200
Message-Id: <20200508123049.121731315@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 1d6f8c5bac93cceb2d4ac8e6331050652004d802 upstream.

Commit 1f27dbd8265d ("platform/x86: GPD pocket fan: Allow somewhat
lower/higher temperature limits") changed the module-param sanity check
to accept temperature limits between 20 and 90 degrees celcius.

But the error message printed when the module params are outside this
range was not updated. This commit updates the error message to match
the new min and max value for the temp-limits.

Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/gpd-pocket-fan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/gpd-pocket-fan.c
+++ b/drivers/platform/x86/gpd-pocket-fan.c
@@ -128,7 +128,7 @@ static int gpd_pocket_fan_probe(struct p
 
 	for (i = 0; i < ARRAY_SIZE(temp_limits); i++) {
 		if (temp_limits[i] < 20000 || temp_limits[i] > 90000) {
-			dev_err(&pdev->dev, "Invalid temp-limit %d (must be between 40000 and 70000)\n",
+			dev_err(&pdev->dev, "Invalid temp-limit %d (must be between 20000 and 90000)\n",
 				temp_limits[i]);
 			temp_limits[0] = TEMP_LIMIT0_DEFAULT;
 			temp_limits[1] = TEMP_LIMIT1_DEFAULT;


