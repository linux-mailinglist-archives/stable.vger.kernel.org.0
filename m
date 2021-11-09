Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DCE44A42C
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhKIBvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhKIBvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 20:51:02 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B86C061764
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 17:48:17 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id f8so70320157edy.4
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 17:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1+K2DVKOFTv6zJj3P2tlCMYZGpaMiCNTrYZWnpyj3TU=;
        b=YpViJGhRGGbw3HKZVVJ8dDOcx4Z22oHf96nvV3o92sw1NRcI++oIekQ+kwN8T5APNE
         DjnYn1Nmec1KRlhtjhq+ZBx4cjEIuuUDqzjMVedxtR8mYceY0fJ+8cmacqw8ofsFM/oj
         B7mJhz08GmzD3uL0VYXNKqRxw/QCrppKmUKp7vyoQkguz2hq46FVTv7Np12Yvxhm73y7
         tB6MwLFHob58kaG7u+7I5EyrDM3MpFFb/3i695XCiNHlRSrPyzh/7dnJLiDkrc++fJ91
         ITrjNUIfl1jxwIiOp691hm7SQx+m+KlAvAfTeSIq+n1DYoiWNwR1BZz4K3G0MoX4qxDl
         87qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1+K2DVKOFTv6zJj3P2tlCMYZGpaMiCNTrYZWnpyj3TU=;
        b=W5q/ii2ng2H8nqrENN9BOq3sDCrtkgKg27LF9SHNDY55poNzi0znexdyN9Df/OZCfH
         yhCVOGp4WlkuqLj6me7MHFWzk//wgy6N9IQ4+KNqkWig3HCOFqdfydZVaZodjQQxWtKF
         Q+U26ohrYPhj2tjaZ72/kdvkEJ6nF08NCxOToc0u6EYDT5cBopVhq9E6tN05zI6VbSSF
         krKGzK5kom7cSUp3BgH68CO5VDtclel+MPw3S+HLAOvQjuyjS9OYIuUWlcYq/0CS7s+0
         SnHj2S65p3tokW1/gHZhF3mN8Do/q2JKZaozHviXX4Py6bIbxTkm3O6KesicDizPhxFY
         ai4Q==
X-Gm-Message-State: AOAM530FxBwkHsM1RrZv2uYhJ5RmDIGkN2JDQ8AlcP5ylUdp4wYT75rP
        0vIMKTSONJZyzIxcEGR+Ldg2YhzYwW0MFee7LTqfuNs/VdNatQ==
X-Google-Smtp-Source: ABdhPJxAVjfPG+W7R04rfc5Q+ZIFbFRhqgt5yvRkS9Rx27yUWta7jbDH0JsPt6gQblJQX5hFRg753ZZ6kBp5LdaNYaA=
X-Received: by 2002:a50:d984:: with SMTP id w4mr4797521edj.375.1636422495629;
 Mon, 08 Nov 2021 17:48:15 -0800 (PST)
MIME-Version: 1.0
References: <CADyq12yY25-LS8cV5LY-C=6_0HLPVZbSJCKtCDJm+wyHQSeVTg@mail.gmail.com>
 <cb682c8a-255e-28e5-d4e0-0981c2ab6ffd@intel.com> <85925a39-37c3-a79a-a084-51f2f291ca9c@intel.com>
In-Reply-To: <85925a39-37c3-a79a-a084-51f2f291ca9c@intel.com>
From:   Brian Geffon <bgeffon@google.com>
Date:   Mon, 8 Nov 2021 20:47:39 -0500
Message-ID: <CADyq12y0o=Y1MOMe7pCghy2ZEV2Y0Dd7jm5e=3o2N4-i088MWw@mail.gmail.com>
Subject: Re: XSAVE / RDPKRU on Intel 11th Gen Core CPUs
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> One more thing...  Does the protection_keys kernel selftest hit any
> errors on this same setup?  It does a lot of PKRU sanity checking and
> I'm a bit surprised it hasn't caught something yet.

Hi Dave,

This issue does reproduce with the self tests too, my simple test
program also fails consistently [1], all it does is spin executing
RDPKRU waiting for a context switch to clobber the value.

$ ./test
unexpected value on iteration 3772082 value:0x55555554 expected:0x55555550

==========================
self tests:

$ ./protection_keys_64
has pkeys: 1
startup pkey_reg: 0000000055555550
WARNING: not run as root, can not do hugetlb test
test 0 PASSED (iteration 1)
test 1 PASSED (iteration 1)
test 2 PASSED (iteration 1)
test 3 PASSED (iteration 1)
test 4 PASSED (iteration 1)
test 5 PASSED (iteration 1)
protection_keys_64: pkey-helpers.h:127: _read_pkey_reg: Assertion
`pkey_reg == shadow_pkey_reg' failed.
Aborted (core dumped)

$ uname -a
Linux localhost 5.13.0-17189-g62fb9874f5da #12 SMP PREEMPT Tue Nov 9
01:29:44 UTC 2021 x86_64 11th Gen Intel(R) Core(TM) i5-1135G7 @
2.40GHz GenuineIntel GNU/Linux

Let me know if I can provide anything else, I'm happy to help troubleshoot this.

Thanks,
Brian

1. https://gist.github.com/bgaff/e4b5457ab1cf5126fea6327666c63441
