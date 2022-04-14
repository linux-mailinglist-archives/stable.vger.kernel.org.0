Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C925013DD
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345635AbiDNNxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345109AbiDNNpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:45:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5A3344D1;
        Thu, 14 Apr 2022 06:42:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DC9A61B51;
        Thu, 14 Apr 2022 13:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE80C385A1;
        Thu, 14 Apr 2022 13:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943728;
        bh=PHHeuhm0NWxLPAAT62pIvnTG3/TxrZ35Cu7YW5GfDsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m84sL6NiQUrfv3xT4FpuSsKIRNFEJ4pUcX/9spPzZKwn14bx1jT9vNj0URPvarhN0
         tOrGBWETcWyc2gzlXcp0hzABj+Vef9S9wetn3rfE9H0zpR7Uuo+sCoP34SX7Qu/Wyj
         59vwlSg+ibUMXaoNCQ1rNMavun6T0XzmCRfmhMe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        anton ivanov <anton.ivanov@cambridgegreys.com>,
        Julius Werner <jwerner@chromium.org>,
        David Gow <davidgow@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 258/475] firmware: google: Properly state IOMEM dependency
Date:   Thu, 14 Apr 2022 15:10:43 +0200
Message-Id: <20220414110902.331271619@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: David Gow <davidgow@google.com>

[ Upstream commit 37fd83916da2e4cae03d350015c82a67b1b334c4 ]

The Google Coreboot implementation requires IOMEM functions
(memmremap, memunmap, devm_memremap), but does not specify this is its
Kconfig. This results in build errors when HAS_IOMEM is not set, such as
on some UML configurations:

/usr/bin/ld: drivers/firmware/google/coreboot_table.o: in function `coreboot_table_probe':
coreboot_table.c:(.text+0x311): undefined reference to `memremap'
/usr/bin/ld: coreboot_table.c:(.text+0x34e): undefined reference to `memunmap'
/usr/bin/ld: drivers/firmware/google/memconsole-coreboot.o: in function `memconsole_probe':
memconsole-coreboot.c:(.text+0x12d): undefined reference to `memremap'
/usr/bin/ld: memconsole-coreboot.c:(.text+0x17e): undefined reference to `devm_memremap'
/usr/bin/ld: memconsole-coreboot.c:(.text+0x191): undefined reference to `memunmap'
/usr/bin/ld: drivers/firmware/google/vpd.o: in function `vpd_section_destroy.isra.0':
vpd.c:(.text+0x300): undefined reference to `memunmap'
/usr/bin/ld: drivers/firmware/google/vpd.o: in function `vpd_section_init':
vpd.c:(.text+0x382): undefined reference to `memremap'
/usr/bin/ld: vpd.c:(.text+0x459): undefined reference to `memunmap'
/usr/bin/ld: drivers/firmware/google/vpd.o: in function `vpd_probe':
vpd.c:(.text+0x59d): undefined reference to `memremap'
/usr/bin/ld: vpd.c:(.text+0x5d3): undefined reference to `memunmap'
collect2: error: ld returned 1 exit status

Fixes: a28aad66da8b ("firmware: coreboot: Collapse platform drivers into bus core")
Acked-By: anton ivanov <anton.ivanov@cambridgegreys.com>
Acked-By: Julius Werner <jwerner@chromium.org>
Signed-off-by: David Gow <davidgow@google.com>
Link: https://lore.kernel.org/r/20220225041502.1901806-1-davidgow@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
index 2fba0aa7fc54..20dfe39a0537 100644
--- a/drivers/firmware/google/Kconfig
+++ b/drivers/firmware/google/Kconfig
@@ -21,7 +21,7 @@ config GOOGLE_SMI
 
 config GOOGLE_COREBOOT_TABLE
 	tristate "Coreboot Table Access"
-	depends on ACPI || OF
+	depends on HAS_IOMEM && (ACPI || OF)
 	help
 	  This option enables the coreboot_table module, which provides other
 	  firmware modules access to the coreboot table. The coreboot table
-- 
2.34.1



