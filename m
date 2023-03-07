Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B18A6AEF95
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbjCGSYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbjCGSYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:24:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1953B0D6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:19:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16CD8614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A449C433EF;
        Tue,  7 Mar 2023 18:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213174;
        bh=ca7r7Q6TweyqtG6p5YrzFMRKcVtOMxtEpUlJCYdV5uE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGujrlClXmPrNk1AwOliQww5nXHLz2K4oL2bYOumaTgs0QGKV0V9ISIFXlCt4c38+
         J8Fxx/22f8zYL0FlgEpqKYpAz6x57eyCSaHIfVFmKw3fKxfhBZmSHMqY/7wk70f1NI
         1+aGm54i74yOAPaY2OVj+V2QE6PCtlMud0wV39h4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 423/885] usb: typec: intel_pmc_mux: Dont leak the ACPI device reference count
Date:   Tue,  7 Mar 2023 17:55:57 +0100
Message-Id: <20230307170020.793812697@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit c3194949ae8fcbe2b7e38670e7c6a5cfd2605edc ]

When acpi_dev_get_memory_resources() fails, the reference count is
left bumped. Drop it as it's done in the other error paths.

Fixes: 43d596e32276 ("usb: typec: intel_pmc_mux: Check the port status before connect")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230102202933.15968-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index fdbf3694e21f4..87e2c91306070 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -614,8 +614,10 @@ static int pmc_usb_probe_iom(struct pmc_usb *pmc)
 
 	INIT_LIST_HEAD(&resource_list);
 	ret = acpi_dev_get_memory_resources(adev, &resource_list);
-	if (ret < 0)
+	if (ret < 0) {
+		acpi_dev_put(adev);
 		return ret;
+	}
 
 	rentry = list_first_entry_or_null(&resource_list, struct resource_entry, node);
 	if (rentry)
-- 
2.39.2



