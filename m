Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9746472BE
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 16:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiLHPVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 10:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiLHPUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 10:20:54 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF74671243;
        Thu,  8 Dec 2022 07:20:11 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1112)
        id 7657B20B6C40; Thu,  8 Dec 2022 07:20:11 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7657B20B6C40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1670512811;
        bh=Q/kTXQ0Cy2jF/9ctAGUSG3KpRvJg6WX6zQtjcqoVlt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CjGkKGTcFFRj7T6RLwa3KZ6PyeqdS+urbWoxIk+/4ZPnj1//qiRG+Z6yVEJSsxH8v
         PaWUn28Fv4rqqIyAQvkuzNXyoa0hZkTsDpmWJyykC4Dkp+yH7Y5CIA7+ulMCLrJdUn
         y3YHn8w0BD/Dz6hfq4yIRMprk1SV05OtwFWTXKjM=
Date:   Thu, 8 Dec 2022 07:20:11 -0800
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        Thilo Fromm <t-lo@linux.microsoft.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH] ext4: Fix deadlock due to mbcache entry corruption
Message-ID: <20221208152011.GA12315@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221123193950.16758-1-jack@suse.cz>
 <20221201151021.GA18380@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <9c414060-989d-55bb-9a7b-0f33bf103c4f@leemhuis.info>
 <Y5F8ayz4gEtKn0LF@mit.edu>
 <20221208091523.t6ka6tqtclcxnsrp@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208091523.t6ka6tqtclcxnsrp@quack3>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 08, 2022 at 10:15:23AM +0100, Jan Kara wrote:
> Hi Ted!
> 
> On Thu 08-12-22 00:55:55, Theodore Ts'o wrote:
> > One thing which is completely unclear to me is how this relates to the
> > claimed regression.  I understand that Jeremi and Thilo have asserted
> > that the hang goes away if a backport commit 51ae846cff5 ("ext4: fix
> > warning in ext4_iomap_begin as race between bmap and write") is not in
> > their 5.15 product tree.
> 
> IMHO the bisection was flawed and somehow the test of a revert (which guys
> claimed to have done) must have been lucky and didn't trip the race. This
> is not that hard to imagine because firstly, the commit 51ae846cff5 got
> included in the same stable kernel release as ext4 xattr changes
> (65f8b80053 ("ext4: fix race when reusing xattr blocks") and related
> mbcache changes) which likely made the race more likely. Secondly, the
> mbcache state corruption is not that easy to hit because you need an
> interaction of slab reclaim on mbcache entry with ext4 xattr code adding
> reference to xattr block and just hitting the reference limit.
> 

Yeah, sorry about that, there was never a bisect that led to 51ae846cff5, it
was just a guess and at that point we were unable to reproduce it ourselves so
we just had information from a user stating that when they revert that commit
in their own test build the issue doesn't occur.

Once we were able to personally reproduce the actual bisect led to 65f8b80053,
which as Honza stated made sure that the corruption/inconsistency leads to a
busy loop which is harder to miss.

> > However, the stack traces point to a problem in the extended attribute
> > code, which has nothing to do with ext4_bmap(), and commit 51ae846cff5
> > only changes the ext4's bmap function --- which these days gets used
> > for the FIBMAP ioctl and very little else.
> > 
> > Furthermore, the fix which Jan provided, and which apparently fixes
> > the user's problem, (a) doesn't touch the ext4_bmap function, and (b)
> > has a fixes tag for the patch:
> > 
> >     Fixes: 6048c64b2609 ("mbcache: add reusable flag to cache entries")
> > 
> > ... which is a commit which dates back to 2016, and the v4.6 kernel.  ?!?
> 
> Yes. AFAICT the bitfield race in mbcache was introduced in this commit but
> somehow ext4 was using mbcache in a way that wasn't tripping the race.
> After 65f8b80053 ("ext4: fix race when reusing xattr blocks"), the race
> became much more likely and users started to notice...
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
