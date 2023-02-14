Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CF9695629
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 02:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjBNBwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 20:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjBNBwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 20:52:46 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D0A1A95B
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 17:52:30 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5005ef73cf3so143793817b3.2
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 17:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2J+3GOG2P0hnwklMWKGq0tLBKfNtpEESwIEDcAq6rlI=;
        b=cF3vp2hnvMgG9ens+55wFDLcpBIkUkt4Nr/ypQnsswmAhEKnCMkvo8mhtgwk6R2oWI
         hnMGi8RcYBDYS6G4DDTcN8MUzkLnggjUk60MrjOF4qdbV194PhN2YZqViUOzWTyIcQJ6
         brzQ5pW4Q58FaWVJNjaNBxB2xGQ4iKx4H373x7OOuRmEN96Xjvrh0gCNa6HTX6opFTlJ
         qOlGG819eQxpIR8i/XLQ64Ea+m3or5yzSsVe0t95k1uYg1O6kfvdyJDKv9u0PVB7y9r4
         fjTDsRkGaP8mohZ7h8DRJ8Wp/HnJAyL73ibTgS74esVy7uZVBqUF5/4Op1M/HpywygD3
         rtJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2J+3GOG2P0hnwklMWKGq0tLBKfNtpEESwIEDcAq6rlI=;
        b=SF3b7YYGmGoYy5z/TS5mjRydebDqIxuqFEQpBT2StvgUTwclJGFh9r5lmNWNo591AF
         k9yrdzRZd4VysT3aX+1RKox+jZ5Q6QnRAtulliy2tWNeoryRIgDu85KRNd94M7qfSo6p
         KHonhl10083o1b8E8D7ca3sNVk0hvmRx1HLcK1q/r4Qh0kVXg+LvGP4rtzPoCAotqe0q
         S92N1Dz4NC7u5VKKsST3sNcG29gLMgD1oSsBiV9Pro2KqGg6p28Ze9onVtg2Idq6Vz9+
         zkpraLSNB9ulLvCxXCtgO180YUldZ/ZJuAAoK8pLQQBg7VyeVO9g0N0PmeT6zcqDke1v
         NBHg==
X-Gm-Message-State: AO0yUKWiNxwvJoj7zLG9/INo6zd1lGr5PaNfdxEdt/yI9zfyD/VxH3bq
        vAJg5fKyEuHca6E9pzCui07Tv+A=
X-Google-Smtp-Source: AK7set8JX2UCuUx1r/BRaJun6ZhAJ9kw7czlUn0qrE78/cOFud3HqDmluAZSD4UYPrIYk/Z3I/l8GIk=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2d3:205:6153:a2b0:1bfd:87af])
 (user=pcc job=sendgmr) by 2002:a05:6902:1147:b0:8df:1fcb:f1c8 with SMTP id
 p7-20020a056902114700b008df1fcbf1c8mr9ybu.2.1676339549200; Mon, 13 Feb 2023
 17:52:29 -0800 (PST)
Date:   Mon, 13 Feb 2023 17:52:14 -0800
Message-Id: <20230214015214.747873-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Subject: [PATCH] arm64: Reset KASAN tag in copy_highpage with HW tags only
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
---
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

