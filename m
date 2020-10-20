Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46456294543
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 00:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410451AbgJTWxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 18:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410448AbgJTWxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 18:53:30 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C15DC0613CE;
        Tue, 20 Oct 2020 15:53:30 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id n15so96760wrq.2;
        Tue, 20 Oct 2020 15:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8xwOX1wGQ4kRH+yi59Vnc3TmWT0s7ByJ8bzcObDDX7Q=;
        b=ON5D7qGIrN/mzBiPook+4cQJ3NpDeqHDWk+nMEJIB7VHsm59H6fDxj7TgJ3giqIZVi
         esB3UtIx8jYonJ54zkGI1e/oxfBBTMLYMqqWncVD+HGMQzuIYDDmiI2KaZNLeW5bC1Na
         09Fv17i2BtRHPEp8qTjZoBEYv6hTFNecjxmrRIKZGWtLIAC69tK1VyMYb+MB+jcMUyET
         a90XnX31PsWGOsDEURjGs33MQbYa+dCJcSs8A328kbn35Lb5lawjRnd6sqW2kbu0PI2J
         ESKenooopyuR900y47lkug4Q6Q1yfxRWrU2qX8OFs3mOvJXR96wd7awk1SwH5dRB7p7q
         59fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8xwOX1wGQ4kRH+yi59Vnc3TmWT0s7ByJ8bzcObDDX7Q=;
        b=JRHUltWPxPSioKYQvbvWZgAtwOm8n41xWkbgqmnN7XGt8My8pr3D6d6w3IjSYkdQ4a
         ET2ZSLF2DFiZCGzhH9rgAmvZMCC2noSMUIUrb3qCzQXHDOKkIayeCcxq594W0vfve6dH
         lmL6Bo7/2Q9fOhSOIGD1QTO7DnttDzStdFFeLmOGfET62T5Y3sER7D2G+kI4RfL3wJAk
         H1YJjrmqqvS2ABaKQD5efGLZQ6QMuuirnsah2IpzW5ZFNVUIdp8avTkp/ndznymFXCv5
         9k0VG57pPjV0Df+zNWrYqSPY3Go94TjosBSAG7x51H3+pcpZaJwUvtjyQtYXPzmAnhnL
         6aHg==
X-Gm-Message-State: AOAM5339sGVXzsKrurdY4ag6qWbDKPvKvwlkWwtdFiHV0ZhmNzk8XNAi
        gDjN8t7ek4dv0k3173B9jdwi5eIMX/brrg==
X-Google-Smtp-Source: ABdhPJw9TbYepD0LjrHyQx6+g06HRp6kkcDs2MVSNCz9+IbI8xbFgycL1Hj6/Q04br8VVv2ksbYMzw==
X-Received: by 2002:adf:ec0e:: with SMTP id x14mr745893wrn.204.1603234409218;
        Tue, 20 Oct 2020 15:53:29 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id f14sm292830wrr.80.2020.10.20.15.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 15:53:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] io_uring: don't reuse linked_timeout
Date:   Tue, 20 Oct 2020 23:50:27 +0100
Message-Id: <10d1ee288a9a352ec8345fcdcd4c6b6827a12cd1.1603233677.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clear linked_timeout for next requests in __io_queue_sqe() so we won't
queue it up unnecessary when it's going to be punted.

Cc: stable@vger.kernel.org # v5.9
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c4e54728175e..8e48e47906ba 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6235,8 +6235,10 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 	if (nxt) {
 		req = nxt;
 
-		if (req->flags & REQ_F_FORCE_ASYNC)
+		if (req->flags & REQ_F_FORCE_ASYNC) {
+			linked_timeout = NULL;
 			goto punt;
+		}
 		goto again;
 	}
 exit:
-- 
2.24.0

