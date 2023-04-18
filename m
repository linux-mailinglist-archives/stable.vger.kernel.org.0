Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E716E595B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 08:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjDRGWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 02:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjDRGWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 02:22:33 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1248A1BDA
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 23:22:12 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b5312bd4fso7973248b3a.0
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 23:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1681798929; x=1684390929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TzsJOek1xUBUP3YBf2eRQeEhD3Svo6XZElWtbVkMay8=;
        b=YG8GY9X07EnaHeXxr8wLKzOvzsN5/4sI2DjM+Hs7zCu0UrsPJpTXrkguwMwOodWMhj
         YuWGFpmoa/JBZbBQUPXduM796ikNDuaA5AqxnGk4Gxr6LOwHK4xb9zKQkU5j2KjSvTwq
         G/oom33AwqUG8m+kYYxiVYv7qucS+Xzh21xCQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681798929; x=1684390929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TzsJOek1xUBUP3YBf2eRQeEhD3Svo6XZElWtbVkMay8=;
        b=YrwubdZBGq+YddwkHz6gri4DT5hJ5IHQL4WBYGP14iio93i7qzMifEO+91yz1VnImB
         s/8/idjJH2QfdVW+pB/vMd23xr/5oSHLNjxS962KF+8c0U4Lw2/kttVrDM6pcrSVjp87
         z0491rg8H0g1o/cEoAojLczsIiuiRLXnHOmEOJUM0MFwwWOJS5fYzol6QnOfXY7NyMUK
         JwhQrBmJkyquidkD1MH6oeDwqDdbapHDuIIagD7hD6xqTcQUVHPotyv3t2K2VIa2D3Iw
         YsO+qBc6RO454ZhQWkoPdBVW4F+cDAb/3af/cLpyukGhul6TMInwAS4YA0boYEaqj7P0
         Kmew==
X-Gm-Message-State: AAQBX9dkj/M+tUcOD/RPbAXiVcHcqMaejm+xsASZf10aqT1Sf/s/T90R
        uAaxHjt47eUXAmuOBENA5D7FKQ==
X-Google-Smtp-Source: AKy350YC4kATbrbaiGVRNclTWx4ZyFk0H3RATKfFe3sPz1aERFzAxQSeiybCsl58pGi4Nscbz6cMzg==
X-Received: by 2002:a17:902:ec8f:b0:1a6:9762:6eed with SMTP id x15-20020a170902ec8f00b001a697626eedmr1274445plg.22.1681798929447;
        Mon, 17 Apr 2023 23:22:09 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:7254:8270:74ed:755b])
        by smtp.gmail.com with UTF8SMTPSA id v1-20020a170902b7c100b0019d1f42b00csm8717437plz.17.2023.04.17.23.22.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 23:22:09 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     linux-mm@kvack.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>,
        linux-kernel@vger.kernel.org,
        David Stevens <stevensd@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] mm/shmem: Fix race in shmem_undo_range w/THP
Date:   Tue, 18 Apr 2023 15:19:33 +0900
Message-ID: <20230418061933.3282785-1-stevensd@google.com>
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
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 9218c955f482..317cbeb0fb6b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1033,7 +1033,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 				}
 				VM_BUG_ON_FOLIO(folio_test_writeback(folio),
 						folio);
-				truncate_inode_folio(mapping, folio);
+				truncate_inode_partial_folio(folio, lstart, lend);
 			}
 			folio_unlock(folio);
 		}
-- 
2.40.0.634.g4ca3ef3211-goog

