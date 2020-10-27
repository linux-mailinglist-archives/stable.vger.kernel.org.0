Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EE929CD26
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 02:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgJ1Bif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 21:38:35 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:39645 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1833009AbgJ0X3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 19:29:31 -0400
Received: by mail-pl1-f175.google.com with SMTP id x23so1575679plr.6
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 16:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=JxDtWghWI5IaHjEami+ieysTKrrtiOIIUwBaYeLTyWQ=;
        b=upUrTZ2lVg2qLF+yTTg65nBtsshtimEddy4AVUEgZ0JcSI08I2g0miqFKdJwXthY7Y
         jwZK557jlX7oSlAo7oi1BBIch3rQ3VodmkSWTcyj4dlapruZgYazdYlP8ecaaKH1a/vg
         iDQjba/Iur82Hq9n0M/oe6kU3lvsbpuJMgW/hn1zGUuy34RmftHUtpy/aL9vkQ47LNYP
         3sLBLYa8q6GPdgtGC2BoqoxQ6ASSDOUfHL9E4Hzn99M8PJBxSzKhwjWA1WS/YW5GrNWG
         eR04Sh5kkp/LF8UqPLxThjxt+Oq3d6xS0/RHXLSmsSgH446Czm17bQjHF/TaGQETDu92
         Awcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=JxDtWghWI5IaHjEami+ieysTKrrtiOIIUwBaYeLTyWQ=;
        b=NZWDWXqM/H3FBA+CPcX7FwSGWDeI9UBW57KfXT25qRvqLmdEBQ9k1cWvOX9546K9+U
         /rvwe6rN7n1+JT4n98Roixjk1cRD7oByi3FdtZDd3dG64LJ97dRs8UO9fmaDWu/QG04j
         IRJjeRvygxAxE6kcuHdUqej8faz7vaWzwEwY9KE4thousCI5At7QInZDLKw3wXSbSPXJ
         +qsR3AOsCc78GrCUJAZzQ9gooVNYFWva6WIU14ZeibKe8/+Q/fbxK5rqP5MzMN2/H6Xv
         Zn/2Ol2yypGp6OR8LTMEEl+fR4s+0WOkXqUTrUjkHKkieBb1IWqkqMQAPbZArZB8uOg4
         XZmw==
X-Gm-Message-State: AOAM530tadKuYz0AWr2QV8P9amvt8s98kpEBG3bZyO0JYpr54r6wP35i
        tahwtMhqAjtBxOnC1C8ygnB3A7ZVHM7ByDdk3Rwua/OTYcluZQ==
X-Google-Smtp-Source: ABdhPJyDFBbM7//cpQWMi9kjJ/Qny2YtDPqEliLjI2opE1QiQCPliwrOea/3dZsSlwgN8iInBHjKoWIn4jTyNQHwvkM=
X-Received: by 2002:a17:90b:110b:: with SMTP id gi11mr3974124pjb.25.1603841368765;
 Tue, 27 Oct 2020 16:29:28 -0700 (PDT)
MIME-Version: 1.0
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 27 Oct 2020 16:29:17 -0700
Message-ID: <CAKwvOdn78WAUiRtyPxW7oEhUz8GN6MkL=Jt+n17jEQXPPZE77g@mail.gmail.com>
Subject: LLVM_IAS=1 x86_64 patches for 5.4 and 4.19
To:     "# 3.4.x" <stable@vger.kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Jian Cai <jiancai@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dmitry Golovin <dima@golovin.in>, Borislav Petkov <bp@suse.de>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>, mbenes@suse.cz
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Stable kernel maintainers,
Please consider cherry picking

commit e81e07244325 ("objtool: Support Clang non-section symbols in
ORC generation")

to linux-5.4.y and linux-4.19.y.  This allows us to use LLVM_IAS=1 for
x86_64 Android kernel builds without warning.

Its partner patch (8782e7cab51b6b) was already backported to
linux-5.4.y as 8c627d4b15de9, and linux-4.19.y as 6e575122cd956.

https://github.com/ClangBuiltLinux/linux/issues/669
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e81e0724432542af8d8c702c31e9d82f57b1ff31
-- 
Thanks,
~Nick Desaulniers
