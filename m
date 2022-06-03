Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4369353CEDB
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345310AbiFCRsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345321AbiFCRsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:48:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7735402D;
        Fri,  3 Jun 2022 10:44:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB089B82430;
        Fri,  3 Jun 2022 17:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01735C385A9;
        Fri,  3 Jun 2022 17:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278286;
        bh=jN3i2LdxfYzhR0w/hB0nyLMKgMI6Tdxlrm4dOLX7fsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/nbTdJ5R5XIvVU33rt9WD8FR8iT+2CzdBB4mIxRYbJj5Qz/zgDPTaZayC0Whi//F
         CFttcEulqANY6i/yC0qvasaaOOMMW74xEFdTwImt6y8TemMJka0QXaM44r888Qu/Eo
         EiWkeNKX6Zj08GKVZVSXOoUcNLJtIx2vei63B7JU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 5.4 09/34] ACPI: sysfs: Make sparse happy about address space in use
Date:   Fri,  3 Jun 2022 19:43:05 +0200
Message-Id: <20220603173816.267614104@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173815.990072516@linuxfoundation.org>
References: <20220603173815.990072516@linuxfoundation.org>
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


