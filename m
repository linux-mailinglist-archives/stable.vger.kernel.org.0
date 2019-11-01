Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19356EC048
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 10:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfKAJLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 05:11:13 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33430 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfKAJLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 05:11:13 -0400
Received: by mail-wr1-f68.google.com with SMTP id s1so9022275wro.0;
        Fri, 01 Nov 2019 02:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vhjdwd9OjDgZKFYAiqq3M747PlQxCBQAkRBjkbyP7ZE=;
        b=ghjSVKpLhAM8ISXDDeFz9y/C6z6EwrwhVPWoJcoRy3cWjxomwNmYtyo2mo2va4jcmA
         ckgLhb1TMEgBPs6z+5cGziauek9PwpjPtF9bNS9UVjN2MWI0TP8XxzM0rIWMYzpe68kt
         cYoCQTDKl0gEYC6UpIDUrjXTC3m2l3cLykNr6n4zH6dhxG0XiiQ5aG5sniB0hCjHSd0b
         XMZQjt+/Vn6NY/B2wd6eewneXLbkji3K/hGNMJSzzs9ysAkpI6byIBnsh/jqluU1PhqP
         R6A4YyDNezfGsHiu66yGzf2lRv9g/RKoBR+MA8dhlif+AaKhzpLwS9VQgtQPRrLKhPCe
         mB/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vhjdwd9OjDgZKFYAiqq3M747PlQxCBQAkRBjkbyP7ZE=;
        b=qfJxv4+D6KBKEdtLvFbVZvfg+CV2tntu2kkZl3BP0CzzV47MabhUtBk414B6NGm7bb
         T9EzMCPJJPTqf18P26rxNOkE3Sn/74WpEh24EzIHEDN78Gj29DZB8Hjr69zrkFt3nnmM
         Jue6/Ua0yBK2zY0bZ4AywFrlHTf8NI4mv5JNnUop7thK7nT0yAYFRRe4ABbv5tYZvj2E
         xotgJPCBV5JUbNUkUyDKRD67EkXzSUw0UQxF7WVTnN6T/xBTql0mZ9ZL4xwb0sKfjj61
         Z1A3GfNuDYxdFQcUEoVZLx2AP1n1gFSBnui7DrnLfSGr6i8E7M6qITxPJglkLgDofN4O
         iH9g==
X-Gm-Message-State: APjAAAWvui0g5Ooj8tr6Juzm8uDg1f8OlWieU7b9b1OETWQCtgLxCg20
        0B/Co8Gmbr5smM1nCDKsS2hPaAIhp3s=
X-Google-Smtp-Source: APXvYqwucsVTviL1wqTqOub9YHhpaHgCtVJWjyxDGuPZN3ErAUCBvnC3v/Sq43iK8ecfBp/JazKKkw==
X-Received: by 2002:adf:b1c6:: with SMTP id r6mr10165019wra.48.1572599469966;
        Fri, 01 Nov 2019 02:11:09 -0700 (PDT)
Received: from localhost.localdomain ([62.178.82.229])
        by smtp.gmail.com with ESMTPSA id y2sm6655648wmy.2.2019.11.01.02.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 02:11:08 -0700 (PDT)
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Gmeiner <christian.gmeiner@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/etnaviv: correct ETNA_MAX_PIPE define
Date:   Fri,  1 Nov 2019 11:10:48 +0100
Message-Id: <20191101101110.10105-1-christian.gmeiner@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

etnaviv supports the following pipe types:

ETNA_PIPE_3D      0x00
ETNA_PIPE_2D      0x01
ETNA_PIPE_VG      0x02

The current used value of 4 for ETNA_MAX_PIPES is wrong and
caueses some troubles in the combination with perf counters.

Lets have a look at the function etnaviv_pm_query_dom(..):
If domain->pipe is 3 then we are one element beyond the end
of the array.

The easiest way to fix this issue is to provide a correct value
for ETNA_MAX_PIPES.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: a8c21a5451d8 ("drm/etnaviv: add initial etnaviv DRM driver")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
 include/uapi/drm/etnaviv_drm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/drm/etnaviv_drm.h b/include/uapi/drm/etnaviv_drm.h
index 09d0df8b71c5..5a62228298d1 100644
--- a/include/uapi/drm/etnaviv_drm.h
+++ b/include/uapi/drm/etnaviv_drm.h
@@ -75,7 +75,7 @@ struct drm_etnaviv_timespec {
 #define ETNAVIV_PARAM_GPU_NUM_VARYINGS              0x1a
 #define ETNAVIV_PARAM_SOFTPIN_START_ADDR            0x1b
 
-#define ETNA_MAX_PIPES 4
+#define ETNA_MAX_PIPES 3
 
 struct drm_etnaviv_param {
 	__u32 pipe;           /* in */
-- 
2.23.0

