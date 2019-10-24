Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6618FE34DB
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 15:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393837AbfJXN6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 09:58:54 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34554 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390960AbfJXN6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 09:58:54 -0400
Received: by mail-qk1-f193.google.com with SMTP id f18so22880977qkm.1
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 06:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UOruI0JrGFz7xrLotlBY15Zel47+fi3BtuX0TPe8v+s=;
        b=ojoJPg1vybYzGTONg5L7cUYX3/GVoymSo7uGRPUG8kfU1ldQOrWGDfUvzrRLML+CTR
         UQL7SYjkigtIrTndCk+J0sqzk13K/85JxFkzAbqUaCFWWDZI4YYySteGjhZMidl2qheO
         aZxZgnpPgNsSK15IiJgvGT5BdDnuUmbFM1hjK4ivbLNK6cThuC4D8v+qljKLKDcGN3/P
         TrIaok3VoSEirnQkvCNRUntWEgh1Q49kKUWXK0nmXE6yxBqs+k62GJVES6/h/H3bF44w
         DrykRV0/8HC4e6JMdM4e6DUtDUDxGsrOEfu5/vj1EUsnQnuoqikCl9AuRm+yaCsOmatn
         HEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UOruI0JrGFz7xrLotlBY15Zel47+fi3BtuX0TPe8v+s=;
        b=ohjSmxRwk6LbOpJnXOOnd9olzN1g+ji7Xt2kfAPcP2wlPnUODNNq02WZCcB0c/BuII
         5mtcSDAe/DylZtBGsPKIdPOcid/1GqBjTVxfOyO24G7Cxzja9EuYYXEw9d3/MCUMFhaZ
         ypqErmRmi1WcnlBToeJslO4vHRvxjQCvrkA7DbgEdNTsM2evbQM5EIUAD0yXYaVZFIqq
         piHBXVx2RfXT6HcWQIdRhgCiBZp07AMoolYAaCD2C7/MqyCwi7UPIMzUCCMpjFRzWgO/
         +P4IjlF66pr7FMxtEJLykOiKS0gIN0jlCcLjIcxghMuPD04jPWtGqQbip0ImhkpE4KoT
         y2CA==
X-Gm-Message-State: APjAAAWVWDClgDVBoStmLCRQV2y+R7TkEElF6BoNFGYdX5+5hD8gdXRx
        3KrjCj86nvgGZyppAhjiTNyRDOMl8O87KpmYY8/l8w==
X-Google-Smtp-Source: APXvYqyJH8mQi7kWDAjmkW7fqPexv//gkSatB3x6zm5BjqDBwjBozeI+h5HyB+gfDOt4dAGZI+IarZp2cnkR7axleZ8=
X-Received: by 2002:a05:620a:2158:: with SMTP id m24mr14081580qkm.250.1571925532851;
 Thu, 24 Oct 2019 06:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com> <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
 <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com>
 <20191024113155.GA7406@andrea.guest.corp.microsoft.com> <CACT4Y+Z2-mm6Qk0cecJdiA5B_VsQ1v8k2z+RWrDQv6dTNFXFog@mail.gmail.com>
 <20191024130502.GA11335@andrea.guest.corp.microsoft.com> <CACT4Y+ahUr11pQQ7=dw80Abj5owUPnPdufbMYvsKLM6iDg5QQg@mail.gmail.com>
 <20191024134319.GA12693@andrea.guest.corp.microsoft.com>
In-Reply-To: <20191024134319.GA12693@andrea.guest.corp.microsoft.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 24 Oct 2019 15:58:40 +0200
Message-ID: <CACT4Y+ZXQyqgBvwgb6cy7NP5FTBbktq5j4ZyySp7jrbcJwFUTA@mail.gmail.com>
Subject: Re: [PATCH v6] taskstats: fix data-race
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bsingharora@gmail.com,
        Marco Elver <elver@google.com>,
        stable <stable@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 3:43 PM Andrea Parri <parri.andrea@gmail.com> wrote:
>
> > But why? I think kernel contains lots of such cases and it seems to be
> > officially documented by the LKMM:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/explanation.txt
> > address dependencies and ppo
>
> Well, that same documentation also alerts about some of the pitfalls
> developers can incur while relying on dependencies.  I'm sure you're
> more than aware of some of the debate surrounding these issues.

I thought that LKMM is finally supposed to stop all these
centi-threads around subtle details of ordering. And not we finally
have it. And it says that using address-dependencies is legal. And you
are one of the authors. And now you are arguing here that we better
not use it :) Can we have some black/white yes/no for code correctness
reflected in LKMM please :) If we are banning address dependencies,
don't we need to fix all of rcu uses?
