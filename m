Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B424E499674
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445543AbiAXVEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:04:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52116 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443746AbiAXU65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:58:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27A2A61414;
        Mon, 24 Jan 2022 20:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1729C340E5;
        Mon, 24 Jan 2022 20:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057935;
        bh=eJP1hCWniN1ltL1kT6b/7fbt3ENomNOTOg9u1vjqjEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUs4qm5YOcvTsDQ6WdRO33cxZ82WIptEMt3LQ0/MLKj/GJOFlE29XZOXw38s27P7A
         RlqE+hasyKXcEK5Hjfc1vjxzHHcU3L2Sw/szAOErvh0qYddZfoCr4FynrAb35JI0f2
         jU8atx7dfde6E1MDoyFbecnKBwgp2JInFqwEIP0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Scally <djrscally@gmail.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0120/1039] media: ipu3-cio2: fix error code in cio2_bridge_connect_sensor()
Date:   Mon, 24 Jan 2022 19:31:49 +0100
Message-Id: <20220124184129.172023559@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 85db29d22cc521d9d06de2f5c7832981a55df157 ]

Return -ENODEV if acpi_get_physical_device_location() fails.  Don't
return success.

Fixes: 485aa3df0dff ("media: ipu3-cio2: Parse sensor orientation and rotation")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Daniel Scally <djrscally@gmail.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu3/cio2-bridge.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/intel/ipu3/cio2-bridge.c b/drivers/media/pci/intel/ipu3/cio2-bridge.c
index 67c467d3c81f9..0b586b4e537ef 100644
--- a/drivers/media/pci/intel/ipu3/cio2-bridge.c
+++ b/drivers/media/pci/intel/ipu3/cio2-bridge.c
@@ -238,8 +238,10 @@ static int cio2_bridge_connect_sensor(const struct cio2_sensor_config *cfg,
 			goto err_put_adev;
 
 		status = acpi_get_physical_device_location(adev->handle, &sensor->pld);
-		if (ACPI_FAILURE(status))
+		if (ACPI_FAILURE(status)) {
+			ret = -ENODEV;
 			goto err_put_adev;
+		}
 
 		if (sensor->ssdb.lanes > CIO2_MAX_LANES) {
 			dev_err(&adev->dev,
-- 
2.34.1



