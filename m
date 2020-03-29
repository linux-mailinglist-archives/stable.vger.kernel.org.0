Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E09A196E8A
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 18:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgC2Qqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 12:46:44 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34704 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgC2Qqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 12:46:44 -0400
Received: by mail-lf1-f67.google.com with SMTP id e7so11993126lfq.1
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 09:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EmVYX7es8ikrGBUh2sSl3Td6n0rszMJFDKO3y+3mky8=;
        b=g7rnQkhER3y3SD2ZzxZ3aRB5SfzXVM+Uw2aQfsZ8/BGY2bNnDCVo8qjREpSxUCZRml
         eKISJTrOfqSfG7e/4O5EQ/q70AtNCDAxrBN5cGYCcp4NGIjkfhjokSgDvlGctaCRXPYY
         m+KJtzoAHTSlypi0B5K1xPDAQqJvWdQveJanw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EmVYX7es8ikrGBUh2sSl3Td6n0rszMJFDKO3y+3mky8=;
        b=FaSB2cGxNyei5YrVyqNuV/yE6iLr7fcFVKQXyzQ7E9OAz1norWOIULfV5U00dH3ylF
         eyzQaHGBwpDzSddg6ncvcyyFQoSGnOFAD8cfnznm+h03RQLR+R1H4kImPHQNhy32UGtA
         YUAbetFl7V+EHxPtwGHa3j1NrYORjdFB0y6dFdNxkARY0L/KcB/h7f+hhPOWqDUT/Bah
         GuadOa4hDrCRB+Y+zf8fqmZxJ1DpVNK0jCvEQCT6yn6ZVXCmyY7Ha36WRAnYE9SJ7rNZ
         I5RK1qRM9XvWL0hWxowr2MmCALqEo3tjihSR6HqrdMYepNb+PrEdEjHH+zoauQMr6Lg2
         5OXQ==
X-Gm-Message-State: AGi0Pua1Qed7NQQFkx2locHp0wnHgo3G+RxwDvPLWgGbSz5rlAmgDCvu
        ofMgmHyePQPlmpWLzSdq0G+bI6aDk9I=
X-Google-Smtp-Source: APiQypKRMCM0ulFvk7z2SRVcUPnMiQrkvYg0JR9haSWEpjD6u79pWBUloc+deFZk91EPUDKqqzm0BQ==
X-Received: by 2002:a19:c005:: with SMTP id q5mr5526272lff.216.1585500399641;
        Sun, 29 Mar 2020 09:46:39 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id x78sm6429848lfa.51.2020.03.29.09.46.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 09:46:38 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id p10so15146048ljn.1
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 09:46:37 -0700 (PDT)
X-Received: by 2002:a2e:a58e:: with SMTP id m14mr4810781ljp.204.1585500397555;
 Sun, 29 Mar 2020 09:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200328191456.4fc0b9ca86780f26c122399e@linux-foundation.org> <20200329021719.MBKzW0xSl%akpm@linux-foundation.org>
In-Reply-To: <20200329021719.MBKzW0xSl%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 29 Mar 2020 09:46:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgs1mfvk8pwefSD2A4=RgH6td50x9D-yn3Axm7icp5Xag@mail.gmail.com>
Message-ID: <CAHk-=wgs1mfvk8pwefSD2A4=RgH6td50x9D-yn3Axm7icp5Xag@mail.gmail.com>
Subject: Re: [patch 2/5] drivers/base/memory.c: indicate all memory blocks as removable
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Karel Zak <kzak@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        ndfont@gmail.com, pbadari@us.ibm.com,
        Rafael Wysocki <rafael@kernel.org>, rcj@linux.vnet.ibm.com,
        stable <stable@vger.kernel.org>, steve.scargall@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please, David H - whatever you do with email is WRONG.

Fix your completely broken email client. Stop doing this.

On Sat, Mar 28, 2020 at 7:17 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: David Hildenbrand <david@redhat.com>
>  [...]
> According to Nathan Fontenot, DLPAR on powerpc is nowadays no longer
> driven from userspace via the drmgr command (powerpc-utils). Nowadays
> it's managed in the kernel - including onlining/offlining of memory
> blocks - triggered by drmgr writing to /sys/kernel/dlpar. So the
> affected legacy userspace handling is only active on old kernels. Only ve=
> ry
> old versions of drmgr on a new kernel (unlikely) might execute slower -
> totally acceptable.
>
> With CONFIG_MEMORY_HOTREMOVE, always indicating "removable" should not
> break any user space tool. We implement a very bad heuristic now.  Withou=
> t
> CONFIG_MEMORY_HOTREMOVE we cannot offline anything, so report
> "not removable" as before.

Notice the bogus MIME line continuation left-overs?

  [...] Only ve=
  ry

and

  [...] Withou=
  t

is just completely wrong.

You either have a completely broken email client that doesn't handle
MIME at all - get rid of it - or you're then dealing with raw mbox
data in a completely broken manner without handling MIME wrapping.

I can't figure out _what_ you're doing wrong, but the pattern is clear
by now: it's not Andrew (although Andrew should check explanations
better!), since it _only_ happens with patches from David Hildenbrand.

Fix your workflow. Because it's broken.

             Linus
