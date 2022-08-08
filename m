Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EF658C64A
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 12:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiHHKXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 06:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242446AbiHHKXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 06:23:05 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA33013CD1
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 03:23:01 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z2so10738693edc.1
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 03:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=rKOjsW4k1qCY11Djsk07ZkPmA4EwDVi2+pYVf11392Q=;
        b=LL7HPAhgp0qNg5a3NHrghxudXbVaJqON4F6eKIhIgb3IkOpTwVsSpREkFTJxnklt8V
         bv+E0Nz5AbN+nZHZh1gFBkdPnL17q1f3KmGVjsKqLM0qdaOnCrTvNY0cG8eRHMwg1kAH
         tl6bU0N60LkIPIH63yEmy8sbzdPASlVl13d9QAE6rQOxc4bxMfsGIggEKHA2jiCp0jXM
         F5wtRPemrqQmrz4OOR5QQM/0OWVv/zpEC6nRXM0X3D5RtPe2y5Cbi8F8mM66wX5mO8Mt
         YjcbVDt2zT0lGHAlnFtEP5B/YDFkhuEpFPVNULc6fk5y5IyGPDXydvfecg2Sg2rbmVFQ
         SDPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=rKOjsW4k1qCY11Djsk07ZkPmA4EwDVi2+pYVf11392Q=;
        b=NXXMoaVaCrIxrJrxQ3iL+eGTKD93RoopiIGVTv2S8NkW/23sNEILSrzlMAPLTfSmi3
         u6sHxRrwGXBEXJ5DLfWOw0DHmk8wtdU5YlqxrBNuMnpDfbvIpz2wB0j+CtPb/ksc4lg3
         5Amojf1ydkaSKdfuwvcab9xLUp5RY7LCK2rbQ+CW3ke5krupbBCR1ub941MTuViFRobq
         ypDf1s9/H/+eiuBUK+Tyxi+5OuE3TFupToIAousfnSfqFnAFXIe4sAblWkcQHPHWZqad
         EKIRZxjhsdIqlmAOuBbaBgmYNkPu8zM7++09brwl6HWCOlTlw0kX01PJ98BRtBCiwUtS
         St3g==
X-Gm-Message-State: ACgBeo17IBqvP1q+p+Ww13D/2r/MjoEYvKES+ar/iabyqlatHxr5McTV
        wJdkI/Trx6InjnR8anypxeiFj25sbAw=
X-Google-Smtp-Source: AA6agR6EOuiy08PaCAUD68eLaYLD6BzvMMZQmmHJT60dGTRidXIZnVtekOZ9FUCW96Q9ElWeS4bcKw==
X-Received: by 2002:a50:ff04:0:b0:43d:67a7:dd2d with SMTP id a4-20020a50ff04000000b0043d67a7dd2dmr17217614edu.11.1659954180474;
        Mon, 08 Aug 2022 03:23:00 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af044400b9d54df6b07d4ee8.dip0.t-ipconnect.de. [2003:f6:af04:4400:b9d5:4df6:b07d:4ee8])
        by smtp.googlemail.com with ESMTPSA id c10-20020a17090618aa00b00730af3346d6sm4822994ejf.212.2022.08.08.03.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 03:22:59 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     bauen1 <j2468h@googlemail.com>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 1/1] selinux: allow dontauditx and auditallowx rules to take effect without allowx
Date:   Mon,  8 Aug 2022 12:20:49 +0200
Message-Id: <20220808102049.46386-2-theflamefire89@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220808102049.46386-1-theflamefire89@gmail.com>
References: <20220808102049.46386-1-theflamefire89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: bauen1 <j2468h@googlemail.com>

commit 44141f58e14317853698f994ca5c3785a0c230d0 upstream.

This allows for dontauditing very specific ioctls e.g. TCGETS without
dontauditing every ioctl or granting additional permissions.

Now either an allowx, dontauditx or auditallowx rules enables checking
for extended permissions.

Signed-off-by: Jonathan Hettwer <j2468h@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
---
 security/selinux/ss/services.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 6ca297821d459..c27c3ce76abbc 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -610,9 +610,7 @@ void services_compute_xperms_drivers(
 					node->datum.u.xperms->driver);
 	}
 
-	/* If no ioctl commands are allowed, ignore auditallow and auditdeny */
-	if (node->key.specified & AVTAB_XPERMS_ALLOWED)
-		xperms->len = 1;
+	xperms->len = 1;
 }
 
 /*
-- 
2.25.1

