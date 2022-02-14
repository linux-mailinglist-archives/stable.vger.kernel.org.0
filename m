Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5838D4B5A03
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 19:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238782AbiBNShj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 13:37:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiBNShj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 13:37:39 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF9160ABE;
        Mon, 14 Feb 2022 10:37:30 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2D80A1F38A;
        Mon, 14 Feb 2022 18:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644863849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hcAP1oYRKlVZf+ejwok9nLI2R/eE64Eg/5Ilx8Cevaw=;
        b=mKoMck6I7z0K8iD8TC1sp81Sq377hEFQ0MnsnbZj+N2a9zXv5vKRAHC6mPUFiHBBAS8faE
        5OuPLV4QNi/EXTMWfaEsG0kiFbwM6EfutYXrIKrNAiw+1Kxghfi9dRG/wmtArgm4br+BdH
        4TPyenKVQwpcIOGTeaKF1ZwQQmmEzSw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0A97F13A85;
        Mon, 14 Feb 2022 18:37:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xsMQAmmhCmJNRAAAMHmgww
        (envelope-from <mkoutny@suse.com>); Mon, 14 Feb 2022 18:37:29 +0000
Date:   Mon, 14 Feb 2022 19:37:27 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-kernel@vger.kernel.org, Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Solar Designer <solar@openwall.com>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        containers@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/8] ucounts: Fix RLIMIT_NPROC regression
Message-ID: <20220214183727.GA10803@blackbody.suse.cz>
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
 <20220211021324.4116773-1-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220211021324.4116773-1-ebiederm@xmission.com>
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

On Thu, Feb 10, 2022 at 08:13:17PM -0600, "Eric W. Biederman" <ebiederm@xmission.com> wrote:
> This can be fixed either by fixing the test or by moving the increment
> to be before the test.  Fix it my moving copy_creds which contains
> the increment before is_ucounts_overlimit.

This is simpler than my approach and I find it correct too.

> Both the test in fork and the test in set_user were semantically
> changed when the code moved to ucounts.  The change of the test in
> fork was bad because it was before the increment.
>
> The test in set_user was wrong and the change to ucounts fixed it.  So
> this fix is only restore the old behavior in one lcatio not two.

Whom should be the task accounted to in the case of set*uid? (The change
to ucounts made the check against the pre-switch user's ucounts.)

> ---
>  kernel/fork.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Reviewed-by: Michal Koutný <mkoutny@suse.com>

