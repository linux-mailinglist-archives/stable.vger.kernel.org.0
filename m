Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C9B200CE0
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389342AbgFSOum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389339AbgFSOuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:50:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69EB220776;
        Fri, 19 Jun 2020 14:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578241;
        bh=qwUWf6gPEAo0RWe2h0rpmiMF6XJTd6r4hEWaMEbOJBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpgOee5ku93EZ5BuxSdRwxJvQQqU7na4JIAqu18/RUXRTl6svqZVTgImiAxwfT0Xd
         Xkiz412dTrgzDANEtBc4jUmg/qiKOIfXeR8cAHu3MkiRYYoBUvvMz1w+zpToX+zpf/
         y/hIXpF3t4XEw8Rj7D30Zpc4l7X/cdOgD/yf6o94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 138/190] platform/x86: hp-wmi: Convert simple_strtoul() to kstrtou32()
Date:   Fri, 19 Jun 2020 16:33:03 +0200
Message-Id: <20200619141640.523071297@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
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
index 06a3c1ef8eee..952544ca0d84 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -474,8 +474,14 @@ static ssize_t postcode_show(struct device *dev, struct device_attribute *attr,
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



