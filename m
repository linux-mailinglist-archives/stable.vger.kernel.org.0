Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92B24E86CE
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 10:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiC0IFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 04:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiC0IFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 04:05:33 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B51E2C64E;
        Sun, 27 Mar 2022 01:03:54 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id jx9so11270148pjb.5;
        Sun, 27 Mar 2022 01:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=5XpCe/dhohQRtgxYw4qrnTYj4xTRi/aun8FZYK8rzRI=;
        b=Ln3wl1pOFR/gFdMI12yBjzwshEtLTaAljOpd3k6OOAdMrx0wY9qzv5IXx4hZr22oCv
         WMq5usgkP125k4vId0VqPdYNmxXgIVWWH2/9T+t3dU5+ARm2ZSepljayGjIUMSQudW4Y
         WGTzmKWOQoRvQTY88VCMY6R6TEx9JlsRTgowEjKz8lAZ2XCzpfy41+uY4kD3Qn++XxvJ
         Uw2vq+hkL0C2IiPeajev9mhqA2WhRc1qSbN2ZJEfBedsQWHlId/y3hUPyBIeODsgLsqy
         OaU2Ra/wnUDh84gWhon4s00tnYbj0gJWEKNyI8pfOcmWb6ZNLtZGVtYJ+pa9M8iS5PQ+
         w+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5XpCe/dhohQRtgxYw4qrnTYj4xTRi/aun8FZYK8rzRI=;
        b=1P1PDSf89ni7ZO6gnzFUHKTk4ORYov8W8HrAAZuOueRb2hGxQoRBmANjBch8dRUfYc
         qXkn6rIVU6uNDpvbq5Qwwtd+QyllRG5EeLKBJdPJOO3RO/hoXKpCBE3CHZ5ELTXVZwPN
         uB4DlTKbzUJCFEptjAoUKoEBhqGomkkPJnmhke78taucwjEbRmM47R4DBgLVct7Dt9V9
         7xOxv8XZ6ztAZ608N/HjwKqhh7C+6qJZeeKkc2k0rYO79TN+GzjHIvzAvOzB7ivp2Fmg
         WXYhpCEyR0ciRrdjhy2nXjSTy3Q6W0ZipQA5MUlCbUClF6BNuUJ9sx3cABkGfs4qwV7d
         8Cxw==
X-Gm-Message-State: AOAM533UV1UBk3sCqXGVZu/J1d0+PE2sRQRBhb6uUb8Cp2S6nXmr4dlK
        S97ecu7kfeUw18oyp/sMsQo=
X-Google-Smtp-Source: ABdhPJwau6MqIHbu+LZ/UCfLHdpIQifopUQhgTPr01bqpIiL25L4v0r2Bjv7OX5yEq8LLa/I1w/3Yw==
X-Received: by 2002:a17:90b:38cf:b0:1bf:42ee:6fa with SMTP id nn15-20020a17090b38cf00b001bf42ee06famr34435669pjb.9.1648368234032;
        Sun, 27 Mar 2022 01:03:54 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id k137-20020a633d8f000000b0039800918b00sm5989617pga.77.2022.03.27.01.03.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 01:03:53 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     sj@kernel.org, akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] damon: vaddr-test: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 16:03:45 +0800
Message-Id: <20220327080345.12295-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	KUNIT_EXPECT_EQ(test, r->ar.start, start + i * expected_width);
	KUNIT_EXPECT_EQ(test, r->ar.end, end);

For the damon_for_each_region(), just like list_for_each_entry(),
the list iterator 'drm_crtc' will point to a bogus position
containing HEAD if the list is empty or no element is found.
This case must be checked before any use of the iterator,
otherwise it will lead to a invalid memory access.

To fix this bug, just mov two KUNIT_EXPECT_EQ() into the loop
when found.

Cc: stable@vger.kernel.org
Fixes: 044cd9750fe01 ("mm/damon/vaddr-test: split a test function having >1024 bytes frame size")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 mm/damon/vaddr-test.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/damon/vaddr-test.h b/mm/damon/vaddr-test.h
index 6a1b9272ea12..98b7a9f54b35 100644
--- a/mm/damon/vaddr-test.h
+++ b/mm/damon/vaddr-test.h
@@ -281,14 +281,16 @@ static void damon_test_split_evenly_succ(struct kunit *test,
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_pieces);
 
 	damon_for_each_region(r, t) {
-		if (i == nr_pieces - 1)
+		if (i == nr_pieces - 1) {
+			KUNIT_EXPECT_EQ(test,
+				r->ar.start, start + i * expected_width);
+			KUNIT_EXPECT_EQ(test, r->ar.end, end);
 			break;
+		}
 		KUNIT_EXPECT_EQ(test,
 				r->ar.start, start + i++ * expected_width);
 		KUNIT_EXPECT_EQ(test, r->ar.end, start + i * expected_width);
 	}
-	KUNIT_EXPECT_EQ(test, r->ar.start, start + i * expected_width);
-	KUNIT_EXPECT_EQ(test, r->ar.end, end);
 	damon_free_target(t);
 }
 
-- 
2.17.1

