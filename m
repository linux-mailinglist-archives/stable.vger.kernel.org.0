Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CCB593105
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 16:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbiHOOwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 10:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiHOOwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 10:52:10 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD5213E8B
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 07:52:08 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id z14-20020a7bc7ce000000b003a5db0388a8so1684096wmk.1
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 07:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=QyfInw3SinvvxHPXWWwPy0IkBa9nuBxYZKgCC5o+lhk=;
        b=bFbbZx/A6FLFU9sjqyXpmNybVclvugcitztxieuHeIPMjNML457cSt9//hqmMtw/sN
         9jSb51ulCqSUAiKmll568C+8ZjhoRfgckGlEwPTiQ6iYGvFlo7K1oidB8dmZ3TcTt/uM
         8O+NAnr25Vu6BdW6gCmI4wnu+5/dS24ZFxGkMRLFI+DejKtIJobgTBz7csVGOS6j0ojG
         hBU/tA6+zGVMTSfFVsuN66ZMLCwFlCCDv4nONtyE8rdfZV4mDYeTELG6Of4BLUbD7Dr8
         erW2v707TOSim3eL32+U6srCs18yczdsOIA9JVb6uJr/OIbW7k3748CYheYwq37RN4is
         L8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=QyfInw3SinvvxHPXWWwPy0IkBa9nuBxYZKgCC5o+lhk=;
        b=J/WI7neE8O02L6W7vTjb8dHpJHFRVNlHM24gf2zce97VCVjqTnLOJ/jf/V55Bbh4Ce
         HJnZz1MdT4IbansMY87TV1IXLrMgBpEsud7ulP/ZeiY9D9CB0x8t0Gqrfs9paEzXMBt0
         4aB5myrDQgjf/pqR9LqrDnyEImvMDGzi6FVxlzRXjogV47P6yqxgkNo7ZTnbcs6eJvWT
         g6nz+4bRRuLhrWr1kOHLj3l3AexH8kGGCrQzARCKkm9C9ufTh0o2589vQG5FbFRVYCRh
         1HA7yH6Wt7n2zv9IZpbw4QStJZFkzHSn7WO1j/uxOPcTnYRoEjeQyA5gNL9H+lU45x/Z
         vXoQ==
X-Gm-Message-State: ACgBeo1j/0MjlS2/sKOx5HEtlW+8kX8K/SEbNxHu0nVt7Bqgl9IFbT0o
        GRpkLbKzTp43bXFkRYzCvWE/rrOo9RE=
X-Google-Smtp-Source: AA6agR4vHHHFcfSyIg+/BzZswNSpoI/ZqlbA9CIcfJeS15x1EGtlKPpLqosLmU5Td/XgSHsk3hYF3w==
X-Received: by 2002:a05:600c:1d14:b0:3a5:e8ba:f394 with SMTP id l20-20020a05600c1d1400b003a5e8baf394mr5067050wms.137.1660575126307;
        Mon, 15 Aug 2022 07:52:06 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:886])
        by smtp.gmail.com with ESMTPSA id r17-20020a05600c35d100b003a38606385esm16014213wmq.3.2022.08.15.07.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 07:52:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 1/1] io_uring: mem-account pbuf buckets
Date:   Mon, 15 Aug 2022 15:50:12 +0100
Message-Id: <97b8d519d72d5ec81e4b5f9cf35a38e7c56179ae.1660574466.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit cc18cc5e82033d406f54144ad6f8092206004684 ]

Potentially, someone may create as many pbuf bucket as there are indexes
in an xarray without any other restrictions bounding our memory usage,
put memory needed for the buckets under memory accounting.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/d34c452e45793e978d26e2606211ec9070d329ea.1659622312.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9bff14c5e2b2..0ce1587df432 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4477,7 +4477,8 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = io_add_buffers(p, &head);
 	if (ret >= 0 && !list) {
-		ret = xa_insert(&ctx->io_buffers, p->bgid, head, GFP_KERNEL);
+		ret = xa_insert(&ctx->io_buffers, p->bgid, head,
+				GFP_KERNEL_ACCOUNT);
 		if (ret < 0)
 			__io_remove_buffers(ctx, head, p->bgid, -1U);
 	}
-- 
2.37.0

