Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C7653CE53
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344719AbiFCRlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344716AbiFCRlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:41:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F073C53A74;
        Fri,  3 Jun 2022 10:40:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AC9E61AFD;
        Fri,  3 Jun 2022 17:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23179C385B8;
        Fri,  3 Jun 2022 17:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278046;
        bh=2/eUY5HJlBIAAIiHk2QQP+pGXmnFeSwcIppQN6JtJJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVCNc8WZRydYfOz5ZqEXeyRPzNB08bkFofmGTQjwO1BJohUf3kRcHSIaUj4CXIK8/
         JRJrpJadDrBwmd64veC2F1nqjQYKYwI7Lwh+ZXOnw8lXqFw5eH+Jvg/jJKuTJ9mW9F
         +Iy4I23rAD8Hme2m0JJxjoFtlvJdieYaVMEypbNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 4.14 05/23] ACPI: sysfs: Make sparse happy about address space in use
Date:   Fri,  3 Jun 2022 19:39:32 +0200
Message-Id: <20220603173814.528641585@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173814.362515009@linuxfoundation.org>
References: <20220603173814.362515009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit bdd56d7d8931e842775d2e5b93d426a8d1940e33 upstream.

Sparse is not happy about address space in use in acpi_data_show():

drivers/acpi/sysfs.c:428:14: warning: incorrect type in assignment (different address spaces)
drivers/acpi/sysfs.c:428:14:    expected void [noderef] __iomem *base
drivers/acpi/sysfs.c:428:14:    got void *
drivers/acpi/sysfs.c:431:59: warning: incorrect type in argument 4 (different address spaces)
drivers/acpi/sysfs.c:431:59:    expected void const *from
drivers/acpi/sysfs.c:431:59:    got void [noderef] __iomem *base
drivers/acpi/sysfs.c:433:30: warning: incorrect type in argument 1 (different address spaces)
drivers/acpi/sysfs.c:433:30:    expected void *logical_address
drivers/acpi/sysfs.c:433:30:    got void [noderef] __iomem *base

Indeed, acpi_os_map_memory() returns a void pointer with dropped specific
address space. Hence, we don't need to carry out __iomem in acpi_data_show().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -435,7 +435,7 @@ static ssize_t acpi_data_show(struct fil
 			      loff_t offset, size_t count)
 {
 	struct acpi_data_attr *data_attr;
-	void __iomem *base;
+	void *base;
 	ssize_t rc;
 
 	data_attr = container_of(bin_attr, struct acpi_data_attr, attr);


