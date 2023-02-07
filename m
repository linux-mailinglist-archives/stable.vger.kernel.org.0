Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B932F68E461
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 00:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjBGX0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 18:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBGXZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 18:25:59 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092F83E63D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 15:25:59 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id bg10-20020a17090b0d8a00b00230c7f312d4so416784pjb.3
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 15:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Je4whiO/TBuZJrryH3c0dVAsCLPrQIWfobnwlHiSJwk=;
        b=qqNlWuZNYSKSdu9Y5oakVXmFqG2X8mEwoDcAGQzO0P1ksDl0snc9gY4U2w/iX9ydiH
         1KewYuAR3Yp58eWxq8I5MDfyTTPtcl439fiPYh4RaB/4tzqC8PsAZR++quZq9PNbf8J2
         xDo3Bv1qBuG+9DbNeDdrPg4gmYw7haKmnqSuoanMbrYcKGThAtIEHeeL/TJK0AMCdN5+
         217TcpNVHI+fXBNCrJQLsLCrisSMnoQEdjKzzyJUwpIQ/tc6Ys1n50rfox35YO6XuloV
         pBIuYGMNvWbJfQZGIDbko1V4LmCoEO6k0RvD0rTEwr18ajD5bp0P3RrVrEPPDtHpwnkq
         PPVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Je4whiO/TBuZJrryH3c0dVAsCLPrQIWfobnwlHiSJwk=;
        b=S/ZkXAq5807TUe+flKhar15rNp2z31ZhAwKljCSk0f6wGr4MycKXn1t0H8Sh5jggpo
         c4ttku+XUqbDgsYmbio5iI0vYsPFDNDMgDU+K+ZOGKvI3/wdj8JlXHihJQ0iR7mETk0U
         O9ovNTF5PSD8iElc+Sg5XqC+y6IjHwtmSsYxDCDjHbSorOhEqdyjvGvrQbAWYDjp3LhU
         kBId1kGAleZaWU7xKSa7S7GjiWmbLV9LJvn6R8VyIoEU8v2hkPO/ygcBDSg1toLraFJR
         GQvWYhrah9Ts3xn925c+T+ciJ3sU9wxocWYhM86vPL941fyyDWHHf2e2urx3MhOTDJRb
         kKiw==
X-Gm-Message-State: AO0yUKWnhLxCXziOwICAOt+8jTyBt5q6WB1VwLu7jKmsG0EYGv1OyZzC
        eFaMX4SqsQopSCEv19ljLc4JDA==
X-Google-Smtp-Source: AK7set+pJTkcm2a/8WW77LNrWRQKWtbUlQHmd9udp31uw5HDgw/ByRmHAUrjdjvpBwRJkmqyxizidQ==
X-Received: by 2002:a17:902:e80e:b0:198:af4f:de09 with SMTP id u14-20020a170902e80e00b00198af4fde09mr65731plg.9.1675812358246;
        Tue, 07 Feb 2023 15:25:58 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 6-20020a17090a08c600b0022bfa25dd88sm70712pjn.40.2023.02.07.15.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 15:25:57 -0800 (PST)
Date:   Tue, 7 Feb 2023 23:25:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Andy Nguyen <theflow@google.com>,
        Thomas Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] KVM: sev: Fix potential overflow
 send|recieve_update_data
Message-ID: <Y+LeAfc61yrYerhk@google.com>
References: <20230207171354.4012821-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207171354.4012821-1-pgonda@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For now at least, I want to keep with "KVM: SVM:" instead of using "KVM: SEV:".
Many commits that touch SEV aren't strictly isolated to SEV, which means the "SEV"
tag is unreliable.  There's also the question of taggin SEV vs. SEV-ES vs. SEV-SNP.
It's usually easy enough to squeeze SEV (or SEV-ES or SNP) into the shortlog, e.g.

  KVM: SVM: Fix potential overflow in SEV's send|receive_update_data()

On Tue, Feb 07, 2023, Peter Gonda wrote:
> KVM_SEV_SEND_UPDATE_DATA and KVM_SEV_RECEIVE_UPDATE_DATA have an integer
> overflow issue. Params.guest_len and offset are both 32bite wide, with a

"32 bits"

> large params.guest_len the check to confirm a page boundary is not
> crossed can falsely pass:
> 
>     /* Check if we are crossing the page boundary *
>     offset = params.guest_uaddr & (PAGE_SIZE - 1);
>     if ((params.guest_len + offset > PAGE_SIZE))
> 
> Add an additional check to this conditional to confirm that

Eh, "to this conditional" is unnecessarily precise.

> params.guest_len itself is not greater than PAGE_SIZE.
> 
> The current code is can only overflow with a params.guest_len of greater

"is can", though I vote to omit the "current code" part entirely, it should be
obvious that this is talking about the pre-patched code.

> than 0xfffff000. And the FW spec says these commands fail with lengths
> greater than 16KB. So this issue should not be a security concern

Slightly reworded, how about this for the "not a security concern" disclaimer?

  Note, this isn't a security concern as overflow can happen if and only if
  params.guest_len is greater than 0xfffff000, and the FW spec says these
  commands fail with lengths greater than 16KB, i.e. the PSP will detect
  KVM's goof.

No need to send a v3, I'll fix up the changelog when applying.  Holler if you
disagree with anything though.

Thanks!
