Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253526E7671
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbjDSJhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbjDSJgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:36:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27FD30EA
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 02:36:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E7EA63D0C
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 09:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73189C4339C;
        Wed, 19 Apr 2023 09:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681897006;
        bh=EvxYfdAaf82Jp7S5pqvrmPLb+c2V1A7/mIDfHv6xcw4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dBx8srcZFt1j/7v7kR/7quLyhd5l7qojg8w5G6kmDLNHwzeTylMfW5vDa8l4IguWC
         qp3ygnJ6eky/CH68nBU1z9tIhgjusCMACQbY52bj5OFGhfE00v1XK9fXjcxgB6F8wp
         lMogBTgaZsl3aHEBaHadYFBaPqfJe9D+Rt/UyAqQ=
Date:   Wed, 19 Apr 2023 11:36:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 129/134] riscv: Move early dtb mapping into the
 fixmap region
Message-ID: <2023041918-stammer-subgroup-fbd1@gregkh>
References: <20230418120313.001025904@linuxfoundation.org>
 <20230418120317.673170852@linuxfoundation.org>
 <20230418-tactile-cocoa-4242e87bf994@wendy>
 <2023041948-overthrow-debtor-289d@gregkh>
 <20230419-uninstall-fragile-51c326b1adbc@wendy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419-uninstall-fragile-51c326b1adbc@wendy>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 19, 2023 at 08:55:34AM +0100, Conor Dooley wrote:
> On Wed, Apr 19, 2023 at 09:27:04AM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Apr 18, 2023 at 02:10:54PM +0100, Conor Dooley wrote:
> > > On Tue, Apr 18, 2023 at 02:23:05PM +0200, Greg Kroah-Hartman wrote:
> > > > From: Alexandre Ghiti <alexghiti@rivosinc.com>
> > > > 
> > > > [ Upstream commit ef69d2559fe91f23d27a3d6fd640b5641787d22e ]
> > > 
> > > Hey Greg,
> > > 
> > > Please check out <e3a6656c-0ec4-9d54-b262-1af08c292ed5@microchip.com>
> > > (I can't find a lore link for stable-commit@vger stuff)
> > > as I am not sure whether it is okay to backport this in isolation.
> > 
> > I'm confused, what is needed to be done here?
> 
> Originally I got an email saying that some patches had failed to apply:
> FAILED: patch "[PATCH] riscv: Move early dtb mapping into the fixmap region" failed to apply to 5.15-stable tree
> <2023041706-esophagus-evacuate-b5a7@gregkh>
> FAILED: patch "[PATCH] riscv: Move early dtb mapping into the fixmap region" failed to apply to 6.1-stable tree
> <2023041708-sinless-rectangle-f480@gregkh>
> 
> I replied to:
> Patch "riscv: No need to relocate the dtb as it lies in the fixmap region" has been added to the 5.15-stable tree
> <2023041741-dirtiness-canon-8104@gregkh>
> Where I said that without the failed patches, the above should not be
> applied to 5.15.y or 6.1y. You said you would drop it from all stable
> trees.
> 
> However, this patch ("riscv: Move early dtb mapping into the fixmap
> region") did end up getting applied to 6.1.y and 6.2.y, despite what the
> email I got said for 6.1.y!

That's because Sasha backported the dependent patches to get it to
apply.

> I don't think that either of the patches can be backported in isolation,
> so either:
> 
> a) drop ("riscv: Move early dtb mapping into the fixmap region") from all
>    stable trees & queue it up alongside (riscv: No need to relocate the
>    dtb as it lies in the fixmap region) for the next stable update
> 
> b) pick ("riscv: No need to relocate the dtb as it lies in the fixmap
>    region") up in such a way that it sits immediately after ("riscv: No
>    need to relocate the dtb as it lies in the fixmap region") in the
>    history
> 
> I am the original reporter of the issue and I have a workaround in place
> so personally the backport is not urgent (to me at least), so which
> option you go for doesn't matter to me.

Let me just drop all of them, that makes it simpler and then if anyone
wants them applied, then they can send us an explicit set of patches.

thanks,

greg k-h
