Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFC12C1965
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 00:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgKWXXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 18:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgKWXXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 18:23:47 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD365C0613CF;
        Mon, 23 Nov 2020 15:23:46 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id 1so1097124wme.3;
        Mon, 23 Nov 2020 15:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iPVFgmYNRnVYuGgxhzMYRvkwTnKqVhuuvHWyw9sWSss=;
        b=fqExvHo38WlMppex8bVVj68brBt56MspN2SZjKOYuOXVHxYJr/azwg8rJe1jw4uu3b
         UhY/L870IGIyC7KV3T+Fycb5V1T14rXoK5vVmMU9W6poEbcrptkQq7VP0eWKH97W+eqV
         HZ8JybRuIFio4EFA1FlKg4yHfJ/GF//fri08gpp1qsXur0BXk9ZLLWrqnxY+dxum2OKA
         ENWu8DEE51le2659MsXJf0Jr3rlDz86VBvfIzG/YKHZrOAfSbOETNXbL5ZpYlJQDOg5N
         Zv66jQYAvIzFhQbtZZd68+oqkMeVQhbNIvKzn+npaAt61whtC/kyxXAXwJdTycsgUrzo
         lJ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iPVFgmYNRnVYuGgxhzMYRvkwTnKqVhuuvHWyw9sWSss=;
        b=KcnTkRlOY4oHcsB6675+QZIa1CtW4PMPEaPQREPYrq4MmszoZm2PynggjDALVJE2wv
         73Q6a4a2j2sZX0TuxqTORgfWYkY3fRiI6AscRUmrHD59JBM23yH1BOaUasj91IvtIuIc
         kPphy0zRvbz2thNy4blGyFwxUtk5/XqW7MlcyhfenpiueG1X9wFQgcSkweS4OIt+0Sc9
         vvZCTU+hayWYun+nxffxLgE0XSyYnkPRPRJZed5tckj4LB9k/ywHcXppscxhRRd1UM5Q
         XQhQMNlUlUTfzzIQ1qMXUqYbg7A08uk++UtxUltJQkKkvyDZGjsX9hkxx5VyFqxkU/Ox
         sKUQ==
X-Gm-Message-State: AOAM530Ar9Kn6B1jRAZxV4WXe85rhbEtafY57+4HVMVtUAYRB2v4RiSU
        szbs/EeaY7Yx7Yen5gm5uPc=
X-Google-Smtp-Source: ABdhPJwNTSIfijVW3uSRi/z/Q5Vvm9kQAEypadvKn8zFauSOyIjbV0k6RsqgHvi+7v13adGPi7QJ9g==
X-Received: by 2002:a05:600c:2:: with SMTP id g2mr1189099wmc.156.1606173825474;
        Mon, 23 Nov 2020 15:23:45 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id s8sm22918689wrn.33.2020.11.23.15.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 15:23:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.10] io_uring: fix ITER_BVEC check
Date:   Mon, 23 Nov 2020 23:20:27 +0000
Message-Id: <26e5446cb6252589a7edc4c3bbe4d8a503919bd8.1606172908.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

iov_iter::type is a bitmask that also keeps direction etc., so it
shouldn't be directly compared against ITER_*. Use proper helper.

Cc: <stable@vger.kernel.org> # 5.9
Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 593dfef32b17..7c1f255807f5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3278,7 +3278,7 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 	rw->free_iovec = iovec;
 	rw->bytes_done = 0;
 	/* can only be fixed buffers, no need to do anything */
-	if (iter->type == ITER_BVEC)
+	if (iov_iter_is_bvec(iter))
 		return;
 	if (!iovec) {
 		unsigned iov_off = 0;
-- 
2.24.0

