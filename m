Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCAC657F0B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiL1QAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbiL1QAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:00:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D28218E23
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:00:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1920661563
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA81FC433F1;
        Wed, 28 Dec 2022 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243229;
        bh=otFveWaqV2lUR8YzwahqjNHQ6/nJvhCF7rnHkC2Cx0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YXjepNGnA1h4B8bTJ6jGvVcGaemYLZCG80EjiXmM+wkGvUrSTLWtSMuVah1UEGaX2
         iVpFgvk/ibPQlS0+Kf9KkOnml+t827yez2j6mgKnqlv46+xwdo0d8AxpflXCAsfcac
         4zDM3BnIeVP53zDWvhDS/xr4gTtJMr/0ZErp938o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0444/1146] Input: wistron_btns - disable on UML
Date:   Wed, 28 Dec 2022 15:33:03 +0100
Message-Id: <20221228144342.239719880@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 9f088900f863..fa942651619d 100644
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



