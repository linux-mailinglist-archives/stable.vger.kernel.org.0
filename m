Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4794EABC5
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 12:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbiC2LBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 07:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbiC2LBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 07:01:01 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F23D8566F;
        Tue, 29 Mar 2022 03:59:19 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id v13so13707315qkv.3;
        Tue, 29 Mar 2022 03:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WeHHguGPowcDvWMr7blgBmwq0GWd0bNHBYB846nmBBc=;
        b=R7CuH78vDiYCJvedJaROsJPEXMamwU/N6ut1asPh8lNtVeQ9xie9A2Ck2ZDyCRvwMU
         uzfEsvjCK7IFPpXPluuxrdrunYczj8sdNfT6qCG81bsOmvPDIg82DT1zGFk9FArYB+WR
         XSXgy03C+Bf+1ksfXj8/gqu4dd1Oe0kNaOZ37INj1DE9zjrQwbNVWwjval2REUDLt9lE
         qunnvuK6B0vLkMTUL7QN0Vga8qZiD77UAmhmc+hHt1sDdUHCE1Zsn9ajGIEZHh0x69uH
         9dfUabQggu7sz3o3gwJibuHG8rmWNTvOfLeSvsZgkSAVVA2ak+oOUxClmbDqt6RYvbwR
         13BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WeHHguGPowcDvWMr7blgBmwq0GWd0bNHBYB846nmBBc=;
        b=mJbL5LyPSNcvwfdu1nPhr9TGlbaC5wGCxaOE5/rylLItl0j26CsAXst7CJYXto1Rj7
         38/qJ0JYXqReb9b/7/qt/OEekuSauVSDBBsxBVnbohvYG0u17SbV3z9kdG2dEk2DpbCK
         8WynNJ6wmpRb+OfmjbiN4CGHT/MjMgYMTZj4erXwRjcc/M6hbTtbnrIUYNDLdmS37KY1
         n/fOBlHf4Tse8XddhRTWt/Hv2EmRJ1N1Y6fZ1ZF9ggk3oTLA5kqTGdIU/F3aEVaPFXNb
         s6J9roId1iPkycK+Tfjj5Cb4VtmwT94Cev6ydgihiyx44prT9IM/E6jiv2W/2rPNG63H
         vWkA==
X-Gm-Message-State: AOAM531iIslNbeLamqLBl7VaoUGHudXf1n2ZFSu58e/dULja7yCPfDV5
        iotx5VC8SmTUziuuCzfZieNYTrrp7G33Eh6Y0GH2gStc
X-Google-Smtp-Source: ABdhPJwqoYi0XNT2COlvQmgCNj2NZw3NxFJuyzWhrMjioYDWM7gCjvABPKquYY1SZkpt4YqN7g6vw9+QeilGXieqBvY=
X-Received: by 2002:a37:a644:0:b0:680:9e24:6583 with SMTP id
 p65-20020a37a644000000b006809e246583mr18903701qke.366.1648551558094; Tue, 29
 Mar 2022 03:59:18 -0700 (PDT)
MIME-Version: 1.0
References: <CACvgo50pK3rr5UH_FyfR1pADmPRjEawi43cAecoaz7nM5AFgBg@mail.gmail.com>
 <20220328020902.19369-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220328020902.19369-1-xiam0nd.tong@gmail.com>
From:   Emil Velikov <emil.l.velikov@gmail.com>
Date:   Tue, 29 Mar 2022 11:59:06 +0100
Message-ID: <CACvgo5342xQHb07FVK4beXWgFexZR0LyODEqemE3y1subnEw1Q@mail.gmail.com>
Subject: Re: [PATCH] dispnv50: atom: fix an incorrect NULL check on list iterator
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     Dave Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Karol Herbst <kherbst@redhat.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Lyude <lyude@redhat.com>,
        ML nouveau <nouveau@lists.freedesktop.org>,
        "# 3.13+" <stable@vger.kernel.org>, yangyingliang@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Mar 2022 at 03:09, Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
>
> on Sun, 27 Mar 2022 16:59:28 +0100, Emil Velikov wrote:
> > On Sun, 27 Mar 2022 at 08:39, Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
> > >
> > > The bug is here:
> > >         return encoder;
> > >
> > > The list iterator value 'encoder' will *always* be set and non-NULL
> > > by drm_for_each_encoder_mask(), so it is incorrect to assume that the
> > > iterator value will be NULL if the list is empty or no element found.
> > > Otherwise it will bypass some NULL checks and lead to invalid memory
> > > access passing the check.
> > >
> > > To fix this bug, just return 'encoder' when found, otherwise return
> > > NULL.
> > >
> >
> > Isn't this covered by the upcoming list* iterator rework [1] or is
> > this another iterator glitch?
>
> Actually, it is a part of the upcoming work.
>
> > IMHO we should be looking at fixing the implementation and not the
> > hundreds of users through the kernel.
> >
> > HTH
> > -Emil
> > [1] https://lwn.net/Articles/887097/
>
> Yes, you are right. This has also been taken into account by the upcoming
> list iterator rework to avoid a lot uesr' changes as much as possible.
>
> However, this patch is fixing a potential bug caused by incorrect use of
> list iterator outside the loop, which can not be fixed by the implementation
> itself.
>

I see, thanks for the information o/

-Emil
