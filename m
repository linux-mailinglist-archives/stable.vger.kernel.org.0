Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAD014BB12
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgA1OLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:11:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728847AbgA1OLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:11:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F5F120678;
        Tue, 28 Jan 2020 14:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220694;
        bh=HHLxh9P3K2FMKxdhD3Kdtx6EDWE6eLoWsvssFaiUe3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DjooNHpTSEFhPfXd+LB8HL68RURZSTmCUwutcOx9Apf7cBPNR0IZL82o/YOb22DCF
         bTk48Fe4B5UcrpCn17Wj9C3qoGT7zoTfJv5VXDotBZ2TNFAzFxvQOmZdT8f0SIUBes
         KoCPMcc/J+AR3vFhW0Bh+QEwwsETokTnHdRcJr6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 108/183] mfd: intel-lpss: Release IDA resources
Date:   Tue, 28 Jan 2020 15:05:27 +0100
Message-Id: <20200128135840.719577124@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 02f36911c1b41fcd8779fa0c135aab0554333fa5 ]

ida instances allocate some internal memory for ->free_bitmap
in addition to the base 'struct ida'. Use ida_destroy() to release
that memory at module_exit().

Fixes: 4b45efe85263 ("mfd: Add support for Intel Sunrisepoint LPSS devices")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel-lpss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/intel-lpss.c b/drivers/mfd/intel-lpss.c
index 4988751933867..adbb23b6595f6 100644
--- a/drivers/mfd/intel-lpss.c
+++ b/drivers/mfd/intel-lpss.c
@@ -525,6 +525,7 @@ module_init(intel_lpss_init);
 
 static void __exit intel_lpss_exit(void)
 {
+	ida_destroy(&intel_lpss_devid_ida);
 	debugfs_remove(intel_lpss_debugfs);
 }
 module_exit(intel_lpss_exit);
-- 
2.20.1



