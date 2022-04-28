Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58129513C18
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 21:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351403AbiD1Tbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 15:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiD1Tbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 15:31:33 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7C7A88BB
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 12:28:17 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-e68392d626so6149812fac.4
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 12:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=dWgiz5nrp/2MwkyGwqqFtNKzpekFyvvJn5Qx6Z2bB5A=;
        b=B5F2eU1tJqQgrHqb1lbcu8YOgDIQMfLMalLuuYSrRaNp/8Lxta47hhp3heCHUGOaWH
         YZaWHwQtJpQNHxEOCnwqfkrigC+85KV/NDR/De9q6GEWJiNBiZ0Zvx5jRqT47TLXM7WT
         5KsutpQrT68LixlIG7TxM5/KZFgsQXnJ0ktuMhPp8liEwchuo80V+ikZY+6A1q7Dy3dt
         FIiosGdIaLh7UTQsy26VF5NP1q4AlFplBlJMN9i8i2n24BahkdmyU7uXHEResZpOp7qn
         oo5iaCdAu4bd0/pDpVGdlWuYiPvksDmBqy5L4jrl/dulXzTo9uva2DTY9DaBFlqspZS5
         bzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=dWgiz5nrp/2MwkyGwqqFtNKzpekFyvvJn5Qx6Z2bB5A=;
        b=8Q/oNrpR2Y8BPc74YrazkWh1qL8wOPtiBlAunbvi/Eb+hp+cL7b9Gql2ATBio7fZjR
         CNbSgIkb7myJgWQ9fzqjw6vaPg2woPysN8uDEtx77pug+hDhgI/t+MbTALFcedsp9FJy
         gz/d7epCks8UHlFNmNLh6TOx15zmYiFN/TdlLwOCE9c0k0GpLXY8zqp/2D6NRdEFxbId
         J/dbR/hG5FxkOm3nhOXxwMkWHU4Ih2f5nErKkmUUsWdL0rRNiPwwm0orfCn5tc5kU3de
         ErmrtDS8gJ5ws3tt9xg94Kbuhr8dXhmvlbM3Wjba8YfK9gHQd7ZtdR5v6B/7DZgRbe0S
         ZD9A==
X-Gm-Message-State: AOAM531tub1irppn9TmPigDgdCmHqk3TwCe2KHqTRnDdSl3WLT78/48e
        TdOTNwqdKeR1aFWx1QDpOX6WNA==
X-Google-Smtp-Source: ABdhPJz/xQWaC6nu0nJSN5arM58FKtUW3YsfBe770j3KjiE8I04CszT70UVQMC428K9LL5PbSKMZXg==
X-Received: by 2002:a05:6870:24a1:b0:e9:2282:614d with SMTP id s33-20020a05687024a100b000e92282614dmr11022021oaq.250.1651174096887;
        Thu, 28 Apr 2022 12:28:16 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id q4-20020a4a3004000000b0035e974ec923sm369125oof.2.2022.04.28.12.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 12:28:16 -0700 (PDT)
Date:   Thu, 28 Apr 2022 12:27:40 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Hugh Dickins <hughd@google.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Shi <shy828301@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH AUTOSEL 13/14] mm/thp: ClearPageDoubleMap in first
 page_add_file_rmap()
