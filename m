Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8556AF487
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbjCGTRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbjCGTQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4B8BAEDC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4976B6150D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4241BC433EF;
        Tue,  7 Mar 2023 19:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215623;
        bh=9oPHTgj6iOYvFCFGNAMKtSh+kwdPOP3VzwsTBjD1YN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XijGLF4Gb9eUxc9rX8SiuIrQhg4pLgt5UU+bYOtXDAvSY2SKwt298nc99A8b7S7c3
         1NksDdFy2UACjqy7dpvKWFgdt6DjAXit/iKE2N+YadX+d3nl+FuJI5bp8BayffOInC
         YsjANzhjGw99HRwQgZHpMlEgDCa+0YMJFEaiKpD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 294/567] usb: typec: intel_pmc_mux: Use the helper acpi_dev_get_memory_resources()
Date:   Tue,  7 Mar 2023 18:00:30 +0100
Message-Id: <20230307165918.621864674@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 1538dc8c1561f0de4ba57a69e2a421a1a3951618 ]

It removes the need to check the resource data type
separately.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: c3194949ae8f ("usb: typec: intel_pmc_mux: Don't leak the ACPI device reference count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index a2f5cfdcf02ac..8af60f0720435 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -563,15 +563,6 @@ static int pmc_usb_register_port(struct pmc_usb *pmc, int index,
 	return ret;
 }
 
-static int is_memory(struct acpi_resource *res, void *data)
-{
-	struct resource_win win = {};
-	struct resource *r = &win.res;
-
-	return !(acpi_dev_resource_memory(res, r) ||
-		 acpi_dev_resource_address_space(res, &win));
-}
-
 /* IOM ACPI IDs and IOM_PORT_STATUS_OFFSET */
 static const struct acpi_device_id iom_acpi_ids[] = {
 	/* TigerLake */
@@ -605,7 +596,7 @@ static int pmc_usb_probe_iom(struct pmc_usb *pmc)
 		return -ENODEV;
 
 	INIT_LIST_HEAD(&resource_list);
-	ret = acpi_dev_get_resources(adev, &resource_list, is_memory, NULL);
+	ret = acpi_dev_get_memory_resources(adev, &resource_list);
 	if (ret < 0)
 		return ret;
 
-- 
2.39.2



