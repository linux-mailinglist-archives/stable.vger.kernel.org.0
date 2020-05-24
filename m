Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCAB1DFC12
	for <lists+stable@lfdr.de>; Sun, 24 May 2020 02:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388196AbgEXAQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 20:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388106AbgEXAQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 20:16:16 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3DEC08C5C0
        for <stable@vger.kernel.org>; Sat, 23 May 2020 17:16:16 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id c12so8594690lfc.10
        for <stable@vger.kernel.org>; Sat, 23 May 2020 17:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3m68u6fbHtBqjSQv0cWxoIcDmwtDvgdO4LpfILQ1PZ0=;
        b=PLeeVDbFE5lth9LtkCyvzFdT69i55fBsQGp6IC8S/ui3poDdGe7l/L1/kH8ez/ROCp
         q6aHohnDM09vUJy9c47/QVG+JyQMj+okxn9lIFq+5JVZhrOvZRs9P2BRPCMImiJCyTdz
         sD3DkwyRgbpKlMHvcWxq5Z3QPIVX/jmzjBSuc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3m68u6fbHtBqjSQv0cWxoIcDmwtDvgdO4LpfILQ1PZ0=;
        b=Zv5pJiu7sg7P+7fSBy/GMa3KXARL+OIznuHsMuTWV/a2LhWsZfq71ZlvJxYGNqnbv3
         jRf6cXL08tNBdD5Tz9poslZYo06IXH4LNgAZ4K4L8Vgkhdnf4691JIqdvJV5p+D+I4/H
         WAZAiDnRdTZZLq4JkKDBcR2/947VAzkcv++lLSfrfrnXjzG0Ee1NS9+N4u1+gEduDkxT
         qtXXt2mt8pOPkvIQUAf111EYVXaBHNgJCeOXJRpvBnHGEtuhZVYRDrElJU1t9o9Ug1+X
         dB8BIrEQrW5GP8KJT1M7xJCtQ1DIsYC3I7UMqdo8meYEWylyLSIQbpd6tRoIiT1r76+g
         hCSA==
X-Gm-Message-State: AOAM5319wSG28puN5opK8KU0NMqeBhIyYDKBbLPsv8E20UnjaX0AxCMq
        wqsDl2zaajNUMIkFjluuArfrGADHCU0=
X-Google-Smtp-Source: ABdhPJyP0ywTXmDfo71i+1BIRa9M9xcUWOilRCnlmkuFK07s9vQTrr41lyHZ2K9er0c64TYzV2z0lA==
X-Received: by 2002:a19:4345:: with SMTP id m5mr3678989lfj.114.1590279373363;
        Sat, 23 May 2020 17:16:13 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id r9sm3289611ljg.69.2020.05.23.17.16.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 17:16:12 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id z13so7300608ljn.7
        for <stable@vger.kernel.org>; Sat, 23 May 2020 17:16:11 -0700 (PDT)
X-Received: by 2002:a2e:7e0a:: with SMTP id z10mr8459409ljc.314.1590279371483;
 Sat, 23 May 2020 17:16:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200523224732.GA243603@roeck-us.net>
In-Reply-To: <20200523224732.GA243603@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 23 May 2020 17:15:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjnwsRfE_RJLAV8SX465uEmpOOJxyqjsLRwoX-UPH0kQg@mail.gmail.com>
Message-ID: <CAHk-=wjnwsRfE_RJLAV8SX465uEmpOOJxyqjsLRwoX-UPH0kQg@mail.gmail.com>
Subject: Re: [PATCH] sparc32: use PUD rather than PGD to get PMD in srmmu_nocache_init()
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Anatoly Pugachev <matorola@gmail.com>,
        sparclinux@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 23, 2020 at 3:47 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> This quite innocent looking patch crashes all my sparc32 boot tests.
> Crash log and bisect results below. Reverting it fixes the problem.

It should also fixed by 0cfc8a8d70dc ("sparc32: fix page table
traversal in srmmu_nocache_init()"). No?

                 Linus
