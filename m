Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75AA2162F11
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 19:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgBRSyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 13:54:01 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45052 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgBRSyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 13:54:01 -0500
Received: by mail-lj1-f193.google.com with SMTP id q8so24156074ljj.11
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 10:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gInmCZBr53UYRN/0yNo3xgcN+xMMFqgmTLh6dxUQ8E4=;
        b=QlbEHSRfkbu7KS+THYfLYq63FliUeh77hmRjUROQFp94gIFTzMuzUhxH0VcrEPWC37
         yJf+X25qCjCpYArPLbxLXcRp42Pd1jfikvfZEA2NJnIKHwC5rNGfxmsKVeUYcU314FvM
         7tU+JcTTL1VwCcjNBZZ3j3BM0KB+XtlR77//4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gInmCZBr53UYRN/0yNo3xgcN+xMMFqgmTLh6dxUQ8E4=;
        b=TzFZx3FFFMSGaAmPVuHd5pb5VoIRX/m7tNdyrLEaJ+e84VgWJPUQIlLFl4oQ0c6I3Q
         qX43lvm+7Ee2AwyYPMqcubnKXyJNsPoYNE/YAk9mOSrfKq10QdT0Hw74HF7Q4b81rR5b
         QIz3dgIhEim/WgPOgVYJzOQufbFpInOP/LUm9yt/0FiIj+CnBHSIBSQtLOPjyJv3WYNi
         rdLImU/hkUG4Snn+tWr/qO51061IE9s8hnSLX8XSGrddrk4XVm9zkfcyYvwHMQwNO4i5
         fkcgvqfg2eEo0JyRRRDz/3VRYLSklkEVBbE4cwoya6E9Jbs2RwpNuFkZT5OExYdeJahc
         ZKXA==
X-Gm-Message-State: APjAAAUGreo/01Lohb4qik45xNduxZFvgfLhBljo7lQYp/e9947hxAs7
        TraQDk/lm4ccZWTdfSyNCjtVlNeB4K8=
X-Google-Smtp-Source: APXvYqxgnfosiqKc4EOPkJRzLQgOGp4/eP50KreB64ZgoUJcsezW/v9XbP8mDhoY/zq0K+7IDUr+sQ==
X-Received: by 2002:a2e:89cd:: with SMTP id c13mr13392144ljk.139.1582052038727;
        Tue, 18 Feb 2020 10:53:58 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id t27sm3028696ljd.26.2020.02.18.10.53.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 10:53:57 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id r14so15296418lfm.5
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 10:53:57 -0800 (PST)
X-Received: by 2002:ac2:456f:: with SMTP id k15mr11156468lfm.125.1582052037344;
 Tue, 18 Feb 2020 10:53:57 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org> <20200214154854.6746-542-sashal@kernel.org>
In-Reply-To: <20200214154854.6746-542-sashal@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 18 Feb 2020 10:53:41 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjnbNRd-3+R5c8L6rS63cF14dDANup7uddak_bO2nfQZg@mail.gmail.com>
Message-ID: <CAHk-=wjnbNRd-3+R5c8L6rS63cF14dDANup7uddak_bO2nfQZg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 542/542] pipe: use exclusive waits when
 reading or writing
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 8:00 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Linus Torvalds <torvalds@linux-foundation.org>
>
> [ Upstream commit 0ddad21d3e99c743a3aa473121dc5561679e26bb ]
>
> This makes the pipe code use separate wait-queues and exclusive waiting
> for readers and writers, [..]

Oh, and since I didn't react initially, let me react now that Andrei
found a bug here: why was this patch auto-selected for 5.5 stable in
the first place?

It wasn't really a fix, and there's no Fixes: tag or stable tag in
there. Yeah, there's a reference to an old commit, but that one isn't
even a kernel commit.

Yeah, the performance improvements are quite nice if you hit the case
this matters for, but still..

              Linus
