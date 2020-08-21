Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6046924D120
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 11:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgHUJHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 05:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgHUJHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 05:07:02 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE92C061385;
        Fri, 21 Aug 2020 02:07:02 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f5so597987plr.9;
        Fri, 21 Aug 2020 02:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lpRfEAK9hizU8z+MYAdROsy4y7XmRdPj3BG7wTbZLZw=;
        b=grlxyTPg/iyMdHs7mW+oLR6rh0bk0w5Ls5KRZqaoAaFp0LjCwJ7buqxLZLTlThUDNG
         tzvM0MKOmcCIT5u6eDZpI3YjhBxLAJ8vLuqN1lHFnNyYkHMqb7SyZT9KvsiHE4grXAQ4
         I4BdGNwGW6X5UdrbmMBiHkesLOrwhbVcP8BkFH0xUL8JxKPnyaG5aEx8kZRSvo+A12wK
         +K5r5Nth0voQc8KbJl+6dOlYi4q6/MGuxe4P1dy1fYiaKDpOgvmw1u0VhFzBWJBVmd2k
         6tjToZKd5NwF/yIeh0ZDhl18GnkHArtdzY9T5df2LnLtFo6u+wV1ffS9b7eeS9vdIjpt
         V/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lpRfEAK9hizU8z+MYAdROsy4y7XmRdPj3BG7wTbZLZw=;
        b=QZcQaHcIrdn9/FdG5IJOgMnm7BpCjX3J5yGikkZvt/QePBr7EKB4PgufD5LSt6t8Fx
         803yGgwfb/OHZV8QAsMqB9OkHjwoPCLF2YcpPq0uaJls8CKJWv5GongHpxs7H1VWFJBZ
         1TssRSSLCeqj15cXyv06Vt49dig/XHts6EySAyMcUOe96dxP209NKDjJtc8jw4r66fR1
         GVyEVwTtMtd/P+mb89f5DGgLuNnjrbpAZIlddtoQLVo26NYncpA6UFkHy6VP3HP/35T/
         bEWCGhoy+7/OhaEbiDNegm41WwkIRV36zFZyXqYpOf842NI/+2D+LtAjq0xT35aZ9qat
         JKCg==
X-Gm-Message-State: AOAM531SOf2amG1SRxGKLfG5AKKzcxPvp2l5aKk4+IN/3aUE4IEPSkxf
        7OG8G6YjTLTdRLXLdjnp3UzY5bICldAuNbFhLm8=
X-Google-Smtp-Source: ABdhPJxcGz7B04L23FgStmA+C5YUh17LayGi0wW4N43S/c8dvT4rWSpO7MdM8lbbuwaa/qzB9+Qc/M9bxRj0WNOq5u0=
X-Received: by 2002:a17:90a:fa06:: with SMTP id cm6mr1765347pjb.129.1598000821832;
 Fri, 21 Aug 2020 02:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200820091537.490965042@linuxfoundation.org> <20200820091541.964627271@linuxfoundation.org>
 <20200821072123.GC23823@amd>
In-Reply-To: <20200821072123.GC23823@amd>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 21 Aug 2020 12:06:45 +0300
Message-ID: <CAHp75Vcbmc-PV-gQxuj9i8sAcFCzhJKe_qzEfrkUTZbnf3Vupg@mail.gmail.com>
Subject: Re: [PATCH 4.19 83/92] mfd: dln2: Run event handler loop under spinlock
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 10:26 AM Pavel Machek <pavel@denx.de> wrote:
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >
> > [ Upstream commit 3d858942250820b9adc35f963a257481d6d4c81d ]
> >
> > The event handler loop must be run with interrupts disabled.
> > Otherwise we will have a warning:
> ...
> > Recently xHCI driver switched to tasklets in the commit 36dc01657b49
> > ("usb: host: xhci: Support running urb giveback in tasklet
> > context").
>
> AFAICT, 36dc01657b49 is not included in 4.19.141, so this commit
> should not be needed, either.

I'm wondering if there are any other USB host controller drivers that
use URB giveback in interrupt enabled context.

-- 
With Best Regards,
Andy Shevchenko
