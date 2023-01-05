Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2997F65F415
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 20:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbjAETFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 14:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbjAETFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 14:05:19 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE605F93A
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 11:05:17 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 6so23295926pfz.4
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 11:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i2SehKkCBcqja+K3E3ORe72aONi2D9OxK5bIcUd12dM=;
        b=awXTcU/LbB+ePHWF7idkRiNofo7lYdnPNZubDcIq8IyKIbBx4SHToTwvZ4OV6bt62I
         0xkDJgInKm6CcvC0xZdUxeT8ck4FAr2l8s6IPAmGvBk4YxUO5+6wHmOL9R0/V/STgtZi
         oD53HoCVjmTchna2qMebJgQvJHDgTo/GMr8q0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i2SehKkCBcqja+K3E3ORe72aONi2D9OxK5bIcUd12dM=;
        b=v1yIermeppD7kUDnxGBCEjw/dDjl9h752/DOuiQybblaf+sas3Hcq9s0Q8f9JbNbum
         ZAlLcLFQQDK3Lnvc1o49q7/kn7OB/VDZsKiZyc4dzdlV7Nycz0R4UsPwptyd4+UjdQR5
         5WGyS2sG+ENiJ+8eWV4to0qgKqFAGJ8mf1jwoShrYB35+nyz+SZqcGlBor6T9jLvNR9T
         oy4gyXWTALqJVKUYkd3e8lyekE6jvI+TTkYIiuKeESgcU/pTCPTcwcc1VAeV78lyz43N
         tZLMvvLZozsytB+v4gQyAjv22+4WfwkbD64QJ4TxeX7eVNrq/S1WfWQ6jcEMt8zi1o0f
         5UMQ==
X-Gm-Message-State: AFqh2kpvbeSzr1sox9XM2y85AnU8XvBBwxqOIIDcPEpOhJR3UyX85hj0
        9Pba9I1YzdyhFZHxsLyx8PosFQ==
X-Google-Smtp-Source: AMrXdXtK4AY6OU0q3gvuV8uf6l3+SAQOjqiJHSlFSiROGKNvtDKWd9vlFkDVudKh7pEgLT1px+78TA==
X-Received: by 2002:a05:6a00:1747:b0:582:7d41:c8a4 with SMTP id j7-20020a056a00174700b005827d41c8a4mr21331148pfc.15.1672945517261;
        Thu, 05 Jan 2023 11:05:17 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f193-20020a6238ca000000b0058269b74da9sm9007525pfa.95.2023.01.05.11.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 11:05:16 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kees Cook <keescook@chromium.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        stable@vger.kernel.org, io-uring@vger.kernel.org,
        Dylan Yudaken <dylany@fb.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2] io_uring: Replace 0-length array with flexible array
Date:   Thu,  5 Jan 2023 11:05:11 -0800
Message-Id: <20230105190507.gonna.131-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1952; h=from:subject:message-id; bh=SWcBV/lk0yg6EOGEoIKozkewCZaGNeQRZtq6oIzzPPY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjtx9n4cZXq94FvnrGkXShFgmcog+jiuB2B/m25yUW xThqRSiJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY7cfZwAKCRCJcvTf3G3AJokvEA Ck4FZY8ra48dMW1t/xvAdzEHf3VLqCDOmJEJTLTkHW3PQYAo0qlzsytzi/4ZKIEcY2AkyW2nn4I/e+ nKckG2kSBcnfT6zXjVbpfr8rLmpV2zndLux7yq9fqqcZBr+EtIzmTNnprZ0RfkuvrSgyu/9hiTx4oy 6qItkMQHCUUxK/QQOyIiKVJHANzZr/FCvfG7EWVjNpCM/BjtdyBDwLfFAGgJqk7meXdJXkW4t55SUN ROHlaYDGSEhCCBzOws2QGDshmXpPuBeVcZqAyu/8wy/44SNlAA401xOQGVrWnFzW5a1pVppnwZZXkT RT2kw0uGFISD7lI5arKAVyYfa2go2+nLLyMnYSoQsljJ1BUnlLstXPKk5Q8wnDG7ffE9prj5mbpEXu o4XL+eUnU92nZKLl5HF2DIhFOlU4sGo7LhHfExEzSCDEgLM/FiLEZHUpkZX5egJb/EAlmz5IjxvyQ4 3AuQKG5wnvfs0VAN55jsv+xd2VifaCOQZpwteZdimwEYRdeUl2fQEuhEunkIEEfqcAVUJFCZjOIlLt SzXtMQPiEgRrcxuBvEhKuG2XzQa2+pYmDN7IoqEU3fJLcRYtE0SM375keiRvqL1OOhrMdad1uinIbY qRUpSu/yGoZPGi6saEr4fpsFHuMLhrSYz5hia2CmbnnRX5py3pXE6IvZYvGg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Zero-length arrays are deprecated[1]. Replace struct io_uring_buf_ring's
"bufs" with a flexible array member. (How is the size of this array
verified?) Detected with GCC 13, using -fstrict-flex-arrays=3:

In function 'io_ring_buffer_select',
    inlined from 'io_buffer_select' at io_uring/kbuf.c:183:10:
io_uring/kbuf.c:141:23: warning: array subscript 255 is outside the bounds of an interior zero-length array 'struct io_uring_buf[0]' [-Wzero-length-bounds]
  141 |                 buf = &br->bufs[head];
      |                       ^~~~~~~~~~~~~~~
In file included from include/linux/io_uring.h:7,
                 from io_uring/kbuf.c:10:
include/uapi/linux/io_uring.h: In function 'io_buffer_select':
include/uapi/linux/io_uring.h:628:41: note: while referencing 'bufs'
  628 |                 struct io_uring_buf     bufs[0];
      |                                         ^~~~

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: stable@vger.kernel.org
Cc: io-uring@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2: use helper since these flex arrays are in a union.
v1: https://lore.kernel.org/lkml/20230105033743.never.628-kees@kernel.org
---
 include/uapi/linux/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2780bce62faf..434f62e0fb72 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -625,7 +625,7 @@ struct io_uring_buf_ring {
 			__u16	resv3;
 			__u16	tail;
 		};
-		struct io_uring_buf	bufs[0];
+		__DECLARE_FLEX_ARRAY(struct io_uring_buf, bufs);
 	};
 };
 
-- 
2.34.1

