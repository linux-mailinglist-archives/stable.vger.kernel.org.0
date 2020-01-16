Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237CE13F68A
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388257AbgAPRCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:02:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388252AbgAPRCE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9FBC2467E;
        Thu, 16 Jan 2020 17:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194124;
        bh=K01wSvsQAwkygxhcrxNqXKveyTlHnvIRavqzWTKFLLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jl/Bw9+vL8elnCP4O5OG1mSDqjKqp1PLoC5sf9lt6PSPVSy6CyNMT9iQPKenM+l7C
         C4w012RWUDoJw66+d3/k1JM+9Ws1+5xVc0/PVoZ7xmYCIFq10rzuJfDTgzASC6/qje
         /jcGiXNyUPd3tKUxieHiEcg7Jmr2i79SNtHZGp2g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mattias Jacobsson <2pi@mok.nu>, Darren Hart <dvhart@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 216/671] platform/x86: wmi: fix potential null pointer dereference
Date:   Thu, 16 Jan 2020 11:52:05 -0500
Message-Id: <20200116165940.10720-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mattias Jacobsson <2pi@mok.nu>

[ Upstream commit c355ec651a8941864549f2586f969d0eb7bf499a ]

In the function wmi_dev_match() the variable id is dereferenced without
first performing a NULL check. The variable can for example be NULL if
a WMI driver is registered without specifying the id_table field in
struct wmi_driver.

Add a NULL check and return that the driver can't handle the device if
the variable is NULL.

Fixes: 844af950da94 ("platform/x86: wmi: Turn WMI into a bus driver")
Signed-off-by: Mattias Jacobsson <2pi@mok.nu>
Signed-off-by: Darren Hart (VMware) <dvhart@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 04791ea5d97b..35cdc3998eb5 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -768,6 +768,9 @@ static int wmi_dev_match(struct device *dev, struct device_driver *driver)
 	struct wmi_block *wblock = dev_to_wblock(dev);
 	const struct wmi_device_id *id = wmi_driver->id_table;
 
+	if (id == NULL)
+		return 0;
+
 	while (id->guid_string) {
 		uuid_le driver_guid;
 
-- 
2.20.1

