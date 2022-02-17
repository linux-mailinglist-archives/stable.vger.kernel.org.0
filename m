Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D9E4B96EB
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 04:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbiBQDsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 22:48:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiBQDsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 22:48:52 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48421C0506;
        Wed, 16 Feb 2022 19:48:39 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id q8so2225543iod.2;
        Wed, 16 Feb 2022 19:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WgWVdTddSK1VIvJpihEOxrT4Mi3SIzAJw8C0VgfJ1+E=;
        b=PFLx2BNFItOcSBVBzOes2CcfuiOg9MZFNk4GMlp3FEWB8qTgBL5FbKnZoRAKYReNL/
         ReDNJ2jxVfhXYWmadIOhteBp5jp1Sev1vNmsZeyjXjVlSxi4P2CC/txIQX7x9no42fno
         35b9yd+0zjb90kjD0RTZWE4ze/Nt2mO0Dv2OBbNMV0VvkEHUdLIB1FJ8RryJH/Fwzuky
         RLM4b4LiDs6AJEA/W6MVIubgvSU1zPeT1bXXrH157OyjpS7EBS2G9qdbF4skflStaHXi
         nfMGkMcVbjqWYUHs2Td7/xiydiYvo50td+/vQ/lbFICW72LMNHR+7cwzpp61v9C8G6jN
         5c0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WgWVdTddSK1VIvJpihEOxrT4Mi3SIzAJw8C0VgfJ1+E=;
        b=4nFyqzaluVju0um2nE9FK6QUhRvTEXSsrIybkjQhfv/UGaZApxeR/5OFh9FZycazfb
         39cTG82c5vF8cKtYN7aVy8ed6huuWJ1q1ZizP7pUQLtHyW3MSQ6SoiscH+xqDO5aGM2N
         36xXhpLglvI4siL7qnmiaw7ZrUKTCnM9zeCllT/sa2aaoCSQ51zqoN06OvjYvS1XZt8G
         DL2SbfTvs6uFdzkrJFx3NaQx0xZnsYbsHu5DPZGOUnwUTURNTOUr6uVXKP5Oje049d98
         9Ptlu7lZA1Y1GqD7kbGXabX2DCsRSbXyTA94k03FOk6wN0Ctwe38MjEFtTlCL0bXB3tT
         i8zQ==
X-Gm-Message-State: AOAM531lxSzH1BVQr3yzQ9SABg4bswQDgt9naQGHXzvXmz/eeeo9ZASc
        MHnaVlYjDsRhLrp44AOInow=
X-Google-Smtp-Source: ABdhPJw368F4fr7QiyGQIds6VCL1NhGqtcNQKtxpD3CT5e3gMbNyzA1gjwbx4VI1KL4OErxP7BRLbw==
X-Received: by 2002:a02:a808:0:b0:30e:e741:5457 with SMTP id f8-20020a02a808000000b0030ee7415457mr687157jaj.289.1645069718640;
        Wed, 16 Feb 2022 19:48:38 -0800 (PST)
Received: from frodo.hsd1.co.comcast.net ([2601:284:8204:2010::1b19])
        by smtp.googlemail.com with ESMTPSA id l16sm1127874ilc.54.2022.02.16.19.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 19:48:38 -0800 (PST)
From:   Jim Cromie <jim.cromie@gmail.com>
To:     jbaron@akamai.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Cc:     daniel.vetter@ffwll.ch, seanpaul@chromium.org, robdclark@gmail.com,
        linux@rasmusvillemoes.dk, joe@perches.com,
        Jim Cromie <jim.cromie@gmail.com>, vincent.whitchurch@axis.com,
        stable@vger.kernel.org
Subject: [PATCH 01/13] dyndbg: fix static_branch manipulation
Date:   Wed, 16 Feb 2022 20:48:17 -0700
Message-Id: <20220217034829.64395-2-jim.cromie@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220217034829.64395-1-jim.cromie@gmail.com>
References: <20220217034829.64395-1-jim.cromie@gmail.com>
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

In https://lore.kernel.org/lkml/20211209150910.GA23668@axis.com/

Vincent's patch commented on, and worked around, a bug toggling
static_branch's, when a 2nd PRINTK-ish flag was added.  The bug
results in a premature static_branch_disable when the 1st of 2 flags
was disabled.

The cited commit computed newflags, but then in the JUMP_LABEL block,
did not use that result, but used just one of the terms in it.  Using
newflags instead made the code work properly.

This is Vincents test-case, reduced.  It needs the 2nd flag to work
properly, but it's explanatory here.

pt_test() {
    echo 5 > /sys/module/dynamic_debug/verbose

    site="module tcp" # just one callsite
    echo " $site =_ " > /proc/dynamic_debug/control # clear it

    # A B ~A ~B
    for flg in +T +p "-T #broke here" -p; do
	echo " $site $flg " > /proc/dynamic_debug/control
    done;

    # A B ~B ~A
    for flg in +T +p "-p #broke here" -T; do
	echo " $site $flg " > /proc/dynamic_debug/control
    done
}
pt_test

Fixes: 84da83a6ffc0 dyndbg: combine flags & mask into a struct, simplify with it
CC: vincent.whitchurch@axis.com
CC: stable@vger.kernel.org
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index dd7f56af9aed..a56c1286ffa4 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -211,10 +211,11 @@ static int ddebug_change(const struct ddebug_query *query,
 				continue;
 #ifdef CONFIG_JUMP_LABEL
 			if (dp->flags & _DPRINTK_FLAGS_PRINT) {
-				if (!(modifiers->flags & _DPRINTK_FLAGS_PRINT))
+				if (!(newflags & _DPRINTK_FLAGS_PRINT))
 					static_branch_disable(&dp->key.dd_key_true);
-			} else if (modifiers->flags & _DPRINTK_FLAGS_PRINT)
+			} else if (newflags & _DPRINTK_FLAGS_PRINT) {
 				static_branch_enable(&dp->key.dd_key_true);
+			}
 #endif
 			dp->flags = newflags;
 			v4pr_info("changed %s:%d [%s]%s =%s\n",
-- 
2.35.1

