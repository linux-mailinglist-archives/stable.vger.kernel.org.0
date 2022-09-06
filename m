Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3425AED3B
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242007AbiIFO1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbiIFO0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:26:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B457C52A;
        Tue,  6 Sep 2022 06:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A908A61542;
        Tue,  6 Sep 2022 13:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B3AC433C1;
        Tue,  6 Sep 2022 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472025;
        bh=OGYL5m/s4earafWbUNY1pAZATl3Yplrok4xWWgfBfyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPs6mi0UVgKHbMtSYTcvX9l+gTycuN2TVMf7XFN4orcidapUTUXzOK0t97jezDS5w
         h2dxa+/FqQ/Ni19l4GuNfzLDjDGnZLn/tiRD15Wh7oA2IjUHsPxwkGLUIcOFLVf9sK
         YzWPxNOdYW65AxmamztaTC7vNJ5OJQtxbQ5KXkpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Utkarsh Patel <utkarsh.h.patel@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.19 121/155] usb: typec: intel_pmc_mux: Add new ACPI ID for Meteor Lake IOM device
Date:   Tue,  6 Sep 2022 15:31:09 +0200
Message-Id: <20220906132834.562680568@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Utkarsh Patel <utkarsh.h.patel@intel.com>

commit 1b1b672cc1d4fb3065dac79efb8901bd6244ef69 upstream.

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
---
 drivers/usb/typec/mux/intel_pmc_mux.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -571,9 +571,11 @@ err_unregister_switch:
 
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
@@ -583,6 +585,9 @@ static const struct acpi_device_id iom_a
 
 	/* AlderLake */
 	{ "INTC1079", 0x160, },
+
+	/* Meteor Lake */
+	{ "INTC107A", 0x160, },
 	{}
 };
 


