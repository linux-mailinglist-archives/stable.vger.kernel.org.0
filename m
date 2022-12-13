Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F4364BD1A
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 20:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbiLMTTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 14:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236748AbiLMTTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 14:19:24 -0500
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Dec 2022 11:19:22 PST
Received: from smtpdh20-1.aruba.it (smtpdh20-1.aruba.it [62.149.155.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1B671E3FE
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 11:19:22 -0800 (PST)
Received: from localhost.localdomain ([146.241.66.6])
        by Aruba Outgoing Smtp  with ESMTPSA
        id 5An9pnstapLT85An9pWbXH; Tue, 13 Dec 2022 20:18:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1670959101; bh=45b7rjT0/sHSloklDkuIVsgXND/IMJ9OTxAKP6zw8VY=;
        h=From:To:Subject:Date:MIME-Version;
        b=AYDt7SXh49oRBw5EfMN/zvZSgqXCjySsPSO8kZyq4LGsxQVhdqzyKGgst26KyIISy
         /N1iIZ/W22WPTuMV/DJoEqPa1DdtCShuTb4vJo4815KUUAlWyKo8PzEKIaV02iOBxo
         7CXpZVyesMdT4Y1ebvD8SVHzH9iKfv+EZuzF89XooieLjEOlkNKqMmCQWo9vQi7fDH
         wBDhQRs7e/rox6uLInslxIUHA/12TyrzgTJRsX++/uFzU3sIUKLGtvCExwsb61ndHl
         +hUr+l77FdM0w68Q6ibHtlOdqCr3W1AFA39NO3NrQz3cyolyQxzXAPFrhe8LdNxa+8
         uM9enQR+8fhfw==
From:   Giulio Benetti <giulio.benetti@benettiengineering.com>
To:     Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Giulio Benetti <giulio.benetti@benettiengineering.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Will Deacon <will@kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Naresh Kamboju <naresh.kamboju@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] ARM: mm: fix warning on phys_addr_t to void pointer assignment
Date:   Tue, 13 Dec 2022 20:18:13 +0100
Message-Id: <20221213191813.4054267-1-giulio.benetti@benettiengineering.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfD1IV/P04Cugw3asqwnUxCFrlRnAaYWaB3aYVXpV2G3EVnhhfFs/Z5jZkCbE4wf2lBfe6O7x1GSkfdLmd3vUJcqaq/3dnchNZgQmRCMahE36rTR/HnQI
 xG/ng25jHVR0HglDXAq1HEFAB/+sajRd0SKVx0k57RipJpRxMhE4DRLKesCDb7EAQV18LIf5tbQkMg5fcNijcchd7HSkA22B45KDLlQPdBnR5HoiQUm/CQmz
 LsY4I+1+wSaTLD2OmhoUbGRBVVgpYDIYcxo5X6c6KUPg9q2qgbKpeX5ngwqhkngwcQVaBdIGTpRBE05V2ek8GtQJad8kEkONtQMG+29jZkuIit1YWf/T7Abj
 nlBJNuZtYgBQ50VjKbriCyELT2aMYu88SnfzkSeMMPhSvITuYRsPLbvKCroxAxhiLiYnPNRqV3MPmU9TEmoht0ECwVigeHdwKgV9j4Dc836561T+7rTB4fQ9
 BCb27D9qf/yYji77OxDjk6Jg6QPpNvYeFOd5m5ENFU1oRO2WW4svLHWw0qHcyoW5SpAm0ulYEHUV+ocSRFtyczdIYaartHlwxlUJuriRJLhTk9AO+sgKx/UB
 uCezY6VtDyzxiQd83kQ9z40RzqlnD1GdVLr6Aw4hBAARHzMbfwqxqjlpWlWIQMrdFvg5FkvCQdbFtzawfXapiGrDH5XbpcVWcCAve9s+wT0kVw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

zero_page is a void* pointer but memblock_alloc() returns phys_addr_t type
so this generates a warning while using clang and with -Wint-error enabled
that becomes and error. So let's cast the return of memblock_alloc() to
(void *).

Cc: <stable@vger.kernel.org> # 4.14.x +
Fixes: 340a982825f7 ("ARM: 9266/1: mm: fix no-MMU ZERO_PAGE() implementation")
Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
---
 arch/arm/mm/nommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
index c1494a4dee25..53f2d8774fdb 100644
--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -161,7 +161,7 @@ void __init paging_init(const struct machine_desc *mdesc)
 	mpu_setup();
 
 	/* allocate the zero page. */
-	zero_page = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+	zero_page = (void *)memblock_alloc(PAGE_SIZE, PAGE_SIZE);
 	if (!zero_page)
 		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
 		      __func__, PAGE_SIZE, PAGE_SIZE);
-- 
2.34.1

