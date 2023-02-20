Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226F969D161
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 17:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbjBTQev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 11:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjBTQeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 11:34:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734571E293;
        Mon, 20 Feb 2023 08:34:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA48660ED5;
        Mon, 20 Feb 2023 16:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D75CC433EF;
        Mon, 20 Feb 2023 16:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676910885;
        bh=r669q4trvVRbS9L9jBRi6DwmqW9Am1sW5bCegLzG1X0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BdmOjcAexhPPM1hkwnwPXT2pQfwJsqgk03ykdX/3F3sEI7jbfSx6KxmtpRb7UlNqg
         WCDMVBy6w3paN2roznrD9jcENaOoXsWLciUcQM+VvIHPNi6Y0TVSMDxeeY66mjYQVj
         v5z3tVgmWTH2zw125UoQC88kDexi2Baiy/IicZGy+4bZIp3dsYtAvuSPasJKMsjyot
         AS2ny8dfgwy93CCb3o5ugyhYeeHKomsNYZ992rx3+HeU1T475+F+l+wHHnDyATXgcd
         C3Lf7FyeGZIq1jyzGnVGjVy/XipIHCTMctgjBWobP2Y01jCzwozzUG8e87XeU96f9z
         JZdXJZ/V2+N1A==
Date:   Mon, 20 Feb 2023 08:34:42 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     KP Singh <kpsingh@kernel.org>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
        kim.phillips@amd.com, alexandre.chartre@oracle.com,
        daniel.sneddon@linux.intel.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] x86/speculation: Fix user-mode spectre-v2
 protection with KERNEL_IBRS
Message-ID: <20230220163442.7fmaeef3oqci4ee3@treble>
References: <20230220120127.1975241-1-kpsingh@kernel.org>
 <20230220121350.aidsipw3kd4rsyss@treble>
 <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
 <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 04:34:02AM -0800, KP Singh wrote:
> On Mon, Feb 20, 2023 at 4:20 AM KP Singh <kpsingh@kernel.org> wrote:
> >
> > On Mon, Feb 20, 2023 at 4:13 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > >
> > > On Mon, Feb 20, 2023 at 01:01:27PM +0100, KP Singh wrote:
> > > > +static inline bool spectre_v2_user_no_stibp(enum spectre_v2_mitigation mode)
> > > > +{
> > > > +     /* When IBRS or enhanced IBRS is enabled, STIBP is not needed.
> > > > +      *
> > > > +      * However, With KERNEL_IBRS, the IBRS bit is cleared on return
> > > > +      * to user and the user-mode code needs to be able to enable protection
> > > > +      * from cross-thread training, either by always enabling STIBP or
> > > > +      * by enabling it via prctl.
> > > > +      */
> > > > +     return (spectre_v2_in_ibrs_mode(mode) &&
> > > > +             !cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS));
> > > > +}
> > >
> > > The comments and code confused me, they both seem to imply some
> > > distinction between IBRS and KERNEL_IBRS, but in the kernel those are
> > > functionally the same thing.  e.g., the kernel doesn't have a user IBRS
> > > mode.
> > >
> > > And, unless I'm missing some subtlety here, it seems to be a convoluted
> > > way of saying that eIBRS doesn't need STIBP in user space.
> 
> Actually, there is a subtlety, STIBP is not needed in IBRS and eIBRS
> however, with KERNEL_IBRS we only enable IBRS (by setting and
> unsetting the IBRS bit of SPEC_CTL) in the kernel context and this is
> why we need to allow STIBP in userspace. If it were for pure IBRS, we
> would not need it either (based on my reading). Now, with
> spectre_v2_in_ibrs_mode, as per the current implementation implies
> that KERNEL_IBRS is chosen, but this may change. Also, I would also
> prefer to have it more readable in the sense that:
> 
> "If the kernel decides to write 0 to the IBRS bit on returning to the
> user, STIBP needs to to be allowed in user space"

We will never enable IBRS in user space.  We tried that years ago and it
was very slow.

-- 
Josh
