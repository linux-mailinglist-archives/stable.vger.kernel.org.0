Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654D464F135
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 19:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiLPSqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 13:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiLPSqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 13:46:14 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563DA27CEF
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 10:46:13 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2BGIjlov020254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Dec 2022 13:45:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1671216350; bh=0ide3HOJSrViN20xczF1Lt88DnIce25P4e17wke2XSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=L67a+VJrOjI8MJDnUZ3P412ybi+mdUtqNGzdz0Q19atGUsE2Tmbbq02ThviVCatDr
         3ACLUMbdaRTnpfiR/OnnkxFaGrJfXLq/Mqp3giSScJdxbpK1XN38euO7xISS1iCpS7
         436DWZodGTKz8tYWjACJXT40UhiTZqSX7xklVcZx4c/R79ZXms52bu60uztS9leDCx
         4CMLRGAvflf4t4BQZgnRNRGjIP6HiBLYvymJ4DcMFf0fbkLsZQ6QcyDV2Y39UX6utv
         rKrwOYd/n03Pw3tv9EYdKAvsDVeWy9fTH+x7jRSdsUhcu4nQus0GGWgS3am9fy0YE2
         fefjmXxO44sHA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id CD0DD15C40A2; Fri, 16 Dec 2022 13:45:47 -0500 (EST)
Date:   Fri, 16 Dec 2022 13:45:47 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Aleksandr Nogikh <nogikh@google.com>
Cc:     Lee Jones <lee@kernel.org>,
        syzbot <syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, gregkh@linuxfoundation.org,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, syzkaller-android-bugs@googlegroups.com,
        tadeusz.struk@linaro.org
Subject: Re: kernel BUG in ext4_free_blocks (2)
Message-ID: <Y5y824gPqZo+vcxb@mit.edu>
References: <0000000000006c411605e2f127e5@google.com>
 <000000000000b60c1105efe06dea@google.com>
 <Y5vTyjRX6ZgIYxgj@mit.edu>
 <Y5xsIkpIznpObOJL@google.com>
 <CANp29Y6KHBE-fpfJCXeN5Ju_qSOfUYAp2n+cNrGj25QtU0X=sA@mail.gmail.com>
 <Y5ylNxoN2p7dmcRD@mit.edu>
 <CANp29Y4QVp1G83pSqpxeETbw_+kQQ5CZUz+Vgi767WxE8AuhHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANp29Y4QVp1G83pSqpxeETbw_+kQQ5CZUz+Vgi767WxE8AuhHQ@mail.gmail.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 06:14:50PM +0100, Aleksandr Nogikh wrote:
> > Thanks for the clarification; stupid question, though -- I see
> > "upstream" is listed on the dashboard link above.  Assuming that
> > "usptream" is "Linus's tree", why was it still saying, "I can't find
> > this patch in any of my trees"?  What about the upstream tree?
> 
> Bugs from different namespaces are treated independently, so in this
> particular case syzbot was expecting the fixing commit to reach the
> Android trees that it fuzzes.

Is there a way someone can look at the dashboard link to determine
which (a) what namespace a particular syzkaller report is in, and (b)
what trees are included in a particular namespace?

Adding a link to the e-mail to the dashboard page may not help if it's
not obvious why the dashboard mentions "upstream" and yet it's not in
"any of the trees".  Maybe the e-mail should explicitly list the trees
that syzkaller will be searching?

And it would seem that it would be a *feature* if looking at a syzbot
dashboard from Android namespace could expose the fact that particular
patch is in any of the LTS trees or Linus's upstream tree, no?

Also, what is the reason for Android for being in a separate
namespace?  Is it running on a separate syzbot VM?  I can understand
why from a feature perspective, that Fuschia and OpenBSD should be in
separate namespaces; but what are the reasons that there are separate
namespaces for Android versus the upstream kernel?  Especially since
the Android dashboard is apparently referencing the upstream kernel?
What's up with that?

Put another way, while I think it's super useful to have a link to
Syzbot dashboard page, in the e-mail, I'm not sure it's going to be a
complete solution to the confusion that was inspired by this case.

That being said, in general I think a link to the Dashboard is useful;
in fact, it might be nice if we could encourage upstream developers
put in the commit trailer:

Link: https://syzkaller.appspot.com/bug?id=5266d464285a03cee9dbfda7d2452a72c3c2ae7c

in addition to, or better yet, instead of:

Reported-by: syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com

... and have Syzbot be able to translate from the Link: tag as being
equivalent to the Reported-by: link.  That's becase the Link is going
to be much more useful to humans than the Reported-by --- we've had a
number of cases where as part of the patch review, we really wanted to
get back to the Dashboard page, and it's not easy to get to the
Dashboard from the Reported-by tag.

Thanks,

						- Ted

