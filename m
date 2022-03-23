Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE66B4E55DE
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 17:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238325AbiCWQCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 12:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238299AbiCWQCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 12:02:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EF17B12D
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 09:01:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2BA76210DE;
        Wed, 23 Mar 2022 16:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648051276; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tqDXuAMHxMddaOrZWSa7fljzAEyL5yzhIigHi3Xxj2Y=;
        b=L3ostfkylfaeRyMWD/+eGS0JSDkvXU2lwQI2NGgkK+iyS8YU0WFETD6vc1KZJY7OI70+5z
        +FtmcK8eOA4/u+qdZTaUNKtcr/dIU0+fFjrxVkwNRMthfIt0oFmUWQs8Tt9eNSzfdImEyY
        alJkYg7w8kdLq6dfKSqFXUE5P5HDPjY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 02E2412FC5;
        Wed, 23 Mar 2022 16:01:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CFIVO0tEO2KvegAAMHmgww
        (envelope-from <mkoutny@suse.com>); Wed, 23 Mar 2022 16:01:15 +0000
From:   =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
To:     gregkh@linuxfoundation.org
Cc:     masami.ichikawa@cybertrust.co.jp, mkoutny@suse.com,
        stable@vger.kernel.org, tj@kernel.org
Subject: [PATCH 3/3] cgroup-v1: Correct privileges check in release_agent writes
Date:   Wed, 23 Mar 2022 17:01:02 +0100
Message-Id: <20220323160102.3347-3-mkoutny@suse.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323160102.3347-1-mkoutny@suse.com>
References: <YjseqrSJQd9412So@kroah.com>
 <20220323160102.3347-1-mkoutny@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 467a726b754f474936980da793b4ff2ec3e382a7 upstream.

The idea is to check: a) the owning user_ns of cgroup_ns, b)
capabilities in init_user_ns.

The commit 24f600856418 ("cgroup-v1: Require capabilities to set
release_agent") got this wrong in the write handler of release_agent
since it checked user_ns of the opener (may be different from the owning
user_ns of cgroup_ns).
Secondly, to avoid possibly confused deputy, the capability of the
opener must be checked.

Fixes: 24f600856418 ("cgroup-v1: Require capabilities to set release_agent")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/stable/20220216121142.GB30035@blackbody.suse.cz/
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Masami Ichikawa(CIP) <masami.ichikawa@cybertrust.co.jp>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup-v1.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 40b8d4e4a810..8f0ea12d7cee 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -544,6 +544,7 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 					  char *buf, size_t nbytes, loff_t off)
 {
 	struct cgroup *cgrp;
+	struct cgroup_file_ctx *ctx;
 
 	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
 
@@ -551,8 +552,9 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 	 * Release agent gets called with all capabilities,
 	 * require capabilities to set release agent.
 	 */
-	if ((of->file->f_cred->user_ns != &init_user_ns) ||
-	    !capable(CAP_SYS_ADMIN))
+	ctx = of->priv;
+	if ((ctx->ns->user_ns != &init_user_ns) ||
+	    !file_ns_capable(of->file, &init_user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
-- 
2.35.1

