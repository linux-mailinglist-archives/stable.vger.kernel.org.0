Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1733669D3B1
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 20:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbjBTTC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 14:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbjBTTCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 14:02:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF86222C3;
        Mon, 20 Feb 2023 11:01:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7B0FB80DC7;
        Mon, 20 Feb 2023 19:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB716C4339B;
        Mon, 20 Feb 2023 18:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676919600;
        bh=ts6SEtewZVGy5pgs+9q4VeqLaHWaM9C2UcAoTTVBen0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W/0mig6dnpdhlKG/yjNPcaj6ORSK7jpUwuqgGLP2rWYhVuCVy29pCWkORoV9hc5Es
         IuSoZgw+VVtLOUxsO9okNlJVVaSS7njpHl+JFM+Diaa4bPbFKwue+y9VZ2nvE2C+IW
         v57ZCjidGvDg/eZpJY5woOP+F7C6diLCRFWCy6rYk2MrcMU1e6/MzHQMdFZXLjqVud
         yllLKtwYFNgU3vKANxLxX7UTfS4I22j1hI3+ipWabnukQWIKTbqQWaoezS0dFEGeOF
         sDN/m5JSK5FpHP5KmuKekhNyr0A9MWP1xQzFjSK6SCQfMhOoJPt1x/bKtUKLSjHVx3
         m+TYhTBNmq+bw==
Date:   Mon, 20 Feb 2023 10:59:57 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     KP Singh <kpsingh@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        pjt@google.com, evn@google.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/bugs: Allow STIBP with IBRS
Message-ID: <20230220185957.yzjdnhcqpmkji2xs@treble>
References: <20230220120127.1975241-1-kpsingh@kernel.org>
 <20230220121350.aidsipw3kd4rsyss@treble>
 <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
 <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
 <20230220163442.7fmaeef3oqci4ee3@treble>
 <Y/Ox3MJZF1Yb7b6y@zn.tnic>
 <20230220175929.2laflfb2met6y3kc@treble>
 <CACYkzJ71xqzY6-wL+YShcL+d6ugzcdFHr6tbYWWE_ep52+RBZQ@mail.gmail.com>
 <20230220182717.uzrym2gtavlbjbxo@treble>
 <CACYkzJ5z3qLhkWqKLvP55HcjLACzAJbFjc4XjRzcft9ww40MaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACYkzJ5z3qLhkWqKLvP55HcjLACzAJbFjc4XjRzcft9ww40MaQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 10:33:56AM -0800, KP Singh wrote:
>  static char *stibp_state(void)
>  {
> -       if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> +       if (!spectre_v2_user_needs_stibp(spectre_v2_enabled))
>                 return "";
> 
>         switch (spectre_v2_user_stibp) {
> 
> Also Josh, is it okay for us to have a discussion and have me write
> the patch as a v2? Your current patch does not even credit me at all.
> Seems a bit unfair, but I don't really care. I was going to rev up the
> patch with your suggestions.

Well, frankly the patch needed a complete rewrite.  The patch
description was unclear about what the problem is and what's being
fixed.  The code was obtuse and the comments didn't help.  I could tell
by the other replies that I wasn't the only one confused.

I can give you Reported-by, or did you have some other tag in mind?

-- 
Josh
