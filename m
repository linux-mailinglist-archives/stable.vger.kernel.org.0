Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B98920E4E
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 19:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfEPR6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 13:58:13 -0400
Received: from mail-lj1-f170.google.com ([209.85.208.170]:39650 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfEPR6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 13:58:13 -0400
Received: by mail-lj1-f170.google.com with SMTP id a10so3920590ljf.6
        for <stable@vger.kernel.org>; Thu, 16 May 2019 10:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0/jD9z0ZN/51ank2Z04vMZo0I847Lvb8NBW8oztmHrE=;
        b=Ht8rs2Sb2xKw8C+nJGxSHbIJ+GwyzI94D2caymNWJdsOAUX78udJIiIBbnR4txPB8u
         q4mbp47ywXzX2sypuulNZJgkGU4owYEIz3x1FePSnMcCHCDej0Qe9jq9sAaG49U5mlXX
         oPLUqR/fEsTw35zzD7S9mtJ4PJsOsfVkrSnJ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0/jD9z0ZN/51ank2Z04vMZo0I847Lvb8NBW8oztmHrE=;
        b=L/bN4ae9TOz8NVIps4YZQZ6YGzQCUKGNuak2XClGEwm2ozP3rJQJHZauH1ZjUKBYXi
         rbHbgJnX+WWwkYNv0AYME7RuZolTQmlT2CBs7FFpNlB/NA8nOiM88XB95w6CvwxW/HA4
         xMAtzxlgH6R5eJ25JfTtd+cQtkWVZLgres5d9vqUmOMCTKHTUGP1NZQS3YX6SdB6ZDZV
         YHVBuKtccrNlgXENifxPCo/lYIYXIwpusXQZqISI2yR5RW5ShpOWNifb06TOx0l9uJAD
         zP6TdqLfK2yppDMnoGPBa96WMpAJBdkwINx8+PN1mVGM9yHg5qvu8h6EksveLwCzeTOR
         rI2Q==
X-Gm-Message-State: APjAAAWiTqLEC3KQAmwRE38QdsiOmrZ+o+N968DuSb702nkXJAdvU3eq
        OgrkLQrK7tjnxlhwObtgXGbu5X2w19E=
X-Google-Smtp-Source: APXvYqwoQlBGzdFdMIORuMmCy5TT4kQ3d5M7O5rMY97odUqWuSNx1rj02X+JCY9uZcfr+WvKfgX+Bg==
X-Received: by 2002:a2e:a0d1:: with SMTP id f17mr4404214ljm.117.1558029490792;
        Thu, 16 May 2019 10:58:10 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id k26sm1228911lfb.63.2019.05.16.10.58.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 10:58:09 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id u27so3312027lfg.10
        for <stable@vger.kernel.org>; Thu, 16 May 2019 10:58:09 -0700 (PDT)
X-Received: by 2002:a19:ca02:: with SMTP id a2mr24482260lfg.88.1558029489242;
 Thu, 16 May 2019 10:58:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190516160135.GA45760@gmail.com>
In-Reply-To: <20190516160135.GA45760@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 16 May 2019 10:57:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgtHi5mT7y=0ij-AksQQOBQJqV1apk2bRaH2tfRTxyFcg@mail.gmail.com>
Message-ID: <CAHk-=wgtHi5mT7y=0ij-AksQQOBQJqV1apk2bRaH2tfRTxyFcg@mail.gmail.com>
Subject: Re: [GIT PULL] locking fix
To:     Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>
Cc:     Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 9:01 AM Ingo Molnar <mingo@kernel.org> wrote:
>
> A single rwsem fix.

Side note, this one isn't marked for stable, but I'm hoping stable
picks it up just from the "Fixes" tag.

Stable people, we're talking about

    a9e9bcb45b15 ("locking/rwsem: Prevent decrement of reader count
before increment")

that I just pulled into my tree, and needs to go in 4.9 and later.

              Linus
