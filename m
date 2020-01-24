Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142E5147C5E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388028AbgAXJvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:51:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730738AbgAXJvY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:51:24 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA85820709;
        Fri, 24 Jan 2020 09:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859484;
        bh=wnjRklRT9QO3ID0lhAhN+Slr5Q2opEtUMhO4dCwSItY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWPgySCZ5TSWidFVwn5r1OTFfkIpDGSRP6SjtAeDhEP9//Zz3+WdsEi/vnUmforez
         +8EW0kPyXAJfYqNr6Wm+65C/yN0Ns9c1/wWo6ynkrDBJ2mtbJRKuDf4842CdgN/Mf7
         AAwJWSiOrgsewI151yRtImYJ4pgFjfe5wETNkRc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mattias Jacobsson <2pi@mok.nu>,
        "Darren Hart (VMware)" <dvhart@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 127/343] platform/x86: wmi: fix potential null pointer dereference
Date:   Fri, 24 Jan 2020 10:29:05 +0100
Message-Id: <20200124092936.684051170@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7f8fa42a10840..a56e997816b23 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -748,6 +748,9 @@ static int wmi_dev_match(struct device *dev, struct device_driver *driver)
 	struct wmi_block *wblock = dev_to_wblock(dev);
 	const struct wmi_device_id *id = wmi_driver->id_table;
 
+	if (id == NULL)
+		return 0;
+
 	while (id->guid_string) {
 		uuid_le driver_guid;
 
-- 
2.20.1



