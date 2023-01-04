Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039FB65D2A9
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbjADM3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238920AbjADM3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:29:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C891B1C8;
        Wed,  4 Jan 2023 04:29:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DA9AACE179B;
        Wed,  4 Jan 2023 12:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4869C433D2;
        Wed,  4 Jan 2023 12:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672835374;
        bh=OPeChS4dtPhC7Q4DXYyE+Te51mZimBdFt9SJbtY/Qco=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YKmbRPvj1qRd9vAJzshIia9hmCBjJJ0Of1v7wV9Pf9kWn8jJbOUc5qs+VK4bFSwnn
         MNKVm1lunomA/efEzUV6uEiuvP2oaEdY+mWYbm7MmmWeKomXrKoAbIxP6jQ55JqVgj
         rnKCW4HtLP8FiiJ24zgEuXqtRNl5J+EdcRfK0Ocw=
Date:   Wed, 4 Jan 2023 13:29:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     stable@vger.kernel.org,
        linux-integrity <linux-integrity@vger.kernel.org>,
        "Guozihua (Scott)" <guozihua@huawei.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>
Subject: Re: Stable backport request
Message-ID: <Y7VxJr3EORKWxhrE@kroah.com>
References: <c946a51ca8b059d1526af1078473e62c58edc357.camel@linux.ibm.com>
 <Y6NPAr7mFTZ9hhCZ@kroah.com>
 <8cff4354dcd583d92da19aa2c52999f70b3decca.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cff4354dcd583d92da19aa2c52999f70b3decca.camel@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 01:52:09PM -0500, Mimi Zohar wrote:
> Hi Greg,
> 
> On Wed, 2022-12-21 at 19:22 +0100, Greg KH wrote:
> > On Wed, Dec 21, 2022 at 09:50:09AM -0500, Mimi Zohar wrote:
> > > Stable team,
> > > 
> > > Please backport these upstream commits to stable kernels:
> > > - c7423dbdbc9e ("ima: Handle -ESTALE returned by
> > > ima_filter_rule_match()"
> > > 
> > > Dependency on:
> > > - d57378d3aa4d ("ima: Simplify ima_lsm_copy_rule")
> > > 
> > > Known minor merge conflicts:
> > > - Commit: 65603435599f ("ima: Fix trivial typos in the comments") fixed
> > > "refrences" spelling, causes a merge conflict.
> > > - Commit 28073eb09c5a ("ima: Fix fall-through warnings for Clang") adds
> > > a "break;" before "default:", causes a merge conflict.
> 
> Up to linux-5.9.y, there are two merge conflicts - a spelling error and
> a missing "break" before "default:", which are the result of the above
> commits.  Otherwise the two commits apply cleanly:
>  - d57378d3aa4d ("ima: Simplify ima_lsm_copy_rule")
>  - c7423dbdbc9e ("ima: Handle -ESTALE returned by
> ima_filter_rule_match()"

Again, this isn't going to work, I need backported commits that have
been tested and verified to work please.

> 
> > > Simplifies backporting to linux-5.4.y:
> > > - 465aee77aae8 ("ima: Free the entire rule when deleting a list of
> > > rules")
> > >   except for the line "kfree(entry->keyrings);" - introduced in 5.6.y.
> > > - 39e5993d0d45 ("ima: Shallow copy the args_p member of
> > > ima_rule_entry.lsm elements")
> > > - b8867eedcf76 ("ima: Rename internal filter rule functions")
> > > - f60c826d0318 ("ima: Use kmemdup rather than kmalloc+memcpy")
> > 
> > I'm sorry, but I'm confused.
> > 
> > What exact commits are needed in what order for which stable trees?
> 
> The above 4 commits are needed, in the order listed, for linux-5.4.y
> before applying these two commits:
>  - d57378d3aa4d ("ima: Simplify ima_lsm_copy_rule")
>  - c7423dbdbc9e ("ima: Handle -ESTALE returned by
> ima_filter_rule_match()"
> 
> > > A patch for kernels prior to commit b16942455193 ("ima: use the lsm
> > > policy update notifier") will be posted separately.
> > 
> > But that commit has been backported to 4.19.y and newer stable trees,
> > right?
> 
> No, b16942455193 ("ima: use the lsm policy update notifier") was
> upstreamed in linux-5.3.y and has not been backported to linux-4.19.y. 
> We're still determining for linux-4.19.y the best way to address the
> bug that commit c7423dbdbc9e ("ima: Handle -ESTALE returned by
> ima_filter_rule_match()") addresses.

It would be easiest if you just send a series of backported commits that
you have tested, otherwise I will get the above instructions wrong :)

thanks,

greg k-h
