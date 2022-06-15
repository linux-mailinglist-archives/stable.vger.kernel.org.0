Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A9054D3EC
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 23:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348291AbiFOVrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 17:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243995AbiFOVrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 17:47:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FB1B65;
        Wed, 15 Jun 2022 14:47:33 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 84B061FA34;
        Wed, 15 Jun 2022 21:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655329652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=89CXqCbcWeJccBkwcSVEPJeJy8Az1fwhDi+ncrVChzM=;
        b=eMBCn7CtVihAlZKW/qaEL8rmGKPgFBhlKRKGxs4NIPSpFsL9dhkzPaIDw8SZQLPDbbXdci
        bv/6g0IhypoyHQZdAPMnWxOCuynVc+Uz+infRzoCQzBVFN0XXuawZFxmAXa/dS6bqFeG82
        rE49ucZA8cF01Y2TyQbVFhwwZAPkc6g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655329652;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=89CXqCbcWeJccBkwcSVEPJeJy8Az1fwhDi+ncrVChzM=;
        b=+q38inbsR4Eov72uC2BveZ7yYSmEQCt3DoHYTiQl+Y6/+jFxhCEnLylOnTPP7zcPu1RTjZ
        nsbmLGdYH3dXQvAw==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 184D62C141;
        Wed, 15 Jun 2022 21:47:32 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 5C055A062E; Wed, 15 Jun 2022 23:47:26 +0200 (CEST)
Date:   Wed, 15 Jun 2022 23:47:26 +0200
From:   Jan Kara <jack@suse.cz>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Backlund <tmb@tmb.nu>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
Message-ID: <20220615214726.iklfsv676ked4z7u@quack3.lan>
References: <bd80cd0d-a364-4ebd-2a89-933f79eaf4c7@tmb.nu>
 <CAHk-=wix7+mGzS-hANyk7DZsZ1NgGMHjPzSQKggEomYrRCrP_Q@mail.gmail.com>
 <CAHk-=wgfFhwMP0=QQY_iZvf0kveR5=VGK919Ayn+ZSUADs9mag@mail.gmail.com>
 <20220615110022.yifrsvzxjsz2wky5@quack3.lan>
 <20220615133845.o2lzfe5s4dzdfvtg@quack3.lan>
 <20220615180026.GA2146974@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615180026.GA2146974@roeck-us.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 15-06-22 11:00:26, Guenter Roeck wrote:
> On Wed, Jun 15, 2022 at 03:38:45PM +0200, Jan Kara wrote:
> > On Wed 15-06-22 13:00:22, Jan Kara wrote:
> > > On Tue 14-06-22 12:00:22, Linus Torvalds wrote:
> > > > On Tue, Jun 14, 2022 at 11:51 AM Linus Torvalds
> > > > <torvalds@linux-foundation.org> wrote:
> > > > >
> > > > > Or just make sure that noop_backing_dev_info is fully initialized
> > > > > before it's used.
> > > > 
> > > > I don't see any real reason why that
> > > > 
> > > >     err = bdi_init(&noop_backing_dev_info);
> > > > 
> > > > couldn't just be done very early. Maybe as the first call in
> > > > driver_init(), before the whole devtmpfs_init() etc.
> > > 
> > > I've checked the dependencies and cgroups (which are the only non-trivial
> > > dependency besides per-CPU infrastructure) are initialized early enough so
> > > it should work fine. So let's try that.
> > 
> > Attached patch boots for me. Guys, who was able to reproduce the failure: Can
> > you please confirm this patch fixes your problem?
> > 
> 
> It does for me.

Thanks for confirmation! I'll send the patch with proper tags etc. and also
push it to Linus if nobody objects.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
