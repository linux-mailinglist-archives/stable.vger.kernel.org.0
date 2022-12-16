Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A44D64ECB6
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 15:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiLPOND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 09:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiLPOM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 09:12:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BAA11441;
        Fri, 16 Dec 2022 06:12:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FB5E6212A;
        Fri, 16 Dec 2022 14:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55F3C433EF;
        Fri, 16 Dec 2022 14:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671199975;
        bh=26Mosu5Cz2UgSpReY99um0xG14PZU5nCcjyyW+3e/+Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pBeXgzD69ynXqAnQcwRVH03m6ilshVHImvxwy1hVGGmGVcmm5HFxswB2u+OcQkebe
         4mtDusbv5FElPGUJN9VEdqhGdXqqwchF1NO6rPe3dARiRlKielSmB3oFkJAu9rfBhs
         tY5oB87UzO1gm8IpbokJXghg1Om1NaWAV9bKmRy59+wXfxpPKto2wkMJc6UUndQ9Uy
         NgoU8/OMEL6krpUoIKnZ2c3t5tFz03UDSJnfOxSVSl0lrhqSoMghiSe22zt3+fO6vg
         nrmQgfxRFoLcAmT5XgjS8WDkwZga+LMXEfbmmnXtVUPQY5RFkhuBuGRAiK2QDvATJk
         GU8qlzzt0PdjQ==
Date:   Fri, 16 Dec 2022 14:12:49 +0000
From:   Lee Jones <lee@kernel.org>
To:     Aleksandr Nogikh <nogikh@google.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        syzbot <syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, gregkh@linuxfoundation.org,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, syzkaller-android-bugs@googlegroups.com,
        tadeusz.struk@linaro.org
Subject: Re: kernel BUG in ext4_free_blocks (2)
Message-ID: <Y5x84fb+YegSendN@google.com>
References: <0000000000006c411605e2f127e5@google.com>
 <000000000000b60c1105efe06dea@google.com>
 <Y5vTyjRX6ZgIYxgj@mit.edu>
 <Y5xsIkpIznpObOJL@google.com>
 <CANp29Y6KHBE-fpfJCXeN5Ju_qSOfUYAp2n+cNrGj25QtU0X=sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y6KHBE-fpfJCXeN5Ju_qSOfUYAp2n+cNrGj25QtU0X=sA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Dec 2022, Aleksandr Nogikh wrote:

> On Fri, Dec 16, 2022 at 2:01 PM Lee Jones <lee@kernel.org> wrote:
> >
> > On Thu, 15 Dec 2022, Theodore Ts'o wrote:
> >
> > > On Thu, Dec 15, 2022 at 08:34:35AM -0800, syzbot wrote:
> > > > This bug is marked as fixed by commit:
> > > > ext4: block range must be validated before use in ext4_mb_clear_bb()
> > > > But I can't find it in any tested tree for more than 90 days.
> > > > Is it a correct commit? Please update it by replying:
> > > > #syz fix: exact-commit-title
> > > > Until then the bug is still considered open and
> > > > new crashes with the same signature are ignored.
> > >
> > > I don't know what is going on with syzkaller's commit detection, but
> > > commit 1e1c2b86ef86 ("ext4: block range must be validated before use
> > > in ext4_mb_clear_bb()") is an exact match for the commit title, and
> > > it's been in the upstream kernel since v6.0.
> > >
> > > How do we make syzkaller accept this?  I'll try this again, but I
> > > don't hold out much hope.
> >
> > I don't see the original bug report (was it posted to a lore
> > associated list?), so there is no way to tell what branch syzbot was
> > fuzzing at the time.  My assumption is that it was !Mainline.
> 
> Syzbot is actually reacting here to this bug from the Android namespace:
> 
> https://syzkaller.appspot.com/bug?id=5266d464285a03cee9dbfda7d2452a72c3c2ae7c
> 
> > Although this does appear to be a Stable candidate, I do not see it
> > in any of the Stable branches yet.  So I suspect the answer here is to
> > wait for the fix to filter down.
> >
> > In the mean time, I guess we should discuss whether syzbot should
> > really be posting scans of downstream trees to upstream lists.
> 
> In this particular case, syzbot has captured all the recipients from
> the patch email [1], because that email Cc'd
> syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com. To syzbot, all
> these people were involved in the original bug discussion, and so it
> notified them about the problem.
> 
> FWIW I've sent a PR[2] to make the "I can't find it in any tested
> tree" message include the link to the syzkaller dashboard. Hopefully
> it will help resolve such confusions faster.

That's helpful, thank you.

-- 
Lee Jones [李琼斯]
