Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22AF493105
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 23:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350064AbiARWwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 17:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344192AbiARWwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 17:52:33 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFE7C06161C
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:52:32 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 4-20020a250304000000b006137f4a9920so662772ybd.6
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+mzcJD1f4b16ra0GiHtWZ6d+B5dxCbu0iOYX1yklcN0=;
        b=V2k6FqTnHCv81lfCofpGjlfsSFnf4w2i3VXnqucVxtJYzgsFuqDUPXRM/A3pAYQIf2
         21zjW+AWg8beUxVB1OUmwjcX2XG4GpgtKnO3zixtmTM0yjFqdFqmGmIfsfeZ+wFbu4OY
         b7lwPifB2TCUghDUNrWRJsjLc/qv6XfgHiQ50q9JLg9BigKpFIQfwRuUWB88TEqfeoxc
         TpDGQjbdSDeCDQM1RZfFXoU4AqU44ElwX277YmqXJ2MWER2xZce2xzdCiWIua13C7Lhx
         bTxckfTF4VcWFPURq6g303V3YGBw81TQz+3TAyp0fNlesoY9BTq+RBvy12L5Ps7evyH9
         gHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+mzcJD1f4b16ra0GiHtWZ6d+B5dxCbu0iOYX1yklcN0=;
        b=aJsk1q6ua/dG/qeAK/+cXahn3tIT/+fVIgyXeaEFgdhn4nTYbO8ggTRMWpOFxICID+
         4s8m0EAFHizAVIEy4/A/YNHEaMauaer+yq0pITDqPw0CJq/ZxVn9Xhk8k+crbOMa9zVt
         RF+2T0K+uXNQhVTTpcQdF8TIT5ukkUcQf+fUBEfQ64YwpuV22HeS8Tq32IsPpxy45K6a
         ICs2PEgHQ28ltLjKAwLIocfQEaZ0l7DDx7v2/mSR3/j1LNp5m8tIFVm+JFROy06koJLA
         0jWV302RpRx9MIMCq1PveWU/TAIVIUPQLPvlmkzvQkD5Vz0uapJ3nSDHp/GXRd3Grfeb
         przQ==
X-Gm-Message-State: AOAM532vtoHz8GpvtcGnshZuIVjieGMgxhSapc79Hbeh2whhclifqoO8
        3Z6hfz5vFYQz3PAp1IN66DcJ6NU=
X-Google-Smtp-Source: ABdhPJzN+1lslSfZER8W3Mqe56Ilvc9Szjyr00149NsPQLB1VCQs9NPmdqhrpfxWCJH0Cf26KGI27lw=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:1443:965d:6393:cd60])
 (user=pcc job=sendgmr) by 2002:a25:b683:: with SMTP id s3mr34831611ybj.293.1642546352072;
 Tue, 18 Jan 2022 14:52:32 -0800 (PST)
Date:   Tue, 18 Jan 2022 14:52:15 -0800
Message-Id: <20220118225215.318101-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2] mm: use compare-exchange operation to set KASAN page tag
From:   Peter Collingbourne <pcc@google.com>
To:     Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Peter Collingbourne <pcc@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It has been reported that the tag setting operation on newly-allocated
pages can cause the page flags to be corrupted when performed
concurrently with other flag updates as a result of the use of
non-atomic operations. Fix the problem by using a compare-exchange
loop to update the tag.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/I456b24a2b9067d93968d43b4bb3351c0cec63101
Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
Cc: stable@vger.kernel.org
---
v2:
- use READ_ONCE()

 include/linux/mm.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c768a7c81b0b..37d1aa65f28c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1531,11 +1531,17 @@ static inline u8 page_kasan_tag(const struct page *page)
 
 static inline void page_kasan_tag_set(struct page *page, u8 tag)
 {
-	if (kasan_enabled()) {
-		tag ^= 0xff;
-		page->flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
-		page->flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
-	}
+	unsigned long old_flags, flags;
+
+	if (!kasan_enabled())
+		return;
+
+	tag ^= 0xff;
+	do {
+		old_flags = flags = READ_ONCE(page->flags);
+		flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
+		flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
+	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
 }
 
 static inline void page_kasan_tag_reset(struct page *page)
-- 
2.34.1.703.g22d0c6ccf7-goog

