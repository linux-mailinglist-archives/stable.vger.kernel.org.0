Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939ADE348A
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 15:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393691AbfJXNn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 09:43:28 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36081 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393656AbfJXNn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 09:43:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id c22so2671207wmd.1;
        Thu, 24 Oct 2019 06:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FGm/Y7V816AbGprOQHUkgpBjccypqHGHqD5N/dMxVkw=;
        b=WemCD9WeMOlk2CrvosRt1hMf4Lxem6lm1hZUuyoJj0K6NGWgX+19cYcBRdqNTF1ixs
         nlh1LJY5VZtICct6frTaqVEVQql6wmU2dSjd6C3zNeiwgELILHPNudrwZvNdIlVDEPLq
         BJ73ykuJ+94u4uQBPNyV6tMgo0+ZUCp+bITF5QywIsdfDdC7jUIdAE17pFsc36PxQ4xV
         vTCReHMAJl8u78OBLKl+EAV7iyvexnZ1AhZoSIYgkKHBhwgYVLTcTBZkhYdtjrBMVgMm
         QjtxBqDMzT3+wxvIx9QrBTJjUHsuCvdPR3l7fqri3ZZWQX/SN7CDxmP1Gcl/uWO84fe1
         4Lgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FGm/Y7V816AbGprOQHUkgpBjccypqHGHqD5N/dMxVkw=;
        b=i4lX+0Oc7ue6+81NUA8GZE/BHEtuP+L/IdnPtVmBAncwlFhQvzkutC5jEEA1QDX81B
         0CQfh7yu9zCxJh8FCd6ZsXqNH0pMG40lsJKgkt4Iuc+fVl/R/JXqCWYDuVvAdt7wz0PM
         esbIwRz8vXWKIeNCpPrXs9jVIl2ER6NWpaVcJ9YaIpoHWokjfJngU07SkrZoOsfenlyH
         TV/HSHGB4UNMas6vEa3nC1ob2SxGwh4ygZq9Ro1o6J8lY9zGMHQNEH2uquwZAqM0U3ek
         c6way7LGxSiv2n5en8OWif332jn23Ugrdqa0G1AbiSycPDf5KoGDypL49mCdBFIYykbT
         xotA==
X-Gm-Message-State: APjAAAW0kvt/Kphgd1ouWfEbFhC9FkPjPavkrPiCrFNsSRUc9k2vn7YZ
        BDoSANhk70t1kYwCa4Ig4h4=
X-Google-Smtp-Source: APXvYqzOXOUeSsq0bKR1Uijb/ZiwdTPLXJEsLwvGyotcdrS+xtT/7Fg0PiKSxgnSjNVkIwYqOuYnSQ==
X-Received: by 2002:a7b:cd19:: with SMTP id f25mr5273390wmj.154.1571924605222;
        Thu, 24 Oct 2019 06:43:25 -0700 (PDT)
Received: from andrea.guest.corp.microsoft.com ([2a01:110:8012:1012:e185:86b0:69d4:5ba5])
        by smtp.gmail.com with ESMTPSA id o6sm15323168wrx.89.2019.10.24.06.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:43:24 -0700 (PDT)
Date:   Thu, 24 Oct 2019 15:43:19 +0200
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
Message-ID: <20191024134319.GA12693@andrea.guest.corp.microsoft.com>
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com>
 <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
 <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com>
 <20191024113155.GA7406@andrea.guest.corp.microsoft.com>
 <CACT4Y+Z2-mm6Qk0cecJdiA5B_VsQ1v8k2z+RWrDQv6dTNFXFog@mail.gmail.com>
 <20191024130502.GA11335@andrea.guest.corp.microsoft.com>
 <CACT4Y+ahUr11pQQ7=dw80Abj5owUPnPdufbMYvsKLM6iDg5QQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+ahUr11pQQ7=dw80Abj5owUPnPdufbMYvsKLM6iDg5QQg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> But why? I think kernel contains lots of such cases and it seems to be
> officially documented by the LKMM:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/explanation.txt
> address dependencies and ppo

Well, that same documentation also alerts about some of the pitfalls
developers can incur while relying on dependencies.  I'm sure you're
more than aware of some of the debate surrounding these issues.

  Andrea
