Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576194C9093
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 17:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbiCAQrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 11:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbiCAQrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 11:47:31 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49ECDF9B;
        Tue,  1 Mar 2022 08:46:50 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id i1so6378516ilu.6;
        Tue, 01 Mar 2022 08:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WgWVdTddSK1VIvJpihEOxrT4Mi3SIzAJw8C0VgfJ1+E=;
        b=ZyIqslhYvDH+znU49RDNGGBtdf2Hx25EKBLYyLNACYFixw48LAxXuDhuXdvN2vYeV0
         XtVH31Chbhr2WBzD6kuN2Lz7Aq+1wtlZukZS0en4xgMbIdXnVLKXVxq/s8o5v54hvmbr
         +v/3ebOGaZG+QRjCOwG4LGK73r4S2U8Ik1iea312xRwkjMKD5XcO0+V3Zr5uaVlkFpZ6
         hZJZ8yZ5Rh0tqRdJg4cL4zVkFORCWrFm1fmiKLAeBYsrqNKwmLTjrWspHnjSm+tRlfKv
         iW1YRmjCT7tc86d4IU91fXGtrPZWxgYvQhvUdvUCycWPlc8fa3md+RIZKr5NCtx0XegN
         W6+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WgWVdTddSK1VIvJpihEOxrT4Mi3SIzAJw8C0VgfJ1+E=;
        b=zSj/hd/fcrYNj1xHMorLpVgBdVXVjtWKDDUOrSBx++E0rxYFa1G8o2Qj0NmqW29tBg
         viClcwLicV9RspMq2At6f7CwbRN3pbQxXMWqqfhgWLpFO76Pdm7EGrVNCvbadJdMWCsD
         oERUg6kcFtGL4Laxh0HKhb+UyS6coln/3Z1K/wdOgt2NN2L7FCYLUeLr+Z7q7Euzcbae
         ACHqnZcxvWvEU8jJx3YYt//nD9nW2JUahvlyAp5noAQHQgX7fkovon0HtBLQwWkPuRMG
         i7yFDpFaTxlPuqiq+dCfICbCsg/EFVyvtEQQe3qAnbvHEMs+VEdpeTPTIE1u3Z2UTbnG
         x1sQ==
X-Gm-Message-State: AOAM532iELnAqsQv4PmcBm5gAweUoevM/WYBsJIvOEzTWSpk3+69k3wM
        rzIMAnb0podQWVKVHsmQxHw=
X-Google-Smtp-Source: ABdhPJy2WosYoNk36kwc3YDo4CJeoXCvRi+g+pvs1KuGqtjA+5zI4UvsFnn0cAKS/KsQmhNn9fQ6aw==
X-Received: by 2002:a05:6e02:1986:b0:2c4:804:2e6a with SMTP id g6-20020a056e02198600b002c408042e6amr2063617ilf.130.1646153210047;
        Tue, 01 Mar 2022 08:46:50 -0800 (PST)
Received: from frodo.hsd1.co.comcast.net ([2601:284:8204:2010::f10e])
        by smtp.googlemail.com with ESMTPSA id o3-20020a6b5a03000000b00640a33c5b0dsm7272411iob.17.2022.03.01.08.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 08:46:49 -0800 (PST)
From:   Jim Cromie <jim.cromie@gmail.com>
To:     jbaron@akamai.com, gregkh@linuxfoundation.org,
        daniel.vetter@ffwll.ch, seanpaul@chromium.org, robdclark@gmail.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Cc:     Jim Cromie <jim.cromie@gmail.com>, vincent.whitchurch@axis.com,
        stable@vger.kernel.org
Subject: [PATCH 01/13] dyndbg: fix static_branch manipulation
Date:   Tue,  1 Mar 2022 09:46:17 -0700
Message-Id: <20220301164629.3814634-2-jim.cromie@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220301164629.3814634-1-jim.cromie@gmail.com>
References: <20220301164629.3814634-1-jim.cromie@gmail.com>
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

