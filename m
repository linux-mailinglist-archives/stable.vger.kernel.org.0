Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371502F9076
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 05:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbhAQExQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jan 2021 23:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbhAQExP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jan 2021 23:53:15 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17523C061573
        for <stable@vger.kernel.org>; Sat, 16 Jan 2021 20:52:35 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id my11so7056085pjb.1
        for <stable@vger.kernel.org>; Sat, 16 Jan 2021 20:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/c3AUuHNj8aviLYKvtDgdT//v0Yif6ZnqYACRpUShpI=;
        b=DSTUciZgm5waG3hnpdK2Zn9VEzLf/iAIDm3JN3IheUhj+IsJFyKZLm1qVuJRrhdgCy
         eP3eYpZgYe0BzW6klkX08TRak6x/PoVxYRIZ9SCNJSX4T8oo1Gw9rbi9CFXvZjOuB9up
         R7tEDpEoyy3TsVdsEYVSxkDu1ZOES9oBQe5RzdvNG/l8p+W2wL0AbYC97pFEFyH39LlK
         SDTAiumqkhXjjx48mxDN1aCXghcpw0uQx/jsyymd/Kbd01JNnEUQXZMKmZ5/NTfhPKy+
         brWUTfODomnvSXEfCwHXcJt+ao6tjOI24jwTWQEWt74e4YMpe1DyNg1pilVzBwv9uVbo
         Qp4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/c3AUuHNj8aviLYKvtDgdT//v0Yif6ZnqYACRpUShpI=;
        b=Fs7NV80SIowZfBb5hBrz0vni2QSuJQx1tmB+BQcIltufhOhxDEnJDsm/vEFz9VbJfp
         nsTFI79xio6BilbZoB/rI1JaBOcVvO13XZVq5J2z6oEM0KCCXO5/RJGbbAQGEWSF26ZZ
         CU28ZVathUlNqJmKOOSB1up96C5D98vLNC5fIWi3nsbtaX8BHFgEZa0lw1g07vZi66pW
         W5nMhtWeQK/h1FYHTDo1ESrEg9tFQ1Sn9dd4Mwmjv5DLYpew2+3y8pMwjlgsf36EmyAP
         lKW9TK9ZdR6jjyy4V28hP8HG6f10805RQuF1xyC0H6VkETkB+roMVlL+s7bd3bA6k2zE
         DVSQ==
X-Gm-Message-State: AOAM533l3nVfIIyWcOxcJZ4p0lygjaXMuAUDZKMJUDJArlAJHCux7BKN
        Mm6nqIm4EM//I5X+bP6ywiQ=
X-Google-Smtp-Source: ABdhPJxaxzeLvLpx65EZTx8J4VYkHtwKmblD9WXdXqUqr95IfWQwHFYYHLtT80OvJSfBgClm7BJ6SQ==
X-Received: by 2002:a17:90b:1905:: with SMTP id mp5mr16412268pjb.205.1610859153641;
        Sat, 16 Jan 2021 20:52:33 -0800 (PST)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id z11sm12359355pjn.5.2021.01.16.20.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 20:52:33 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     2225233704@qq.com
Cc:     Menglong Dong <dong.menglong@zte.com.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Wise <pabs3@bonedaddy.net>, Jakub Wilk <jwilk@jwilk.net>,
        Neil Horman <nhorman@tuxdriver.com>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] coredump: fix core_pattern parse error
Date:   Sun, 17 Jan 2021 12:52:28 +0800
Message-Id: <20210117045228.118959-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

'format_corename()' will splite 'core_pattern' on spaces when it is in
pipe mode, and take helper_argv[0] as the path to usermode executable.
It works fine in most cases.

However, if there is a space between '|' and '/file/path', such as
'| /usr/lib/systemd/systemd-coredump %P %u %g', then helper_argv[0] will
be parsed as '', and users will get a 'Core dump to | disabled'.

It is not friendly to users, as the pattern above was valid previously.
Fix this by ignoring the spaces between '|' and '/file/path'.

Fixes: 315c69261dd3 ("coredump: split pipe command whitespace before expanding template")
Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Wise <pabs3@bonedaddy.net>
Cc: Jakub Wilk <jwilk@jwilk.net> [https://bugs.debian.org/924398]
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/5fb62870.1c69fb81.8ef5d.af76@mx.google.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/coredump.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 0cd9056d79cc..c6acfc694f65 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -229,7 +229,8 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm,
 		 */
 		if (ispipe) {
 			if (isspace(*pat_ptr)) {
-				was_space = true;
+				if (cn->used != 0)
+					was_space = true;
 				pat_ptr++;
 				continue;
 			} else if (was_space) {
-- 
2.30.0

