Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86FC853CEAC
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343916AbiFCRp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345092AbiFCRoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:44:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E64F5522D;
        Fri,  3 Jun 2022 10:42:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3398B8242E;
        Fri,  3 Jun 2022 17:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C795C385A9;
        Fri,  3 Jun 2022 17:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278151;
        bh=jN3i2LdxfYzhR0w/hB0nyLMKgMI6Tdxlrm4dOLX7fsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHcXXRiZ0en+FlvnKlXB6WTsyqTsqW2lkoCJS/6Cqq2hVZWxbCuiCanUkp51jGKVK
         Y1qApdBpHX1PjkMmZMJVbxSkC5IXd+SXWik0vEHFD6/mb+CpArQ810kcDrJpmjbEI+
         PTcqCSujyQ8aZQh1q4yY6wWJE8qgT+7Ia/VWWA2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 4.19 05/30] ACPI: sysfs: Make sparse happy about address space in use
Date:   Fri,  3 Jun 2022 19:39:33 +0200
Message-Id: <20220603173815.250557142@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173815.088143764@linuxfoundation.org>
References: <20220603173815.088143764@linuxfoundation.org>
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
@@ -438,7 +438,7 @@ static ssize_t acpi_data_show(struct fil
 			      loff_t offset, size_t count)
 {
 	struct acpi_data_attr *data_attr;
-	void __iomem *base;
+	void *base;
 	ssize_t rc;
 
 	data_attr = container_of(bin_attr, struct acpi_data_attr, attr);


