Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B283101358
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbfKSFYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:24:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728254AbfKSFYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:24:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FC9C21783;
        Tue, 19 Nov 2019 05:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141086;
        bh=nL257+5kU0ZhATbuvvRos00sxXWABvhtjW0o5lB36dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMKSqgfh2ZOf0emicRaB4DK2+hnNoTYzHYoN90wSZqy8hw0YQMHP8Lw6xMD8Ydccn
         qryn5I98IGYwukZKsK+aW4YXrA9YRuJgpjJ4IpEEW7QD0HZQkKWJ85RbUvyy3nVVGh
         jeqpuMgkFo7kDRRgncG0LEZLkhc4a1KejPaAVvmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/422] soundwire: intel: Fix uninitialized adev deref
Date:   Tue, 19 Nov 2019 06:13:56 +0100
Message-Id: <20191119051402.493920522@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit e1c815f4b24a305e5bc9eceb541674bf4d02b709 ]

In case of error, we can dereference uninitialized 'adev'

drivers/soundwire/intel_init.c:154 sdw_intel_acpi_cb()
error: uninitialized symbol 'adev'.

Fix that by not using adev for warn print and make it pr_err.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/intel_init.c b/drivers/soundwire/intel_init.c
index d1ea6b4d0ad30..5c8a20d998786 100644
--- a/drivers/soundwire/intel_init.c
+++ b/drivers/soundwire/intel_init.c
@@ -151,7 +151,7 @@ static acpi_status sdw_intel_acpi_cb(acpi_handle handle, u32 level,
 	struct acpi_device *adev;
 
 	if (acpi_bus_get_device(handle, &adev)) {
-		dev_err(&adev->dev, "Couldn't find ACPI handle\n");
+		pr_err("%s: Couldn't find ACPI handle\n", __func__);
 		return AE_NOT_FOUND;
 	}
 
-- 
2.20.1



