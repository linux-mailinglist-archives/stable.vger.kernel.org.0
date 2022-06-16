Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6415254D706
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 03:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344378AbiFPBZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 21:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345025AbiFPBZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 21:25:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56BA2393DA
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 18:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655342719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D44Dr4YMc8cT2I8kBBUFAcAZBxETYvbJSxn5FHOEfW4=;
        b=MDQV+jh1SXU4WYxkXXdSTQ7AmkCPtC8INSAkYAGX2yimTdXcJqZY8xJRPqiS54MRcdPhk0
        yF94HvC4ule7VltMlJwwjvRDkcPVgK1L8eYNlLgmPS4xVQ+p7Ee8fgjoFk3ayCMtFP0m9n
        o06DrUE0jCqN10Y6ZAnjntpgfvruxzE=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-mRQjaAL4MQOIHlGTDCqVvg-1; Wed, 15 Jun 2022 21:25:18 -0400
X-MC-Unique: mRQjaAL4MQOIHlGTDCqVvg-1
Received: by mail-pg1-f199.google.com with SMTP id g129-20020a636b87000000b00401b8392ac8so7312222pgc.4
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 18:25:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D44Dr4YMc8cT2I8kBBUFAcAZBxETYvbJSxn5FHOEfW4=;
        b=6v6Y6IfjXClYdTF9hdtdEZsyHYGpJOL4N1e/UlJ1BTxr8U49Tb2RrtvIz14ue0fsXP
         4QWbaJ2GS+su1QlCfIBOwkQ5upyt7TrIO+YHHaNlJ9Ac0uXMCvbNFrwZw0LxvMSpxoxL
         De7M27ox9qBvTa6s8TUBkHwqdX6Lyo3XOq00t3qADXcjeT+GOaSfcSXnz0byU4Cn+uKL
         rP0+DfQe6kiIm1ifq/RvAk2ZF6eu2NHurEFntw+b5gkNeROL22B2iVFu/w3fQbanpvFb
         ++8iD7PGg2LhlEr+tEtFV9xGofxpQHCZ77zN1aFx+180nJ9uWeGrRWchRtnPd64vUPcW
         O38w==
X-Gm-Message-State: AJIora/9t+NGaFCSThniIHlcn/iAqKaRSM4jw0mTZuFezoilwzqdO8wS
        8LMOWbEPLhai7UM5BJCokvuJZUSoMLUiikn9SDnYcX89l6jvrAjrFhfUzxrnZouZXdHQW2C/yuU
        qkFZ4Kg3/YkLt+bXb
X-Received: by 2002:a17:90b:1d0a:b0:1e8:7f14:8db with SMTP id on10-20020a17090b1d0a00b001e87f1408dbmr13087394pjb.218.1655342717160;
        Wed, 15 Jun 2022 18:25:17 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sOjYTGh40XzdifkbuDHlq13ntELiTF3c1SqlwRgQ4mA+C9ql0VnOeF8KNef5kg+vvKioqBXA==
X-Received: by 2002:a17:90b:1d0a:b0:1e8:7f14:8db with SMTP id on10-20020a17090b1d0a00b001e87f1408dbmr13087362pjb.218.1655342716811;
        Wed, 15 Jun 2022 18:25:16 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 203-20020a6218d4000000b0051ba0ee30cbsm275270pfy.128.2022.06.15.18.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 18:25:16 -0700 (PDT)
Date:   Thu, 16 Jun 2022 09:22:32 +0800
From:   Coiby Xu <coxu@redhat.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     kexec@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        Michal Suchanek <msuchanek@suse.de>,
        Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
        Will Deacon <will@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Chun-Yi Lee <jlee@suse.com>, stable@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 3/4] arm64: kexec_file: use more system keyrings to
 verify kernel image signature
Message-ID: <20220616012232.5rjmukabncqnus5s@Rk>
References: <20220512070123.29486-1-coxu@redhat.com>
 <20220512070123.29486-4-coxu@redhat.com>
 <e44bb6b11573838417b5d561173c27a1571c94b6.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e44bb6b11573838417b5d561173c27a1571c94b6.camel@linux.ibm.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 09, 2022 at 07:15:27PM -0400, Mimi Zohar wrote:
>On Thu, 2022-05-12 at 15:01 +0800, Coiby Xu wrote:
>> Currently, a problem faced by arm64 is if a kernel image is signed by a
>> MOK key, loading it via the kexec_file_load() system call would be
>> rejected with the error "Lockdown: kexec: kexec of unsigned images is
>> restricted; see man kernel_lockdown.7".
>>
>> This happens because image_verify_sig uses only the primary keyring that
>> contains only kernel built-in keys to verify the kexec image.
>
>From the git history it's clear that .platform keyring was upstreamed
>during the same open window as commit 732b7b93d849 ("arm64: kexec_file:
>add kernel signature verification support").   Loading the MOK keys
>onto the .platform keyring was upstreamed much later.  For this reason,
>commit 732b7b93d849 only used keys on the  .builtin_trusted_keys
>keyring.   This patch is now addressing it and the newly upstreamed
>.machine keyring.

Thanks for explaining the history to me!

>
>Only using the .builtin_trusted_keys is the problem statement, which
>should be one of the first lines of the patch description, if not the
>first line.

Thanks for the suggestion! I've provided a new version of commit message
in the end.

>
>>
>> This patch allows to verify arm64 kernel image signature using not only
>> .builtin_trusted_keys but also .platform and .secondary_trusted_keys
>> keyring.
>
>Please remember to update this to include the .machine keyring.

Sure, thanks for the reminder!

>
>>
>> Fixes: 732b7b93d849 ("arm64: kexec_file: add kernel signature verification support")
>
>Since the MOK keys weren't loaded onto the .platform keyring until much
>later, I would not classify this as a fix.

For this Fixes tag, I mean arm64 couldn't make use of the secondary
keyring because a secondary system keyring was introduced long before
commit 732b7b93d849 ("arm64: kexec_file: add kernel signature
verification support"),

	commit d3bfe84129f65e0af2450743ebdab33d161d01c9
	Author: David Howells <dhowells@redhat.com>
	Date:   Wed Apr 6 16:14:27 2016 +0100
	
	    certs: Add a secondary system keyring that can be added to dynamically
	
	
	commit 732b7b93d849f8a44886ead563dfb6adec7f4419
	Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
	Date:   Thu Nov 15 14:52:54 2018 +0900
	
	    arm64: kexec_file: add kernel signature verification support

Of course, my commit message is misleading since it talks about MOK key
in the first line. If stating the problem as arm64 only using the
.builtin_trusted_keys as suggested by you, I think this Fixes tag would
make sense. How about the following one?

Currently, when loading a kernel image via the kexec_file_load() system
call, arm64 can only use the .builtin_trusted_keys keyring to verify
a signature whereas x86 can use three more keyrings i.e.
.secondary_trusted_keys, .machine and .platform keyrings. For example,
one resulting problem is kexec'ing a kernel image  would be rejected
with the error "Lockdown: kexec: kexec of unsigned images is restricted;
see man kernel_lockdown.7".
  
This patch set enables arm64 to make use of the same keyrings as x86 to
verify the signature kexec'ed kernel image. 

Fixes: 732b7b93d849 ("arm64: kexec_file: add kernel signature verification support")


>
>thanks,
>
>Mimi
>

-- 
Best regards,
Coiby

