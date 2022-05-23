Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB895317FF
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240314AbiEWRaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242769AbiEWR2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844758BD22;
        Mon, 23 May 2022 10:24:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A45B60B2C;
        Mon, 23 May 2022 17:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E52DC385A9;
        Mon, 23 May 2022 17:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326650;
        bh=airJjC0MifQFzoS4q1rZ//RwvnXOzHIIfM7a9aMTeuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9mOm1STWeXypyvlaSvCCvlRnP6k4PLhNENz97L5hhU2pjlE3EjQ7LqTxGHAJUS0K
         3XaqLteUQXFCCU4wvqyoJ9/bwvcupNNP5duQQnAQXF0M+UvVPOgdpG3+ISu93E58b3
         yWlsZ+Egu/i2YDVmW2WAfMq6gKxJo8rxXfyEitBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 017/158] gfs2: cancel timed-out glock requests
Date:   Mon, 23 May 2022 19:02:54 +0200
Message-Id: <20220523165833.486564248@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



