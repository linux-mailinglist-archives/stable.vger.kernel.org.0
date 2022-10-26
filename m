Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F52660DF04
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 12:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbiJZKuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 06:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJZKuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 06:50:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27255252B8
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 03:50:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59C1661E05
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 10:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F93C433C1;
        Wed, 26 Oct 2022 10:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666781405;
        bh=boEsi/InFJxTy/pvk2Wx3Sg5dSCvTStHGPubud3/XZ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E73gpQqoj2SSQ8SlybIg4TAqhPtJrfUKkInUvbQTdh1srRaGsu/kjcrt2eThGY0F/
         mXAeSAuf/j1LFvdJtMFlMjk6IAJNFfg0zprcchkbzWyXM9jmy1I/2s3RaSnbhAkztM
         aBDy0oBZAWI+KjxC4irldbB6YHV1ZY+uOzuWtlro=
Date:   Wed, 26 Oct 2022 12:50:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Tomasz =?utf-8?Q?Mo=C5=84?= <tomasz.mon@camlingroup.com>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        Han Xu <han.xu@nxp.com>, kernel <kernel@pengutronix.de>,
        stable <stable@vger.kernel.org>,
        k drobinski <k.drobinski@camlintechnologies.com>
Subject: Re: [PATCH] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
 program/erase times
Message-ID: <Y1kQ2/u1YLSGEmLK@kroah.com>
References: <c2d545d1f5478e66c0dac47f4bc4c04256ff44aa.camel@camlingroup.com>
 <fd830c7e94de6b4a0b532dfcf46cf1edd22b42fb.camel@camlingroup.com>
 <YtD/9KJZwlVj+6hS@kroah.com>
 <20220715074631.GA7333@pengutronix.de>
 <YtEdIujszEKSprbF@kroah.com>
 <770744970.283550.1657871950910.JavaMail.zimbra@nod.at>
 <20220902090252.75285234@xps-13>
 <CAJ+vNU0r3Enkwn+WzvEJYc_O4NurRyCssx2S-_ZS_cYCpk2-cA@mail.gmail.com>
 <20221024100114.627f87bd@xps-13>
 <CAJ+vNU2R=FVSpRVWh8RBJ7XZmRRjkqHce1WTGXDKrjeHRbuzSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+vNU2R=FVSpRVWh8RBJ7XZmRRjkqHce1WTGXDKrjeHRbuzSw@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 03:02:27PM -0700, Tim Harvey wrote:
> On Mon, Oct 24, 2022 at 1:01 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Tim,
> >
> > tharvey@gateworks.com wrote on Fri, 21 Oct 2022 14:55:15 -0700:
> >
> > > On Fri, Sep 2, 2022 at 12:03 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > Hey folks,
> > > >
> > > > richard@nod.at wrote on Fri, 15 Jul 2022 09:59:10 +0200 (CEST):
> > > >
> > > > > ----- Ursprüngliche Mail -----
> > > > > >> My IRC history doesn't go back far enough, but if I recall correctly
> > > > > >> Miquel is on vacation, he would have picked up this patch for linux-next
> > > > > >> otherwise.
> > > > >
> > > > > Exactly.
> > > >
> > > > Indeed, I was off for an extended period of time, I'm (very) slowly
> > > > catching up now.
> > > >
> > > > >
> > > > > > Ok, let me do a round of stable releases so that people don't get hit by
> > > > > > this now...
> > > > >
> > > > > Thanks a lot for doing so.
> > > > >
> > > > > > Hopefully this gets fixed up by 5.19-final.
> > > > >
> > > > > Sure, I'll pickup this patch.
> > > >
> > > > Thanks Greg & Richard for the handling of this issue.
> > > >
> > > > Cheers,
> > > > Miquèl
> > > >
> > >
> > > Hello All,
> > >
> > > As Tomasz stated previously 06781a5026350 was merged in v5.19-rc4 and
> > > then was picked up by several stable kernels. While this made it into
> > > the 5.15 and 5.18 stable branches it did not make it into the
> > > following which are thus the are currently broken:
> > > 5.10.y
> > > 5.17.y
> > >
> > > How do we get this patch applied to those stable branches as well to
> > > resolve this?
> >
> > It is likely that the original patch (targeting a mainline kernel) did
> > not apply to those branches. In this case you can adapt the fix to the
> > concerned kernels and send it to stable@ (following the Documentation
> > guidelines for backports).
> >
> > Thanks,
> > Miquèl
> 
> Miquèl,
> 
> Thanks for the pointer. You are correct that this patch which resolves
> the regression does not apply directly to 5.4/5.10/5.17 stable trees.
> I'm looking over
> https://www.kernel.org/doc/html/v4.10/process/stable-kernel-rules.html
> and I'm not clear what I need to put in the commit to make it clear
> that it only applies to those specific trees. Do I simply adjust the
> 'Fixes' tag to address the commit from that specific stable branch and
> send one for each stable branch (thus each would have a different sha
> in the Fixes tag) while also adding the 'commit <sha> upstream' to the
> top?

Please send multiple patches and say below the --- line which stable
tree it should be applied to.

Note that 5.17 is long end-of-life, always check the front page of
kernel.org for the active kernel versions.

thanks,

greg k-h
