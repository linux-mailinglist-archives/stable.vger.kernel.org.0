Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220EC4B8D18
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 16:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbiBPP7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 10:59:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbiBPP73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 10:59:29 -0500
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE56C2A797D;
        Wed, 16 Feb 2022 07:59:14 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:58018)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMi2-009INN-4C; Wed, 16 Feb 2022 08:59:14 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37452 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMi0-002YPH-Jr; Wed, 16 Feb 2022 08:59:13 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Solar Designer <solar@openwall.com>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        containers@lists.linux-foundation.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Date:   Wed, 16 Feb 2022 09:58:31 -0600
Message-Id: <20220216155832.680775-4-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
References: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nKMi0-002YPH-Jr;;;mid=<20220216155832.680775-4-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ooX4vhp2sZhuHKwMTsjIRkVQYwVLWDik=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Timing: total 912 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 10 (1.1%), b_tie_ro: 8 (0.9%), parse: 1.47 (0.2%),
         extract_message_metadata: 18 (1.9%), get_uri_detail_list: 2.5 (0.3%),
        tests_pri_-1000: 21 (2.3%), tests_pri_-950: 1.75 (0.2%),
        tests_pri_-900: 1.45 (0.2%), tests_pri_-90: 174 (19.1%), check_bayes:
        172 (18.9%), b_tokenize: 12 (1.4%), b_tok_get_all: 7 (0.8%),
        b_comp_prob: 3.3 (0.4%), b_tok_touch_all: 145 (15.9%), b_finish: 0.90
        (0.1%), tests_pri_0: 672 (73.7%), check_dkim_signature: 0.83 (0.1%),
        check_dkim_adsp: 3.0 (0.3%), poll_dns_idle: 0.73 (0.1%), tests_pri_10:
        2.1 (0.2%), tests_pri_500: 7 (0.7%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH v2 4/5] ucounts: Move RLIMIT_NPROC handling after set_user
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/sys.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 8dd938a3d2bf..97dc9e5d6bf9 100644
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
@@ -562,6 +568,7 @@ long __sys_setreuid(uid_t ruid, uid_t euid)
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
@@ -703,6 +711,7 @@ long __sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 	if (retval < 0)
 		goto error;
 
+	flag_nproc_exceeded(new);
 	return commit_creds(new);
 
 error:
-- 
2.29.2

