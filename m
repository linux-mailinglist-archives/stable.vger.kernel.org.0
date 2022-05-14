Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228AB5272BA
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 17:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbiENPre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 11:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbiENPrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 11:47:33 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17A52674
        for <stable@vger.kernel.org>; Sat, 14 May 2022 08:47:32 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id m1so14967059wrb.8
        for <stable@vger.kernel.org>; Sat, 14 May 2022 08:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XF9WOeoNCxcDaLsr8Qe25CLiDFZtWpRFkEZCVH1jcxc=;
        b=NZvyI9pRkq6sZdk1XkdNJl16uc6LUDsOvbAEksKXWwyQkpav5r40d5rme8TA9PGLCI
         e20bYa/gX1Yly4YjfeFm9sHuW0HrC0a+NMWPbXuxMzvzgMdSYB4ywJqgFS4P2id4bfhe
         tYhAiQFCB5V6jbZC2YXfVNZjlqLuPhkLtaO9hjk1CQiqfK9zKh7Disr53zyZPmCy1bkH
         RHn05zJcqDkbI6nx6uOG002HbZIVhyWxmQsXpkPnWvI7ppQ1fsbyc2aKQ9nJLbXkueI2
         vBHwm5FHvSIBWinrRfub/2iIXWfyHAle9EM2S40rJHuwx7NH/g3SrG06gZfBqdaBpmbr
         jghA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XF9WOeoNCxcDaLsr8Qe25CLiDFZtWpRFkEZCVH1jcxc=;
        b=y4hbkhVMAWm8aZALdzOniK/PUh/Xuj4oYQjAku07WggTwH/qkrc4vKLrLhxAhWNpHM
         41oZpVaFC1uvirHG4OB+LAChpE6QhVXSqjy12zagrYlI9rPiPZgMjsnIO/91v6UkKbwc
         yJVGzeMCZYnJmhhnIuoAIWpcFXohJdAE1+lRrnijk9OaxS84hFmCgyB4sgZTW8rUvaWc
         ER3XSS1zRUNRcQE6WtDCmwvhO+QynfykTMb+Sn8DlOqDXYdl0mvp3EFoCpBppQE5qYGG
         QPflQtDNQRz930wx3g4wfKkgT1Z2fCgWSN2eE0IQi1d0hnESZia68eW/ObXrEk0F0Iru
         dRtQ==
X-Gm-Message-State: AOAM532bz7QxY8ab/X+B3OKnzSv4sXGAJ4Vip0HkUF2YH2gJKUKQE7oc
        nREAU0KV4Vh+frRi0yfOoe5MwbPxO60=
X-Google-Smtp-Source: ABdhPJwBgN225KwwIQfXF3L0Iyss08nyrG7B3Zd47D/06A2ebOtKVu3yXog4fN5bIyLmyBeQMlHCfA==
X-Received: by 2002:a05:6000:1110:b0:20a:e113:8221 with SMTP id z16-20020a056000111000b0020ae1138221mr7834070wrw.271.1652543251268;
        Sat, 14 May 2022 08:47:31 -0700 (PDT)
Received: from localhost.localdomain (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id t1-20020adfa2c1000000b0020c5253d8d2sm5033093wra.30.2022.05.14.08.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 08:47:31 -0700 (PDT)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4] MIPS: fix build with gcc-12
Date:   Sat, 14 May 2022 16:47:30 +0100
Message-Id: <20220514154730.6924-1-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some mips builds with gcc-12 fails with the error:
arch/mips/jz4740/setup.c:64:25: error: comparison between two arrays
	[-Werror=array-compare]
   	64 |         if (__dtb_start != __dtb_end)

'd24f48767d5e ("MIPS: Use address-of operator on section symbols")' has
been applied which fixes most of the error, but it missed one file which
was not available upstream when the change was done.

Fixes: d24f48767d5e ("MIPS: Use address-of operator on section symbols")
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/mips/jz4740/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/jz4740/setup.c b/arch/mips/jz4740/setup.c
index dc8ee21e0948e..45e327960a465 100644
--- a/arch/mips/jz4740/setup.c
+++ b/arch/mips/jz4740/setup.c
@@ -61,7 +61,7 @@ void __init plat_mem_setup(void)
 
 	jz4740_reset_init();
 
-	if (__dtb_start != __dtb_end)
+	if (&__dtb_start != &__dtb_end)
 		dtb = __dtb_start;
 	else
 		dtb = (void *)fw_passed_dtb;
-- 
2.30.2

