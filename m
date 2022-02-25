Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4554C45EA
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 14:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241121AbiBYNUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 08:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbiBYNUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 08:20:34 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D0C285701
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 05:20:02 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2FA96212C0;
        Fri, 25 Feb 2022 13:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645795201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=/MvNGVWn/fqPmfDt6G2RV7SA7btU5aJCsXBxXyvMvV8=;
        b=PyGXP+48KYSDoGapAEkyoRET8KNhVMJ8tRALaZGmdvogG13C70Sv9o00ohTiw3dSgrjoZ2
        gzcO5UWZmnpJWGl0YjsRqhav3VrVa15x5WwYnj8id/GpRl+502J9HapqRnDnE0Fiwz6Fn6
        VxP33G4BwJizAQ8g4xekSkIddzqdeKM=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id CE7E4A3B8B;
        Fri, 25 Feb 2022 13:20:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8159ADA818; Fri, 25 Feb 2022 14:16:11 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2] btrfs: remove redundant check in up check_setget_bounds
Date:   Fri, 25 Feb 2022 14:16:08 +0100
Message-Id: <ea59f1a0b66e214ec12864931711b764605fbacb.1645794094.git.dsterba@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are two separate checks in the bounds checker, the first one being
a special case of the second. As this function is performance critical
due to checking access to any eb member, reducing the size can slightly
improve performance.

On a release build on x86_64 the helper is completely inlined so the
function call overhead is also gone.

There was a report of 5% performance drop on metadata heavy workload,
that disappeared after disabling asserts. The most significant part of
that is the bounds checker.

https://lore.kernel.org/linux-btrfs/20200724164147.39925-1-josef@toxicpanda.com/

After the analysis, the optimized code removes the worst overhead which
is the function call and the performance was restored.

https://lore.kernel.org/linux-btrfs/20200730110943.GE3703@twin.jikos.cz/

1. baseline, asserts on, setget check on

run time:		46s
run time with perf:	48s

2. asserts on, comment out setget check

run time:		44s
run time with perf:	47s

So this is confirms the 5% difference

3. asserts on, optimized seget check

run time:		44s
run time with perf:	47s

The optimizations are reducing the number of ifs to 1 and inlining the
hot path. Low-level stuff, gets the performance back. Patch below.

4. asserts off, no setget check

run time:		44s
run time with perf:	45s

This verifies that asserts other than the setget check have negligible
impact on performance and it's not harmful to keep them on.

Analysis where the performance is lost:

* check_setget_bounds is short function, but it's still a function call,
  changing the flow of instructions and given how many times it's
  called the overhead adds up

* there are two conditions, one to check if the range is
  completely outside (member_offset > eb->len) or partially inside
  (member_offset + size > eb->len)

CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---

v2:

- patch picked from the series in
  https://lore.kernel.org/linux-btrfs/cover.1643904960.git.dsterba@suse.com/
- changelog updated with numbers and analysis

 fs/btrfs/struct-funcs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/struct-funcs.c b/fs/btrfs/struct-funcs.c
index f429256f56db..12455b2b41de 100644
--- a/fs/btrfs/struct-funcs.c
+++ b/fs/btrfs/struct-funcs.c
@@ -12,15 +12,10 @@ static bool check_setget_bounds(const struct extent_buffer *eb,
 {
 	const unsigned long member_offset = (unsigned long)ptr + off;
 
-	if (member_offset > eb->len) {
+	if (unlikely(member_offset + size > eb->len)) {
 		btrfs_warn(eb->fs_info,
-	"bad eb member start: ptr 0x%lx start %llu member offset %lu size %d",
-			(unsigned long)ptr, eb->start, member_offset, size);
-		return false;
-	}
-	if (member_offset + size > eb->len) {
-		btrfs_warn(eb->fs_info,
-	"bad eb member end: ptr 0x%lx start %llu member offset %lu size %d",
+		"bad eb member %s: ptr 0x%lx start %llu member offset %lu size %d",
+			(member_offset > eb->len ? "start" : "end"),
 			(unsigned long)ptr, eb->start, member_offset, size);
 		return false;
 	}
-- 
2.34.1

