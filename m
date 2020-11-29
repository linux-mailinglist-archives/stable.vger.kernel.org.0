Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF2D2C7AB3
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 19:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgK2Shf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 13:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgK2Shf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Nov 2020 13:37:35 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF86C0613CF;
        Sun, 29 Nov 2020 10:36:54 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id w24so18227289wmi.0;
        Sun, 29 Nov 2020 10:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9kXsDXNxleufXRhATKpjraGLjJabF9PaHKMZ+hMzp4k=;
        b=GaoeYku0/UJ5zNxFBdjLC+o2qRqgOJenb9RuRS2lNA2WBNTWEBM4gc/paDwov6yN5z
         7MSUq6KmwBltYdFnxTgcYGXj6oYKXmT2uwnK0wygfhMuneE9NPvKTEo6TJMikZr05nxx
         RMvA5M44qDu0FNGyBYoVL5Ub32rr+3MfwbTj/IOLemC5bgmt0CtYwzPdtPE+jcqRbd71
         TR2JbSR0iKFVoUEarRpLWGNeMLAmOYaz7ricdx+PpwgTvh21tZ6sN5/7aa4y07jHBLQH
         RtSdwmNWcy/1f8a746YHZ2xr3KEvlcz816Sl1RXOTJpmVkmySk7ADW6HvKXU8lBneexe
         WjzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9kXsDXNxleufXRhATKpjraGLjJabF9PaHKMZ+hMzp4k=;
        b=JWyu3DVayDWvVs8lVNbjJ238PVx3mbtldoADh1MU/0LJwvrlQJ4fEGxoEt6i7VYJlj
         ouPjIEwqGHB6/jhxjJabq/T4vO8cAf8RYkq3GbesV//qwuDUrhup3x19lhnbiirkMgKP
         k2m+WLYReBDZLvo1VK8y+3Fabe0zezYjTZCFbjYqRlSUeM8vnY18yA8NtVZPzLfdG0DL
         vfIDPAT/SWljKzpRuPdnQy1opmIV4wmmGhcvFjgGHq1tE4uzATay5VApEqUBvQ9lzE1J
         l+EQcNc0Vs37tVYwbSO81T+C7iALtvJILvhFUfeg6Gg/gEy3NyHiEur5yNW+M37Cgzki
         gpSw==
X-Gm-Message-State: AOAM533wgVRQXeBwSuSjCttpJHxuVRX84L5JEbZeovS7Hr4e5s0mq6xF
        eD+v+O+wOl/hqiaCQkWZF98=
X-Google-Smtp-Source: ABdhPJwqqw5XxYuWrveePQ/bId6rJ729hPkSZFVzw6vJex2ol6ba9GY9+cjodfyWt1+C2pG7c3Sxrg==
X-Received: by 2002:a1c:9c53:: with SMTP id f80mr19371063wme.19.1606675013769;
        Sun, 29 Nov 2020 10:36:53 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id a18sm18003443wrr.20.2020.11.29.10.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 10:36:53 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 5.10] io_uring: fix recvmsg setup with compat buf-select
Date:   Sun, 29 Nov 2020 18:33:32 +0000
Message-Id: <70a236ff44cc9361ed03ebcd9c361864efdf8dc3.1606674793.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

__io_compat_recvmsg_copy_hdr() with REQ_F_BUFFER_SELECT reads out iov
len but never assigns it to iov/fast_iov, leaving sr->len with garbage.
Hopefully, following io_buffer_select() truncates it to the selected
buffer size, but the value is still may be under what was specified.

Cc: <stable@vger.kernel.org> # 5.7
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1023f7b44cea..a2a7c65a77aa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4499,7 +4499,8 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 			return -EFAULT;
 		if (clen < 0)
 			return -EINVAL;
-		sr->len = iomsg->iov[0].iov_len;
+		sr->len = clen;
+		iomsg->iov[0].iov_len = clen;
 		iomsg->iov = NULL;
 	} else {
 		ret = __import_iovec(READ, (struct iovec __user *)uiov, len,
-- 
2.24.0

