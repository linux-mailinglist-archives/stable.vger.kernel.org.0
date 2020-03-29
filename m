Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E46B196E82
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 18:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgC2Qlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 12:41:40 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33035 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbgC2Qlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 12:41:40 -0400
Received: by mail-lj1-f193.google.com with SMTP id f20so15395365ljm.0
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 09:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nk/py5jZBxzObOcby51mXWU/kobKG+iABnzbduyumWs=;
        b=UoW389smPUOgJiH5VJ1JgiTbIMh5/cRiosrYaI5qZp+IuieoBnnrNionqiEhpZE8Wa
         26ZosCi7ha4Jh3uB97q6BC3GwSXw1afXgKjvIPHU2Mjl5C29i+n65ZrZ1F4ye4Wuaf1Q
         DajnrSEQZS6NIzGEk39wRcOFk02i+EVLH1+kI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nk/py5jZBxzObOcby51mXWU/kobKG+iABnzbduyumWs=;
        b=Ev0NagkCyqj5ipdGN7ZhKKDdofNUstnWQNGIeLL9FY3IEza2iDPFmqhE84efFpWkiB
         4PFJ/6vWvOYlSbCBWwumwGsO+O1rTUj4x4EejE1kWpBomYsRZ9SvzQIcgUVVfjDEPxnI
         5JtgDNKMaw0lC+0L1X4hAHO+L3LNpMYeoH53lq1diGYUdHBRU+GGrQGdhXyFa20vIhS1
         BCNzUP1D2B+wU+9V5eWkWE3C8QG0G9PpL1crskp2zq/jPBS8pTPt3K7js8O9eQmlm0+X
         D6RsRkIk1pSqqzLS6126dKT8Hv2KodKb+C3GJUkUUDMuCSglv5w4x9Qy7mOi4AfttyB5
         pCAA==
X-Gm-Message-State: AGi0PuYDJC3Lwk4T5ktQkHCMW6plJMC300VRN/N+AwTFU1mdH7hA/dKC
        xoBkWqvmN2EngnxbTOYI5elrmxhDwZk=
X-Google-Smtp-Source: APiQypJl6oQPsKXPotFYcgObe+qseAxHGEG8H3qaUigi0nBI2HZeuuTLYS9AZBed/WAo8LM0udTooQ==
X-Received: by 2002:a2e:96ca:: with SMTP id d10mr3363667ljj.273.1585500097033;
        Sun, 29 Mar 2020 09:41:37 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id u8sm6446103lfk.93.2020.03.29.09.41.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 09:41:35 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id r7so7699666ljg.13
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 09:41:35 -0700 (PDT)
X-Received: by 2002:a2e:9b8e:: with SMTP id z14mr4972188lji.150.1585500095183;
 Sun, 29 Mar 2020 09:41:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200328191456.4fc0b9ca86780f26c122399e@linux-foundation.org> <20200329021725.na3Cd6vpE%akpm@linux-foundation.org>
In-Reply-To: <20200329021725.na3Cd6vpE%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 29 Mar 2020 09:41:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiixaPEW_AMhVkiypoADfp4Jdt3cX=6LN_f=yE9yTpK9g@mail.gmail.com>
Message-ID: <CAHk-=wiixaPEW_AMhVkiypoADfp4Jdt3cX=6LN_f=yE9yTpK9g@mail.gmail.com>
Subject: Re: [patch 4/5] mm: fork: fix kernel_stack memcg stats for various
 stack implementations
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     bharata@linux.ibm.com, Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux-MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>,
        mm-commits@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 28, 2020 at 7:17 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Note: This is a special version of the patch created for stable
> backports. It contains code from the following two patches:
>   - mm: memcg/slab: introduce mem_cgroup_from_obj()
>   - mm: fork: fix kernel_stack memcg stats for various stack implementations

Whaa?

Nonsensical commit comment removed.

                Linus
