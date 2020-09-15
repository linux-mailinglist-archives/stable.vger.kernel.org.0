Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA8C26AA8C
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 19:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgIOR1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 13:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727887AbgIOR1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 13:27:06 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BEAC0612F2
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 10:24:46 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id k25so3577211ljk.0
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 10:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TlLASjtOWZl97ccS56UuppG/O1DcME2TKl7d1jzvYzM=;
        b=ZQ4GHeUyUTLfgc95eXulgPvEP8C1iC3CepnrK9c7pfKYqS19IJUGCmeEpx5/qKZ02M
         zzlDzATp4hfO861tzoWuNixpFbmNPSR7fXNK9Pyas2eKtrBsZmkJKLUIKMnfkIZRLHXC
         WbAoAlOxBDEO1ElAIYEY4Jq81yKgIiBKzhNdo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TlLASjtOWZl97ccS56UuppG/O1DcME2TKl7d1jzvYzM=;
        b=roK3YVnhyt9qAXXXkzdhM2rwjZAGc7VFScJeOhoIG1QXM8z/VvZ6nlQc/vR2bmHLol
         +ScOEbrguuHbqaBJNZlDNOCUEITq+AicxrE/mKXEq2hyYZIz6SGLOXugnHg+gUWzT8qV
         GVFzIujLhhMcHrnihpZ3yCsu/g2scQaSxJwNyjtJJFJqT5NDCMwEpyz+CNuJL8//JX0+
         9D6pwwSW8vCkoyNan/wRlkMgTIpAJMaOVkcpJ70riDB+DL7lc3jwV8U6PZxSZCPgnvL9
         LrDHoBpIDRijk1pxckJmvD4GSEh2f/yayGtp1rcrGGGdQgWHENm9Nk7x26UTWNOnSdyD
         3vdA==
X-Gm-Message-State: AOAM531uRujsVjuhJkd5NLOw4JWvshY2Ur7yoJ1Q/gl9NXRCFScshChH
        FskxN/I30087PTLI0WrK7I8l3cel+/3G5Q==
X-Google-Smtp-Source: ABdhPJwET0PVXZcuznrej/yTzYpBPWLMucUJMLVe15+tLLIBiSGHevNbQcJHKw0EidsAqa+nCnESWA==
X-Received: by 2002:a2e:9a4d:: with SMTP id k13mr1256988ljj.138.1600190683972;
        Tue, 15 Sep 2020 10:24:43 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id m204sm4050548lfd.307.2020.09.15.10.24.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 10:24:42 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id k25so3511242ljg.9
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 10:24:42 -0700 (PDT)
X-Received: by 2002:a2e:91cd:: with SMTP id u13mr6495156ljg.421.1600190682261;
 Tue, 15 Sep 2020 10:24:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200915140653.610388773@linuxfoundation.org> <20200915140658.820608455@linuxfoundation.org>
In-Reply-To: <20200915140658.820608455@linuxfoundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Sep 2020 10:24:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiBNqZm2E89SiTmtSPQr+pbdswwdPY6oH_wF1rvAeJnAQ@mail.gmail.com>
Message-ID: <CAHk-=wiBNqZm2E89SiTmtSPQr+pbdswwdPY6oH_wF1rvAeJnAQ@mail.gmail.com>
Subject: Re: [PATCH 5.8 108/177] gcov: Disable gcov build with GCC 10
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 7:28 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> GCOV built with GCC 10 doesn't initialize n_function variable.  This
> produces different kernel panics as was seen by Colin in Ubuntu and me
> in FC 32.
>
> As a workaround, let's disable GCOV build for broken GCC 10 version.

Oh, Peter Oberparleiter actually figured out what was wrong, and we
have commit 40249c696207 ("gcov: add support for GCC 10.1") upstream
that enables it again with the fix for the changed semantics in
gcc-10.

                          Linus
