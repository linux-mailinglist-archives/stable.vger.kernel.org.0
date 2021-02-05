Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB80310FAC
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 19:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBEQa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 11:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbhBEQMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 11:12:49 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C785C0613D6;
        Fri,  5 Feb 2021 09:54:31 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id F3B1A1280710;
        Fri,  5 Feb 2021 09:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612547671;
        bh=PE2KsD5qLssJPf2TOCMDQXfom48gfBf0PZCJ8+JzFRI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=wF8YwJT/b7g2SVeBvvLJKFESDGEizeKVxIAIxmHBnIT0QFk4QS9fny6G51iG6LSSw
         7zt+d8VZltbAq49nitSKEoNscSgqJYRHg5v8/LWRcIfLITMAyezfceRTkcoxiKkiOS
         hFnNqxO+1g7HXqrFOWeQkG9AU2TFglCMfUKWG2WE=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WWDtKxxITTrK; Fri,  5 Feb 2021 09:54:30 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 5A9F312806FA;
        Fri,  5 Feb 2021 09:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612547670;
        bh=PE2KsD5qLssJPf2TOCMDQXfom48gfBf0PZCJ8+JzFRI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=uPHJZTPKFy1jq3i18W1/GpQwkxEDJ0ACwi2RbhJpptBO25WnDNxX2wj9Q22E/6jg8
         Am85OBURiNgmgQV9lpPQOgVYw803pGqO8cp8122hNdAA2gN7VW6KMf1lNFb5kO6RMB
         LEqbKkpuEz1Kn/HcLr1gxk6IgZ8vgftAbDNGfFQE=
Message-ID: <89892a6152826e89276126fd2688b7c767484f41.camel@HansenPartnership.com>
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
Date:   Fri, 05 Feb 2021 09:54:29 -0800
In-Reply-To: <20210205172528.GP4718@ziepe.ca>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
         <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
         <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
         <YByrCnswkIlz1w1t@kernel.org>
         <ee4adfbb99273e1bdceca210bc1fa5f16a50c415.camel@HansenPartnership.com>
         <20210205172528.GP4718@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-02-05 at 13:25 -0400, Jason Gunthorpe wrote:
> On Fri, Feb 05, 2021 at 08:48:11AM -0800, James Bottomley wrote:
> > > Thanks for pointing this out. I'd strongly support Jason's
> > > proposal:
> > > 
> > > https://lore.kernel.org/linux-integrity/20201215175624.GG5487@ziepe.ca/
> > > 
> > > It's the best long-term way to fix this.
> > 
> > Really, no it's not.  It introduces extra mechanism we don't need.
> > To recap the issue: character devices already have an automatic
> > mechanism which holds a reference to the struct device while the
> > character node is open so the default is to release resources on
> > final
> > put of the struct device.
> 
> The refcount on the struct device only keeps the memory alive, it
> doesn't say anything about the ops. We still need to lock and check
> the ops each and every time they are used.

I think this is the crux of our disagreement: I think the ops doesn't
matter because to call try_get_ops you have to have a chip structure
and the only way you get a chip structure is if you hold a device
containing it, in which case the device hold guarantees the chip can't
be freed.  Or if you pass in TPM_ANY_NUM to an operation which calls 
tpm_chip_find_get() which iterates the idr to find a chip under the idr
lock.  If you find a chip device at the idr, you're guaranteed it
exists, because elimination of it is the first thing the release does
and if you find a dying dev (i.e. the release routine blocks on the idr
mutex trying to kill the chip attachment), try_get_ops() fails because
the ops are already NULL.

In either case, I think you get returned a device to which you hold a
reference.  Is there any other case where you can get a chip without
also getting a device reference?

I'll answer the other point in a separate email, but I think the
principle sounds OK: we could do the final put right after we del the
char devices because that's called in the module release routine and
thus not have to rely on the devm actions which, as you say, are an
annoying complication.

James


