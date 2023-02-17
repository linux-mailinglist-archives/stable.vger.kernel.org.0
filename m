Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD6169B592
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 23:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjBQWfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 17:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBQWfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 17:35:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2752D75;
        Fri, 17 Feb 2023 14:35:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 108DFB82DD1;
        Fri, 17 Feb 2023 22:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E54C433D2;
        Fri, 17 Feb 2023 22:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676673346;
        bh=AJkZmUCTEOmCCALQIpc7uUcbL0+2XWrf05ehY0N88Wg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mUDU7xopOIEZs436JwIl+cCjUZA63Bqc/3skD+sDIV81RbNuihUv2rCacAjG7+UDA
         anKS0vxHmLuCZFSyP71rOvqWQdcZDRb8QXRLjWnGcZ0NUNZunrKxhM0ulPVdIojsDB
         NzdqHZ2CykePkK0icHoZxqnLQVDah7R5ZriBmGKd+U5p2wBMxOsYdZb+v87GUygq7D
         pcoA1XnCs9PRJVsAt3eqnnvVZIQfday5V/XK4mTPoHaEZyWU7nV4/qtK9uaB2EZjHU
         khWWiTcye8kLe1QZ115skjBuBFqkA/zTcAIVeywHRKHRw8pdIBm6+osm4ynbCxGd3Z
         /wrpK3hxTBmYg==
Date:   Sat, 18 Feb 2023 00:35:42 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jason@zx2c4.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: [PATCH 1/1] tpm: disable hwrng for fTPM on some AMD designs
Message-ID: <Y/ABPhpMQrQgQ72l@kernel.org>
References: <20230214201955.7461-1-mario.limonciello@amd.com>
 <20230214201955.7461-2-mario.limonciello@amd.com>
 <50b5498c-38fb-e2e8-63f0-3d5bbc047737@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50b5498c-38fb-e2e8-63f0-3d5bbc047737@leemhuis.info>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 17, 2023 at 04:18:39PM +0100, Thorsten Leemhuis wrote:
> On 14.02.23 21:19, Mario Limonciello wrote:
> > AMD has issued an advisory indicating that having fTPM enabled in
> > BIOS can cause "stuttering" in the OS.  This issue has been fixed
> > in newer versions of the fTPM firmware, but it's up to system
> > designers to decide whether to distribute it.
> > 
> > This issue has existed for a while, but is more prevalent starting
> > with kernel 6.1 because commit b006c439d58db ("hwrng: core - start
> > hwrng kthread also for untrusted sources") started to use the fTPM
> > for hwrng by default. However, all uses of /dev/hwrng result in
> > unacceptable stuttering.
> > 
> > So, simply disable registration of the defective hwrng when detecting
> > these faulty fTPM versions.
> 
> Hmm, no reply since Mario posted this.
> 
> Jarkko, James, what's your stance on this? Does the patch look fine from
> your point of view? And does the situation justify merging this on the
> last minute for 6.2? Or should we merge it early for 6.3 and then
> backport to stable?
> 
> Ciao, Thorsten

As I stated in earlier response: do we want to forbid tpm_crb in this case
or do we want to pass-through with a faulty firmware?

Not weighting either choice here I just don't see any motivating points
in the commit message to pick either, that's all.

BR, Jarkko
