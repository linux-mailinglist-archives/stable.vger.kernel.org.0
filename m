Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E614F3B4D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348181AbiDELww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357137AbiDEKZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:25:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C1F53E0F;
        Tue,  5 Apr 2022 03:09:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22A62616E7;
        Tue,  5 Apr 2022 10:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C01C385A0;
        Tue,  5 Apr 2022 10:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153375;
        bh=OV47iBJ5fsFk1E4W5Sw81qOODEtHY8MEP71aX2/Lg+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2sLKwxFYGiKfC5ptjrPslQhJ6s5FYO/a77X6rbvmK56df+3uZXBl6lHZVpAs3mVb5
         sdOTb9JtGMbIyCDXtascdRG2boR/UT2IuPdVngzOwnbOkI1WZwMFAV2i5vvBHPfuoV
         843sGPQHJbwucFiZOySyjyAuUNypXpj7nudUHMYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/599] video: fbdev: controlfb: Fix set but not used warnings
Date:   Tue,  5 Apr 2022 09:28:12 +0200
Message-Id: <20220405070304.732913507@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Sam Ravnborg <sam@ravnborg.org>

[ Upstream commit 4aca4dbcac9d8eed8a8dc15b6883270a20a84218 ]

The controlfb driver has a number of dummy defines for IO operations.
They were introduced in commit a07a63b0e24d
("video: fbdev: controlfb: add COMPILE_TEST support").

The write variants did not use their value parameter in the
dummy versions, resulting in set but not used warnings.
Fix this by adding "(void)val" to silence the compiler.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patchwork.freedesktop.org/patch/msgid/20201206190247.1861316-13-sam@ravnborg.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/controlfb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/controlfb.c b/drivers/video/fbdev/controlfb.c
index 2df56bd303d2..509311471d51 100644
--- a/drivers/video/fbdev/controlfb.c
+++ b/drivers/video/fbdev/controlfb.c
@@ -64,9 +64,9 @@
 #undef in_le32
 #undef out_le32
 #define in_8(addr)		0
-#define out_8(addr, val)
+#define out_8(addr, val)	(void)(val)
 #define in_le32(addr)		0
-#define out_le32(addr, val)
+#define out_le32(addr, val)	(void)(val)
 #define pgprot_cached_wthru(prot) (prot)
 #else
 static void invalid_vram_cache(void __force *addr)
-- 
2.34.1



