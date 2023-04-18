Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED4E6E5C4E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 10:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjDRIk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 04:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjDRIky (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 04:40:54 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D0CB7
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 01:40:54 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b7096e2e4so1344070b3a.2
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 01:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1681807253; x=1684399253;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=olmN5gzlqP0NhrI47T0CCa7149+yb2ZCju0LTQmGI+4=;
        b=ageKEel5fyZv58tT025n8lqnZUiQ+cxCGVdQkICI1dh7J7VmSwxtTivqmdjU79I/Qo
         vpCBbkdrkJTlMQgLIbzVqr3aFjxx1zPt56ImFdKa4upwf3xN3L+p3gif4WHtLXkkG+t3
         Qx0i5U3/lCXRFCZn4698WdTVFJFunG2ubvagU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681807253; x=1684399253;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=olmN5gzlqP0NhrI47T0CCa7149+yb2ZCju0LTQmGI+4=;
        b=YV7XlaXnyo324O0CLhEm2FMe9oj3Zv9uTC4Yl51qKBUNhtXoLNMYVh0l9T3wpF36Sk
         Rux3L9IzUHgJly1E6v09wOMdMPsexF8mVVM9mTI0AYUaR2JwvyWNinTlwBxkuY2wP0Ak
         r2q3YH3ZYPA9zei++PF7wOGsPU0zymjDcukswBZlgrjjczAEOCWJu0+B7uX4k0f488Yf
         lqYPtu0aqTbDzwwKh/ID98ayBBRJ88LzCp+gPhA5woJx/5XyE3tsSpGRiGfSD8ks7402
         PiSpvVkMmPwNMBv7BkzkL4DzjTOOuy+hCcLevKeAPrUiV4lSjEcG7eXbM88+MvPHFaBq
         /Nsg==
X-Gm-Message-State: AAQBX9euEVMRcVo2zVEm76gufyIl7szo2Cph+NBd+shOslE8+3SdmVvX
        xpPQZSk/v2gUw+MijhDvr0fNaA==
X-Google-Smtp-Source: AKy350ZxonPvBGz2w+q2ydfxziDS0CMMutHh8UVXMlDu7WQu9HDpm3Lk0fD6oTQLzVjEnx6nyC+jCA==
X-Received: by 2002:a05:6a00:2390:b0:636:e0fb:8c44 with SMTP id f16-20020a056a00239000b00636e0fb8c44mr26317272pfc.12.1681807253493;
        Tue, 18 Apr 2023 01:40:53 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:7254:8270:74ed:755b])
        by smtp.gmail.com with UTF8SMTPSA id y3-20020a62b503000000b00625b9e625fdsm9007639pfe.179.2023.04.18.01.40.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 01:40:53 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     linux-mm@kvack.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>,
        linux-kernel@vger.kernel.org,
        David Stevens <stevensd@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v2] mm/shmem: Fix race in shmem_undo_range w/THP
Date:   Tue, 18 Apr 2023 17:40:31 +0900
Message-ID: <20230418084031.3439795-1-stevensd@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Split folios during the second loop of shmem_undo_range. It's not
sufficient to only split folios when dealing with partial pages, since
it's possible for a THP to be faulted in after that point. Calling
truncate_inode_folio in that situation can result in throwing away data
outside of the range being targeted.

Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
Cc: stable@vger.kernel.org
Signed-off-by: David Stevens <stevensd@chromium.org>
---
v1 -> v2:
 - Actually drop pages after splitting a THP

 mm/shmem.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 9218c955f482..226c94a257b1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1033,7 +1033,22 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 				}
 				VM_BUG_ON_FOLIO(folio_test_writeback(folio),
 						folio);
-				truncate_inode_folio(mapping, folio);
+
+				if (!folio_test_large(folio)) {
+					truncate_inode_folio(mapping, folio);
+				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
+					/*
+					 * If we split a page, reset the loop so that we
+					 * pick up the new sub pages. Otherwise the THP
+					 * was entirely dropped or the target range was
+					 * zeroed, so just continue the loop as is.
+					 */
+					if (!folio_test_large(folio)) {
+						folio_unlock(folio);
+						index = start;
+						break;
+					}
+				}
 			}
 			folio_unlock(folio);
 		}
-- 
2.40.0.634.g4ca3ef3211-goog

