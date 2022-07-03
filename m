Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B4A564539
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 07:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiGCFFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 01:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiGCFFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 01:05:12 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9A1AE60;
        Sat,  2 Jul 2022 22:05:11 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r14so2975041wrg.1;
        Sat, 02 Jul 2022 22:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2sCTSOQ1ZXKFCV8V5QraEF1aJLFJQmb4vDQ1L6sPiro=;
        b=NF3Qr+Hz+K0si5WKIWAuxIsjmh2g5mbSU2z9jIsZ2RNZEk+xuBKAERpt4n+MnST+S8
         dnjDkPBOAiYFKodj9u7EcbRgLDpLN3YcLcmyOqu0ruqlUeTrfoj/EnUeBYWMN8wQXUYw
         uGB9JCSPY3o5V/8USHH7JiYWoyjQiay3hoM6I6Wb4YSi/SglvyNZXxA2TjxLTEujrJJl
         9Y7FWj5UroBu3IDwwLpBWDO5aE6RJiSJkcuSQRZug1BSaeIMgfJPV9IGXnCFXIpiI6XN
         B1yWQ/3chvY/2G9PWRSLaWXyFXwwvR3gpB/i1SmTFZmImCgziO07RolwmsohbxPNhZNb
         RD0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2sCTSOQ1ZXKFCV8V5QraEF1aJLFJQmb4vDQ1L6sPiro=;
        b=oDGQfj0yUjz8+0xj1f0yxcmO7wTXr+0k2bMIWAQuE1d870zB0ybu5GOFV8s2UnRmGH
         4lNm81oOjtSreGtp4494y3fNd1HaQ4HSbu8caG+pxWsw486yRqNzZRBUvkVI2AEVKXGo
         2dTr6A7HWyIG2uPHRCVPwQ8ZHKPP7tMbtX6Yzdhy3ux0P1u98ruiaInWizFmyCuDdo5G
         00bn52lgXwd54D+IxAP+GW6EUP1/YC4y7HUWcVNvfUswuM0Hosi/EgaS6ml4dMfAGb+i
         P+IGqN9hC/K2A7mqDx2aLzduIEPWWKObjlicTIFglFF4L5qABqUZEynBi4g1BqvKhpYE
         koDA==
X-Gm-Message-State: AJIora9lISYXjtpT7zxwteNNrXTyhphYgwbEYY5lNwSFk7MqiOd+QkZg
        pWVWSA8OxZ2ViCGEGW44sIA=
X-Google-Smtp-Source: AGRyM1tQ6qFl/c2ISNvXLA3SfGxGjkAKpXQ4vgFZalBB0HpvHMYxIYYoJoeDj5DVlteEAZlpW/VoNA==
X-Received: by 2002:adf:f20a:0:b0:21d:6661:41e9 with SMTP id p10-20020adff20a000000b0021d666141e9mr1589991wro.604.1656824710151;
        Sat, 02 Jul 2022 22:05:10 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id e2-20020adfdbc2000000b0021b9f126fd3sm27028952wrj.14.2022.07.02.22.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 22:05:09 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Anthony Iliopoulos <ailiop@suse.com>
Subject: [PATCH 5.10 v3 5/7] xfs: fix xfs_trans slab cache name
Date:   Sun,  3 Jul 2022 08:04:54 +0300
Message-Id: <20220703050456.3222610-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220703050456.3222610-1-amir73il@gmail.com>
References: <20220703050456.3222610-1-amir73il@gmail.com>
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

From: Anthony Iliopoulos <ailiop@suse.com>

commit 25dfa65f814951a33072bcbae795989d817858da upstream.

Removal of kmem_zone_init wrappers accidentally changed a slab cache
name from "xfs_trans" to "xf_trans". Fix this so that userspace
consumers of /proc/slabinfo and /sys/kernel/slab can find it again.

Fixes: b1231760e443 ("xfs: Remove slab init wrappers")
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 04af5d17abc7..6323974d6b3e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1934,7 +1934,7 @@ xfs_init_zones(void)
 	if (!xfs_ifork_zone)
 		goto out_destroy_da_state_zone;
 
-	xfs_trans_zone = kmem_cache_create("xf_trans",
+	xfs_trans_zone = kmem_cache_create("xfs_trans",
 					   sizeof(struct xfs_trans),
 					   0, 0, NULL);
 	if (!xfs_trans_zone)
-- 
2.25.1

