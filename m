Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340734D5D98
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 09:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiCKIkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 03:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiCKIkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 03:40:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60F61B98A2;
        Fri, 11 Mar 2022 00:39:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D7AA61DF7;
        Fri, 11 Mar 2022 08:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A644C340E9;
        Fri, 11 Mar 2022 08:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646987951;
        bh=VR65Ts15rZoinOtKMC5nZR3huGHCng96LOJ+iodA26M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y8h9eVCjKRRo53CER8Rxrj6wSw5A0E+3gFPJ/3JsFJs7i7WERXFk27+CyA6gu16mP
         To0aHOvPYC4wiCxsMbHO/WE0oxoilhTUHhQ4zXFDujR5zywHMlaydAq07Ei3CO4c8l
         XaRgs20lJ3gb9iYLOBGNpa8HDPzsCsJHi3jDBBW0=
Date:   Fri, 11 Mar 2022 09:39:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH 5.16 29/37] arm64: entry: Add vectors that have the bhb
 mitigation sequences
Message-ID: <YisKrFY6yBDmUu6b@kroah.com>
References: <20220309155859.086952723@linuxfoundation.org>
 <20220309155859.932269331@linuxfoundation.org>
 <20220310232729.GA16308@amd>
 <YisFJPSqqWy8GABY@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YisFJPSqqWy8GABY@kroah.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 11, 2022 at 09:15:32AM +0100, Greg Kroah-Hartman wrote:
> On Fri, Mar 11, 2022 at 12:27:29AM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > From: James Morse <james.morse@arm.com>
> > > 
> > > commit ba2689234be92024e5635d30fe744f4853ad97db upstream.
> > > 
> > > Some CPUs affected by Spectre-BHB need a sequence of branches, or a
> > > firmware call to be run before any indirect branch. This needs to go
> > > in the vectors. No CPU needs both.
> > > 
> > > While this can be patched in, it would run on all CPUs as there is a
> > > single set of vectors. If only one part of a big/little combination is
> > > affected, the unaffected CPUs have to run the mitigation too.
> > 
> > This adds build error. Same problem is in 5.10.
> > 
> > > --- /dev/null
> > > +++ b/arch/arm64/include/asm/vectors.h
> > > @@ -0,0 +1,34 @@
> > ...
> > > +/*
> > > + * Note: the order of this enum corresponds to two arrays in entry.S:
> > > + * tramp_vecs and __bp_harden_el1_vectors. By default the canonical
> > > + * 'full fat' vectors are used directly.
> > > + */
> > > +enum arm64_bp_harden_el1_vectors {
> > > +#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
> > > +	/*
> > > +	 * Perform the BHB loop mitigation, before branching to the canonical
> > > +	 * vectors.
> > > +	 */
> > > +	EL1_VECTOR_BHB_LOOP,
> > > +
> > > +	/*
> > > +	 * Make the SMC call for firmware mitigation, before branching to the
> > > +	 * canonical vectors.
> > > +	 */
> > > +	EL1_VECTOR_BHB_FW,
> > > +#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
> > > +
> > > +	/*
> > > +	 * Remap the kernel before branching to the canonical vectors.
> > > +	 */
> > > +	EL1_VECTOR_KPTI,
> > > ++};
> > > +
> > 
> > 
> > Note "++". Following patch fixes this up, but it is still a trap for
> > people trying to bisect.
> 
> Ick, ok, will try to fix up, thanks for finding this.

Now fixed up for 5.16.y, 5.15.y, and 5.10.y, thanks.

greg k-h
