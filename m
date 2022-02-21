Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5974BDF90
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352265AbiBUKFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:05:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352868AbiBUJ4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:56:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51B445048;
        Mon, 21 Feb 2022 01:24:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83E6FB80EB8;
        Mon, 21 Feb 2022 09:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD81DC340E9;
        Mon, 21 Feb 2022 09:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435480;
        bh=7/FBbwrvHWUltZ4Jxxrkk2lhlNEV2NohBiXF+5Bj8II=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JpJOqU9b3kLwHvoFCSUhxjjZmO2fmAzGUtK0H2+cYBdS0CCM9CCO8bxbpJ4m2JO6S
         IbUYRhD+Q5uZhDeHgZuMllVJVy5SHWJQFFdXFLfJgOXj0u6HDwxYNLKjL3h+orz+Ab
         PCQLJb/fKc4PVEcfb1f3CVtM21+NYjqjJZ8odrvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.16 177/227] ucounts: Move RLIMIT_NPROC handling after set_user
Date:   Mon, 21 Feb 2022 09:49:56 +0100
Message-Id: <20220221084940.695551387@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eric W. Biederman <ebiederm@xmission.com>

commit c923a8e7edb010da67424077cbf1a6f1396ebd2e upstream.

During set*id() which cred->ucounts to charge the the current process
to is not known until after set_cred_ucounts.  So move the
RLIMIT_NPROC checking into a new helper flag_nproc_exceeded and call
flag_nproc_exceeded after set_cred_ucounts.

This is very much an arbitrary subset of the places where we currently
change the RLIMIT_NPROC accounting, designed to preserve the existing
logic.

Fixing the existing logic will be the subject of another series of
changes.

Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220216155832.680775-4-ebiederm@xmission.com
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sys.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -472,6 +472,16 @@ static int set_user(struct cred *new)
 	if (!new_user)
 		return -EAGAIN;
 
+	free_uid(new->user);
+	new->user = new_user;
+	return 0;
+}
+
+static void flag_nproc_exceeded(struct cred *new)
+{
+	if (new->ucounts == current_ucounts())
+		return;
+
 	/*
 	 * We don't fail in case of NPROC limit excess here because too many
 	 * poorly written programs don't check set*uid() return code, assuming
@@ -480,14 +490,10 @@ static int set_user(struct cred *new)
 	 * failure to the execve() stage.
 	 */
 	if (is_ucounts_overlimit(new->ucounts, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)) &&
-			new_user != INIT_USER)
+			new->user != INIT_USER)
 		current->flags |= PF_NPROC_EXCEEDED;
 	else
 		current->flags &= ~PF_NPROC_EXCEEDED;
-
-	free_uid(new->user);
-	new->user = new_user;
-	return 0;
 }
 
 /*
@@ -562,6 +568,7 @@ long __sys_setreuid(uid_t ruid, uid_t eu
 	if (retval < 0)
 		goto error;
 
+	flag_nproc_exceeded(new);
 	return commit_creds(new);
 
 error:
@@ -624,6 +631,7 @@ long __sys_setuid(uid_t uid)
 	if (retval < 0)
 		goto error;
 
+	flag_nproc_exceeded(new);
 	return commit_creds(new);
 
 error:
@@ -703,6 +711,7 @@ long __sys_setresuid(uid_t ruid, uid_t e
 	if (retval < 0)
 		goto error;
 
+	flag_nproc_exceeded(new);
 	return commit_creds(new);
 
 error:


