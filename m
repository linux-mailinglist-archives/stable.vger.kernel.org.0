Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39054ED5E2
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 10:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiCaIkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 04:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiCaIkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 04:40:37 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964513BA4E
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 01:38:48 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id p15so46523745ejc.7
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 01:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9RMKKrryOVnu3VhzCD1VF7LZZR0DSgayzdUmb3Tu53k=;
        b=c/a8HkvGusD0VHfseWle6cB/KMsnNLxZtaI9E6YEPd2f3Ay7SSaywbcuyl/qOuXpx7
         5/fkW2lXkltLFr3B0LVE0/SHh0jLHqaTBs5PWnEUBNmVxT18zw3pQfsa/HaoTRIAnmjs
         qPXoZCjSC7i04J1uDtkAmhsb4Vm0QdvIWMBQwPb2oJ6tzNUFdMucD/PFbUK7BFLZoGtq
         Xg7bHb/csIsmHtf35TzKjMp4iA6QDF+67WWet3t1AoXZsR4hzkkXATvSaSuFQWkmo9u/
         4QWXiMij+6bFeI32M7XMl93xmxqD+YufjQyzP79v6BNBoSAl+LidnUb/1nGSyma1IsOl
         VEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9RMKKrryOVnu3VhzCD1VF7LZZR0DSgayzdUmb3Tu53k=;
        b=V1c8kg5HGY3ab4SketaX5YoCEJYYWVU8WKgOCiGwnNfu0qc9vKkb/XKOP7U1spKNkQ
         h3zUFdocb3x5WUPAx/ea+hAttTFOnroujBUUdTH9fZowaFjBz+DD9EjBB26mBp+mblbI
         Ws+rzn+r9MtSF7m6NGZwxt678kToOywu0x/ETu32o2sdI5XeTLstakOFAP9HWPfFJgf4
         Kd9pfSSwPJrfAxL9V33tkDJCEWi3towkObKKmfXAq7imzfV19sQVt475pU+kX42vGWHZ
         owExCthP8IEPKyPkA6IYNmueJCdIG/42s6FBLmWdtdV/9EIzc/2CLgSw6MnWm+9XHHTU
         b3OA==
X-Gm-Message-State: AOAM531B0bjJTvyXKKv3KO5jaRjp+0oGA2qQvoWIbJT93YSsfRaoh+Av
        /NS7QKn92MBXDEi2mn0N5QLVIVjDKIOZFykfICoixw==
X-Google-Smtp-Source: ABdhPJzZ64lT4jQoxd8nCjGxDTqo/uciOJixCc510kAeSEPLXlv1Gbkim7xxeGQIiJdrsnhjG56ttTAdPtyKxTCUc5o=
X-Received: by 2002:a17:906:5d06:b0:6df:b0ac:59c2 with SMTP id
 g6-20020a1709065d0600b006dfb0ac59c2mr4142364ejt.758.1648715926986; Thu, 31
 Mar 2022 01:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220330211913.2068108-1-wonchung@google.com> <s5hzgl6eg48.wl-tiwai@suse.de>
In-Reply-To: <s5hzgl6eg48.wl-tiwai@suse.de>
From:   Won Chung <wonchung@google.com>
Date:   Thu, 31 Mar 2022 01:38:34 -0700
Message-ID: <CAOvb9yiO_n48JPZ3f0+y-fQ_YoOmuWF5c692Jt5_SKbxdA4yAw@mail.gmail.com>
Subject: Re: [PATCH v2] sound/hda: Add NULL check to component match callback function
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 12:27 AM Takashi Iwai <tiwai@suse.de> wrote:
>
> On Wed, 30 Mar 2022 23:19:13 +0200,
> Won Chung wrote:
> >
> > Component match callback function needs to check if expected data is
> > passed to it. Without this check, it can cause a NULL pointer
> > dereference when another driver registers a component before i915
> > drivers have their component master fully bind.
> >
> > Fixes: 7b882fe3e3e8b ("ALSA: hda - handle multiple i915 device instances")
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Won Chung <wonchung@google.com>
> > ---
> > - Add "Fixes" tag
> > - Send to stable@vger.kernel.org
>
> You rather need to add "Cc: stable@vger.kernel.org" line to the patch
> itself (around sign-off block), not actually Cc'ing the mail.
> I edited manually, but please do it so at the next time.
>
> Although I applied the patch as-is now, I wonder...
>
>
> > -     if (!strcmp(dev->driver->name, "i915") &&
> > +     if (dev->driver && !strcmp(dev->driver->name, "i915") &&
>
> Can NULL dev->driver be really seen?  I thought the components are
> added by the drivers, hence they ought to have the driver field set.
> But there can be corner cases I overlooked.
>
>
> thanks,
>
> Takashi

Hi Takashi,

When I try using component_add in a different driver (usb4 in my
case), I think dev->driver here is NULL because the i915 drivers do
not have their component master fully bound when this new component is
registered. When I test it, it seems to be causing a crash.

Would it be okay for me to resend a new patch with the flags
corrected? I have mistakenly added Heikki and Mika as "Signed-off-by"
instead of "Suggested-by". I am sorry for that.

Thanks,
Won
