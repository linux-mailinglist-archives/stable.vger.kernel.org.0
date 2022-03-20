Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2FE4E1CF0
	for <lists+stable@lfdr.de>; Sun, 20 Mar 2022 17:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243239AbiCTQxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Mar 2022 12:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbiCTQxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Mar 2022 12:53:01 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5464F39811;
        Sun, 20 Mar 2022 09:51:38 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so5103566pjf.1;
        Sun, 20 Mar 2022 09:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hqswhbnOMm7ffYakT7tRGJ2is1DrUVKVb/3MOzX5S9A=;
        b=K+SgmylNNoqzvCijb+HlnpncJ/rhUCdJZP5qya/K7MkTTwtC7Y+Z3GMn8DK5R6cQnz
         uZvRySRta0HruYs2/vWX8Pida8dOzy3TvnNWf/WMnH4V0jqh0KyI1L1Q+Iai9bAS9Qtl
         348GgmaoBGsDHm6Msc6CyWwo4jIOfQXzwQywhkvFVteSCKIGzixTNuK1h6rh3m/DqkUh
         y1nsbZoSx8JYTMqo8rkMevvE085CzWCIpzvmEj0BnbnS7cn83MzMc04rsRxqjWURWPsc
         tjRs7MxOy76mhoPNctzUx4q6ny2sk17tgQAhyrhf5ifVCQSGLBWfprCe8526ESoQ2ttv
         5grQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hqswhbnOMm7ffYakT7tRGJ2is1DrUVKVb/3MOzX5S9A=;
        b=38x3ofwmmInjR5Ld3f5U65pJitXhC9mIeSDVB+sOjHzTmhw5grUontDLW5c60XhpdK
         cJR3RHoFovJjZTnQR5Gv5vsogNP0+8eZgvxtnAmQvGkZn8X9UQm10Nu62dbrh38sAIVQ
         Lv1y9FsYtcSNyRk1/58xVAG1Sb4DehpHAx2IZkVf/ZYg1BQ6qDnSgg+HhuTjHzNIsWj5
         hijp6TjqrTTOLNsvJAz4EVLIumfzTysTVGsDQyduzFq1tZSgGgP8qVGqirNum+1XMVDp
         mFhbDTDsCoKEsS9Q/9BClE91btFC7agXyHIQ8ER0Guef6xjFiirpkr7QszxA6Mo+AFud
         kK5A==
X-Gm-Message-State: AOAM530VzzH4mQ04kQo1Rmze5/CboRjgH0N1k6k69wvgXUIWtDBIIj4K
        3qcWG4vdbcOku0K6Peykklc=
X-Google-Smtp-Source: ABdhPJwX71AurQQf72bu6+WIH9UBG2NloztXwddX29163AB54/FsKys0sap9iAb/PXIUfbVEOEwZyw==
X-Received: by 2002:a17:90b:4f92:b0:1bf:25e2:f6af with SMTP id qe18-20020a17090b4f9200b001bf25e2f6afmr21846736pjb.98.1647795097761;
        Sun, 20 Mar 2022 09:51:37 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:401:1d20:7b82:18e2:fb73:9272])
        by smtp.gmail.com with ESMTPSA id f4-20020aa782c4000000b004f6f0334a51sm15218841pfn.126.2022.03.20.09.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 09:51:37 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] xtensa: fix xtensa_wsr always writing 0
Date:   Sun, 20 Mar 2022 09:51:28 -0700
Message-Id: <20220320165128.3137083-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit cad6fade6e78 ("xtensa: clean up WSR*/RSR*/get_sr/set_sr")
replaced 'WSR' macro in the function xtensa_wsr with 'xtensa_set_sr',
but variable 'v' in the xtensa_set_sr body shadowed the argument 'v'
passed to it, resulting in wrong value written to debug registers.

Fix that by removing intermediate variable from the xtensa_set_sr
macro body.

Cc: stable@vger.kernel.org
Fixes: cad6fade6e78 ("xtensa: clean up WSR*/RSR*/get_sr/set_sr")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/include/asm/processor.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/include/asm/processor.h b/arch/xtensa/include/asm/processor.h
index ba62bbcea160..67ccc3d48c8c 100644
--- a/arch/xtensa/include/asm/processor.h
+++ b/arch/xtensa/include/asm/processor.h
@@ -242,8 +242,8 @@ extern unsigned long __get_wchan(struct task_struct *p);
 
 #define xtensa_set_sr(x, sr) \
 	({ \
-	 unsigned int v = (unsigned int)(x); \
-	 __asm__ __volatile__ ("wsr %0, "__stringify(sr) :: "a"(v)); \
+	 __asm__ __volatile__ ("wsr %0, "__stringify(sr) :: \
+			       "a"((unsigned int)(x))); \
 	 })
 
 #define xtensa_get_sr(sr) \
-- 
2.30.2

