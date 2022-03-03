Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E114CB524
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 03:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiCCCwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 21:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbiCCCwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 21:52:19 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D022162016;
        Wed,  2 Mar 2022 18:51:34 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
        by gnuweeb.org (Postfix) with ESMTPSA id 7AFB77E6B2;
        Thu,  3 Mar 2022 02:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646275893;
        bh=5R8CtEIQAKm9DWp0yzIHx+yDFFKxgK9WMLzK1eontrU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fTBKyPxtbjqj5dfmMrFfkpCL3i+b6lnI76IffnpZQN/DXazvWtHDrFp1qVKdO+OO9
         PalyoMXD5foNdo/G/7M+woTNWma+yVH3pngxLco+u5pnSjyP7WlYshmdKV5+/gHVzK
         /TKbm2eEQR8/r8UxSr9dwbMxBKjq8MZEbQGxUJapgk7Z8F+IeeZizEZ2xl04prQNZp
         BUp0G18+T7+jRfsiTVJ0FtfAWMtFkUmH9x9qJck3P0tvlr9LCABZsGM4cnAyxjYOlj
         DQb4HdJXLmdVWqVS98Gs59jgJoWrCI8HuX8/WTWj8iuWg1aBIe1087uXVQMxZwundU
         oFYZvotz9YNWA==
Received: by mail-lf1-f48.google.com with SMTP id g39so6039246lfv.10;
        Wed, 02 Mar 2022 18:51:33 -0800 (PST)
X-Gm-Message-State: AOAM530rmDL5eGZtyuhpkAiAg6j23hZGB83NeuTmXLerqhWBGZWoW8KN
        R225Xz193qS1gNVG7U9O/h3ayFKK+3KsgjFGScA=
X-Google-Smtp-Source: ABdhPJyv90IKXz8uZ/SLsv8Ivd2dShHqBxwheVBt3+dCnU5rpnzjNuNHTcMq6jBf+tbGvIfGopymNZ3oqMlZj8Km87A=
X-Received: by 2002:ac2:4e85:0:b0:441:94b6:b2c with SMTP id
 o5-20020ac24e85000000b0044194b60b2cmr20570001lfr.610.1646275891428; Wed, 02
 Mar 2022 18:51:31 -0800 (PST)
MIME-Version: 1.0
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
 <20220301094608.118879-3-ammarfaizi2@gnuweeb.org> <Yh+oyD/5M3TW5ZMM@yaz-ubuntu>
 <4371a592-6686-c535-4daf-993dedb43cd4@gnuweeb.org> <109a10da-d1d1-c47a-2f04-31796457f6ff@gnuweeb.org>
 <20220303015826.4176416-1-alviro.iskandar@gnuweeb.org> <49313736-61f8-d001-0fe4-b6166c859585@gnuweeb.org>
 <9dfe087a-f941-1bc4-657d-7e7c198888ff@gnuweeb.org>
In-Reply-To: <9dfe087a-f941-1bc4-657d-7e7c198888ff@gnuweeb.org>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Thu, 3 Mar 2022 09:51:20 +0700
X-Gmail-Original-Message-ID: <CAOG64qPHf3Y+m-9DcewPhqKUzHD7rOtkG_kRXfuMsH66g0P2Vg@mail.gmail.com>
Message-ID: <CAOG64qPHf3Y+m-9DcewPhqKUzHD7rOtkG_kRXfuMsH66g0P2Vg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] x86/mce/amd: Fix memory leak when
 `threshold_create_bank()` fails
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Yazen Ghannam <yazen.ghannam@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>, x86@kernel.org,
        stable@vger.kernel.org, Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 3, 2022 at 9:32 AM Ammar Faizi wrote:
> On 3/3/22 9:07 AM, Ammar Faizi wrote:
> > On 3/3/22 8:58 AM, Alviro Iskandar Setiawan wrote:
> > > hi sir, i think this can be improved again, we can avoid calling
> > > this_cpu_read(mce_num_banks) twice if we pass the numbanks as an
> > > argument, plz review the changes below
> >
> > OK, nice improvement. I will fold this in...
> >
>
> It looks like this now. Yazen, Alviro, please review the
> following patch. If you think it looks good, I will submit
> it for the v5.
>

i think it looks good, thanks sir

-- Viro
