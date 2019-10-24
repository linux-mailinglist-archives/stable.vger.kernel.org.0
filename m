Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30109E35BA
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 16:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502832AbfJXOk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 10:40:59 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35077 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502826AbfJXOk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 10:40:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id l10so25964785wrb.2;
        Thu, 24 Oct 2019 07:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HESF/d6OH5Aw6sJWEIGxgkKbyHNgcjcLHfFi7kk0g9A=;
        b=TcUTD+agNlBhc1hjm88GbLWqbU6tMfgjgHRDWLRNfaJ4hc36Tb9ML4aCHvpyxtPTEn
         C2E5Ewp7E6OTopg9A/Di347itIL2MdoqhpP4ZZjw5IJ7qLG0TzJvqUXDenxz7YMnEy6v
         l6zGfh6br2lRtFYR43Lk4U+bJoxH9+GT1LISiSL9zM1Np0ofboXkUMs6bZnwEWxybRw1
         JdpELAxqwKgYbFXBggEFPWSTRbrhhmGFoyiyJzXAtLRf+WOyEqMFyKWvRlguOMPrD6TR
         QAOtAcx9am6QXkUKVLlsfd0JVcZbrIi83kS6v0lTep3b8TA80z8Fr9GHh52lINsSQT4V
         8AfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HESF/d6OH5Aw6sJWEIGxgkKbyHNgcjcLHfFi7kk0g9A=;
        b=PkKkxQn5KHkzS11QS5PzOGTBpkSZH8hKJsr5chBxosfa8cbCZV6XIrEIdKHZqztUBo
         suuPXAE9+4/iLYUkYuGkK0wTuxVdPEHzYxwyDrvZXQtc/6R4/CXDTfMjZl24nC9FqpG/
         9/0H36I+wozOH/HCKtv0ww8bVQ38Pgy83QYecYage8CYHjZh13/dsbOeeZnFibkdsib9
         MCsvTrbvvkkl/6eh8D2gx76EGX1Tb66y3H0cfaT1Jm1SkmQbijcPyiKPpTmhNtxeovF5
         gbjn2kJ3hOmXuLkH/aDYKvSkVe8SpDagnwLLRmDGHonAe/kYYsfzqHTZKFZytpxO6Pwv
         i1PA==
X-Gm-Message-State: APjAAAXSYKZF4ROBDHUMWoi84HAyzCx4gO1sIH4LfwzcvmkxRCcuo1Ej
        MGrCMEFFgNPp2F7AxurvLTs=
X-Google-Smtp-Source: APXvYqwBuY8frNbFlrrd+MU0T1iMVeSexigCZJNzWTb2sAaAERi4UQ+ZR6IEtM7ZTeW1Z9d6m7DAYA==
X-Received: by 2002:adf:e381:: with SMTP id e1mr3927570wrm.94.1571928057005;
        Thu, 24 Oct 2019 07:40:57 -0700 (PDT)
Received: from andrea.guest.corp.microsoft.com ([2a01:110:8012:1010:e187:86b0:69d4:5ba5])
        by smtp.gmail.com with ESMTPSA id u1sm2289665wmc.38.2019.10.24.07.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 07:40:56 -0700 (PDT)
Date:   Thu, 24 Oct 2019 16:40:49 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bsingharora@gmail.com,
        Marco Elver <elver@google.com>,
        stable <stable@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH v6] taskstats: fix data-race
Message-ID: <20191024144049.GA13747@andrea.guest.corp.microsoft.com>
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com>
 <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
 <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com>
 <20191024113155.GA7406@andrea.guest.corp.microsoft.com>
 <CACT4Y+Z2-mm6Qk0cecJdiA5B_VsQ1v8k2z+RWrDQv6dTNFXFog@mail.gmail.com>
 <20191024130502.GA11335@andrea.guest.corp.microsoft.com>
 <CACT4Y+ahUr11pQQ7=dw80Abj5owUPnPdufbMYvsKLM6iDg5QQg@mail.gmail.com>
 <20191024134319.GA12693@andrea.guest.corp.microsoft.com>
 <CACT4Y+ZXQyqgBvwgb6cy7NP5FTBbktq5j4ZyySp7jrbcJwFUTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZXQyqgBvwgb6cy7NP5FTBbktq5j4ZyySp7jrbcJwFUTA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 03:58:40PM +0200, Dmitry Vyukov wrote:
> On Thu, Oct 24, 2019 at 3:43 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> >
> > > But why? I think kernel contains lots of such cases and it seems to be
> > > officially documented by the LKMM:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/explanation.txt
> > > address dependencies and ppo
> >
> > Well, that same documentation also alerts about some of the pitfalls
> > developers can incur while relying on dependencies.  I'm sure you're
> > more than aware of some of the debate surrounding these issues.
> 
> I thought that LKMM is finally supposed to stop all these
> centi-threads around subtle details of ordering. And not we finally
> have it. And it says that using address-dependencies is legal. And you
> are one of the authors. And now you are arguing here that we better
> not use it :) Can we have some black/white yes/no for code correctness
> reflected in LKMM please :) If we are banning address dependencies,
> don't we need to fix all of rcu uses?

Current limitations of the LKMM are listed in tools/memory-model/README
(and I myself discussed a number of them at LPC recently); the relevant
point here seems to be:

1.	Compiler optimizations are not accurately modeled.  Of course,
	the use of READ_ONCE() and WRITE_ONCE() limits the compiler's
	ability to optimize, but under some circumstances it is possible
	for the compiler to undermine the memory model.  [...]

	Note that this limitation in turn limits LKMM's ability to
	accurately model address, control, and data dependencies.

A less elegant, but hopefully more effective, way to phrase such point
is maybe "feel free to rely on dependencies, but then do not blame the
LKMM authors please".  ;-)

Thanks,
  Andrea
