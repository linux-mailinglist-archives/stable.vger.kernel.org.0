Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CD64B8F84
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 18:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237296AbiBPRmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 12:42:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237291AbiBPRmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 12:42:45 -0500
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id AA9AC159281
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 09:42:29 -0800 (PST)
Received: (qmail 28379 invoked from network); 16 Feb 2022 17:42:27 -0000
Received: from localhost (HELO pvt.openwall.com) (127.0.0.1)
  by localhost with SMTP; 16 Feb 2022 17:42:27 -0000
Received: by pvt.openwall.com (Postfix, from userid 503)
        id B379BAB88C; Wed, 16 Feb 2022 18:42:20 +0100 (CET)
Date:   Wed, 16 Feb 2022 18:42:20 +0100
From:   Solar Designer <solar@openwall.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-kernel@vger.kernel.org, Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        containers@lists.linux-foundation.org,
        Michal Koutn?? <mkoutny@suse.com>, linux-api@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] rlimit: Fix RLIMIT_NPROC enforcement failure caused by capability calls in set_user
Message-ID: <20220216174220.GA10389@openwall.com>
References: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org> <20220216155832.680775-1-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216155832.680775-1-ebiederm@xmission.com>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 09:58:28AM -0600, Eric W. Biederman wrote:
> Solar Designer <solar@openwall.com> wrote:
> > I'm not aware of anyone actually running into this issue and reporting
> > it.  The systems that I personally know use suexec along with rlimits
> > still run older/distro kernels, so would not yet be affected.
> >
> > So my mention was based on my understanding of how suexec works, and
> > code review.  Specifically, Apache httpd has the setting RLimitNPROC,
> > which makes it set RLIMIT_NPROC:
> >
> > https://httpd.apache.org/docs/2.4/mod/core.html#rlimitnproc
> >
> > The above documentation for it includes:
> >
> > "This applies to processes forked from Apache httpd children servicing
> > requests, not the Apache httpd children themselves. This includes CGI
> > scripts and SSI exec commands, but not any processes forked from the
> > Apache httpd parent, such as piped logs."
> >
> > In code, there are:
> >
> > ./modules/generators/mod_cgid.c:        ( (cgid_req.limits.limit_nproc_set) && ((rc = apr_procattr_limit_set(procattr, APR_LIMIT_NPROC,
> > ./modules/generators/mod_cgi.c:        ((rc = apr_procattr_limit_set(procattr, APR_LIMIT_NPROC,
> > ./modules/filters/mod_ext_filter.c:    rv = apr_procattr_limit_set(procattr, APR_LIMIT_NPROC, conf->limit_nproc);
> >
> > For example, in mod_cgi.c this is in run_cgi_child().
> >
> > I think this means an httpd child sets RLIMIT_NPROC shortly before it
> > execs suexec, which is a SUID root program.  suexec then switches to the
> > target user and execs the CGI script.
> >
> > Before 2863643fb8b9, the setuid() in suexec would set the flag, and the
> > target user's process count would be checked against RLIMIT_NPROC on
> > execve().  After 2863643fb8b9, the setuid() in suexec wouldn't set the
> > flag because setuid() is (naturally) called when the process is still
> > running as root (thus, has those limits bypass capabilities), and
> > accordingly execve() would not check the target user's process count
> > against RLIMIT_NPROC.
> 
> In commit 2863643fb8b9 ("set_user: add capability check when
> rlimit(RLIMIT_NPROC) exceeds") capable calls were added to set_user to
> make it more consistent with fork.  Unfortunately because of call site
> differences those capables calls were checking the credentials of the

s/capables/capable/

> user before set*id() instead of after set*id().
> 
> This breaks enforcement of RLIMIT_NPROC for applications that set the
> rlimit and then call set*id() while holding a full set of
> capabilities.  The capabilities are only changed in the new credential
> in security_task_fix_setuid().
> 
> The code in apache suexec appears to follow this pattern.
> 
> Commit 909cc4ae86f3 ("[PATCH] Fix two bugs with process limits
> (RLIMIT_NPROC)") where this check was added describes the targes of this
> capability check as:
> 
>   2/ When a root-owned process (e.g. cgiwrap) sets up process limits and then
>       calls setuid, the setuid should fail if the user would then be running
>       more than rlim_cur[RLIMIT_NPROC] processes, but it doesn't.  This patch
>       adds an appropriate test.  With this patch, and per-user process limit
>       imposed in cgiwrap really works.
> 
> So the original use case also of this check also appears to match the broken
> pattern.

Duplicate "also" - drop one.

> Restore the enforcement of RLIMIT_NPROC by removing the bad capable
> checks added in set_user.  This unfortunately restores the
> inconsistencies state the code has been in for the last 11 years, but

s/inconsistencies/inconsistent/

> dealing with the inconsistencies looks like a larger problem.
> 
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/20210907213042.GA22626@openwall.com/
> Link: https://lkml.kernel.org/r/20220212221412.GA29214@openwall.com
> Fixes: 2863643fb8b9 ("set_user: add capability check when rlimit(RLIMIT_NPROC) exceeds")
> History-Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/sys.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index ecc4cf019242..8dd938a3d2bf 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -480,8 +480,7 @@ static int set_user(struct cred *new)
>  	 * failure to the execve() stage.
>  	 */
>  	if (is_ucounts_overlimit(new->ucounts, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)) &&
> -			new_user != INIT_USER &&
> -			!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
> +			new_user != INIT_USER)
>  		current->flags |= PF_NPROC_EXCEEDED;
>  	else
>  		current->flags &= ~PF_NPROC_EXCEEDED;

Reviewed-by: Solar Designer <solar@openwall.com>

Alexander
