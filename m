Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC30CC11E
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 18:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfJDQzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 12:55:05 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35914 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDQzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 12:55:05 -0400
Received: by mail-lf1-f68.google.com with SMTP id x80so4974302lff.3
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 09:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FrJ0zFRu4R4V+3PxeCLcufXSv3jjR/ayM3x6nxe14uQ=;
        b=Zr8CCOYrhLwg2IJlYUbmrLBubB+LAs47+X7FsJcUYinv3ZCNzplia9GI/omGn9Nnwp
         J95JxEkcdRGDKXb7Lva3O/y0uDib1iXfQ6DVEjqeNehpofny7rhAXvDak088Hh6+0CCm
         WepPxEeusU+YGFBek4shM+8Ydjq7N1s7i0Vtg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FrJ0zFRu4R4V+3PxeCLcufXSv3jjR/ayM3x6nxe14uQ=;
        b=Dzp37FnNT3Q9CvzS9NpB5wSUta6vsZdQK6JX0LvNhFE1RMYIQh0HjRvgtfddQfNhQb
         qZc3yNc9Jdi51qPMveO1i5y5MisY1uJSb50sYTiCuFMNpCR8f/ZlT4Ql43Aw6tIkNBUt
         4rJ4T8z/fB3hh0w2oY4PJtOBlY/0sgEcvQA4MYclhtWVCCdGX95PpNUgixSZqZRdPZUS
         Q2F6NPVFEIQjtSB9DLd9Oh+GUkol7D85m9h+ExIH+SkFY2nef2AwdZwCFALOGMxCNiih
         kHu1ysMsDjFdFAFAnh81p5bV4uwUW/JxPoocnlKQZUcLcwsl0oxtohBGi+324s41xnuw
         PdbQ==
X-Gm-Message-State: APjAAAXH7/zvCV3o3Dba1orwd36tThJBjwrQWjC7IYBAQkron2vqk6AU
        9KYEDhJDBDtdHJgPCu0+WXUWJmBFRwo=
X-Google-Smtp-Source: APXvYqyfiQCw5LYYIjK2m0cnIGlF+lXeatvGu33mLK/LY/jtwXYNuxzdc27VmwRFCMAnxKALC7kKKw==
X-Received: by 2002:a19:428f:: with SMTP id p137mr9573344lfa.149.1570208102203;
        Fri, 04 Oct 2019 09:55:02 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id k23sm1387326ljk.93.2019.10.04.09.55.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 09:55:01 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id 7so7206587ljw.7
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 09:55:01 -0700 (PDT)
X-Received: by 2002:a2e:9241:: with SMTP id v1mr10287406ljg.148.1570208100900;
 Fri, 04 Oct 2019 09:55:00 -0700 (PDT)
MIME-Version: 1.0
References: <20191004140503.9817-1-christian.brauner@ubuntu.com>
 <20191004142748.GG26530@ZenIV.linux.org.uk> <CAHk-=wih7tK-PoRTSUXgarpgR-WA8kN_voiMynQr8eysvPPgfA@mail.gmail.com>
In-Reply-To: <CAHk-=wih7tK-PoRTSUXgarpgR-WA8kN_voiMynQr8eysvPPgfA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 4 Oct 2019 09:54:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=whZUbznC+sdnFz6B5F7E7+ywZgx025u0kEnFk3S_7gFQA@mail.gmail.com>
Message-ID: <CAHk-=whZUbznC+sdnFz6B5F7E7+ywZgx025u0kEnFk3S_7gFQA@mail.gmail.com>
Subject: Re: [PATCH] devpts: Fix NULL pointer dereference in dcache_readdir()
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Varad Gautam <vrd@amazon.de>, stable <stable@vger.kernel.org>,
        Jan Glauber <jglauber@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 4, 2019 at 9:52 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Dang, I thought this already got merged. But we only discussed it
> extensively and I guess it got delayed by all the discussions about
> possible fixes for the d_lock contention.

Side note: I'm not all _that_ worried about the d_lock contention
thing, simply because the regression report was from an artificial
benchmark, and it was on a 144-core machine.

Compared to the Oops, it's not really a thing.

            Linus
