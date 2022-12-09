Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269AF64800F
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 10:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiLIJW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 04:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiLIJW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 04:22:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2839A63D5A;
        Fri,  9 Dec 2022 01:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B726C620EB;
        Fri,  9 Dec 2022 09:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4647C433EF;
        Fri,  9 Dec 2022 09:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670577746;
        bh=t9ntCFU2QC0atatzokbhDOOUldhhZsXcpUu4+cOPBQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oESKMB8oIMWLi07buDBSB9qYSDA5w3dWE96Iir0ilbl1cngYHsstQWSdX/9Y4ZG52
         djbNhTycUxHvmepSGgs3H1WJ5ZkT+Bt5gJXebAFw7hrTRTQMhAzZ/PszV845EDW9Pu
         6qG8k97diyXcH5Cad5dV2YBa8mD8R26UR3f0fx38=
Date:   Fri, 9 Dec 2022 10:22:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@gmail.com,
        Paul Moore <paul@paul-moore.com>, sds@tycho.nsa.gov,
        eparis@parisplace.org, sashal@kernel.org, selinux@vger.kernel.org,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [RFC] IMA LSM based rule race condition issue on 4.19 LTS
Message-ID: <Y5L+Tpym6XRrZSLB@kroah.com>
References: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
 <Y5Lf8SRgyrqDJwiH@kroah.com>
 <93d137dc-e0d3-3741-7e01-dca1ba9c0903@huawei.com>
 <Y5L10fjvxmU3klRu@kroah.com>
 <58219c48-840d-b4f3-b195-82b2a1465b37@huawei.com>
 <Y5L5RZlOOd9RMeWw@kroah.com>
 <d69f9bd3-de1f-aa32-7c6b-30d909f724d0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d69f9bd3-de1f-aa32-7c6b-30d909f724d0@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 09, 2022 at 05:11:40PM +0800, Guozihua (Scott) wrote:
> On 2022/12/9 17:00, Greg KH wrote:
> > On Fri, Dec 09, 2022 at 04:59:17PM +0800, Guozihua (Scott) wrote:
> >> On 2022/12/9 16:46, Greg KH wrote:
> >>> On Fri, Dec 09, 2022 at 03:53:25PM +0800, Guozihua (Scott) wrote:
> >>>> On 2022/12/9 15:12, Greg KH wrote:
> >>>>> On Fri, Dec 09, 2022 at 03:00:35PM +0800, Guozihua (Scott) wrote:
> >>>>>> Hi community.
> >>>>>>
> >>>>>> Previously our team reported a race condition in IMA relates to LSM based
> >>>>>> rules which would case IMA to match files that should be filtered out under
> >>>>>> normal condition. The issue was originally analyzed and fixed on mainstream.
> >>>>>> The patch and the discussion could be found here:
> >>>>>> https://lore.kernel.org/all/20220921125804.59490-1-guozihua@huawei.com/
> >>>>>>
> >>>>>> After that, we did a regression test on 4.19 LTS and the same issue arises.
> >>>>>> Further analysis reveled that the issue is from a completely different
> >>>>>> cause.
> >>>>>
> >>>>> What commit in the tree fixed this in newer kernels?  Why can't we just
> >>>>> backport that one to 4.19.y as well?
> >>>>>
> >>>>> thanks,
> >>>>>
> >>>>> greg k-h
> >>>>
> >>>> Hi Greg,
> >>>>
> >>>> The fix for mainline is now on linux-next, commit 	d57378d3aa4d ("ima:
> >>>> Simplify ima_lsm_copy_rule") and 	c7423dbdbc9ece ("ima: Handle -ESTALE
> >>>> returned by ima_filter_rule_match()"). However, these patches cannot be
> >>>> picked directly into 4.19.y due to code difference.
> >>>
> >>> Ok, so it's much more than just 4.19 that's an issue here.  And are
> >>> those commits tagged for stable inclusion?
> >>
> >> Not actually, not on the commit itself.
> > 
> > That's not good.  When they hit Linus's tree, please submit backports to
> > the stable mailing list so that they can be picked up.
> Thing is these commits cannot be simply backported to 4.19.y. Preceding
> patches are missing. How do we do backporting in this situation? Do we
> first backport the preceding patches? Or maybe we develop another
> solution for 4.19.y?

First they need to go to newer kernel trees, and then worry about 4.19.
We never want anyone to upgrade to a newer kernel and have a regression.

Also, we can't do anything until they hit Linus's tree, as per the
stable kernel rules.

thanks,

greg k-h
