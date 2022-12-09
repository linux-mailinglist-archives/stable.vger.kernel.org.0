Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62ED86480F3
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 11:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiLIK1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 05:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiLIK12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 05:27:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B9D6B996;
        Fri,  9 Dec 2022 02:27:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4A97621F8;
        Fri,  9 Dec 2022 10:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36DAC433EF;
        Fri,  9 Dec 2022 10:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670581646;
        bh=Vg/jY9jXOQpKUYcFCDt33qBBzBN62AJVK6EstpsyWhA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GQGrmX1vI7TVUCo7Jt2fONuyjVf4WbekcRa5FZpsSLfT7l6b90PU5P5C1/SmawZcm
         Yto4TJA/eFeDAtJ+x4Kbn8zRMR61esofMf9eP2Qr7iv9c1wpU1aUbDyRZsQ1dx51O+
         9DaUKFKy+Vbx5vU2QOEWt0dGCYzhWbvlIfIK2NMY=
Date:   Fri, 9 Dec 2022 11:27:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@gmail.com,
        Paul Moore <paul@paul-moore.com>, sds@tycho.nsa.gov,
        eparis@parisplace.org, sashal@kernel.org, selinux@vger.kernel.org,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [RFC] IMA LSM based rule race condition issue on 4.19 LTS
Message-ID: <Y5MNi85uzgXIMxX2@kroah.com>
References: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
 <Y5Lf8SRgyrqDJwiH@kroah.com>
 <93d137dc-e0d3-3741-7e01-dca1ba9c0903@huawei.com>
 <Y5L10fjvxmU3klRu@kroah.com>
 <58219c48-840d-b4f3-b195-82b2a1465b37@huawei.com>
 <Y5L5RZlOOd9RMeWw@kroah.com>
 <d69f9bd3-de1f-aa32-7c6b-30d909f724d0@huawei.com>
 <Y5L+Tpym6XRrZSLB@kroah.com>
 <8e409a81-dc00-f022-08fe-c1c26e9cf5e8@huawei.com>
 <415d44a2-33a1-c100-1ffc-ad6f1409afd8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <415d44a2-33a1-c100-1ffc-ad6f1409afd8@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 09, 2022 at 05:38:00PM +0800, Guozihua (Scott) wrote:
> On 2022/12/9 17:32, Guozihua (Scott) wrote:
> > On 2022/12/9 17:22, Greg KH wrote:
> >> On Fri, Dec 09, 2022 at 05:11:40PM +0800, Guozihua (Scott) wrote:
> >>> On 2022/12/9 17:00, Greg KH wrote:
> >>>> On Fri, Dec 09, 2022 at 04:59:17PM +0800, Guozihua (Scott) wrote:
> >>>>> On 2022/12/9 16:46, Greg KH wrote:
> >>>>>> On Fri, Dec 09, 2022 at 03:53:25PM +0800, Guozihua (Scott) wrote:
> >>>>>>> On 2022/12/9 15:12, Greg KH wrote:
> >>>>>>>> On Fri, Dec 09, 2022 at 03:00:35PM +0800, Guozihua (Scott) wrote:
> >>>>>>>>> Hi community.
> >>>>>>>>>
> >>>>>>>>> Previously our team reported a race condition in IMA relates to LSM based
> >>>>>>>>> rules which would case IMA to match files that should be filtered out under
> >>>>>>>>> normal condition. The issue was originally analyzed and fixed on mainstream.
> >>>>>>>>> The patch and the discussion could be found here:
> >>>>>>>>> https://lore.kernel.org/all/20220921125804.59490-1-guozihua@huawei.com/
> >>>>>>>>>
> >>>>>>>>> After that, we did a regression test on 4.19 LTS and the same issue arises.
> >>>>>>>>> Further analysis reveled that the issue is from a completely different
> >>>>>>>>> cause.
> >>>>>>>>
> >>>>>>>> What commit in the tree fixed this in newer kernels?  Why can't we just
> >>>>>>>> backport that one to 4.19.y as well?
> >>>>>>>>
> >>>>>>>> thanks,
> >>>>>>>>
> >>>>>>>> greg k-h
> >>>>>>>
> >>>>>>> Hi Greg,
> >>>>>>>
> >>>>>>> The fix for mainline is now on linux-next, commit 	d57378d3aa4d ("ima:
> >>>>>>> Simplify ima_lsm_copy_rule") and 	c7423dbdbc9ece ("ima: Handle -ESTALE
> >>>>>>> returned by ima_filter_rule_match()"). However, these patches cannot be
> >>>>>>> picked directly into 4.19.y due to code difference.
> >>>>>>
> >>>>>> Ok, so it's much more than just 4.19 that's an issue here.  And are
> >>>>>> those commits tagged for stable inclusion?
> >>>>>
> >>>>> Not actually, not on the commit itself.
> >>>>
> >>>> That's not good.  When they hit Linus's tree, please submit backports to
> >>>> the stable mailing list so that they can be picked up.
> >>> Thing is these commits cannot be simply backported to 4.19.y. Preceding
> >>> patches are missing. How do we do backporting in this situation? Do we
> >>> first backport the preceding patches? Or maybe we develop another
> >>> solution for 4.19.y?
> >>
> >> First they need to go to newer kernel trees, and then worry about 4.19.
> >> We never want anyone to upgrade to a newer kernel and have a regression.
> >>
> >> Also, we can't do anything until they hit Linus's tree, as per the
> >> stable kernel rules.
> > Alright. We'll wait for these patches to be in Linus' tree. But should
> > we stick to a backport from mainstream or we form a different solution
> > for LTS?

We always want to have a normal backport of what is in Linus's tree if
at all possible.  Whenever we diverge from that, we almost always get it
wrong and have to fix it up again later.

> BTW, I have a look into it and if we are backporting mainstream's
> solution, we would also needs to backport b16942455193 ("ima: use the
> lsm policy update notifier")

That's fine, please just send a patch series to the stable list when
needed.

thanks,

greg k-h
