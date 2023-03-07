Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF436AF7E6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 22:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjCGVpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 16:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbjCGVpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 16:45:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C6FA18B7;
        Tue,  7 Mar 2023 13:45:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B2D9B81A1D;
        Tue,  7 Mar 2023 21:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DCEC4339B;
        Tue,  7 Mar 2023 21:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678225526;
        bh=HH8mJ1XwzzJVj0SV4GpOAl0LULKJW0qe4QV7EO1mXAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qYOPwrerPTTlhpHpsXrpuQ80dZPP680H+k/302Jkk0wa3w1dlwnEvfDjKnxwK/8xC
         PUxteEzrXOI1vGaaLn1xx2LHEGexfd/i1JCh1LttzLAs7uoTuzfamUAE6ckTg17uxf
         cRXjz0h7+aYLBtf5OB0z4P0UnH/d68v9TnbLSIrhYi2vEoTZG48t+GEVG4GX7YPDyL
         WoyzDUIyGFrD5eGv9fibkdC2v/yd7X4Wi3DmBURR1dtiwlRgcNf+BzMWxiszepOIkK
         CF0EoXOrWNMkwSpplgA/tMDyImZumOEpRPCQrDIWmNVF2w3x9SwJejLWsEER2RpoYu
         CZNFnMeRfvvkQ==
Date:   Tue, 7 Mar 2023 21:45:24 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAewdAql4PBUYOG5@gmail.com>
References: <20230226034256.771769-1-sashal@kernel.org>
 <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZATC3djtr9/uPX+P@duo.ucw.cz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 10:18:35PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > So to summarize, that buggy commit was backported even though:
> > > 
> > >   * There were no indications that it was a bug fix (and thus potentially
> > >     suitable for stable) in the first place.
> > >   * On the AUTOSEL thread, someone told you the commit is broken.
> > >   * There was already a thread that reported a regression caused by the commit.
> > >     Easily findable via lore search.
> > >   * There was also already a pending patch that Fixes the commit.  Again easily
> > >     findable via lore search.
> > > 
> > > So it seems a *lot* of things went wrong, no?  Why?  If so many things can go
> > > wrong, it's not just a "mistake" but rather the process is the problem...
> > 
> > BTW, another cause of this is that the commit (66f99628eb24) was AUTOSEL'd after
> > only being in mainline for 4 days, and *released* in all LTS kernels after only
> > being in mainline for 12 days.  Surely that's a timeline befitting a critical
> > security vulnerability, not some random neural-network-selected commit that
> > wasn't even fixing anything?
> 
> I see this problem, too, "-stable" is more experimental than Linus's
> releases.
> 
> I believe that -stable would be more useful without AUTOSEL process.
> 

There has to be a way to ensure that security fixes that weren't properly tagged
make it to stable anyway.  So, AUTOSEL is necessary, at least in some form.  I
think that debating *whether it should exist* is a distraction from what's
actually important, which is that the current AUTOSEL process has some specific
problems, and these specific problems need to be fixed...

- Eric
