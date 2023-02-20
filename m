Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8208A69CDE9
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjBTNyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjBTNyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:54:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA8F1E9D2
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:54:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C29660E9E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A429DC433D2;
        Mon, 20 Feb 2023 13:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901242;
        bh=85VMH/1lZVswfIyXaXbLNR+c6CWzvM7lOPM8oTT+CeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPXOrcwxH4MZHYd8TlLtlOHHObWMz571sfWl0C44CIYTIuEZ4PuyttUh7bBmR/BdK
         0BU4ikrYejeg/k0QEYVzKbCKGyZ/K2C+uaZa1xa3+dETlDaAaxXHJD5xroqALVTuc7
         FnEXBU7Ri5jNYycLfud0z2MqtNaxmvKlBlgVJHEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 83/83] platform/x86/amd: pmc: add CONFIG_SERIO dependency
Date:   Mon, 20 Feb 2023 14:36:56 +0100
Message-Id: <20230220133556.648532475@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit abce209d18fd26e865b2406cc68819289db973f9 upstream.

Using the serio subsystem now requires the code to be reachable:

x86_64-linux-ld: drivers/platform/x86/amd/pmc.o: in function `amd_pmc_suspend_handler':
pmc.c:(.text+0x86c): undefined reference to `serio_bus'

Add the usual dependency: as other users of serio use 'select'
rather than 'depends on', use the same here.

Fixes: 8e60615e8932 ("platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230127093950.2368575-1-arnd@kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -171,6 +171,7 @@ config ACER_WMI
 config AMD_PMC
 	tristate "AMD SoC PMC driver"
 	depends on ACPI && PCI
+	select SERIO
 	help
 	  The driver provides support for AMD Power Management Controller
 	  primarily responsible for S2Idle transactions that are driven from


