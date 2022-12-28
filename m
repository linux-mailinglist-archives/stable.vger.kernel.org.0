Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7956582F9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbiL1Qnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbiL1QnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:43:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D247A1D335
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:37:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AB5161576
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77894C433EF;
        Wed, 28 Dec 2022 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245452;
        bh=FYBXsWlUp8AgPasGNzvLJEMDl7Pt9WKeBV+dNyhtRUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SS08v0szOVRnsEe0nTDmNVIsFbRmYArERmga8tpcfoUD7uV/ZSL0kd87rdMHTOYAT
         94uXShyjp4H0pXzq64udWklMHLIutcS+BLy3rAY5b4201Pu9B4dSBayJUf8srXD4dl
         m0Ck8uHtvu40Q9cWed/HXvffTN5XOz1YGNYhrglA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Huafei <lihuafei1@huawei.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0855/1146] kprobes: Fix check for probe enabled in kill_kprobe()
Date:   Wed, 28 Dec 2022 15:39:54 +0100
Message-Id: <20221228144353.378179777@linuxfoundation.org>
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

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit 0c76ef3f26d5ef2ac2c21b47e7620cff35809fbb ]

In kill_kprobe(), the check whether disarm_kprobe_ftrace() needs to be
called always fails. This is because before that we set the
KPROBE_FLAG_GONE flag for kprobe so that "!kprobe_disabled(p)" is always
false.

The disarm_kprobe_ftrace() call introduced by commit:

  0cb2f1372baa ("kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler")

to fix the NULL pointer reference problem. When the probe is enabled, if
we do not disarm it, this problem still exists.

Fix it by putting the probe enabled check before setting the
KPROBE_FLAG_GONE flag.

Link: https://lore.kernel.org/all/20221126114316.201857-1-lihuafei1@huawei.com/

Fixes: 3031313eb3d54 ("kprobes: Fix to check probe enabled before disarm_kprobe_ftrace()")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3050631e528d..a35074f0daa1 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2364,6 +2364,14 @@ static void kill_kprobe(struct kprobe *p)
 
 	lockdep_assert_held(&kprobe_mutex);
 
+	/*
+	 * The module is going away. We should disarm the kprobe which
+	 * is using ftrace, because ftrace framework is still available at
+	 * 'MODULE_STATE_GOING' notification.
+	 */
+	if (kprobe_ftrace(p) && !kprobe_disabled(p) && !kprobes_all_disarmed)
+		disarm_kprobe_ftrace(p);
+
 	p->flags |= KPROBE_FLAG_GONE;
 	if (kprobe_aggrprobe(p)) {
 		/*
@@ -2380,14 +2388,6 @@ static void kill_kprobe(struct kprobe *p)
 	 * the original probed function (which will be freed soon) any more.
 	 */
 	arch_remove_kprobe(p);
-
-	/*
-	 * The module is going away. We should disarm the kprobe which
-	 * is using ftrace, because ftrace framework is still available at
-	 * 'MODULE_STATE_GOING' notification.
-	 */
-	if (kprobe_ftrace(p) && !kprobe_disabled(p) && !kprobes_all_disarmed)
-		disarm_kprobe_ftrace(p);
 }
 
 /* Disable one kprobe */
-- 
2.35.1



