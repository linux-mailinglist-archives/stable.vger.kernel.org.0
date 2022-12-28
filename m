Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997C7657983
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiL1PCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbiL1PCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:02:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E47713D0E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:01:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE494B81717
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39512C433EF;
        Wed, 28 Dec 2022 15:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239706;
        bh=iEkJ4ggRPgklRu6XR4Cbdj3ONEfNXBceFrQnHeRM3SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=smpsbCBazCU3SqaL4a7Ove1s7/LU9xc8oYU3uUyw/WYJKtpOhgHAxOgQ2c41GWyAG
         eGfCddN+Lmtd1C8G0x3w5PNAFizDVHmdhVKZbwEJXXrSVDFUuYVueYZV+RITGn5Uyh
         yC6b5D8iB8V29JiRRNF8A8KrycGYKzgkiOFkWKiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 260/731] Input: wistron_btns - disable on UML
Date:   Wed, 28 Dec 2022 15:36:07 +0100
Message-Id: <20221228144304.099587100@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b2b80d9dd14cb5b70dc254bddbc4eea932694791 ]

The wistron_btns driver calls rtc_cmos_read(), which isn't
available with UML builds, so disable this driver on UML.

Prevents this build error:

ld: drivers/input/misc/wistron_btns.o: in function `poll_bios':
wistron_btns.c:(.text+0x4be): undefined reference to `rtc_cmos_read'

Fixes: 0bbadafdc49d ("um: allow disabling NO_IOMEM") # v5.14+
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20221130161604.1879-1-rdunlap@infradead.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index dd5227cf8696..b5b8ddb536be 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -330,7 +330,7 @@ config INPUT_CPCAP_PWRBUTTON
 
 config INPUT_WISTRON_BTNS
 	tristate "x86 Wistron laptop button interface"
-	depends on X86_32
+	depends on X86_32 && !UML
 	select INPUT_SPARSEKMAP
 	select NEW_LEDS
 	select LEDS_CLASS
-- 
2.35.1



