Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA07E306A
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 13:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407123AbfJXLcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 07:32:04 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52729 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404851AbfJXLcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 07:32:04 -0400
Received: by mail-wm1-f65.google.com with SMTP id p21so977404wmg.2;
        Thu, 24 Oct 2019 04:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DZXnuoq0kzhyK3ZfyoChFruO7ulVTQT5yFbmA2HiD5E=;
        b=aYpyjBWHp2ru8kuGR9sy99ozfEb8hLsT7plp3/t5h3GBLaJU57Mm68N/rIWhzrMKor
         8lDwjKC/z9P+LdyymtMnjeiSWtXfMFDqh0vnOKym4NTPhMgQ0Iql+FxCLBpgQBB+lDxS
         Rafte8ufY3uz8wIyqfs+Ij/7JuMZDXYji+52pcKdU8k49DEWROdU9v+K4Ql1K5465prS
         dj+EfmeNGhtUPuWLjV4dWuB1jS5RzwEFg3JZ9PbB9PjYgULkr0ZFMnP6hLeIDkHhLx6Z
         tHv+IqtxP+DMTF6yAqQa5+sTQJPWiVkqPQ5VsSqvK5BykzkG/bNkhU+I9VA+uXkYEh5k
         PDnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DZXnuoq0kzhyK3ZfyoChFruO7ulVTQT5yFbmA2HiD5E=;
        b=mIojsoMyxxGbBYy29E8cUZYksQmTkq6eM5D904SAXc9VeABkjSDWMvDIF+54jRKfHy
         pEI2C8aeBHlbXFTu/nTLszx2sGP/uQrGP4reQLm+PytVQo8DM7AnDVKAgYptOjulr0hA
         QdsyMZhw+DKE871YLqPFHUS7S4tsCqJtbor/EPTu3QmIXcilH7nuhAb4WH6wVI/7WnJU
         8gGtRurGQ/QjG6RvHbS5I2o8rq9e9OsURBQEPPvBVHmNfl+arhejR6MLXcy9lkq1/eh8
         FH/KBe9kgYg9rvZ4Ycy1RdwG+ptesqMetjD1wrG1QEqAEtyeLxUBSLf8zDLshRIEG7Iv
         erQA==
X-Gm-Message-State: APjAAAURqiwlxw8/burun6fJrxplxGAr/qsMthzDEU0f1XBqjCr6/fhL
        HEOFUDycRLH16zHI2FnRgnWYImC+cPY=
X-Google-Smtp-Source: APXvYqyjgIfeo3Ch2UyCdDU3CvMg5d9whxkZEKIlIftTVIk/yJnJwVCnwhUKTT34dYwEP+gC9dOGeA==
X-Received: by 2002:a1c:1f4b:: with SMTP id f72mr4221461wmf.22.1571916721880;
        Thu, 24 Oct 2019 04:32:01 -0700 (PDT)
Received: from andrea.guest.corp.microsoft.com ([2a01:110:8012:1010:e187:86b0:69d4:5ba5])
        by smtp.gmail.com with ESMTPSA id h3sm10822210wrt.88.2019.10.24.04.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 04:32:01 -0700 (PDT)
Date:   Thu, 24 Oct 2019 13:31:55 +0200
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
Message-ID: <20191024113155.GA7406@andrea.guest.corp.microsoft.com>
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com>
 <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
 <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> How these later loads can be completely independent of the pointer
> value? They need to obtain the pointer value from somewhere. And this
> can only be done by loaded it. And if a thread loads a pointer and
> then dereferences that pointer, that's a data/address dependency and
> we assume this is now covered by READ_ONCE.

The "dependency" I was considering here is a dependency _between the
load of sig->stats in taskstats_tgid_alloc() and the (program-order)
later loads of *(sig->stats) in taskstats_exit().  Roughly speaking,
such a dependency should correspond to a dependency chain at the asm
or registers level from the first load to the later loads; e.g., in:

  Thread [register r0 contains the address of sig->stats]

  A: LOAD r1,[r0]	// LOAD_ACQUIRE sig->stats
     ...
  B: LOAD r2,[r0]	// LOAD *(sig->stats)
  C: LOAD r3,[r2]

there would be no such dependency from A to C.  Compare, e.g., with:

  Thread [register r0 contains the address of sig->stats]

  A: LOAD r1,[r0]	// LOAD_ACQUIRE sig->stats
     ...
  C: LOAD r3,[r1]	// LOAD *(sig->stats)

AFAICT, there's no guarantee that the compilers will generate such a
dependency from the code under discussion.


> Or these later loads of the pointer can also race with the store? If
> so, I think they also need to use READ_ONCE (rather than turn this earlier
> pointer load into acquire).

AFAICT, _if the LOAD_ACQUIRE reads from the mentioned STORE_RELEASE,
then the former must induce enough synchronization to eliminate data
races (as well as any undesired re-ordering).

TBH, I am not familiar enough with the underlying logic of this code
to say whether that "if .. reads from .." pre-condition holds by the
time those *(sig->stats) execute.

Thanks,
  Andrea
