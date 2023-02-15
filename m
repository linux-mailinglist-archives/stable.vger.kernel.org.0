Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793AE6975B2
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 06:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbjBOFJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 00:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbjBOFJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 00:09:23 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362981D905
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 21:09:19 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-517f8be4b00so189347557b3.3
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 21:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oz1c94+PpSpdOwRxmJhtyfwix/rF7URLVnLJpJ4OuRQ=;
        b=PAVs9wTHuHqSwdcXMccaVRi59RVMu0fidE3NSoZW9Pmt84r9A7VI97aWIZJzb8OYfV
         XB9svOI3UGKkfvMLPWWpv5fCkxC3Ez+vBsJRjEYxoLotr34BEi+4cCL+f8c6akzvKJgY
         HO7rMm0aUhukTkjHLUbwDKw3cdz7BMWzOpLwMtGuPYRDHRU2ShL3LnmPac+F5HFZRzpF
         02J7y2OeS0bSMab5TdzI4cLbo0T3SegMO0IGmQK3hUOW/2hkexLAXB3Shg/bUbwQ2FEm
         qg739zx4pTnFrmjYMgixcf28HbVJS75iGYe4pNgbFfRyTG1wFmoAk7aSs+DITRWMkY5g
         rdOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oz1c94+PpSpdOwRxmJhtyfwix/rF7URLVnLJpJ4OuRQ=;
        b=i6TU4CP509BOUHtEtA+GyJ6+GD/fvVE+kVCpiVJ/szdK2GbpZA3bHowcJikQrhxfpz
         HlDs3n7qGETUdFBg0WQv+HK5pC3UB7lAwBb4gYnGVCh643Xp3Xe68jXV30TZGQL247ax
         0qW4SHxnxRcsOOGZq8QdiEyInQgoMOOlJZuP9V0+TS2P4v9V5ETp6eyj6s0GftKnCTa+
         ouDdy6LX7cJHioLWiCxK8Sr1Q2NH3TR5vzB7oOuQIdOQo6wWAYq+0Db1zDN4D8zOq1Qc
         5pKmBu1BlUe/gtpad+2y1de67GVLJIOmjeNGzroI4/GYQwfmw2B8ry9fqraoYDIhMbR1
         mxtw==
X-Gm-Message-State: AO0yUKUd/RrXQNRpEbvKweyBqmRsaOtOhu9N7VQpw8CWn4UrwMG6Hr+d
        x6+0qMm97sQ6MvtTNUh1bACau3E=
X-Google-Smtp-Source: AK7set8Jv69dLvHNhXRcipzuj+FaMPD6itu9fekdMrlFGOW8fqWQ+CBzIrkh2Nr4ezQ+OweciUym0ms=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2d3:205:d5d8:eed0:c0c1:29d7])
 (user=pcc job=sendgmr) by 2002:a05:6902:341:b0:8bb:3a1:e811 with SMTP id
 e1-20020a056902034100b008bb03a1e811mr129660ybs.348.1676437758447; Tue, 14 Feb
 2023 21:09:18 -0800 (PST)
Date:   Tue, 14 Feb 2023 21:09:11 -0800
Message-Id: <20230215050911.1433132-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Subject: [PATCH v2] arm64: Reset KASAN tag in copy_highpage with HW tags only
From:   Peter Collingbourne <pcc@google.com>
To:     catalin.marinas@arm.com, andreyknvl@gmail.com
Cc:     Peter Collingbourne <pcc@google.com>,
        "=?UTF-8?q?Qun-wei=20Lin=20=28=E6=9E=97=E7=BE=A4=E5=B4=B4=29?=" 
        <Qun-wei.Lin@mediatek.com>,
        "=?UTF-8?q?Guangye=20Yang=20=28=E6=9D=A8=E5=85=89=E4=B8=9A=29?=" 
        <guangye.yang@mediatek.com>, linux-mm@kvack.org,
        "=?UTF-8?q?Chinwen=20Chang=20=28=E5=BC=B5=E9=8C=A6=E6=96=87=29?=" 
        <chinwen.chang@mediatek.com>, kasan-dev@googlegroups.com,
        ryabinin.a.a@gmail.com, linux-arm-kernel@lists.infradead.org,
        vincenzo.frascino@arm.com, will@kernel.org, eugenis@google.com,
        "=?UTF-8?q?Kuan-Ying=20Lee=20=28=E6=9D=8E=E5=86=A0=E7=A9=8E=29?=" 
        <Kuan-Ying.Lee@mediatek.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During page migration, the copy_highpage function is used to copy the
page data to the target page. If the source page is a userspace page
with MTE tags, the KASAN tag of the target page must have the match-all
tag in order to avoid tag check faults during subsequent accesses to the
page by the kernel. However, the target page may have been allocated in
a number of ways, some of which will use the KASAN allocator and will
therefore end up setting the KASAN tag to a non-match-all tag. Therefore,
update the target page's KASAN tag to match the source page.

We ended up unintentionally fixing this issue as a result of a bad
merge conflict resolution between commit e059853d14ca ("arm64: mte:
Fix/clarify the PG_mte_tagged semantics") and commit 20794545c146 ("arm64:
kasan: Revert "arm64: mte: reset the page tag in page->flags""), which
preserved a tag reset for PG_mte_tagged pages which was considered to be
unnecessary at the time. Because SW tags KASAN uses separate tag storage,
update the code to only reset the tags when HW tags KASAN is enabled.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/If303d8a709438d3ff5af5fd8570=
6505830f52e0c
Reported-by: "Kuan-Ying Lee (=E6=9D=8E=E5=86=A0=E7=A9=8E)" <Kuan-Ying.Lee@m=
ediatek.com>
Cc: <stable@vger.kernel.org> # 6.1
Fixes: 20794545c146 ("arm64: kasan: Revert "arm64: mte: reset the page tag =
in page->flags"")
---
v2:
- added Fixes tag

For the stable branch, e059853d14ca needs to be cherry-picked and the follo=
wing
merge conflict resolution is needed:

-               page_kasan_tag_reset(to);
+               if (kasan_hw_tags_enabled())
+                       page_kasan_tag_reset(to);
 -              /* It's a new page, shouldn't have been tagged yet */
 -              WARN_ON_ONCE(!try_page_mte_tagging(to));

 arch/arm64/mm/copypage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 8dd5a8fe64b4..4aadcfb01754 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -22,7 +22,8 @@ void copy_highpage(struct page *to, struct page *from)
 	copy_page(kto, kfrom);
=20
 	if (system_supports_mte() && page_mte_tagged(from)) {
-		page_kasan_tag_reset(to);
+		if (kasan_hw_tags_enabled())
+			page_kasan_tag_reset(to);
 		/* It's a new page, shouldn't have been tagged yet */
 		WARN_ON_ONCE(!try_page_mte_tagging(to));
 		mte_copy_page_tags(kto, kfrom);
--=20
2.39.1.581.gbfd45094c4-goog

