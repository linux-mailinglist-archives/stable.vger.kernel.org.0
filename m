Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925F42011D2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403898AbgFSPps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393526AbgFSP1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:27:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A3F2217D8;
        Fri, 19 Jun 2020 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580424;
        bh=0ipDXHuXsr5Qaoa9TOtSQq6ymopP/5G4FnF3eZVMeJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQHA268bOl2kMEOsnQCJeBmWX0sFsng58RztAhu1pFkr/1tdfy9+qewyWBZVPY3zt
         kVS9hDuKPiXzY1Cm+sIVx8fPeSy9dax6I9k9SCIhfVtWT2Tb/Nhsjx8m1v8FBGQMZu
         8CWNASmT6kz97qAz3mehqN4GyxImeGROx/G/hTlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 242/376] platform/x86: hp-wmi: Convert simple_strtoul() to kstrtou32()
Date:   Fri, 19 Jun 2020 16:32:40 +0200
Message-Id: <20200619141721.786058666@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5cdc45ed3948042f0d73c6fec5ee9b59e637d0d2 ]

First of all, unsigned long can overflow u32 value on 64-bit machine.
Second, simple_strtoul() doesn't check for overflow in the input.

Convert simple_strtoul() to kstrtou32() to eliminate above issues.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index a881b709af25..a44a2ec33287 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -461,8 +461,14 @@ static ssize_t postcode_show(struct device *dev, struct device_attribute *attr,
 static ssize_t als_store(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
-	u32 tmp = simple_strtoul(buf, NULL, 10);
-	int ret = hp_wmi_perform_query(HPWMI_ALS_QUERY, HPWMI_WRITE, &tmp,
+	u32 tmp;
+	int ret;
+
+	ret = kstrtou32(buf, 10, &tmp);
+	if (ret)
+		return ret;
+
+	ret = hp_wmi_perform_query(HPWMI_ALS_QUERY, HPWMI_WRITE, &tmp,
 				       sizeof(tmp), sizeof(tmp));
 	if (ret)
 		return ret < 0 ? ret : -EINVAL;
-- 
2.25.1



