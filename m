Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4004B6931
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 11:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbiBOKZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 05:25:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiBOKZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 05:25:30 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B60222B3D;
        Tue, 15 Feb 2022 02:25:21 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1B04C1F38A;
        Tue, 15 Feb 2022 10:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644920720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YGR5xNdMddG1r9ffll2bZVgu5smsqg8zr1h/pc18qAI=;
        b=Ix+yXlLTyk2EtJi5gmicwbx3fBeJbYgnqUOgVLGrC+JXf9LIgEUIM77i/stAanTHUwZxgu
        u9MO9Jj/g/wvUYGVLqVMpmBNStGq/OyFvSOAs6wL0YyAZaKvGy8RGvfnA7NF1brPYnEDuT
        +btvbPBQA6lGWJ80XeLOueDHyodYJlg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EEE2E13C16;
        Tue, 15 Feb 2022 10:25:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id M27MOY9/C2LnHQAAMHmgww
        (envelope-from <mkoutny@suse.com>); Tue, 15 Feb 2022 10:25:19 +0000
Date:   Tue, 15 Feb 2022 11:25:18 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Solar Designer <solar@openwall.com>, linux-kernel@vger.kernel.org,
        Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 3/8] ucounts: Fix and simplify RLIMIT_NPROC handling
 during setuid()+execve
Message-ID: <20220215102518.GE21589@blackbody.suse.cz>
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
 <20220211021324.4116773-3-ebiederm@xmission.com>
 <20220212231701.GA29483@openwall.com>
 <87ee45wkjq.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ee45wkjq.fsf@email.froward.int.ebiederm.org>
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

On Mon, Feb 14, 2022 at 09:10:49AM -0600, "Eric W. Biederman" <ebiederm@xmission.com> wrote:
> I really like how cleanly this patch seems to be.  Unfortunately it is
> wrong.

It seems [1] so:

setuid()		// RLIMIT_NPROC is fine at this moment
...		fork()
		...
...		fork()
execve()		// eh, oh

This "punishes" the exec'ing task although the cause is elsewhere.

Michal

[1] The decoupled setuid()+execve() check can be interpretted both ways.
I understood historically the excess at the setuid() moment is relevant.
