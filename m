Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9932C4B21
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 23:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgKYW5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 17:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgKYW47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 17:56:59 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2285C0613D4;
        Wed, 25 Nov 2020 14:56:59 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id e8so3762513pfh.2;
        Wed, 25 Nov 2020 14:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kIh4FHvq8ePRNBrDx3FCPjMe1x8Qk7QKOwE9kc0FlUw=;
        b=HZZ11jgDnitr8XBs4ugwuHXp7jJlzb/alhFV2C9J8DKHEW6uvZfaUfkoqzNhzxg76k
         dKAFT5iUQzdryTIHq6KEGnsYL3m5MJy9H8DXwRraybgs8oYX66TabKvLgw54GkNhuHzP
         /RzS5zpmEwbkr9nlvvr4W93OdTXLnw+ZqBZPDZsHRJqKQHzzVy2Sg1zTI/D4frtV0h46
         UL8yBz8MgyMcOYyiOYKkBroaDDDHmK8ZPHCBIwhiO2Cl59vy1Q55qUy6t7u9L3f9DCZb
         V4SWxOdo/EjuWaBxRbT40GGFvu1C3mgyvCg53KyNUrBhebEObmkTF/pbEAaC40f8Ia0Q
         CvNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=kIh4FHvq8ePRNBrDx3FCPjMe1x8Qk7QKOwE9kc0FlUw=;
        b=uD34pNgf5wYIeO1y3WIyEfN5xDjBrfHywgZ68z23JdayhoXkDFLzoa8BIi2kiX3lB8
         4i7AlxccRE421qQoSnTpdxTDx4cmkIpx2VVfKJ5MyI9XvSS8t6GCvzAPH8iJyGfjnMJ2
         hLL2xnvuU8EDbEhM9r3Li/d+S+OPIu5pRqoVGlrvI13xy/2yPx/m/hcMlcZWe/DfdBeq
         vc8CjQVIjAcJJqFKFjIt3h4lJinKNj3ZOEeTktAoS3L9WAGMAfNzv5A3yqdMGEzTcLgM
         BOiUdMfARZoAXZraSiLDnsm0kmMsVs1y854clx4TUznxOiiX7soy8b8M+pugQ6PYY/tA
         f89w==
X-Gm-Message-State: AOAM532pxC1TJ0zRI+cNxfbvmkHZFXSWdv7fzbin0vppwErFvlJhxzoR
        codUOh0ZViYvvDWOjSPvYzNkJljTRw0=
X-Google-Smtp-Source: ABdhPJwsE8TvXJJN4srOk2ezQ6oaEqAMzl6ScUZepa+BTlfPXHgqu0LVI+15g7kGDIdecrIL8YX6Bg==
X-Received: by 2002:a17:90a:db89:: with SMTP id h9mr50288pjv.34.1606345019544;
        Wed, 25 Nov 2020 14:56:59 -0800 (PST)
Received: from bbox-1.mtv.corp.google.com ([2620:15c:211:201:7220:84ff:fe09:5e58])
        by smtp.gmail.com with ESMTPSA id b5sm4129325pjg.28.2020.11.25.14.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 14:56:58 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
From:   Minchan Kim <minchan@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, stable@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] tracing: Fix align of static buffer
Date:   Wed, 25 Nov 2020 14:56:54 -0800
Message-Id: <20201125225654.1618966-1-minchan@kernel.org>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With 5.9 kernel on ARM64, I found ftrace_dump output was broken but
it had no problem with normal output "cat /sys/kernel/debug/tracing/trace".

With investigation, it seems coping the data into temporal buffer seems to
break the align binary printf expects if the static buffer is not aligned
with 4-byte. IIUC, get_arg in bstr_printf expects that args has already
right align to be decoded and seq_buf_bprintf says ``the arguments are saved
in a 32bit word array that is defined by the format string constraints``.
So if we don't keep the align under copy to temporal buffer, the output
will be broken by shifting some bytes.

This patch fixes it.

Cc: <stable@vger.kernel.org>
Fixes: 8e99cf91b99bb ("tracing: Do not allocate buffer in trace_find_next_entry() in atomic")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6a282bbc7e7f..01bfcc345d55 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3534,7 +3534,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
 }
 
 #define STATIC_TEMP_BUF_SIZE	128
-static char static_temp_buf[STATIC_TEMP_BUF_SIZE];
+static char static_temp_buf[STATIC_TEMP_BUF_SIZE] __aligned(4);
 
 /* Find the next real entry, without updating the iterator itself */
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
-- 
2.29.2.454.gaff20da3a2-goog

