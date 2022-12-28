Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B0265801B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbiL1QN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234541AbiL1QNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:13:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6811AA21
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:11:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF1F561560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6286C433D2;
        Wed, 28 Dec 2022 16:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243896;
        bh=dJgZaAXz44OcIoZ8lj2GbfgRiJ7+2jo3eYjnptDEBUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+rTi37Rw7h9A3HH9df81v4tpf8kMejpob3q30rnnBekyQsW9pkeHMv5sMAXIK0VL
         D0R4/FKD8NQHs3AetVOzsZhiGLrqQXKmR4jOexCzESUmYJKsB75aRC3DfGv3rmxxnG
         /ptkapQ5kXBFxRI/+KAVy26kdHQV0GU5kVbexYY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0574/1146] apparmor: Fix regression in stacking due to label flags
Date:   Wed, 28 Dec 2022 15:35:13 +0100
Message-Id: <20221228144345.763098284@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 1f939c6bd1512d0b39b470396740added3cb403f ]

The unconfined label flag is not being computed correctly. It
should only be set if all the profiles in the vector are set, which
is different than what is required for the debug and stale flag
that are set if any on the profile flags are set.

Fixes: c1ed5da19765 ("apparmor: allow label to carry debug flags")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 0f36ee907438..a67c5897ee25 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -197,15 +197,18 @@ static bool vec_is_stale(struct aa_profile **vec, int n)
 	return false;
 }
 
-static long union_vec_flags(struct aa_profile **vec, int n, long mask)
+static long accum_vec_flags(struct aa_profile **vec, int n)
 {
-	long u = 0;
+	long u = FLAG_UNCONFINED;
 	int i;
 
 	AA_BUG(!vec);
 
 	for (i = 0; i < n; i++) {
-		u |= vec[i]->label.flags & mask;
+		u |= vec[i]->label.flags & (FLAG_DEBUG1 | FLAG_DEBUG2 |
+					    FLAG_STALE);
+		if (!(u & vec[i]->label.flags & FLAG_UNCONFINED))
+			u &= ~FLAG_UNCONFINED;
 	}
 
 	return u;
@@ -1097,8 +1100,7 @@ static struct aa_label *label_merge_insert(struct aa_label *new,
 		else if (k == b->size)
 			return aa_get_label(b);
 	}
-	new->flags |= union_vec_flags(new->vec, new->size, FLAG_UNCONFINED |
-					      FLAG_DEBUG1 | FLAG_DEBUG2);
+	new->flags |= accum_vec_flags(new->vec, new->size);
 	ls = labels_set(new);
 	write_lock_irqsave(&ls->lock, flags);
 	label = __label_insert(labels_set(new), new, false);
-- 
2.35.1



