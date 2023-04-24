Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45336ECE38
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjDXNaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbjDXNaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BDB6E86
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB2EA622DA
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB65C433D2;
        Mon, 24 Apr 2023 13:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342972;
        bh=XceAHinoPLvIfUIBuPBswUzyA8nZBrYRZs6HlidQhSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGHYxijAgue2htwz1z8YvvH+ZF5VHXF0slGTZcs+CRAy++Vn5rFmftM8cpv6tqt64
         69ACNpwbi9phIqeDJB6tt9/GGl1CKPgaA7UPVkvzRFl4EZ3bP57qXBzkTsQFkI+wW7
         gFXv4DeXOAQB6rOAx4C502dzJ/cG23DvhTdhd+ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, WANG Xuerui <git@xen0n.name>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 028/110] LoongArch: Fix build error if CONFIG_SUSPEND is not set
Date:   Mon, 24 Apr 2023 15:16:50 +0200
Message-Id: <20230424131137.183655156@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 1cf62488f5e465b1cd814d19be238a4b7ad5be38 ]

We can see the following build error on LoongArch if CONFIG_SUSPEND is
not set:

  ld: drivers/acpi/sleep.o: in function 'acpi_pm_prepare':
  sleep.c:(.text+0x2b8): undefined reference to 'loongarch_wakeup_start'

Here is the call trace:

  acpi_pm_prepare()
    __acpi_pm_prepare()
      acpi_sleep_prepare()
        acpi_get_wakeup_address()
          loongarch_wakeup_start()

Root cause: loongarch_wakeup_start() is defined in arch/loongarch/power/
suspend_asm.S which is only built under CONFIG_SUSPEND. In order to fix
the build error, just let acpi_get_wakeup_address() return 0 if CONFIG_
SUSPEND is not set.

Fixes: 366bb35a8e48 ("LoongArch: Add suspend (ACPI S3) support")
Reviewed-by: WANG Xuerui <git@xen0n.name>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/all/11215033-fa3c-ecb1-2fc0-e9aeba47be9b@infradead.org/
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/acpi.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/loongarch/include/asm/acpi.h b/arch/loongarch/include/asm/acpi.h
index 4198753aa1d0f..976a810352c60 100644
--- a/arch/loongarch/include/asm/acpi.h
+++ b/arch/loongarch/include/asm/acpi.h
@@ -41,8 +41,11 @@ extern void loongarch_suspend_enter(void);
 
 static inline unsigned long acpi_get_wakeup_address(void)
 {
+#ifdef CONFIG_SUSPEND
 	extern void loongarch_wakeup_start(void);
 	return (unsigned long)loongarch_wakeup_start;
+#endif
+	return 0UL;
 }
 
 #endif /* _ASM_LOONGARCH_ACPI_H */
-- 
2.39.2



