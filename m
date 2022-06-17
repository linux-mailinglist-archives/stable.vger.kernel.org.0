Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79A854F460
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 11:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380637AbiFQJeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 05:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380379AbiFQJeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 05:34:19 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6BB17041;
        Fri, 17 Jun 2022 02:34:17 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1AAE51F9F2;
        Fri, 17 Jun 2022 09:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655458456; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h/9jqjrWjBq+e8n5l8yHB+T+IMUuGKVC8FC3ULDVvXU=;
        b=FTPJFKA8FeF9eqe9UAx56v0OCaYJQ98NUpJd/Fyu/841zDYpmp7V+vrQsAaMyJTaLIHpDY
        jW9QIC1yFPElNwZ+OaFngDZ+N+49bTldw4qwJSKasPgVqLc42YFrrwQd8+Us4hOBxatBb+
        0uyd0BqBYJUd6fO4ZwcpZKpnlDzIxvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655458456;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h/9jqjrWjBq+e8n5l8yHB+T+IMUuGKVC8FC3ULDVvXU=;
        b=EFEK7kcQRPw9Mm0TJwQfiIJswOmHv9RkqbMuwSjmowmKP+lRPUGBTalCTRC2LKzeJOIXfD
        gvMyeDTeYhGX+rCg==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B54492C141;
        Fri, 17 Jun 2022 09:34:15 +0000 (UTC)
Date:   Fri, 17 Jun 2022 11:34:14 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Coiby Xu <coxu@redhat.com>, kexec@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Baoquan He <bhe@redhat.com>,
        Dave Young <dyoung@redhat.com>, Will Deacon <will@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Chun-Yi Lee <jlee@suse.com>, stable@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 3/4] arm64: kexec_file: use more system keyrings to
 verify kernel image signature
Message-ID: <20220617093414.GA4660@kitsune.suse.cz>
References: <20220512070123.29486-1-coxu@redhat.com>
 <20220512070123.29486-4-coxu@redhat.com>
 <e44bb6b11573838417b5d561173c27a1571c94b6.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e44bb6b11573838417b5d561173c27a1571c94b6.camel@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Thu, Jun 09, 2022 at 07:15:27PM -0400, Mimi Zohar wrote:
> On Thu, 2022-05-12 at 15:01 +0800, Coiby Xu wrote:
> > Currently, a problem faced by arm64 is if a kernel image is signed by a
> > MOK key, loading it via the kexec_file_load() system call would be
> > rejected with the error "Lockdown: kexec: kexec of unsigned images is
> > restricted; see man kernel_lockdown.7".
> > 
> > This happens because image_verify_sig uses only the primary keyring that
> > contains only kernel built-in keys to verify the kexec image.
> 
> From the git history it's clear that .platform keyring was upstreamed
> during the same open window as commit 732b7b93d849 ("arm64: kexec_file:
> add kernel signature verification support").   Loading the MOK keys
> onto the .platform keyring was upstreamed much later.  For this reason,
> commit 732b7b93d849 only used keys on the  .builtin_trusted_keys
> keyring.   This patch is now addressing it and the newly upstreamed
> .machine keyring.
> 
> Only using the .builtin_trusted_keys is the problem statement, which
> should be one of the first lines of the patch description, if not the
> first line.
> 
> > 
> > This patch allows to verify arm64 kernel image signature using not only
> > .builtin_trusted_keys but also .platform and .secondary_trusted_keys
> > keyring.
> 
> Please remember to update this to include the .machine keyring.
> 
> > 
> > Fixes: 732b7b93d849 ("arm64: kexec_file: add kernel signature verification support")
> 
> Since the MOK keys weren't loaded onto the .platform keyring until much
> later, I would not classify this as a fix.

It's definitely a fix

ea93102f32244e3f45c8b26260be77ed0cc1d16c v4.19-rc1 Fix kexec forbidding kernels signed with keys in the secondary keyring to boot
732b7b93d849f8a44886ead563dfb6adec7f4419 v5.0-rc1 arm64: kexec_file: add kernel signature verification support

the arm code does not reflect the preexisting use of the secondary keyring.

278311e417be60f7caef6fcb12bda4da2711ceff v5.1-rc1 kexec, KEYS: Make use of platform keyring for signature

This was added a bit later, indeed.

Cherry-picking the changes one by one to the arm code you can get
separate fixes tag for each change.

Replacing the arm code with the x86 code by code deduplication you get
whatever is the state of the art in the kernel in question. In 5.0 you
get the secondary keyring, and since 5.1 you also get the platform
keyring.

Nonetheless, it's a fix for the arm code which is deficient from the
very start.

Thanks

Michal

