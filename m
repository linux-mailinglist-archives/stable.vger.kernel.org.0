Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A0D69D272
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 18:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjBTR7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 12:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjBTR7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 12:59:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D1FFF20;
        Mon, 20 Feb 2023 09:59:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2A8E60EFB;
        Mon, 20 Feb 2023 17:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7304EC433D2;
        Mon, 20 Feb 2023 17:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676915972;
        bh=kPWrE4MTuivBZFuUVWlmy1L+G6O/GnpeaMSpK/LclV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rPe6+U1nMjl5SEz5Znhl4+/zchYRNH8qTQrXrOY8RUbP2So/SOhHaD/iBNk36oigk
         YeKOcJFTHr3eJBu2PVLL2uIkImFKA5VlHevS2/ioX/UtG+NWeKDoBXKaNisETBXPEu
         Xl7xYCNoIsH3nwOSKEXKRCwmlz7bavcHYAyhgu2ow5rGkwKcVuG7WtkSg2T1Ytc/Sa
         iDyLlZNZ0ZMcHTO9JuvW/OaHemA3OdrxHqJDCkdZ0C+SHJstRC8Kkq0cWhbnppthBk
         efVqGGtOV3Xe0C5d3xctwoyh4yHnjAj6XX46h7Cqsddzvle8wp9mJY8mNYjniEXUQf
         JJShXs/W8KOdA==
Date:   Mon, 20 Feb 2023 09:59:29 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        pjt@google.com, evn@google.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] x86/speculation: Fix user-mode spectre-v2
 protection with KERNEL_IBRS
Message-ID: <20230220175929.2laflfb2met6y3kc@treble>
References: <20230220120127.1975241-1-kpsingh@kernel.org>
 <20230220121350.aidsipw3kd4rsyss@treble>
 <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
 <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
 <20230220163442.7fmaeef3oqci4ee3@treble>
 <Y/Ox3MJZF1Yb7b6y@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/Ox3MJZF1Yb7b6y@zn.tnic>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 06:46:04PM +0100, Borislav Petkov wrote:
> On Mon, Feb 20, 2023 at 08:34:42AM -0800, Josh Poimboeuf wrote:
> > We will never enable IBRS in user space.  We tried that years ago and it
> > was very slow.
> 
> Then I don't know what this is trying to fix.
> 
> We'd need a proper bug statement in the commit message what the problem
> is. As folks have established, the hw vuln mess is a whole universe of
> crazy. So without proper documenting, this spaghetti madness will be
> completely unreadable.

Agreed, and there seems to be a lot of confusion around this patch.  I
think I understand the issue, let me write up a new patch which is
hopefully clearer.

-- 
Josh
