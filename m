Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923CD688778
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 20:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbjBBTUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 14:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbjBBTUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 14:20:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEDA7DBD7;
        Thu,  2 Feb 2023 11:20:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DF0BB827C8;
        Thu,  2 Feb 2023 19:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD2CC4339C;
        Thu,  2 Feb 2023 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675365640;
        bh=JMF3AP3CosyLA5m89zkgGX3JGOxiecE9dcZ7MdoTDOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ub+f1ALxZ0mlr3pdVXVfuO4S01WUZ7wG9HvoOV6fjMc4cJgfCl2Q7xA+uPDvReDv3
         BLpS2MQX5dkerbo70NDvIvPZipMAUsxXDQ4HgCJNK4jFeDK/mUKK9kuuwnoYjfls7/
         rPV3aZBjQpJfWNKYPO3qTWoNAftknJCm+frFRM5wiJOyzL3gCOfo76enQV6z15TBnN
         bcG3S82A0PphyE5feyKqtt0Hte0zYkYPp3YbndxPnrRONS+1aPkGGYIuvG2WcXmgyM
         23AQCbRB4Bcbzy+o8jSF0dmpjwfZOkdid+GSS+G7vDFrD8rcIr+HglMm/f3N9UrRzo
         cpS3stvMco2Eg==
Date:   Thu, 2 Feb 2023 19:20:38 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.4 00/17] Backport oops_limit to 5.4
Message-ID: <Y9wNBjIPg93EqCdI@gmail.com>
References: <20230202044255.128815-1-ebiggers@kernel.org>
 <Y9vwBL2+NWtwMnA4@sashalap>
 <Y9v3G6UantaCo29G@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9v3G6UantaCo29G@sashalap>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 02, 2023 at 12:47:07PM -0500, Sasha Levin wrote:
> On Thu, Feb 02, 2023 at 12:16:52PM -0500, Sasha Levin wrote:
> > On Wed, Feb 01, 2023 at 08:42:38PM -0800, Eric Biggers wrote:
> > > This series backports the patchset
> > > "exit: Put an upper limit on how often we can oops"
> > > (https://lore.kernel.org/linux-mm/20221117233838.give.484-kees@kernel.org/T/#u)
> > > to 5.4, as recommended at
> > > https://googleprojectzero.blogspot.com/2023/01/exploiting-null-dereferences-in-linux.html
> > > This follows the backports to 5.10 and 5.15 which already released.
> > > 
> > > This required backporting various prerequisite patches.
> > > 
> > > I've tested that oops_limit and warn_limit work correctly on x86_64.
> > 
> > Queued up all 3 backports, thanks!
> 
> ... and proceeded to drop the 4.19 and 4.14 backports which fail to
> build:
> 
> mm/kasan/report.c: In function 'kasan_end_report':
> mm/kasan/report.c:175:16: error: 'KASAN_BIT_MULTI_SHOT' undeclared (first use in this function)
>   175 |  if (!test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))

Thanks, I'll fix that.  I had grepped for KASAN_BIT_MULTI_SHOT to make sure
those branches had it, but I didn't notice it was defined later in the file :-(

- Eric
