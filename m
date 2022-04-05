Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6706D4F47CB
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239172AbiDEVVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572914AbiDERTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 13:19:51 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1484D9CF
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 10:17:52 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w21so11544030pgm.7
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 10:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oLYBS6qSnQJDgHjg4Cj/j2Qud2mtZddgHInB5HJPeJI=;
        b=LjoNMKdoa2fQAXS+kSSP5+w5CB9a38NU+nsairp0fAYRVkSuE5pCKkLbh+w3mkv3kU
         f/D/yVZPMsLyjmGoclxJf72/hNgGVWsb+AUghM2UbT1G6fLt9RZxs02Aq+RzxkpND3Ls
         31KigSq940fcdUut6dq4VTF2P2un1IquDcydA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oLYBS6qSnQJDgHjg4Cj/j2Qud2mtZddgHInB5HJPeJI=;
        b=SrCIgF5BQxnxYRu8zOE9SFql2aHi8g3xe4tvAOLHYT3bks64qSRbxP2vRBZvmPQoo9
         lpedM//O59Cx91U5iOKWSxb4JsmEHCl6NmTdWUCNj3V1DGuqX0sN3f+PP+r3QUoeIPFz
         +ussK9eySrulWpN+e7F/gSXcEofgRbOTXIWThmkr14QQ9MO6u1VHNWWtS8xLhxtcUsS8
         BHCQe2CkKYlOAHEHuJNqib+F5FVD5AGnn4abjWG4OawTFw3kmZyUI5Xs86sLy0cJsZod
         2Y6Eawlb4MFY5HKa+jneRYaEK/2TtNJ5KaJGgnE8x4DRfDCfHNSC+0mZttGFNdKnUSMB
         FSGg==
X-Gm-Message-State: AOAM530AeLQBiLN6mxq3CI8gDsO+F4xtQalymI/CS33PBqPGCbtD1ToS
        V2cj4ptt3LWyWfhze9OKoiTpMQ==
X-Google-Smtp-Source: ABdhPJwlJsEZo/PkPNT8otsdduOSiGXLIcEUWsi8iE+msHB+Nh3AdQJ6kUVN7PByXt5yxtNPk/JT0Q==
X-Received: by 2002:a62:e213:0:b0:4fa:6b13:3a9a with SMTP id a19-20020a62e213000000b004fa6b133a9amr4665590pfi.18.1649179071654;
        Tue, 05 Apr 2022 10:17:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p10-20020a637f4a000000b00373a2760775sm13654616pgn.2.2022.04.05.10.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 10:17:51 -0700 (PDT)
Date:   Tue, 5 Apr 2022 10:17:50 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH v2] gcc-plugins: latent_entropy: use /dev/urandom
Message-ID: <202204051016.4E9DD89@keescook>
References: <CAHmME9otYi4pCzZwSGnK40dp1QMRVPxp+DBysVuLXUKkXinAxg@mail.gmail.com>
 <20220403204036.1269562-1-Jason@zx2c4.com>
 <202204041144.96FC64A8@keescook>
 <Ykt1cj0wPKEsHL2q@zx2c4.com>
 <202204041953.D7E0BA15@keescook>
 <CAHmME9rC-pmi3K=w06-bOsHP5=tPv9CS51hr69P1C5tmvHf_mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rC-pmi3K=w06-bOsHP5=tPv9CS51hr69P1C5tmvHf_mA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 02:38:58PM +0200, Jason A. Donenfeld wrote:
> Hi Kees,
> 
> On 4/5/22, Kees Cook <keescook@chromium.org> wrote:
> > On Tue, Apr 05, 2022 at 12:47:14AM +0200, Jason A. Donenfeld wrote:
> >> On Mon, Apr 4, 2022 at 8:49 PM Kees Cook <keescook@chromium.org> wrote:
> >> > This mixes two changes: the pRNG change and the "use urandom if
> >> > non-deterministic" change. I think these should be split, so the pRNG
> >> > change can be explicitly justified.
> >>
> >> Alright, I'll split those. Or, more probably, just drop the xorshift
> >> thing. There's not actually a strong reason for preferring xorshift. I
> >> did it because it produces more uniformity and is faster to compute and
> >> all that. But none of that stuff actually matters here. It was just a
> >> sort of "well I'm at it..." thing.
> >
> > Well, it's nice to have and you already wrote it, so seems a waste to
> > just drop it. :)
> >
> >> > >  static struct plugin_info latent_entropy_plugin_info = {
> >> > > -     .version        = "201606141920vanilla",
> >> > > +     .version        = "202203311920vanilla",
> >> >
> >> > This doesn't really need to be versioned. We can change this to just
> >> > "vanilla", IMO.
> >>
> >> Okay. I suppose you want it to be in a different patch too, right? In
> >> which case I'll leave it out and maybe get to it later. (I suppose one
> >> probably needs to double check whether it's used for anything
> >> interesting like dwarf debug info or whatever, where maybe it's
> >> helpful?)
> >
> > Hm, I don't think it shows up anywhere, but you can just drop the hunk
> > that touch it. I can remove them all with a separate patch later.
> >
> 
> Okay. That's what I did here
> https://lore.kernel.org/lkml/20220404230709.124508-1-Jason@zx2c4.com/
> so awaiting your merge. (I still find all aspects of v2 more
> preferable for a variety of weak reasons in case you'd like to merge
> that instead, but v3 is available now.)

v3 uses a different check for the -f option, though? Isn't that
preferred over the v2 method?

Also, I did some quick benchmarking, and any difference in runtime is
completely lost in the noise, so that's good.

-- 
Kees Cook
