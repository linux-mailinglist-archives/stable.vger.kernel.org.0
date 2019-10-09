Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4FC8D1733
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbfJIR5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:57:18 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37207 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730546AbfJIR5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 13:57:17 -0400
Received: by mail-lf1-f68.google.com with SMTP id w67so2335565lff.4
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 10:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o8boM57nsIRzYbBpN0Z2Y51IdQe2gX/7UPNvVMmUq/U=;
        b=h0bAzS/dV9bQ6OnmXiwCK9ZIyyBp1EgxxpfnZdS3eiJkJ4Cjz7v9qeZ5N91ha6cYYN
         sdAGRVz3vOBIiPXxDatCim0mPu9JCDWAHWzCx9srQuMd9i2Of+bFJ7pwT0s3HSW9A+uI
         g3PA1uiN+F7kYnzzhfntyPIl5pCuME5B6pPLI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o8boM57nsIRzYbBpN0Z2Y51IdQe2gX/7UPNvVMmUq/U=;
        b=DHJX1O2PTEUIX/Tw4FsP66Ch9I6h7EMOkz5MJaKkzUsaFxkYkkaQy5WatJ6MV71Bkc
         MrHG8+nrW5rncaJyX2459FEZXbWc9XqH3jsfsa2ifE+ce1sbF2JtqCzRHbIsLHwBCKf4
         XKHwMrj8F1HXb7ClXJ+rsJP6jIyNDfJ4CuHKJ6z6Ylap4pN/fw/0X90wYJe5+wZSz9Ax
         pvnAQToByhgEdqNkjk2fZ2c6lU9S7N+BmesvV+7FCK+SO7XmLordtau9p7VKTYrIZfHy
         DqqAxYC107Td1Xt685RZJ+z/yuhR5x+C46dGAeBEJCcfnDhT11ajwcyxlXl8SbBRGqB3
         t5PA==
X-Gm-Message-State: APjAAAWV0e2xFVdkJcE/boT1JES9qhqqnhPJ37sdRY7lnCyt1ODz1pwr
        RsTRQxEvc3qcV1cdYN0QDAMphX1dTWQ=
X-Google-Smtp-Source: APXvYqwR7HaaCe8bdU75ZPtLFfXK4sqJXNlQVliV03cZrmKwRS7GB5xa1AHqRBB1nLc2gskV96gCnw==
X-Received: by 2002:a19:4bcf:: with SMTP id y198mr2892790lfa.168.1570643834886;
        Wed, 09 Oct 2019 10:57:14 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id l5sm610627lfk.17.2019.10.09.10.57.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 10:57:13 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id a22so3457544ljd.0
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 10:57:13 -0700 (PDT)
X-Received: by 2002:a2e:9848:: with SMTP id e8mr3209250ljj.148.1570643832712;
 Wed, 09 Oct 2019 10:57:12 -0700 (PDT)
MIME-Version: 1.0
References: <20191009170558.32517-1-sashal@kernel.org> <20191009170558.32517-26-sashal@kernel.org>
In-Reply-To: <20191009170558.32517-26-sashal@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 9 Oct 2019 10:56:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiVe+nxotYXExXRxhvCSTCqyRuZUto6UrvR2oHfeGrJ+g@mail.gmail.com>
Message-ID: <CAHk-=wiVe+nxotYXExXRxhvCSTCqyRuZUto6UrvR2oHfeGrJ+g@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 26/26] Make filldir[64]() verify the
 directory entry filename is valid
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 9, 2019 at 10:24 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Linus Torvalds <torvalds@linux-foundation.org>
>
> [ Upstream commit 8a23eb804ca4f2be909e372cf5a9e7b30ae476cd ]

I didn't mark this for stable because I expect things to still change
- particularly the WARN_ON_ONCE() should be removed before final 5.4,
I just wanted to see if anybody could trigger it with testing etc.

(At least syzbot did trigger it).

If you do want to take it, take it without the WARN_ON_ONCE() calls
and note that in the commit message..

           Linus
