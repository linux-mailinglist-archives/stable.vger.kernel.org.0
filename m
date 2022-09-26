Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7160D5EA195
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiIZKwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbiIZKuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:50:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB98D59247;
        Mon, 26 Sep 2022 03:27:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A535B80925;
        Mon, 26 Sep 2022 10:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E64C43140;
        Mon, 26 Sep 2022 10:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188047;
        bh=jgs2rmYeQfS+qB9Xe0Qgv74qghQsrxHN7MKy+rPReOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pxYVYi9Uvrv6YbpGOYZDnfWx0TP/nzRBmlGSS+xTiDO+Re3BPdXs+7wyQVOZss3Ag
         adYV80LYkkxVZJK6HhC64gsn2WRPo7GlRRse3BotJV0jz3ucJDgYp0/AeZWtf/3Evb
         jEKBSbCuXIqsjdscMTwoxT8iHZxPiJS4GpiU4u6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Utkarsh Patel <utkarsh.h.patel@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/141] usb: typec: intel_pmc_mux: Add new ACPI ID for Meteor Lake IOM device
Date:   Mon, 26 Sep 2022 12:10:32 +0200
Message-Id: <20220926100754.854707566@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Utkarsh Patel <utkarsh.h.patel@intel.com>

[ Upstream commit 1b1b672cc1d4fb3065dac79efb8901bd6244ef69 ]

This adds the necessary ACPI ID for Intel Meteor Lake
IOM devices.

The callback function is_memory() is modified so that it
also checks if the resource descriptor passed to it is a
memory type "Address Space Resource Descriptor".

On Intel Meteor Lake the ACPI memory resource is not
described using the "32-bit Memory Range Descriptor" because
the memory is outside of the 32-bit address space. The
memory resource is described using the "Address Space
Resource Descriptor" instead.

Intel Meteor Lake is the first platform to describe the
memory resource for this device with Address Space Resource
Descriptor, but it most likely will not be the last.
Therefore the change to the is_memory() callback function
is made generic.

Signed-off-by: Utkarsh Patel <utkarsh.h.patel@intel.com>
Cc: stable@vger.kernel.org
[ heikki: Rewrote the commit message. ]
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20220816101629.69054-2-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index ea1333ad4b2b..80daa70e288b 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -541,9 +541,11 @@ static int pmc_usb_register_port(struct pmc_usb *pmc, int index,
 
 static int is_memory(struct acpi_resource *res, void *data)
 {
-	struct resource r;
+	struct resource_win win = {};
+	struct resource *r = &win.res;
 
-	return !acpi_dev_resource_memory(res, &r);
+	return !(acpi_dev_resource_memory(res, r) ||
+		 acpi_dev_resource_address_space(res, &win));
 }
 
 /* IOM ACPI IDs and IOM_PORT_STATUS_OFFSET */
@@ -553,6 +555,9 @@ static const struct acpi_device_id iom_acpi_ids[] = {
 
 	/* AlderLake */
 	{ "INTC1079", 0x160, },
+
+	/* Meteor Lake */
+	{ "INTC107A", 0x160, },
 	{}
 };
 
-- 
2.35.1



