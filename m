Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3755171B3
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 16:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237875AbiEBOlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 10:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237799AbiEBOla (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 10:41:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F35CF10BD
        for <stable@vger.kernel.org>; Mon,  2 May 2022 07:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651502281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wVoPR7+BaUM00iEkwlBxjF0xXPgmMZX2vpPWycEtV78=;
        b=ZS2/40R1iUOIYVDEhNdS10GFGN5FbeZEKHU8f2VEETFm8HuMOX/5Y+wypBiTHq0gcnjwRM
        IbmP2ROLc9S8T4oqkv32x75Ofl+iO/OG1RGMSZQHqy77qxTL8NHPNo8e3F5zUohhYmUy5o
        JTcAMpTCeJIwr/nGlH6knbsRIoLQDRU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-MmWCcKafP32gX5GLYtBFzw-1; Mon, 02 May 2022 10:37:59 -0400
X-MC-Unique: MmWCcKafP32gX5GLYtBFzw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E91C3806707;
        Mon,  2 May 2022 14:37:58 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.34])
        by smtp.corp.redhat.com (Postfix) with SMTP id DBB8540869CE;
        Mon,  2 May 2022 14:37:52 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Mon,  2 May 2022 16:37:57 +0200 (CEST)
Date:   Mon, 2 May 2022 16:37:51 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-kernel@vger.kernel.org, rjw@rjwysocki.net, mingo@kernel.org,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, mgorman@suse.de, bigeasy@linutronix.de,
        Will Deacon <will@kernel.org>, tj@kernel.org,
        linux-pm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-um@lists.infradead.org, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org, Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, linux-ia64@vger.kernel.org,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 06/12] ptrace: Reimplement PTRACE_KILL by always
 sending SIGKILL
Message-ID: <20220502143750.GC17276@redhat.com>
References: <87k0b7v9yk.fsf_-_@email.froward.int.ebiederm.org>
 <20220429214837.386518-6-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429214837.386518-6-ebiederm@xmission.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/29, Eric W. Biederman wrote:
>
> Call send_sig_info in PTRACE_KILL instead of ptrace_resume.  Calling
> ptrace_resume is not safe to call if the task has not been stopped
> with ptrace_freeze_traced.

Oh, I was never, never able to understand why do we have PTRACE_KILL
and what should it actually do.

I suggested many times to simply remove it but OK, we probably can't
do this.

> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -1238,7 +1238,7 @@ int ptrace_request(struct task_struct *child, long request,
>  	case PTRACE_KILL:
>  		if (child->exit_state)	/* already dead */
>  			return 0;
> -		return ptrace_resume(child, request, SIGKILL);
> +		return send_sig_info(SIGKILL, SEND_SIG_NOINFO, child);

Note that currently ptrace(PTRACE_KILL) can never fail (yes, yes, it
is unsafe), but send_sig_info() can. If we do not remove PTRACE_KILL,
then I'd suggest

	case PTRACE_KILL:
		if (!child->exit_state)
			send_sig_info(SIGKILL);
		return 0;

to make this change a bit more compatible.

Also, please remove the note about PTRACE_KILL in set_task_blockstep().

Oleg.

