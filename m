Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE04DE5CE3
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfJZNRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727563AbfJZNRz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:17:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8382A214DA;
        Sat, 26 Oct 2019 13:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095874;
        bh=7S5rOoF8/lGt10heURodpPUnIlrI6Ut+qHhem2+PfUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKb8zwjayST2V+g/Gy5Q5ldMnUETd+3MEDdzANiPb6JFYZPbLiHcE7zSVyclfKIjq
         i+3fP9hDUz455EHCjuVHBpVdr25hmlr5af+4Kqe9CSX6rL+/JyV9564FtflQbS6BQe
         Q0LQIhn1CJugQHcnxHycbS3k9itG7AZ0nUSfL+ns=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ammy Yi <ammy.yi@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 63/99] platform/x86: i2c-multi-instantiate: Fail the probe if no IRQ provided
Date:   Sat, 26 Oct 2019 09:15:24 -0400
Message-Id: <20191026131600.2507-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 832392db9747b9c95724d37fc6a5dadd3d4ec514 ]

For APIC case of interrupt we don't fail a ->probe() of the driver,
which makes kernel to print a lot of warnings from the children.

We have two options here:
- switch to platform_get_irq_optional(), though it won't stop children
  to be probed and failed
- fail the ->probe() of i2c-multi-instantiate

Since the in reality we never had devices in the wild where IRQ resource
is optional, the latter solution suits the best.

Fixes: 799d3379a672 ("platform/x86: i2c-multi-instantiate: Introduce IOAPIC IRQ support")
Reported-by: Ammy Yi <ammy.yi@intel.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/i2c-multi-instantiate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/i2c-multi-instantiate.c b/drivers/platform/x86/i2c-multi-instantiate.c
index 70efa3d298253..b66e5aa6bf588 100644
--- a/drivers/platform/x86/i2c-multi-instantiate.c
+++ b/drivers/platform/x86/i2c-multi-instantiate.c
@@ -110,6 +110,7 @@ static int i2c_multi_inst_probe(struct platform_device *pdev)
 			if (ret < 0) {
 				dev_dbg(dev, "Error requesting irq at index %d: %d\n",
 					inst_data[i].irq_idx, ret);
+				goto error;
 			}
 			board_info.irq = ret;
 			break;
-- 
2.20.1

