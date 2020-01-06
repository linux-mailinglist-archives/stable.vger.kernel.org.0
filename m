Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A283131731
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 19:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgAFSDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 13:03:45 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44645 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAFSDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 13:03:44 -0500
Received: by mail-qt1-f194.google.com with SMTP id t3so43126061qtr.11;
        Mon, 06 Jan 2020 10:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NXHuuZed9m4gmjDMxbSt8Ydx4KTmpkC7vJID6XaP7I0=;
        b=MRrkj8EI0gCPmdFxE+7l+GK4uoJ6rM6ez9nHt6AUuGx0FMkXiOZaBPPo6v3ir/4qvC
         UM5lPvnzAegMqlxcvWBcv3A3h05n6p3fJ4wHTpCTlugRpUV3todEv6atqHe976LnXxna
         if18JR4BhGt+t0M9PlWIWDBou86TspPSN28Kqbqr919TE6T9gKIMe/E0zIxV3Oq3Tfnm
         LO0AH25bvTRbBaokmYmmGonA1NFq16uTbNKa5S2pthdQ8j1nL0twPvfvOIY3HlDgZQNg
         YZUB0rAifbrSZjdksMKGwPQs4JtyBqj9GDLvR3mBRdQiAlt/GQkvWduSfMO9EhkKG5Fy
         FoYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NXHuuZed9m4gmjDMxbSt8Ydx4KTmpkC7vJID6XaP7I0=;
        b=VezwHh+MIzzxCQGalTuzxr99SNZEgNC8XxVSbBV56MIyvlQkv+7LNisHa866jeX9o0
         94nGEkGj5cejiHTRS+5gRElR3k2ZMKt2P16H1XOLPaptyhZvAOERYWH0IfR83znHbXKM
         NSyp1+rs8rvHEX6R4EbuZKekH3/mHA0yCvFMYlYFQoJ+fVDKQ0Gx/hAJgs3DVGVJVazG
         ij3LPm/QJVYowTN6ApfvJatJTq0dZprpBSboZOg48Hui2ALcKvRpKOAUydLWHhl7InIq
         F9E9N7/yZrcDGu71cfQJV2qcmbcSx+/62TnrB/X6xMHvszCy+G+sPb1cexhQzkb1VyKW
         OCBQ==
X-Gm-Message-State: APjAAAUnId8NLkMWS+NoVkwkR6cyzkHFuplSB/95GrLUASK+KCbNJRTw
        mIBIPCEjHK1Ler5IEW0yMAzNv7cVr28C8vvdmC4=
X-Google-Smtp-Source: APXvYqzoJpUI0qTBtGKc5HQQ71R+sejfLNU2IySNvN3xwwd+i3ukSvzyjPMESKmBcjWfEsJ28fSXH9mWzvLYPr9q2Ko=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr72628654qtq.93.1578333823652;
 Mon, 06 Jan 2020 10:03:43 -0800 (PST)
MIME-Version: 1.0
References: <20200102172413.654385-1-amanieu@gmail.com> <20200102172413.654385-3-amanieu@gmail.com>
 <20200102180130.hmpipoiiu3zsl2d6@wittgenstein> <20200106173953.GB9676@willie-the-truck>
In-Reply-To: <20200106173953.GB9676@willie-the-truck>
From:   "Amanieu d'Antras" <amanieu@gmail.com>
Date:   Mon, 6 Jan 2020 19:03:32 +0100
Message-ID: <CA+y5pbSBYLvZ46nJP0pSYZnRohtPxHitOHPEaLXq23-QrPKk2g@mail.gmail.com>
Subject: Re: [PATCH 2/7] arm64: Implement copy_thread_tls
To:     Will Deacon <will@kernel.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 6, 2020 at 6:39 PM Will Deacon <will@kernel.org> wrote:
> I also ran the native and compat selftests but, unfortunately, they all
> pass even without this patch. Do you reckon it would be possible to update
> them to check the tls pointer?

Here's the program I used for testing on arm64. I considered adding it
to the selftests but there is no portable way of reading the TLS
register on all architectures.

#include <sys/syscall.h>
#include <unistd.h>
#include <stdio.h>
#include <stdint.h>

#define __NR_clone3 435
struct clone_args {
    uint64_t flags;
    uint64_t pidfd;
    uint64_t child_tid;
    uint64_t parent_tid;
    uint64_t exit_signal;
    uint64_t stack;
    uint64_t stack_size;
    uint64_t tls;
};

#define USE_CLONE3

int main() {
    printf("Before fork: tp = %p\n", __builtin_thread_pointer());
#ifdef USE_CLONE3
    struct clone_args args = {
        .flags = CLONE_SETTLS,
        .tls = (uint64_t)__builtin_thread_pointer(),
    };
    int ret = syscall(__NR_clone3, &args, sizeof(args));
#else
    int ret = syscall(__NR_clone, CLONE_SETTLS, 0, 0,
__builtin_thread_pointer(), 0);
#endif
    printf("Fork returned %d, tp = %p\n", ret, __builtin_thread_pointer());
}
