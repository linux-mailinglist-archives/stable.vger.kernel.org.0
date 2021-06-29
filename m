Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F02D3B6E63
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 08:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhF2Gyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 02:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbhF2Gyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 02:54:35 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6685C061574
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 23:52:08 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so21716140otl.0
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 23:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=tKW+f+kyq0r0z+d3KxnzyQ6cXDIvquTW43KpblhRPwQ=;
        b=B6wGz2C7SkAxi0X+WZjQKaVZODECGqp+aB0Tp8Jz2sW4SF8/9mOyzBOMvDOfel96YV
         Pbr3GWyXuRCQ+AYdTKT3fCNcCKeK5SLSuYd0odW7jeDROfIQPxv5bnPDWvq1M1NBH69q
         9uabFap6nMtYyIK0oxIaoFUXDyslI4jVOTmgcCAtF7/SVYiI/pbFVT5J6C5bcKzR3173
         vK4B7+5KAYKfK7PP29/Awy08Jl7swg6acAprZiTxq/Nds5BTT274FXii4sFLc/BZADoW
         6D3uRbJ5aa7nfCkYim//Zhi7Ds9d2Q8fFi/4dZt4VXxUwhkGURhP+RDNIYi858YuhzWS
         r20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=tKW+f+kyq0r0z+d3KxnzyQ6cXDIvquTW43KpblhRPwQ=;
        b=FHMjMJzORQw6op+MlfTM9fWRJ/zR7MAJPp5j5S8C8nS0wgo8RwePBFlxERwc9ns088
         yfbDHMLYZqz8cJofi16F+GEgw6YymUlWrkozD6qujJMiwWI9kbFo+84XgXmJ4obQ6JEA
         2mjj0/AbJbD2CeiOve4EhCicLGQIDIQgZowZKeYAXvcfVSA1dKvFyngIUzlXZeY9MW6j
         KCyd9RDQLmeAtPkpwDn0wB8/NcwTjhOwl6doHhy7ipIHVe9UjsQdElpgf40AaeKh+oGp
         fGD+n7Qr1EZDPdvtqoioKvIzxxrlb6XE4J2l9P34he1ikIS4Nnbhf1d2tA5DGvxpbFwR
         GQ0Q==
X-Gm-Message-State: AOAM531jpQ6GQLvUp5Cgbmymb/dpu4u2NVQGTfH7cElrU82GMQvBVExi
        0lTdPtt7MbQbnPg32lLVQpRb4Q==
X-Google-Smtp-Source: ABdhPJzzwwtcBftHWyytNlbN9PTCAkJrtqXukGcHmJcIYzX2zsUOgOWAAr1CHsgHXcFrSUBmKzP0Fg==
X-Received: by 2002:a9d:4a8a:: with SMTP id i10mr3131666otf.282.1624949527730;
        Mon, 28 Jun 2021 23:52:07 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id w186sm3639824oib.58.2021.06.28.23.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 23:52:07 -0700 (PDT)
Date:   Mon, 28 Jun 2021 23:51:55 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     Sasha Levin <sashal@kernel.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Xu Yu <xuyu@linux.alibaba.com>, Jue Wang <juew@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alex Shi <alexs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: Re: mm/thp commits: please wait a few days
In-Reply-To: <YNq4yJls+PKsULh0@kroah.com>
Message-ID: <265a4571-7eb6-e2e6-7cf9-6ef825cd3152@google.com>
References: <88937026-b998-8d9b-7a23-ff24576491f4@google.com> <YMrU4FRkrQ7AVo5d@kroah.com> <YNNMGjoMajhPNyiK@kroah.com> <ca4d4e0-531-3373-c6ee-a33d379a557c@google.com> <20210623134642.2927395a89b1d07bab620a20@linux-foundation.org> <c2bf7b2-a2d9-95a1-e322-4cf4b8613e9@google.com>
 <6b253bc4-2562-d1bb-18f2-517cfad5d5e7@google.com> <YNm93fkIPrqMwHzd@kroah.com> <366846c0-245a-771e-7a1-4a307ac6e5e1@google.com> <YNqTCV7DmYGZiZ7N@sashalap> <YNq4yJls+PKsULh0@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Jun 2021, Greg Kroah-Hartman wrote:
> On Mon, Jun 28, 2021 at 11:27:05PM -0400, Sasha Levin wrote:
> > On Mon, Jun 28, 2021 at 10:12:57AM -0700, Hugh Dickins wrote:
> > > On Mon, 28 Jun 2021, Greg Kroah-Hartman wrote:
> > > > So could you just send a mbox of patches (or tarball), for the 4.19,
> > > > 4.14, and 4.9 trees?  That would make it much easier to ensure I got
> > > > them all correct.
> > > 
> > > At risk of irritating you, sorry, I am resisting: the more data I send
> > > you, the more likely I am to mess it up in some stupid way.  Please ask
> > > again and I shall, but I think your success with 5.12, 5.10, 5.4 just
> > > means that you were right to take a break before 4.19, 4.14, 4.4.
> > 
> > I've tried following the instructions for 4.19, and that worked fine on
> > my end too.
> > 
> > If no one objects, I can pick up 4.9-4.19 after the current set of
> > kernels is released.
> 
> No objection from me, thanks!
> 
> greg k-h

Sure, Sasha, whenever suits you: thanks to you both.

Hugh
