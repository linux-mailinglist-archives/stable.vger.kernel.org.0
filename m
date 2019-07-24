Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEDBC74080
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbfGXU5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:57:11 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39945 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387468AbfGXU5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 16:57:11 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so48263785eds.7
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 13:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g7jmVKgAMZ0EJjJYcTyuRaBKrONt7LnrJf96N5smSSA=;
        b=wgsq9IQpg9+qVQjxnd9Y1p7HWUT3susRAAqLhpdvwgNZQw5HKaP9yJgTwo0bpyu3uD
         f0vUHzuSRD59YPWU0nuhaToKSdb4a6P8SDJlDl1JIO7aP7lxLON1Zoich7CM8XW0zCUJ
         Fh9DMO+gCyF/6GtU7S5S8qPHDOjft70bvXrilxxUj8dj9Z/f7j1ggUzXHZ84FRTvbCkk
         lb3PE1LSHqYk1WMURenHJHa7TGHEg4ab//VLurfKO97uDP7pSmjHheY2n28bFsVkOkZo
         +OG0vW/Q+eSjO5r2MbaxGyfVWmCm9JoJaJVT13v9CYZdzHcgvPwoGZlboAy70bsoMTD1
         h2+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g7jmVKgAMZ0EJjJYcTyuRaBKrONt7LnrJf96N5smSSA=;
        b=cXbJwS14b5BGG0OB7Zt41Vt6Xq8Aw0CWtS7hqkBLSfgtSth/iaUdxiIV5AfWbTuyas
         LHFG5ZkgFjnrvd5lL2SHfVXpBDO/L/H+gOo2IxpRZzplVCuLYL1ANWRclOq8fOwj7fcN
         rVl2F08dr1y9hvydd9p6v/1elMo1Iu/faDRjnPPmqq1Di+HIfVJJiPPuEAXuSZpTfVER
         NaMAhh6wt+BbBjdWsUjLxf4hzYQqnNjSB0mv545bGo1SXHY2aGPBtoPk2+ezuqGAd63Y
         k1PIReYnWhayLQzx/k3O3uxJ7WhktwB+D0L0LQZxG534mNVJyb9VK+fy9FwJxBEYXmMi
         rxDw==
X-Gm-Message-State: APjAAAWvU7XFBGgG3QdApgtafN4tvc4MBIShM6fVFERYwH6rhsoxOeT+
        rgTOm2Y2dCWRk31NfUuChExp0g89LuX/+g==
X-Google-Smtp-Source: APXvYqyIkEwFtCpOUU/R5L7cPJ7FxUJo0Hkz33jhY6s9b1++ydLhk0FFrcg7Vu235EwDNvgA9MCWNQ==
X-Received: by 2002:a50:fa96:: with SMTP id w22mr74576385edr.45.1564001829041;
        Wed, 24 Jul 2019 13:57:09 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id g18sm9358317ejo.3.2019.07.24.13.57.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 13:57:08 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     stable@vger.kernel.org
Cc:     asmadeus@codewreck.org, sashal@kernel.org,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 3/3] lib/strscpy: Shut up KASAN false-positives in strscpy()
Date:   Wed, 24 Jul 2019 22:55:57 +0200
Message-Id: <20190724205557.30913-4-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724205557.30913-1-matthieu.baerts@tessares.net>
References: <20190724205557.30913-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

commit 1a3241ff10d038ecd096d03380327f2a0b5840a6 upstream.

strscpy() performs the word-at-a-time optimistic reads.  So it may may
access the memory past the end of the object, which is perfectly fine
since strscpy() doesn't use that (past-the-end) data and makes sure the
optimistic read won't cross a page boundary.

Use new read_word_at_a_time() to shut up the KASAN.

Note that this potentially could hide some bugs.  In example bellow,
stscpy() will copy more than we should (1-3 extra uninitialized bytes):

        char dst[8];
        char *src;

        src = kmalloc(5, GFP_KERNEL);
        memset(src, 0xff, 5);
        strscpy(dst, src, 8);

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 lib/string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/string.c b/lib/string.c
index 1530643edf00..33befc6ba3fa 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -203,7 +203,7 @@ ssize_t strscpy(char *dest, const char *src, size_t count)
 	while (max >= sizeof(unsigned long)) {
 		unsigned long c, data;
 
-		c = *(unsigned long *)(src+res);
+		c = read_word_at_a_time(src+res);
 		if (has_zero(c, &data, &constants)) {
 			data = prep_zero_mask(c, data, &constants);
 			data = create_zero_mask(data);
-- 
2.20.1

