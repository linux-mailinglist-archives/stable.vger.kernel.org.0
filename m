Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97C44F6F75
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbiDGBMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbiDGBMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:12:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4BC17A82;
        Wed,  6 Apr 2022 18:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B039B81E7F;
        Thu,  7 Apr 2022 01:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E85C385A7;
        Thu,  7 Apr 2022 01:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293833;
        bh=airJjC0MifQFzoS4q1rZ//RwvnXOzHIIfM7a9aMTeuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnOhaFEXeuDrZLKnMoUOqEzcXvD/4TdfjFtI44QyZSiu6bcXqt17BiWeiIx2vMXqO
         W7sTZiqPtVh1mfs9ELXpTPbBoVYG0wthPDYk74NlMiHRygCizi8gkhFrsiCPFbUEBl
         JnW0XNejXZx0/hw0bW8NVSgf75xq5ntSnutxqFap66fhiWiITJnjSSoVodZ8ByZ8cY
         SKXnTZNHrMJZAiSp+II/8CZbNe+FPdsRQn2mzytO4RZflyZTzs8qCSjG9B9CHKLN3G
         euCIoSMhf5Pfk7ryePwr+sOfFB6ipiRhtJIx2ODFdC9EXPdWFrfXstETm4n5XYfg3D
         rkLTRYdh41Huw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.17 02/31] gfs2: cancel timed-out glock requests
Date:   Wed,  6 Apr 2022 21:10:00 -0400
Message-Id: <20220407011029.113321-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011029.113321-1-sashal@kernel.org>
References: <20220407011029.113321-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 1fc05c8d8426d4085a219c23f8855c4aaf9e3ffb ]

The gfs2 evict code tries to upgrade the iopen glock from SH to EX. If
the attempt to upgrade times out, gfs2 needs to tell dlm to cancel the
lock request or it can deadlock. We also need to wake up the process
waiting for the lock when dlm sends its AST back to gfs2.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 6b23399eaee0..d368d9a2e8f0 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -669,6 +669,8 @@ static void finish_xmote(struct gfs2_glock *gl, unsigned int ret)
 
 	/* Check for state != intended state */
 	if (unlikely(state != gl->gl_target)) {
+		if (gh && (ret & LM_OUT_CANCELED))
+			gfs2_holder_wake(gh);
 		if (gh && !test_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags)) {
 			/* move to back of queue and try next entry */
 			if (ret & LM_OUT_CANCELED) {
@@ -1691,6 +1693,14 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 	struct gfs2_glock *gl = gh->gh_gl;
 
 	spin_lock(&gl->gl_lockref.lock);
+	if (list_is_first(&gh->gh_list, &gl->gl_holders) &&
+	    !test_bit(HIF_HOLDER, &gh->gh_iflags)) {
+		spin_unlock(&gl->gl_lockref.lock);
+		gl->gl_name.ln_sbd->sd_lockstruct.ls_ops->lm_cancel(gl);
+		wait_on_bit(&gh->gh_iflags, HIF_WAIT, TASK_UNINTERRUPTIBLE);
+		spin_lock(&gl->gl_lockref.lock);
+	}
+
 	__gfs2_glock_dq(gh);
 	spin_unlock(&gl->gl_lockref.lock);
 }
-- 
2.35.1

