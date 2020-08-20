Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C52624B302
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgHTJkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729025AbgHTJkX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:40:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C3572075E;
        Thu, 20 Aug 2020 09:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916423;
        bh=qIeXM+NKCoFlMSstjLORdhuyqn+uoFkSc/8KPoObLQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrGy5rCZWtPM3zQj0nzFIocV5C8Oox4coEzF+9VUGDwo23YUYCAxwgsdkHjxJOqbn
         kEm1G6r3tfoaH5ZtuChnbeYHk9jh3H6w+gmkF8j+cWiG99HSWhuRq50m3eZdklMXry
         F6NE6Hh+LkRR0GNJwAaCNb4HlXrioxy7t9gzdLY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 121/204] devres: keep both device name and resource name in pretty name
Date:   Thu, 20 Aug 2020 11:20:18 +0200
Message-Id: <20200820091612.339749742@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 35bd8c07db2ce8fd2834ef866240613a4ef982e7 ]

Sometimes debugging a device is easiest using devmem on its register
map, and that can be seen with /proc/iomem. But some device drivers have
many memory regions. Take for example a networking switch. Its memory
map used to look like this in /proc/iomem:

1fc000000-1fc3fffff : pcie@1f0000000
  1fc000000-1fc3fffff : 0000:00:00.5
    1fc010000-1fc01ffff : sys
    1fc030000-1fc03ffff : rew
    1fc060000-1fc0603ff : s2
    1fc070000-1fc0701ff : devcpu_gcb
    1fc080000-1fc0800ff : qs
    1fc090000-1fc0900cb : ptp
    1fc100000-1fc10ffff : port0
    1fc110000-1fc11ffff : port1
    1fc120000-1fc12ffff : port2
    1fc130000-1fc13ffff : port3
    1fc140000-1fc14ffff : port4
    1fc150000-1fc15ffff : port5
    1fc200000-1fc21ffff : qsys
    1fc280000-1fc28ffff : ana

But after the patch in Fixes: was applied, the information is now
presented in a much more opaque way:

1fc000000-1fc3fffff : pcie@1f0000000
  1fc000000-1fc3fffff : 0000:00:00.5
    1fc010000-1fc01ffff : 0000:00:00.5
    1fc030000-1fc03ffff : 0000:00:00.5
    1fc060000-1fc0603ff : 0000:00:00.5
    1fc070000-1fc0701ff : 0000:00:00.5
    1fc080000-1fc0800ff : 0000:00:00.5
    1fc090000-1fc0900cb : 0000:00:00.5
    1fc100000-1fc10ffff : 0000:00:00.5
    1fc110000-1fc11ffff : 0000:00:00.5
    1fc120000-1fc12ffff : 0000:00:00.5
    1fc130000-1fc13ffff : 0000:00:00.5
    1fc140000-1fc14ffff : 0000:00:00.5
    1fc150000-1fc15ffff : 0000:00:00.5
    1fc200000-1fc21ffff : 0000:00:00.5
    1fc280000-1fc28ffff : 0000:00:00.5

That patch made a fair comment that /proc/iomem might be confusing when
it shows resources without an associated device, but we can do better
than just hide the resource name altogether. Namely, we can print the
device name _and_ the resource name. Like this:

1fc000000-1fc3fffff : pcie@1f0000000
  1fc000000-1fc3fffff : 0000:00:00.5
    1fc010000-1fc01ffff : 0000:00:00.5 sys
    1fc030000-1fc03ffff : 0000:00:00.5 rew
    1fc060000-1fc0603ff : 0000:00:00.5 s2
    1fc070000-1fc0701ff : 0000:00:00.5 devcpu_gcb
    1fc080000-1fc0800ff : 0000:00:00.5 qs
    1fc090000-1fc0900cb : 0000:00:00.5 ptp
    1fc100000-1fc10ffff : 0000:00:00.5 port0
    1fc110000-1fc11ffff : 0000:00:00.5 port1
    1fc120000-1fc12ffff : 0000:00:00.5 port2
    1fc130000-1fc13ffff : 0000:00:00.5 port3
    1fc140000-1fc14ffff : 0000:00:00.5 port4
    1fc150000-1fc15ffff : 0000:00:00.5 port5
    1fc200000-1fc21ffff : 0000:00:00.5 qsys
    1fc280000-1fc28ffff : 0000:00:00.5 ana

Fixes: 8d84b18f5678 ("devres: always use dev_name() in devm_ioremap_resource()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20200601095826.1757621-1-olteanv@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/devres.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/lib/devres.c b/lib/devres.c
index 6ef51f159c54b..ca0d28727ccef 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -119,6 +119,7 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
 {
 	resource_size_t size;
 	void __iomem *dest_ptr;
+	char *pretty_name;
 
 	BUG_ON(!dev);
 
@@ -129,7 +130,15 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
 
 	size = resource_size(res);
 
-	if (!devm_request_mem_region(dev, res->start, size, dev_name(dev))) {
+	if (res->name)
+		pretty_name = devm_kasprintf(dev, GFP_KERNEL, "%s %s",
+					     dev_name(dev), res->name);
+	else
+		pretty_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
+	if (!pretty_name)
+		return IOMEM_ERR_PTR(-ENOMEM);
+
+	if (!devm_request_mem_region(dev, res->start, size, pretty_name)) {
 		dev_err(dev, "can't request region for resource %pR\n", res);
 		return IOMEM_ERR_PTR(-EBUSY);
 	}
-- 
2.25.1



