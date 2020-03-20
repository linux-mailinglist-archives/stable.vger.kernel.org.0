Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE2318CACC
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 10:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgCTJui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 05:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgCTJui (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 05:50:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4846220722;
        Fri, 20 Mar 2020 09:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584697837;
        bh=6Hi/GoUNHTpjmABiklHfFMHrjL7QULq5N/nrNhRxqDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rPq2NraNaXake/on6rKCRP8HBkYDMhZrm97KjuSDKQ9y5hbAbGVhxWHufzapJyjrt
         TXQ5R6YM5MIGRXAZKJ0N9Ywa0DFud1oqrKXyQJcWCMXo34uqH9UTx1d1HL2pl2DCuT
         9Y6T4inoI9iCCjU99P6Z3mU+IZb87FMDC5lp6+Sc=
Date:   Fri, 20 Mar 2020 10:50:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        "# 4.0+" <stable@vger.kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: FAILED: patch "[PATCH] mmc: core: Allow host controllers to
 require R1B for CMD6" failed to apply to 5.5-stable tree
Message-ID: <20200320095035.GC421650@kroah.com>
References: <158435827821152@kroah.com>
 <20200318192528.GH4189@sasha-vm>
 <CAPDyKFp2zX5Zij4bCRuOrxBzgpyH9n2Ee3rNBVkm46n8R5DfNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFp2zX5Zij4bCRuOrxBzgpyH9n2Ee3rNBVkm46n8R5DfNA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 20, 2020 at 10:12:15AM +0100, Ulf Hansson wrote:
> + Naresh
> 
> On Wed, 18 Mar 2020 at 20:25, Sasha Levin <sashal@kernel.org> wrote:
> >
> > On Mon, Mar 16, 2020 at 12:31:18PM +0100, gregkh@linuxfoundation.org wrote:
> > >
> > >The patch below does not apply to the 5.5-stable tree.
> > >If someone wants it applied there, or to any other stable or longterm
> > >tree, then please email the backport, including the original git commit
> > >id to <stable@vger.kernel.org>.
> > >
> > >thanks,
> > >
> > >greg k-h
> > >
> > >------------------ original commit in Linus's tree ------------------
> > >
> > >From 1292e3efb149ee21d8d33d725eeed4e6b1ade963 Mon Sep 17 00:00:00 2001
> > >From: Ulf Hansson <ulf.hansson@linaro.org>
> > >Date: Tue, 10 Mar 2020 12:49:43 +0100
> > >Subject: [PATCH] mmc: core: Allow host controllers to require R1B for CMD6
> > >
> > >It has turned out that some host controllers can't use R1B for CMD6 and
> > >other commands that have R1B associated with them. Therefore invent a new
> > >host cap, MMC_CAP_NEED_RSP_BUSY to let them specify this.
> > >
> > >In __mmc_switch(), let's check the flag and use it to prevent R1B responses
> > >from being converted into R1. Note that, this also means that the host are
> > >on its own, when it comes to manage the busy timeout.
> > >
> > >Suggested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
> > >Cc: <stable@vger.kernel.org>
> > >Tested-by: Anders Roxell <anders.roxell@linaro.org>
> > >Tested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
> > >Tested-by: Faiz Abbas <faiz_abbas@ti.com>
> > >Tested-By: Peter Geis <pgwipeout@gmail.com>
> > >Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> >
> > I've fixed up and queued this whole mmc series of stable tagged patches
> > for 4.19-5.5.
> 
> I looked at stable-rc tree and realized that you have also picked the
> following patch:
> 
> commit 533a6cfe08f96a7b5c65e06d20916d552c11b256
> Author: Ulf Hansson <ulf.hansson@linaro.org>
> Date:   Wed Jan 22 15:27:47 2020 +0100
> mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()
> 
> I assume this one was needed to apply the others mmc patches on top.
> This is a problem, because the above patch should not go for stable as
> it causes problems (unless additional patches are backported as well).
> 
> I suggest to drop the whole slew of mmc patches for the current stable
> rcs. Then I can send manual backports instead, is that okay?

Yes, I have now done that, having a properly backported set of patches
would be great, thanks!

greg k-h
