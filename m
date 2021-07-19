Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E4A3CE156
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349114AbhGSPZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346608AbhGSPRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:17:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F98C613F1;
        Mon, 19 Jul 2021 15:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710257;
        bh=Kr5HoqsE5MPFdwwLrEQmw5vIHfZj7/DGPLKFuD6t3uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBoDx9Tz12ha9BWRYfEC/IdAdQcepcuUwrbU3rA3nLWsIRygT0l7L0IZaBNja9aZG
         v+eClcNjRHT0HmcQW7MfUwNkDv7PT4LNLxPVnUhvTpSko6KY0YFovwBdWgjhnE+Ggd
         UWF8/sHtzse9lgSYI6zH8S+nNR0WIWtD1hXT6w6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Liguang Zhang <zhangliguang@linux.alibaba.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/243] ACPI: AMBA: Fix resource name in /proc/iomem
Date:   Mon, 19 Jul 2021 16:52:49 +0200
Message-Id: <20210719144945.437342514@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liguang Zhang <zhangliguang@linux.alibaba.com>

[ Upstream commit 7718629432676b5ebd9a32940782fe297a0abf8d ]

In function amba_handler_attach(), dev->res.name is initialized by
amba_device_alloc. But when address_found is false, dev->res.name is
assigned to null value, which leads to wrong resource name display in
/proc/iomem, "<BAD>" is seen for those resources.

Signed-off-by: Liguang Zhang <zhangliguang@linux.alibaba.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_amba.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpi_amba.c b/drivers/acpi/acpi_amba.c
index 49b781a9cd97..ab8a4e0191b1 100644
--- a/drivers/acpi/acpi_amba.c
+++ b/drivers/acpi/acpi_amba.c
@@ -76,6 +76,7 @@ static int amba_handler_attach(struct acpi_device *adev,
 		case IORESOURCE_MEM:
 			if (!address_found) {
 				dev->res = *rentry->res;
+				dev->res.name = dev_name(&dev->dev);
 				address_found = true;
 			}
 			break;
-- 
2.30.2



