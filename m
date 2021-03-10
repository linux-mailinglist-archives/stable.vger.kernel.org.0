Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B79C333680
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 08:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhCJHkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 02:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhCJHkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 02:40:31 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507CBC061760
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 23:40:31 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id ci14so36441390ejc.7
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 23:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7htfKEWj4A1mHYbOJujhEP8fr6drS4OtZ91jlFV3ApY=;
        b=lc1dhv1vlFR8xg17tISMV9ljgonYRYnKCI/dV2TYIoLjzvNOCNBnM2dcg6GR99RUV7
         6olqwk9R6ELu+/8U7cxQSYQFhTp2YEHQ67u9v4N45SJR2Gr9705iihIiaWE1MY65yLEv
         1kJgIT1Du4xtvS4SsKPll30rFeGxpvFFPkg4s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7htfKEWj4A1mHYbOJujhEP8fr6drS4OtZ91jlFV3ApY=;
        b=RWsRB3OpzxcFnPK7j5BasJAbNVQOdYoa3ixTwb+ZbfOMRJOD0Vh7JqKeKJtvvNOl4m
         C2tYdhnZ1HU6Q7qOpN73yANELIw6QP3lhXPZdUvvkXLqGfx1AbFzMeiRmB+fBkKpxfT9
         KQwcJYoSe7gTXPi20TG2h1voZNQP6fUW4kN+a9arqAU5ouTn7d+P6XAluutdB5md4+CI
         ODy85+L6BprORHkvRUZrW9tl7gQWW/2Uh9VRY2kvCZyvd7EED6OjSOwukS6FtEY2fm1x
         PsP0Le236t12+W22i+LWSG8ZCGRGkpHR0vOWva0YcdAcsQVJ2zbNEmcQOkh4AHpHpr00
         R5iw==
X-Gm-Message-State: AOAM530uciz2a3Lx53xwVpUoEbAayDJRx1wAvWCGmSD1RrL64nfTEwFy
        9Dse9eWZecNadEjkC42gS95vrg==
X-Google-Smtp-Source: ABdhPJwIhNo0p77nmtL5NmTaAsBp68g+mGOKFQRYDcHVyhZbKylB7G6jH6lPNhXHMRN8oSrGbY7I1w==
X-Received: by 2002:a17:906:cd05:: with SMTP id oz5mr2232468ejb.345.1615362029874;
        Tue, 09 Mar 2021 23:40:29 -0800 (PST)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id a12sm10253646edx.91.2021.03.09.23.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 23:40:29 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        stable@vger.kernel.org
Subject: [PATCH] media: videobuf2: Fix integer overrun in vb2_mmap
Date:   Wed, 10 Mar 2021 08:40:28 +0100
Message-Id: <20210310074028.1042475-1-ribalda@chromium.org>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The plane_length is an unsigned integer. So, if we have a size of
0xffffffff bytes we incorrectly allocate 0 bytes instead of 1 << 32.

Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: stable@vger.kernel.org
Fixes: 7f8414594e47 ("[media] media: videobuf2: fix the length check for mmap")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 543da515c761..876db5886867 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2256,7 +2256,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	 * The buffer length was page_aligned at __vb2_buf_mem_alloc(),
 	 * so, we need to do the same here.
 	 */
-	length = PAGE_ALIGN(vb->planes[plane].length);
+	length = PAGE_ALIGN((unsigned int)vb->planes[plane].length);
 	if (length < (vma->vm_end - vma->vm_start)) {
 		dprintk(q, 1,
 			"MMAP invalid, as it would overflow buffer length\n");
-- 
2.30.1.766.gb4fecdf3b7-goog

