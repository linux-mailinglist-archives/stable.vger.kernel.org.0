Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0D14B69E0
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 11:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbiBOKzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 05:55:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236818AbiBOKzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 05:55:06 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59195DB4A7;
        Tue, 15 Feb 2022 02:54:45 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DE5091F38A;
        Tue, 15 Feb 2022 10:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644922483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rfmZMUuiUWbSeaZevcuqK5Mt/Es3rIbFyHjyVGT5YLk=;
        b=JXAKRttIkXBQcHMO45e1zb+//IypCL2y+IoK473DR0Kkc2DjsFjmK5JqYTxeEIf1QHH9oM
        3Qp8r5Suv51YYQoUGvtMC/y64zk92ycL/PaR0UTDqPjfWCs3LaB5FMVMLSTL5gAhHlBHIj
        qU7gHmxDlEHT0GNGGEtmrrfP3zzlrW0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B4FD813C51;
        Tue, 15 Feb 2022 10:54:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OuSvK3OGC2LZLAAAMHmgww
        (envelope-from <mkoutny@suse.com>); Tue, 15 Feb 2022 10:54:43 +0000
Date:   Tue, 15 Feb 2022 11:54:42 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-kernel@vger.kernel.org, Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Solar Designer <solar@openwall.com>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        containers@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 4/8] ucounts: Only except the root user in init_user_ns
 from RLIMIT_NPROC
Message-ID: <20220215105442.GF21589@blackbody.suse.cz>
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
 <20220211021324.4116773-4-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211021324.4116773-4-ebiederm@xmission.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 10, 2022 at 08:13:20PM -0600, "Eric W. Biederman" <ebiederm@xmission.com> wrote:
> @@ -1881,7 +1881,7 @@ static int do_execveat_common(int fd, struct filename *filename,
[...]
> -	    (current_user() != INIT_USER) &&
> +	    (current_ucounts() != &init_ucounts) &&
[...]
> @@ -2027,7 +2027,7 @@ static __latent_entropy struct task_struct *copy_process(
[...]
> -		if (p->real_cred->user != INIT_USER &&
> +		if ((task_ucounts(p) != &init_ucounts) &&

These substitutions make sense to me.

>  		    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
>  			goto bad_fork_cleanup_count;
>  	}
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 6b2e3ca7ee99..f0c04073403d 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -123,6 +123,8 @@ int create_user_ns(struct cred *new)
>  		ns->ucount_max[i] = INT_MAX;
>  	}
>  	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC));
> +	if (new->ucounts == &init_ucounts)
> +		set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_NPROC, RLIMIT_INFINITY);
>  	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_MSGQUEUE, rlimit(RLIMIT_MSGQUEUE));
>  	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_SIGPENDING, rlimit(RLIMIT_SIGPENDING));
>  	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_MEMLOCK, rlimit(RLIMIT_MEMLOCK));

First, I wanted to object this double fork_init() but I realized it's
relevant for newly created user_ns.

Second, I think new->ucounts would be correct at this point and the
check should be

> if (ucounts == &init_ucounts)

i.e. before set_cred_ucounts() new->ucounts may not be correct.

I'd suggest also a comment in the create_user_ns() explaining the
reason is to exempt global root from RLIMINT_NRPOC also indirectly via
descendant user_nss.

Thanks,
Michal
