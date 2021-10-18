Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B5F432821
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 22:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhJRUH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 16:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhJRUH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 16:07:27 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA1DC06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 13:05:16 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id g5so12068487plg.1
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 13:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gA5NVBhwNW6cB47b6gADEH6G16s82hlNxMBdMQJ46G4=;
        b=SfaHX5YKldLyP3NtC+ktRQct4C+/GIRlpXxDZ9s68Y0YxnZuS8wh5ZJxfgE0maUIHq
         lVNuNsueljz7+BSE1iCbBtdSuAszidqeRlOCs6GDsOD+yrp5H/kZVTckts1UOleBYgFs
         aoVX1xzDWAXh7x4kNe8tGES57oERW9QwogHazvnM5HczEg7pa5/o2H+2lMHr1V50WDV7
         jTihlgUATf3SQnWoLqUPQDtkStaUclvHepANzW/z1syaRhicRUHkLTGgOAfreFCVzCK1
         tv63MtIYQtAB3ZAh1hS2qHJxFyyuOEPpNgdYr23ZR84YxFNmxX6XZRJXUNaV0JQ4JUqK
         8pmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gA5NVBhwNW6cB47b6gADEH6G16s82hlNxMBdMQJ46G4=;
        b=x8IPUOuWjv26mn2ZcbnCLLsioADEbHC41Q2mQ1E8IjOiYt1wvbZ5rlhPnu2yvKyN+u
         V9hirvV5w0rKQAsX88SNRaHgBONF8lQbzDkQc6KxftfWtUFhRQpAEv95jQsVAPnLVJso
         e5/8+9t81g1Hxa2qEvQwCZS8dsjSXirKqsA5TGxqD79xPtZgCAr7OFpiRo/txIHELwiE
         T3QSroMe+yMv1lZOgyTw/dUBQ2n6PMNkiQ9nZB55d3u+GqLU1fsIP0193a9YcQKGrS6t
         8UKPyOz+tRx0lz3Qj+RdkRPGMqj8kiHOGobBKHhw2XOkJeWn+CpshjLq5LzL8B+yFGVg
         gPIA==
X-Gm-Message-State: AOAM531YtmeNTWKylOon04dBKZLwjwOkpLqJ+xmtI0UnM+TBjJBT/Idx
        iCcT5r9mAKt0uKBcMc7fU364IQ==
X-Google-Smtp-Source: ABdhPJwSxbIu5Hn2VcVRe6RKLH//qooKR5tgpTVxwkjGgW2GG1l4y28tCj7bxanZ6i+w3vp1TpVD8g==
X-Received: by 2002:a17:90b:4b07:: with SMTP id lx7mr1097565pjb.195.1634587515606;
        Mon, 18 Oct 2021 13:05:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id kb15sm272822pjb.43.2021.10.18.13.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 13:05:14 -0700 (PDT)
Date:   Mon, 18 Oct 2021 20:05:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jane Malalane <jane.malalane@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Pu Wen <puwen@hygon.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Message-ID: <YW3TdmEe/mx/5aOO@google.com>
References: <20211013142230.10129-1-jane.malalane@citrix.com>
 <YW25x7AYiM1f1HQA@zn.tnic>
 <YW3LJdztZom+xQHv@google.com>
 <YW3M40tOILjI3DiD@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YW3M40tOILjI3DiD@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021, Borislav Petkov wrote:
> On Mon, Oct 18, 2021 at 07:29:41PM +0000, Sean Christopherson wrote:
> > I agree.  If the argument for this patch is that the kernel can be migrated to
> > older hardware, then it stands to reason that the kernel could also be migrated
> > to a different CPU vendor entirely.  E.g. start on Intel, migrate to Zen1, kaboom.
> 
> Migration across vendors? Really, that works?
> 
> I'll believe it only when I see it with my own eyes.

There are plenty of caveats, but it is feasible.  KVM even has a few patches that
came about specifically to support cross-vendor migration, e.g. commit adc2a23734ac
("KVM: nSVM: improve SYSENTER emulation on AMD").
