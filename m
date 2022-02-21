Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2454BE0C2
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352425AbiBUKFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:05:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352695AbiBUJ40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:56:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB2344747;
        Mon, 21 Feb 2022 01:24:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C7D561017;
        Mon, 21 Feb 2022 09:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8756C340E9;
        Mon, 21 Feb 2022 09:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435477;
        bh=bVtbcFu1bP+aF7lF8UMTo0RVnvCW+DX0l8LGlJdH/wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJIYTSXobjtoJOeJulURuEbdRLDVf0T8iZQYX19P2eIQzWlpybHVluYQbN8O51bPr
         xJcDJ5ljHMnzCmo/9Bo3OORtbc32miVr4u5FjqlZmeE+hvs67RP1n4EAzelfNPywfj
         ESj//tku4DObXOucCpSxK8oco0SiwEJXTLrzk0wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Solar Designer <solar@openwall.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.16 176/227] rlimit: Fix RLIMIT_NPROC enforcement failure caused by capability calls in set_user
Date:   Mon, 21 Feb 2022 09:49:55 +0100
Message-Id: <20220221084940.664308892@linuxfoundation.org>
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

commit c16bdeb5a39ffa3f32b32f812831a2092d2a3061 upstream.

Solar Designer <solar@openwall.com> wrote:
> I'm not aware of anyone actually running into this issue and reporting
> it.  The systems that I personally know use suexec along with rlimits
> still run older/distro kernels, so would not yet be affected.
>
> So my mention was based on my understanding of how suexec works, and
> code review.  Specifically, Apache httpd has the setting RLimitNPROC,
> which makes it set RLIMIT_NPROC:
>
> https://httpd.apache.org/docs/2.4/mod/core.html#rlimitnproc
>
> The above documentation for it includes:
>
> "This applies to processes forked from Apache httpd children servicing
> requests, not the Apache httpd children themselves. This includes CGI
> scripts and SSI exec commands, but not any processes forked from the
> Apache httpd parent, such as piped logs."
>
> In code, there are:
>
> ./modules/generators/mod_cgid.c:        ( (cgid_req.limits.limit_nproc_set) && ((rc = apr_procattr_limit_set(procattr, APR_LIMIT_NPROC,
> ./modules/generators/mod_cgi.c:        ((rc = apr_procattr_limit_set(procattr, APR_LIMIT_NPROC,
> ./modules/filters/mod_ext_filter.c:    rv = apr_procattr_limit_set(procattr, APR_LIMIT_NPROC, conf->limit_nproc);
>
> For example, in mod_cgi.c this is in run_cgi_child().
>
> I think this means an httpd child sets RLIMIT_NPROC shortly before it
> execs suexec, which is a SUID root program.  suexec then switches to the
> target user and execs the CGI script.
>
> Before 2863643fb8b9, the setuid() in suexec would set the flag, and the
> target user's process count would be checked against RLIMIT_NPROC on
> execve().  After 2863643fb8b9, the setuid() in suexec wouldn't set the
> flag because setuid() is (naturally) called when the process is still
> running as root (thus, has those limits bypass capabilities), and
> accordingly execve() would not check the target user's process count
> against RLIMIT_NPROC.

In commit 2863643fb8b9 ("set_user: add capability check when
rlimit(RLIMIT_NPROC) exceeds") capable calls were added to set_user to
make it more consistent with fork.  Unfortunately because of call site
differences those capable calls were checking the credentials of the
user before set*id() instead of after set*id().

This breaks enforcement of RLIMIT_NPROC for applications that set the
rlimit and then call set*id() while holding a full set of
capabilities.  The capabilities are only changed in the new credential
in security_task_fix_setuid().

The code in apache suexec appears to follow this pattern.

Commit 909cc4ae86f3 ("[PATCH] Fix two bugs with process limits
(RLIMIT_NPROC)") where this check was added describes the targes of this
capability check as:

  2/ When a root-owned process (e.g. cgiwrap) sets up process limits and then
      calls setuid, the setuid should fail if the user would then be running
      more than rlim_cur[RLIMIT_NPROC] processes, but it doesn't.  This patch
      adds an appropriate test.  With this patch, and per-user process limit
      imposed in cgiwrap really works.

So the original use case of this check also appears to match the broken
pattern.

Restore the enforcement of RLIMIT_NPROC by removing the bad capable
checks added in set_user.  This unfortunately restores the
inconsistent state the code has been in for the last 11 years, but
dealing with the inconsistencies looks like a larger problem.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20210907213042.GA22626@openwall.com/
Link: https://lkml.kernel.org/r/20220212221412.GA29214@openwall.com
Link: https://lkml.kernel.org/r/20220216155832.680775-1-ebiederm@xmission.com
Fixes: 2863643fb8b9 ("set_user: add capability check when rlimit(RLIMIT_NPROC) exceeds")
History-Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Reviewed-by: Solar Designer <solar@openwall.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sys.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -480,8 +480,7 @@ static int set_user(struct cred *new)
 	 * failure to the execve() stage.
 	 */
 	if (is_ucounts_overlimit(new->ucounts, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)) &&
-			new_user != INIT_USER &&
-			!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
+			new_user != INIT_USER)
 		current->flags |= PF_NPROC_EXCEEDED;
 	else
 		current->flags &= ~PF_NPROC_EXCEEDED;


