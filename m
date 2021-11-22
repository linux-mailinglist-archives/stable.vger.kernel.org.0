Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588834593F3
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 18:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbhKVR1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 12:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhKVR1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 12:27:04 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC99C061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 09:23:57 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id t24-20020a252d18000000b005c225ae9e16so29143671ybt.15
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 09:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PGtFrfPrOHCxalsNDu1KsjPp/sYbE7M30GQePbEZ9/E=;
        b=Jw+vAoD+TjWkU4zQAl2E3RyiNu7wOezu6mDkO34oBHYAqoA3Y84CEEkpsp9fy99EBc
         D3BjhrKjfVMFPiVQYV53l0PPl9kdskl/wGaHGUXEV1Wv+xyEwnvqma0IRJCCG2gza2eO
         C/ctanTZBauaAe9uGMTLF4uoMEVgTyyVMw9KC5aZP3HHGejXpGR/sQxPkZ4IBDhFX4+m
         9i9/7aHLGpE+ScSLM5jaVGZX4zkLe33+CPRoz/eaEye+nz8dvXdPywskPwli2zDRBWP0
         BHdwR9uac+aWwxAnamLZS2RROiz5Y8nCi+VDMQUeHW2cahVy5GY9mlWMTJlSJnZzPQBi
         OpTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PGtFrfPrOHCxalsNDu1KsjPp/sYbE7M30GQePbEZ9/E=;
        b=jXKwTvZQ6c7n5BJULrhZnNOQPE36TARVb13QD2PRAm77wO7UKhAjWWdbTG+A2NFPQk
         anSS3jTm97we8m96FENLshstF/IGAp3H9jw59JXC9D1tvopgnzf1AKuSX5Ahko407erf
         3jHFPLiFr4ChYkJFFlpSi9PwfdUGsWqqEoZi8DggJQXRUk1C6ob8eXkj1Hgqo5qliuNT
         MtOT/g3TEQFh1uJGv5rZPwXRELHmQFmKvZ74u01b60DcfeMyYT/03LRxTYozxclRGSk8
         AASoPL1pyJip9AlKZ1nGVpPS+HinxqCphUaYyu04rM74n2sSCAnDsOc9YJ0mFZP/aWnU
         WqHg==
X-Gm-Message-State: AOAM530eJ/7Zs19bzpxVouWiUJ0urzH1Cv44X868nqSo2cJ/ci06KXgz
        bGAIf2EENgQlbN8qbNaXw/N1BDOaHNdu
X-Google-Smtp-Source: ABdhPJydMfs4NTkUapC/GfqccCHbBUyikgcqt9Mtw0GvUG62LQUB83DI1OA+kXAQ/2RW+sTFNHJWkbwKu70/
X-Received: from gthelen2.svl.corp.google.com ([2620:15c:2cd:202:e00:41d2:6dc5:6993])
 (user=gthelen job=sendgmr) by 2002:a05:6902:52b:: with SMTP id
 y11mr61662285ybs.199.1637601837135; Mon, 22 Nov 2021 09:23:57 -0800 (PST)
Date:   Mon, 22 Nov 2021 09:23:55 -0800
In-Reply-To: <YZe1RlVuseJi1M1T@kroah.com>
Message-Id: <xr93wnl0gl3o.fsf@gthelen2.svl.corp.google.com>
Mime-Version: 1.0
References: <xr9335nxwc5y.fsf@gthelen2.svl.corp.google.com> <YZe1RlVuseJi1M1T@kroah.com>
Subject: Re: STABLE REQUEST: perf/core: Avoid put_page() when GUP fails
From:   Greg Thelen <gthelen@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> wrote:

> On Mon, Nov 15, 2021 at 09:39:53AM -0800, Greg Thelen wrote:
>> The patch titled ("perf/core: Avoid put_page() when GUP fails") has been
>> merged into linus/master as commit
>> 4716023a8f6a0f4a28047f14dd7ebdc319606b84.
>> 
>> The patch fixes an issue present in all v4.14+ kernels that can cause
>> page reference count underflow, which can lead to unintentional page
>> sharing.
>> 
>> The patch did not have cc: stable footer, so I'm manually requesting
>> -stable inclusion into v4.14+.
>> 
>> There are some trivial conflicts in older kernels. I'd be happy to
>> review/test, if that's useful.
>
> Please provide working versions for 4.14, 4.19, and 5.4.  The others
> kernels applied just fine.
>
> thanks,
>
> greg k-h

Done. Backported and tested on stable 4.14-y, 4.19-y, and 5.4-y:
https://lore.kernel.org/stable/20211122171825.1582436-1-gthelen@google.com/
https://lore.kernel.org/stable/20211122171824.1582407-1-gthelen@google.com/
https://lore.kernel.org/stable/20211122171818.1582357-1-gthelen@google.com/
