Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3A94B6A61
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 12:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiBOLLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 06:11:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236996AbiBOLKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 06:10:45 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F06107D0B;
        Tue, 15 Feb 2022 03:10:36 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1902E210F9;
        Tue, 15 Feb 2022 11:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644923435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BHEbbqhZ9bplcn2cVncV8XJfPQy+VWY5Bk3UorYJFo0=;
        b=qrFWcd3RhhUPupOQfdAdVOyPq2GQWXMnWMXmrKG/1QayZTBWHsyX/u4aj0zTYGJPe3q6gJ
        EQKeBFYUBk78gsNJ8rGjz0rOBA98bNg/NTuwZxDfB9EK255gdauWR3J2dwHbUYf7H9cfVs
        J3T2mcwGnD4q+3IUVS9rdJYc0PXqaVc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E5B3A13C40;
        Tue, 15 Feb 2022 11:10:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fa0nNyqKC2LgNAAAMHmgww
        (envelope-from <mkoutny@suse.com>); Tue, 15 Feb 2022 11:10:34 +0000
Date:   Tue, 15 Feb 2022 12:10:33 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-kernel@vger.kernel.org, Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Solar Designer <solar@openwall.com>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        containers@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/8] ucounts: Fix set_cred_ucounts
Message-ID: <20220215111033.GG21589@blackbody.suse.cz>
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
 <20220211021324.4116773-2-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220211021324.4116773-2-ebiederm@xmission.com>
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

On Thu, Feb 10, 2022 at 08:13:18PM -0600, "Eric W. Biederman" <ebiederm@xmission.com> wrote:
> diff --git a/kernel/cred.c b/kernel/cred.c
> index 473d17c431f3..933155c96922 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -665,21 +665,16 @@ EXPORT_SYMBOL(cred_fscmp);
>  
>  int set_cred_ucounts(struct cred *new)
>  {
> -	struct task_struct *task = current;
> -	const struct cred *old = task->real_cred;
>  	struct ucounts *new_ucounts, *old_ucounts = new->ucounts;
>  
> -	if (new->user == old->user && new->user_ns == old->user_ns)
> -		return 0;
> -
>  	/*
>  	 * This optimization is needed because alloc_ucounts() uses locks
>  	 * for table lookups.
>  	 */
> -	if (old_ucounts->ns == new->user_ns && uid_eq(old_ucounts->uid, new->euid))
> +	if (old_ucounts->ns == new->user_ns && uid_eq(old_ucounts->uid, new->uid))
>  		return 0;
>  
> -	if (!(new_ucounts = alloc_ucounts(new->user_ns, new->euid)))
> +	if (!(new_ucounts = alloc_ucounts(new->user_ns, new->uid)))
>  		return -EAGAIN;
>  
>  	new->ucounts = new_ucounts;

Reviewed-by: Michal Koutný <mkoutny@suse.com>
