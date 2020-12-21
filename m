Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487DF2E02FB
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 00:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgLUXrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 18:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUXrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 18:47:20 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1FBC0613D6;
        Mon, 21 Dec 2020 15:46:39 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 11so7381476pfu.4;
        Mon, 21 Dec 2020 15:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=L+0JEMaoTQhD9jy4Rl8XAyjJSgO9j0YTaiOmnYpP02Y=;
        b=Ps04niOpFbu+NWVSJoYqYU1JpLcgUiedzqB4MZuSPChfBJj/qY2eq2FGHkG0oWY9Nz
         kPpkJ2l+8Q0ELMgCFzdpXGecfsBG6esd18k6EcrVRxAieSNuoVW0N3R6f8ko9NhtYk0s
         seX3dpcCiKXmfJnLRc1CC14BG6i+4AagCQAphesrN9ZGpU8ly4JPsq2jNvcvwy+EJNRJ
         ZhBE16Qhstk0MTTkYXrjueAHTbheqJ1qlnUvG8r0VhM6bQryq9uhC8E/zWBdC1s3LIdQ
         wygq/eNdZPucwNs/ES9BBRJfDhE6o6SWD9P2SgEo9d1RemPjjPhSB7wUqt4Zta2E8Tox
         htrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=L+0JEMaoTQhD9jy4Rl8XAyjJSgO9j0YTaiOmnYpP02Y=;
        b=tYIDoDlPhsD9Z9xEgfw/ISpprW+N8POieGyPeFCzLTdgFiVXYooBk8x0I21sCfZwW6
         HnxHZZwjCubNHACNHRyguwJo71YlxA6QLhBUjWGyTKLTCQLv7eiS2kHLIo7MPwAeGhKf
         qr7lyxn+9Ep6xipsF37K/1y6dvuBnGVuzYe/49L/eaC0AsRWtOHDPBwdXxuI0mPcUpwT
         55SnDWHLWourpkt2Af1FuxMLzVKD7Na4s/HeZ/dnmAryGq3uT1nRRzu2LJAuqo7Jz9Pv
         q4Ujb9SIL9gDhwMzGvnbkHbptup9EgNc0nqfAN2PL7gu/UssVXVHtmOkyVfN9rJuUaNf
         LwFA==
X-Gm-Message-State: AOAM532n5T7UJ8Vlownz8Q9sYgEqQ6rFC/bkmAMyNdBk/5PI5+/8a4ln
        SZj0t6qSqE9lWPkFoB5kd4k=
X-Google-Smtp-Source: ABdhPJyiRX/b5fEsU/ic1PlWfthrlm7MZHAoPC4HSmZNiGOvTuMo4An+knAyb8zfIJ+Mbm+bTMXSBQ==
X-Received: by 2002:a62:61c5:0:b029:1a9:5a82:4227 with SMTP id v188-20020a6261c50000b02901a95a824227mr17693431pfb.61.1608594399329;
        Mon, 21 Dec 2020 15:46:39 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:104c:8d35:de28:b8dc? ([2601:647:4700:9b2:104c:8d35:de28:b8dc])
        by smtp.gmail.com with ESMTPSA id c62sm17710501pfa.116.2020.12.21.15.46.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Dec 2020 15:46:38 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAHk-=wihkGVvXXQL_qSPWF6s4NJYWyEkq+D3CUWQf9H5V1jqtg@mail.gmail.com>
Date:   Mon, 21 Dec 2020 15:46:33 -0800
Cc:     Peter Xu <peterx@redhat.com>, Yu Zhao <yuzhao@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BCB833E2-B5CD-4FE6-B788-43E5925F70DF@gmail.com>
References: <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <B8095F3C-81E3-4AF9-A6A5-F597D51264BD@gmail.com>
 <CAHk-=wihkGVvXXQL_qSPWF6s4NJYWyEkq+D3CUWQf9H5V1jqtg@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 21, 2020, at 3:30 PM, Linus Torvalds =
<torvalds@linux-foundation.org> wrote:
>=20
> On Mon, Dec 21, 2020 at 2:55 PM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>> So as an alternative solution, I can do copying under the PTL after
>> flushing, which seems to solve the problem.
>=20
> ...
> Note that the "Re-validate under PTL" code in cow_user_page() is *not*
> the "now we are installing the copy". No, that's actually for the
> "uhhuh, the copy using the virtual address outside the ptl failed, now
> we need to do something special=E2=80=9D.
> ...
> So are we sure the COW case is so special?
>=20
> I really think this is clearly just a userfaultfd bug that we hadn't
> realized until now, and had possibly been hidden by timings or other
> random stuff before.

Thanks for the detailed explanation. I think I got the COW parts =
correct,
but as you said, I am completely not sure that COW is so special.

Seems as if some general per page-table mechanism for detection of stale
PTEs is needed, so by default anyone that acquires the PTL is guaranteed
that the PTEs in memory are coherent across all the TLBs.

But I still did not figure out how to do so without introducing =
overheads,
and the question is indeed if people care about mprotect and uffd-wp
performance.

