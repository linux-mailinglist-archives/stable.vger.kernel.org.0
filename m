Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C4F456250
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 19:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhKRS3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 13:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbhKRS3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 13:29:37 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3E6C061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 10:26:37 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id b4so6139634pgh.10
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 10:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BePHryJRh+AZFLFJTMvFMe11XPIwb1r0oyfzLnxL9yk=;
        b=Q0s/92hw51pnLxTl512a09hj7EXPcQvOimJk/FoQvgbIKq3NEsayear2nuBBFJrtvM
         3K+MjFpHh1+aOizb3sDJK0cReddz3Ixkc2AWiQemzWBhrvZ1Oo6Q6HFUytTOIXq2Lssn
         vVpMFpF/fiU9d6qBGwPBkE9VTr9+8nOrn7lK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BePHryJRh+AZFLFJTMvFMe11XPIwb1r0oyfzLnxL9yk=;
        b=ncH1ZBPv1JxZxLf7FBL61QhxWLomOfz/w1BiGNBAYA5PxQ7/pijqRGkSbVccO1Wu8q
         hAZenrKMbHrYPm06ukgK1CeD07hzKMX8bAzw8JDPEnflpByagjBehJZP6VKBHuGBXgZJ
         jONs+paTDtiIow7/xQ6glJGyggpiManehm50xeM1SYLKQU7tdcqSxW1kBCr1NwCkB8SJ
         O3Ti0MvD6l7hUiR2UyJ3UJauemoFE7MMWYntgpsDtEvzRhhTmyDh4/H4m+6UAKN0EnNA
         18F6ZLcUZ7CV2cPiBp0dq/PHWgnTiZ/BkeBc6ilkvTtcNN2LatdYwjVckS/w/3naiemP
         g+KA==
X-Gm-Message-State: AOAM5308lkfq/Xb7mNLNaxkjoAKEU9Ah51IeJwWIPZUutvdvywXz1Ih+
        A0nGXiBRcQXoc0HwnJ3jUhTTEAdAv7JYQg==
X-Google-Smtp-Source: ABdhPJxF+0AU1EU7h9D4ori8ZbjaAYZzA1RiyFcSgEhW0DF7iUiaUX3yZH1/NG9IPeQzxjrfsGDlHQ==
X-Received: by 2002:a63:b50d:: with SMTP id y13mr12575488pge.286.1637259996897;
        Thu, 18 Nov 2021 10:26:36 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id pg13sm285664pjb.8.2021.11.18.10.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:26:36 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kees Cook <keescook@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] pstore/blk: Use "%lu" to format unsigned long
Date:   Thu, 18 Nov 2021 10:26:21 -0800
Message-Id: <20211118182621.1280983-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1656; i=keescook@chromium.org; h=from:subject; bh=3JoUp8iGWo9rrwqZSi2U2+JRY+ohAhlH98w56aP/tVY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlprMCjaJRyXQlBB2411Zg0Yb0swKuTRbhm/1v0oA 6zsVmq+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZaazAAKCRCJcvTf3G3AJrwGEA CrktTH4VCpYYmn+WNRgS1vXlQN26UEpP59YyU/NysfqU8JEtwg6/3ikaSdSTq4LAIliX+DJLn0vM7e GkY8PVV6S+WqqvAkuhn0K5DMCc3W+Z+rVKMRHwBx4XQuDXY/+CpwMvYEcFR3D+kU7CuqPqKGM4uMXL PTzk2hoRIUCsYP5IUdXMY3E4mCyEaGDeZB9jhmYD8M4JtiuzIfSecDemri+InHkTUAcJXltHdKH/eL kREKM6eRSs/B9vlGy5sjRBR+Uwq898cqnssxkf0VmJJqHw6YXFIyE1DsdMWDIHx968RuABNGdf5iP2 dlVljRSAG+dN3fhVJPgVjuZh8yh6ybRzN7LXaUIxQA609k64Q98vfjbCc8ndxSylWgQoCECgJgGq5e S4aCRDRaK4ZOs+GfLpij6Eew7enY6NPF9e48jINkom1Zvyp3eXqz6KcC9h0NRt4Xv5PVz6mFBK9hBn UcRXMlxBwEXYEqH1uDfSaDH9ImvDbe3sUDIjJoipKqX4ZcC0SnGNNpksEr5mZIiUxY0lhRB0HM0bFd xoVRkl5V4s1QpMxJjxvH+SD5s0GUqQWBnD6u+p0vyqVirb3Tgik5QOBWtGUE3ke+WZeZcAiQpfO618 72b1hIDmQfQydccPIefcnRlLClhrn6fJNi/SRg6ZESNbN4IRvoJkRybGpKQg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

On 32-bit:

    fs/pstore/blk.c: In function ‘__best_effort_init’:
    include/linux/kern_levels.h:5:18: warning: format ‘%zu’ expects argument of type ‘size_t’, but argument 3 has type ‘long unsigned int’ [-Wformat=]
	5 | #define KERN_SOH "\001"  /* ASCII Start Of Header */
	  |                  ^~~~~~
    include/linux/kern_levels.h:14:19: note: in expansion of macro ‘KERN_SOH’
       14 | #define KERN_INFO KERN_SOH "6" /* informational */
	  |                   ^~~~~~~~
    include/linux/printk.h:373:9: note: in expansion of macro ‘KERN_INFO’
      373 |  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
	  |         ^~~~~~~~~
    fs/pstore/blk.c:314:3: note: in expansion of macro ‘pr_info’
      314 |   pr_info("attached %s (%zu) (no dedicated panic_write!)\n",
	  |   ^~~~~~~

Cc: stable@vger.kernel.org
Fixes: 7bb9557b48fcabaa ("pstore/blk: Use the normal block device I/O path")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210629103700.1935012-1-geert@linux-m68k.org
---
 fs/pstore/blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pstore/blk.c b/fs/pstore/blk.c
index 5d1fbaffd66a..4ae0cfcd15f2 100644
--- a/fs/pstore/blk.c
+++ b/fs/pstore/blk.c
@@ -309,7 +309,7 @@ static int __init __best_effort_init(void)
 	if (ret)
 		kfree(best_effort_dev);
 	else
-		pr_info("attached %s (%zu) (no dedicated panic_write!)\n",
+		pr_info("attached %s (%lu) (no dedicated panic_write!)\n",
 			blkdev, best_effort_dev->zone.total_size);
 
 	return ret;
-- 
2.30.2

