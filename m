Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BAA68914F
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 08:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjBCHyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 02:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjBCHyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 02:54:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8968FB78;
        Thu,  2 Feb 2023 23:54:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7D4A2CE2F20;
        Fri,  3 Feb 2023 07:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411D2C433EF;
        Fri,  3 Feb 2023 07:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675410873;
        bh=8kVrWXLI+f7Str8SPSIc0PrDCs0ohsA9tquxZFBxMX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YWDwJeLPao5EKokVf8fBrw17EPGLCzVQJ14QszbkapqpGOtwzVE4Ooxe2VhXRQPku
         ug5pmtK/Bk+9PbfkQK4DG/bWQ+F69r3eE868qi3SZJbgaigo5NqkVKS2/tJqvY6Ojg
         5NG8jMgQkAbq9dquWflKAg7THqxVo8VUcy875f+Y=
Date:   Fri, 3 Feb 2023 08:54:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.ibm.com,
        paul@paul-moore.com, luhuaxin1@huawei.com
Subject: Re: [PATCH 4.19 0/3] Backport handling -ESTALE policy update failure
 to 4.19
Message-ID: <Y9y9tiHoOCkSutJT@kroah.com>
References: <20230201023952.30247-1-guozihua@huawei.com>
 <Y9vw6RhQ6KJ5+E1I@sashalap>
 <02723ce8-0ad4-7860-b76c-7d2b30710dcf@huawei.com>
 <Y9y7c5sEX5phLybE@kroah.com>
 <Y9y8cYNR6TnAjnHS@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9y8cYNR6TnAjnHS@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 08:49:05AM +0100, Greg KH wrote:
> On Fri, Feb 03, 2023 at 08:44:51AM +0100, Greg KH wrote:
> > On Fri, Feb 03, 2023 at 09:10:13AM +0800, Guozihua (Scott) wrote:
> > > On 2023/2/3 1:20, Sasha Levin wrote:
> > > > On Wed, Feb 01, 2023 at 10:39:49AM +0800, GUO Zihua wrote:
> > > >> This series backports patches in order to resolve the issue discussed
> > > >> here:
> > > >> https://lore.kernel.org/selinux/389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com/
> > > >>
> > > >> This required backporting the non-blocking LSM policy update mechanism
> > > >> prerequisite patches.
> > > > 
> > > > Do we not need this on newer kernels? Why only 4.19?
> > > > 
> > > Hi Sasha.
> > > 
> > > The issue mentioned in this patch was fixed already in the newer kernel.
> > > All three patches here are backports from mainline.
> > 
> > Ok, now queued up, thanks.
> 
> Nope, I've now dropped them all as you did not include the needed fix up
> commits as well.  We can not add patches to the stable tree that are
> known broken, right?
> 
> How well did you test this?  I see at least 3 missing patches that you
> should have had in this patch series for it to work properly.

Ah, you didn't even test this series, as it breaks the build
as-submitted.

{sigh}

In order for us to take this, I think you need to find someone else who
will validate your patch series _FIRST_ before submitting it to us.  And
I want their tested-by on them validating that it did actually work (if
for no other reason than to have someone else be willing to be
responsible if things go bad.)

Breaking our builds and forcing me to point out missing patches is not
how the stable kernel process works in any sane manner.

greg k-h
