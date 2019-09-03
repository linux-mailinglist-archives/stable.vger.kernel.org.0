Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1C3A60DD
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 07:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfICFz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 01:55:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44529 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfICFz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 01:55:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id 30so5028035wrk.11;
        Mon, 02 Sep 2019 22:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=X7sSiUySVZV9o7/lrwJkuFeTAt0kOUYd/2rnVcX4C8w=;
        b=Ys9Y1fQIYN15V0apg8nw2x0mdkLG1gGNdLtlgz4yLuv9IaPS1KM1uIJ8JN37YtoltE
         l8m2NDUGfIn0E5p4sarsomM9ekjwyWsHsGnAUD5wkCtuvsEbywJGCy1q+CDsMJrIYNCq
         Lh6kM0IYyvOWZoWc62AfycTE0J7CU6MwvpmfPExJ7BjxJZGNPfCfYqfF59G8B/9AvTZV
         IxhS+n5aKbC1rVX+jOnVOQvJG5nrFZnCbpYfYjlPcQmQYmtXkc4qvJlrFWSLocMFeqDg
         WTRxJ1TqYC6NiivsiaabMgS91UanJWDR3VngBpHqlgCIHu81YQ49cfa6u1eu05K0Vh8g
         F24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=X7sSiUySVZV9o7/lrwJkuFeTAt0kOUYd/2rnVcX4C8w=;
        b=HV/H5fVwvqyarnC0Db3tzlcei1DNHhlVyqhKn8ZMJByrzHgslNLUyk+PXeAD5k5a/u
         PBih6leeV59wo0Hu+0eTRpGev+4JLhcH2Oihzs3pNLFk/cYvDSgEvb0pVydNb01Et/j8
         5dO4ZDhOHN8hIcpijYIjY4nduuuFGHcGqLAuP3+7zHF4fmvXFDoiruOBzQx5nR0dwgT4
         eCQN2N3rAOf8QJNZBBsMJ8nhhoXfbeuLR3MqX+onXXuHgQm+yUOZ0FnTfhu+E57Fkdru
         S9Svew5Zqhp2KlX8iQt8qOBsnKBYmoY3JDKFBe1m0WCzIRubIydKmL2LuOLbroTTZ5Fa
         y8Ww==
X-Gm-Message-State: APjAAAVYq3PWSIzKMBUbm4QOTUDVeSG3kHBe+zDDfnhS9DcgFgUeUv/0
        47QkaxDJdOGBvH2IWwB21vl6TS/m95s=
X-Google-Smtp-Source: APXvYqyBhTmrTiKTpFKgVK1t14H6EtrLzraSNMVF6fR+NHY6gWzA/qnovaxj2pzBYW88+FhaukDwWQ==
X-Received: by 2002:a5d:6602:: with SMTP id n2mr10555596wru.317.1567490155857;
        Mon, 02 Sep 2019 22:55:55 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id a130sm7848265wmf.48.2019.09.02.22.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 22:55:55 -0700 (PDT)
Date:   Mon, 2 Sep 2019 22:55:53 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
Message-ID: <20190903055553.GC60296@archlinux-threadripper>
References: <20190812023214.107817-1-natechancellor@gmail.com>
 <878srdv206.fsf@mpe.ellerman.id.au>
 <20190828175322.GA121833@archlinux-threadripper>
 <CAKwvOdmXbYrR6n-cxKt3XxkE4Lmj0sSoZBUtHVb0V2LTUFHmug@mail.gmail.com>
 <20190828184529.GC127646@archlinux-threadripper>
 <6801a83ed6d54d95b87a41c57ef6e6b0@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6801a83ed6d54d95b87a41c57ef6e6b0@AcuMS.aculab.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 09:59:48AM +0000, David Laight wrote:
> From: Nathan Chancellor
> > Sent: 28 August 2019 19:45
> ...
> > However, I think that -fno-builtin-* would be appropriate here because
> > we are providing our own setjmp implementation, meaning clang should not
> > be trying to do anything with the builtin implementation like building a
> > declaration for it.
> 
> Isn't implementing setjmp impossible unless you tell the compiler that
> you function is 'setjmp-like' ?

No idea, PowerPC is the only architecture that does such a thing.

https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git/tree/arch/powerpc/kernel/misc.S#n43

Goes back all the way to before git history (all the way to ppc64's
addition actually):

https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/?id=61542216fa90397a2e70c46583edf26bc81994df

https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/arch/ppc64/xmon/setjmp.c?id=5f12b0bff93831620218e8ed3970903ecb7861ce

I would just like this warning fixed given that PowerPC builds with
-Werror by default so it is causing a build failure in our CI.

Cheers,
Nathan
