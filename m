Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC7FF4B25
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731981AbfKHLiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:38:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732106AbfKHLiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D11721D7E;
        Fri,  8 Nov 2019 11:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213080;
        bh=nL257+5kU0ZhATbuvvRos00sxXWABvhtjW0o5lB36dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQeEzUOg2hjpVmYJIe0L7xn5enHs8f/BvXj+FV0sNENbEY1rFK+QbpxDsMXBu0gbW
         SJg/a4tG1ENK1shWjj56RGaRulIRKlVLxMmQou2iDYsk+wDTaHd2PftzQQo17aT2WG
         jDFobEfyIlpfsptRwqV9zaAxSularrAkJqSZ2sG4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 007/205] soundwire: intel: Fix uninitialized adev deref
Date:   Fri,  8 Nov 2019 06:34:34 -0500
Message-Id: <20191108113752.12502-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

