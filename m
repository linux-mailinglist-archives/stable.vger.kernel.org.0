Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1ED768E5CE
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 03:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjBHCHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 21:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBHCHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 21:07:31 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C286A42DE2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 18:07:21 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id h1-20020a17090a470100b0022646263abfso324565pjg.6
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 18:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fjLzNTffPyNKoOpCO+EIjjZIhIIdZ+k/heQ8Ni+Ji9s=;
        b=T/qLoacl4043qKDNr0mWzqcXWDu6+/xWES7FCxj9m+ETC0cQx8gp5SAmSWDEuQ1fKs
         JHCR9RUeUdCQE0KQwBKNfhKXYHdZtGHQPfigAU7w8NKkEWINNqszEspFI4N1OPHpLJri
         jGW8yBAYYPaH4hWZO0YT16h7pRu3K7QJ2QZtr0OLwfSQgFoBwesCHkWwAu4ViXdAykt3
         8lQyR3RVDHOXYPrbD/PNh2QECfcPqcy0KOAxn6JlAf5cXBIyGSWOOz80Xc41y24ouTch
         wHvCCUtHtMSwIIMV1JcpJJLlQvRcwWyAWsVgHqmCO7FIgqKiAD4LcyF92XF3xvp62hun
         5/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fjLzNTffPyNKoOpCO+EIjjZIhIIdZ+k/heQ8Ni+Ji9s=;
        b=7olX14NpwUoayDLR8PZPKEOuhufZqK9zB8l7tdQng9bfQ7om7QEBBLqnT6sgomuJyJ
         sDQ9CKd8RBWIivYpSrEZFJtP8V5c3zOdys+fRc5Y4bqdKs6u7U3OI0/h9t1+B6Tzs3ey
         sY7mMT9+iO1hYrAOjiOD0MZW5yaLLIlFJKSNG8LpbTPkFQQRtQoGOICYDefbhGQVMlYf
         hmlBj8mvlb1UzoLkIu9D6azrSU5Am51oIw2xVtz+jRMQ9oGvYO1KlyNB5+M+atHfGx2R
         ET5gYkIBgDhr9Yuqr9pCd6cZ2lH8j6augblNzzTbn5/w3JfkKcIWsMbogMgwft/0PWtB
         KkPg==
X-Gm-Message-State: AO0yUKUmDvsraLCdZASBgoLAXDTBuJduFY1ROjfVOlcy1wpkY3befD8t
        e4FO7zAV9ReGWmVp+q260LSUSaFggKI=
X-Google-Smtp-Source: AK7set+DjTRucDhx3PWAF+ihgr95vPESJel7rr9CCKa2wrx0LnOGkfytGz3XKsY7kl68vd4rlYLTEiBrQcU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:98db:0:b0:593:f41a:fc78 with SMTP id
 e27-20020aa798db000000b00593f41afc78mr1274746pfm.25.1675822041143; Tue, 07
 Feb 2023 18:07:21 -0800 (PST)
Date:   Wed,  8 Feb 2023 02:07:02 +0000
In-Reply-To: <20230207171354.4012821-1-pgonda@google.com>
Mime-Version: 1.0
References: <20230207171354.4012821-1-pgonda@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <167580939268.351288.874111179458946336.b4-ty@google.com>
Subject: Re: [PATCH V2] KVM: sev: Fix potential overflow send|recieve_update_data
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Peter Gonda <pgonda@google.com>
Cc:     Andy Nguyen <theflow@google.com>,
        Thomas Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 07 Feb 2023 09:13:54 -0800, Peter Gonda wrote:
> KVM_SEV_SEND_UPDATE_DATA and KVM_SEV_RECEIVE_UPDATE_DATA have an integer
> overflow issue. Params.guest_len and offset are both 32bite wide, with a
> large params.guest_len the check to confirm a page boundary is not
> crossed can falsely pass:
> 
>     /* Check if we are crossing the page boundary *
>     offset = params.guest_uaddr & (PAGE_SIZE - 1);
>     if ((params.guest_len + offset > PAGE_SIZE))
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: sev: Fix potential overflow send|recieve_update_data
      https://github.com/kvm-x86/linux/commit/f94f053aa3a5

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