In-Reply-To: <YmrHsVZTEzqIDiKd@kroah.com>
Message-ID: <bec6e6cf-daa7-d632-7f81-471acba69c9d@google.com>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org> <20220428154222.1230793-13-gregkh@linuxfoundation.org> <c2ed1fe1-247e-e644-c367-87d32eb92cf5@google.com> <YmrHsVZTEzqIDiKd@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 28 Apr 2022, Greg Kroah-Hartman wrote:
> On Thu, Apr 28, 2022 at 09:51:58AM -0700, Hugh Dickins wrote:
> > On Thu, 28 Apr 2022, Greg Kroah-Hartman wrote:
> > 
> > > From: Hugh Dickins <hughd@google.com>
> > > 
> > > commit bd55b0c2d64e84a75575f548a33a3dfecc135b65 upstream.
> > > 
> > > PageDoubleMap is maintained differently for anon and for shmem+file: the
> > > shmem+file one was never cleared, because a safe place to do so could
> > > not be found; so it would blight future use of the cached hugepage until
> > > evicted.
> > > 
> > > See https://lore.kernel.org/lkml/1571938066-29031-1-git-send-email-yang.shi@linux.alibaba.com/
> > > 
> > > But page_add_file_rmap() does provide a safe place to do so (though later
> > > than one might wish): allowing testing to return to an initial state
> > > without a damaging drop_caches.
> > > 
> > > Link: https://lkml.kernel.org/r/61c5cf99-a962-9a25-597a-53ab1bd8fbc0@google.com
> > > Fixes: 9a73f61bdb8a ("thp, mlock: do not mlock PTE-mapped file huge pages")
> > > Signed-off-by: Hugh Dickins <hughd@google.com>
> > > Reviewed-by: Yang Shi <shy828301@gmail.com>
> > > Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > NAK.
> > 
> > I thought we had a long-standing agreement that AUTOSEL does not try
> > to add patches from akpm's tree which had not been marked for stable.
> 
> True, this was my attempt at saying "hey these all look like they should
> go to stable trees, why not?"

Okay, it seems I should have read "AUTOSEL" as "Hey, GregKH here,
these all look like they should go to stable trees, why not?",
which would have drawn a friendlier response.

The answer is that I considered stable at the time, and akpm did too,
and none of my three (I've not looked through the other 11) are serious
enough to be needed in stable; and I'm cautious about backports, because
I know that the tree they went on top of differs thereabouts from 5.17.

Of course I think the patches in 5.18-rc are good, and yes, they're
things I've thought worthwhile enough for me personally to port forward
over several releases until I had time to send in.  But that doesn't
make them safe stable candidates, without someone to verify and vouch
for the results in this or that tree - I run on a much slower clock
than you and most around here, I do not have time for that at present
(and would prefer not even to be having this conversation).

But I'm happily overruled if any mm guys think they are worth that
extra effort, and will verify and vouch for them.

> 
> > I've chosen to answer to this patch of my 3 in your 14 AUTOSELs,
> > because this one is just an improvement, not at all a bugfix needed
> > for stable (maybe AUTOSEL noticed "racy" or "safely" in the comments,
> > and misunderstood).  The "Fixes" was intended to help any humans who
> > wanted to backport into their trees.
> 
> This all was off of the Fixes: tag.  Again, if these commits fix
> something why are they not for stable?  I'm a human asking to backport
> these into the stable trees based on that :)

Your humanity is not in doubt :)  But I think we've gone over this
too many times - each year?  There's a "Fixes:" tag and "Cc: stable"
tag, and in akpm's tree we prefer to be able to specify "Fixes:" to
help each other, without that automatically implying "Cc: stable".
Andrew goes to considerable trouble to determine when "Cc: stable"
is appropriate.

> 
> > I do recall that this 13/14, and 14/14, are mods to mm/rmap.c
> > which followed other (mm/munlock) mods to mm/rmap.c in 5.18-rc1,
> > which affected the out path of the function involved, and somehow
> > made 14/14 a little cleaner.  I'm sorry, but I just don't rate it
> > worth my time at the moment, to verify whether 14/14 happens to
> > have ended up as a correct patch or not.
> > 
> > And nobody can verify them without these AUTOSELs saying to which
> > tree they are targeted - 5.17 I suppose.
> 
> 5.17 to start with, older ones based on where the Fixes: tags went to.
> 
> So do you really want me to drop these?  I will but why are you adding
> fixes: tags if you don't want people to take them?

Yes, please drop them - thanks.  As to the other 11: I hope authors
will speak up one way or the other, but I'll drop out now.

Hugh
