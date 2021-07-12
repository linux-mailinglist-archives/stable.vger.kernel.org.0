Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF6F3C4D47
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241915AbhGLHMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243943AbhGLHKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C15D261361;
        Mon, 12 Jul 2021 07:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073527;
        bh=rqr4Q5JyxKUXHRrZVbxg8KfSVyoWl63NLom30Shk1Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfGS3rsfNyOLfwuPF03TDX9P+ep7G+SK5ENWrQ4kzACHr/MFFQ/jp1TTvaFf0W9Dp
         uJiWcHn5JXl9FgDLgdG05ksVM4LmW2M8A5H1GQD0d0WGH9o5ws58wid5tY/L37VOnS
         gbYPbTAEx2oaMeYVDuUrcg9n4XeywdiZxvRttmI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Daniel Scally <djrscally@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 273/700] media: ipu3-cio2: Fix reference counting when looping over ACPI devices
Date:   Mon, 12 Jul 2021 08:05:56 +0200
Message-Id: <20210712061005.310254682@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 2cb2705cf7ffe41dc5bd81290e4241bfb7f031cc ]

When we continue, due to device is disabled, loop we have to drop
reference count. When we have an array full of devices we have to also
drop the reference count. Note, in this case the
cio2_bridge_unregister_sensors() is called by the caller.

Fixes: 803abec64ef9 ("media: ipu3-cio2: Add cio2-bridge to ipu3-cio2 driver")
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Daniel Scally <djrscally@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu3/cio2-bridge.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/cio2-bridge.c b/drivers/media/pci/intel/ipu3/cio2-bridge.c
index c2199042d3db..85f8b587405e 100644
--- a/drivers/media/pci/intel/ipu3/cio2-bridge.c
+++ b/drivers/media/pci/intel/ipu3/cio2-bridge.c
@@ -173,14 +173,15 @@ static int cio2_bridge_connect_sensor(const struct cio2_sensor_config *cfg,
 	int ret;
 
 	for_each_acpi_dev_match(adev, cfg->hid, NULL, -1) {
-		if (!adev->status.enabled)
+		if (!adev->status.enabled) {
+			acpi_dev_put(adev);
 			continue;
+		}
 
 		if (bridge->n_sensors >= CIO2_NUM_PORTS) {
+			acpi_dev_put(adev);
 			dev_err(&cio2->dev, "Exceeded available CIO2 ports\n");
-			cio2_bridge_unregister_sensors(bridge);
-			ret = -EINVAL;
-			goto err_out;
+			return -EINVAL;
 		}
 
 		sensor = &bridge->sensors[bridge->n_sensors];
@@ -228,7 +229,6 @@ err_free_swnodes:
 	software_node_unregister_nodes(sensor->swnodes);
 err_put_adev:
 	acpi_dev_put(sensor->adev);
-err_out:
 	return ret;
 }
 
-- 
2.30.2



