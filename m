Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFDD234CA2
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 23:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgGaVDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 17:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgGaVDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 17:03:05 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A3DC061574
        for <stable@vger.kernel.org>; Fri, 31 Jul 2020 14:03:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a14so30473631ybm.13
        for <stable@vger.kernel.org>; Fri, 31 Jul 2020 14:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1Eh/wQ40rCPdQV1JiRjjRBdPYnmIc11YaQZLvEs3Mp4=;
        b=OYixH7JdGmTUIvuymI6eEmbudvjglQTb8eU++fXyFYvmFGyTMWsHGf68RwqWjQwjDi
         bH5BlLXK88fQI/foBGa6Uttv5zmHlrCw0e3Omym+1dHOM2jJbv9/wx/fBeu88SCHnRNt
         8pk8fdPdQLus+g9MMjU9+M4WnmFXuOhT2vRIff9kqrzO1FUg2TRXbCA67y8Os9tP6d4j
         U9nTKPf82HQJEADqi81cAtsxIlJJIz/TdHocstUQLl0Efl7rIp6M3NFBJUsZcai90t8c
         4CAQyRQs9LgcdRsLoofjsp6weXibVf/r1kcmyOKGD7pFuBKvp5jFDo4qe5/3zOihjfir
         bTyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1Eh/wQ40rCPdQV1JiRjjRBdPYnmIc11YaQZLvEs3Mp4=;
        b=mKL3KalOlyy6KxV6nzEqkM9Bf750EKGdODBRCPg+JW2gFuwsXB/xXGezLxfWfY7PPe
         1cfVNpwyeaxjyWnSep+Lvn4KJujPGUdnt96SJL8fdhMSrShB6A5fIUbqkwh9+n9s4yVD
         Ev8qWoH4QVUIcH1hjhtPxLyU6CtFmtMICuEudEFYEpyro4wAsPT4+uaOsVwdYJ5Eyt/3
         NaSHLddbVF+3rkGSooKrh/KttRM8cCLzXhgUiVqrseLIXMCNvkI7qkC915Df4R5CPsF2
         Xbvd/MVz7gA8pyut4NxJ4V30DkgRkwaIStVt83emyrHpSVld4lsk73znS6if30WFkhzQ
         lF2Q==
X-Gm-Message-State: AOAM531XWXj3wj+/m5obTpAkntNba5t4ZcBK7osOGRiYU44iOrZOM0t1
        fqFHUJlpG2oiybZ/0PxKhjuZ0tmHRhXvSCrwlxJD72ycRJrASkgVsH7oS+nLaYzPHgPYFaKB3T9
        mUo8Ii4SFaEy3+BDXzeR4wx5IXpBqLmFRZEmvwi70pjFxI9Na9lvrOcYKIyPdi5X9x2muUXAsh+
        EAPw==
X-Google-Smtp-Source: ABdhPJyhaSUCxrybIPsH/F5/XWW7eiTiutPvXFcY4IMbCe0+9wf/6fPdBQ/2hzE+UvsdX+ngHyaqnlyqcGDxZgLTtSA=
X-Received: by 2002:a25:a308:: with SMTP id d8mr9226993ybi.60.1596229382568;
 Fri, 31 Jul 2020 14:03:02 -0700 (PDT)
Date:   Fri, 31 Jul 2020 14:02:55 -0700
Message-Id: <20200731210255.3821452-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH 4.19] wireless: Use offsetof instead of custom macro.
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     stable@vger.kernel.org
Cc:     Pi-Hsun Shih <pihsun@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pi-Hsun Shih <pihsun@chromium.org>

commit 6989310f5d4327e8595664954edd40a7f99ddd0d upstream.

Use offsetof to calculate offset of a field to take advantage of
compiler built-in version when possible, and avoid UBSAN warning when
compiling with Clang:

==================================================================
UBSAN: Undefined behaviour in net/wireless/wext-core.c:525:14
member access within null pointer of type 'struct iw_point'
CPU: 3 PID: 165 Comm: kworker/u16:3 Tainted: G S      W         4.19.23 #43
Workqueue: cfg80211 __cfg80211_scan_done [cfg80211]
Call trace:
 dump_backtrace+0x0/0x194
 show_stack+0x20/0x2c
 __dump_stack+0x20/0x28
 dump_stack+0x70/0x94
 ubsan_epilogue+0x14/0x44
 ubsan_type_mismatch_common+0xf4/0xfc
 __ubsan_handle_type_mismatch_v1+0x34/0x54
 wireless_send_event+0x3cc/0x470
 ___cfg80211_scan_done+0x13c/0x220 [cfg80211]
 __cfg80211_scan_done+0x28/0x34 [cfg80211]
 process_one_work+0x170/0x35c
 worker_thread+0x254/0x380
 kthread+0x13c/0x158
 ret_from_fork+0x10/0x18
===================================================================

Signed-off-by: Pi-Hsun Shih <pihsun@chromium.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20191204081307.138765-1-pihsun@chromium.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Fix landed in v5.7-rc1. Thanks to James Hsu of MediaTek for the report.

 include/uapi/linux/wireless.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/wireless.h b/include/uapi/linux/wireless.h
index 86eca3208b6b..a2c006a364e0 100644
--- a/include/uapi/linux/wireless.h
+++ b/include/uapi/linux/wireless.h
@@ -74,6 +74,8 @@
 #include <linux/socket.h>		/* for "struct sockaddr" et al	*/
 #include <linux/if.h>			/* for IFNAMSIZ and co... */
 
+#include <stddef.h>                     /* for offsetof */
+
 /***************************** VERSION *****************************/
 /*
  * This constant is used to know the availability of the wireless
@@ -1090,8 +1092,7 @@ struct iw_event {
 /* iw_point events are special. First, the payload (extra data) come at
  * the end of the event, so they are bigger than IW_EV_POINT_LEN. Second,
  * we omit the pointer, so start at an offset. */
-#define IW_EV_POINT_OFF (((char *) &(((struct iw_point *) NULL)->length)) - \
-			  (char *) NULL)
+#define IW_EV_POINT_OFF offsetof(struct iw_point, length)
 #define IW_EV_POINT_LEN	(IW_EV_LCP_LEN + sizeof(struct iw_point) - \
 			 IW_EV_POINT_OFF)
 
-- 
2.28.0.163.g6104cc2f0b6-goog

