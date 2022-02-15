Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEB74B6BA6
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 13:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237480AbiBOMFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 07:05:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbiBOMFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 07:05:48 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE7CD21D6
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 04:05:38 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id d17so6398421pfl.0
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 04:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AvoSKo98ulJsw2WNwaVfLj/l/nh9gyg8Vgm73/f2Cg0=;
        b=QwMS041zrimjNV74ySW6/aEYe7UiHK52oC4sA7e5yXzaKYm47mFk2ThPjn6rsCa5/w
         pcneguNLnPKLl9Iyy/7mdNG/s4XJo0gQztdp2w28VT+XlklF8pIsuBYhZKpTa0uKmT6T
         gq+8A5YvlPgSEe63jC9r1+xxeJCPeN4K7sE7HT32ZRwlRJExpCIAm8LV7oWMrI3XaqEq
         nM0x3OQkPX10IbiuBEpekHpxVnB/ZDsFgzxqLPREk6w23Lz8p+sUtSc9u4Ob+mC9fv7+
         uUBTpM3pQq40xLUrqweNbRpYzAos9jzswxhQTGnygnPUd8R/8fO+YZ/YKL8519MYCIvD
         DAEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AvoSKo98ulJsw2WNwaVfLj/l/nh9gyg8Vgm73/f2Cg0=;
        b=atIWVC9R6nHCoSMp3ddyjUSTYUqHxZwE6Go+Ui19pBSYxuecsBSRB6nJG08YQzdPN8
         7ci2Oxn5qoTDVseUXpOdJiyB8gzQoFeLTYMAGpJvBg+WwBscNb+ECVVbHJOscBZNJNKk
         dWvGedt61i+h4YSpCtQ+l0RdoPeGkdSZBVKITVLaNGOLgKjQ1yMED3X9nIr24B5Qv+6z
         oRCgny62puKVoenaAAk8OJHOUZ/9uGEAgV+Wc/E9GFwALp44ptX1u1Gfw9OPfiRNC2R0
         YU5j++9YAZkezul/g+cNjDB08gQz9axyYIDkKcjWc1NY/FZ6ioCvNWApT2fce6gimXc4
         S+9g==
X-Gm-Message-State: AOAM5319NyVkX6N9EgP9AklCxxrMC8rOHBAsXSIh2YVvgzuG9gJS2MJF
        SJHKBXxxRNsC4Qlk7pXPVNAdJgdFPstzyUEfJv7Y8A==
X-Google-Smtp-Source: ABdhPJxFNaJhw9q+C7NaqGxKKGzPpa5mjZ240L5mkJh17FY5uNOfGjZF8e1QzCfRoulUqZIZL5kKn04LRXKUReNzq6s=
X-Received: by 2002:a05:6a00:b83:: with SMTP id g3mr4064233pfj.58.1644926737009;
 Tue, 15 Feb 2022 04:05:37 -0800 (PST)
MIME-Version: 1.0
References: <20220129093036.488231-1-pumahsu@google.com> <413ce7e5-1c35-c3d0-a89e-a3c7f03b4db7@linux.intel.com>
 <CAGCq0La83AKrdk4w2b6wJLZVB0oKB7_AH3iqc4R0K1vDnqrX9A@mail.gmail.com> <86bd1bef-2f07-8dee-a125-be208903204e@linux.intel.com>
In-Reply-To: <86bd1bef-2f07-8dee-a125-be208903204e@linux.intel.com>
From:   Puma Hsu <pumahsu@google.com>
Date:   Tue, 15 Feb 2022 20:05:00 +0800
Message-ID: <CAGCq0LZfYbqyFO8C5zct4cuUVEvs8CMN3g6MYO14_cLGdm-ATQ@mail.gmail.com>
Subject: Re: [PATCH v6] xhci: re-initialize the HC during resume if HCE was set
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     mathias.nyman@intel.com, Greg KH <gregkh@linuxfoundation.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Albert Wang <albertccwang@google.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
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

On Thu, Feb 10, 2022 at 7:08 PM Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
>
> On 8.2.2022 9.11, Puma Hsu wrote:
> > On Thu, Feb 3, 2022 at 3:11 AM Mathias Nyman
> > <mathias.nyman@linux.intel.com> wrote:
> >>
> >> On 29.1.2022 11.30, Puma Hsu wrote:
> >>> When HCE(Host Controller Error) is set, it means an internal
> >>> error condition has been detected. Software needs to re-initialize
> >>> the HC, so add this check in xhci resume.
> >>>
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Puma Hsu <pumahsu@google.com>
> >>> ---
> >>> v2: Follow Sergey Shtylyov <s.shtylyov@omp.ru>'s comment.
> >>> v3: Add stable@vger.kernel.org for stable release.
> >>> v4: Refine the commit message.
> >>> v5: Add a debug log. Follow Mathias Nyman <mathias.nyman@linux.intel.com>'s comment.
> >>> v6: Fix the missing declaration for str.
> >>>
> >>>  drivers/usb/host/xhci.c | 7 +++++--
> >>>  1 file changed, 5 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> >>> index dc357cabb265..6f1198068004 100644
> >>> --- a/drivers/usb/host/xhci.c
> >>> +++ b/drivers/usb/host/xhci.c
> >>> @@ -1091,6 +1091,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
> >>>       int                     retval = 0;
> >>>       bool                    comp_timer_running = false;
> >>>       bool                    pending_portevent = false;
> >>> +     char                    str[XHCI_MSG_MAX];
> >>>
> >>>       if (!hcd->state)
> >>>               return 0;
> >>> @@ -1146,8 +1147,10 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
> >>>               temp = readl(&xhci->op_regs->status);
> >>>       }
> >>>
> >>> -     /* If restore operation fails, re-initialize the HC during resume */
> >>> -     if ((temp & STS_SRE) || hibernated) {
> >>> +     /* If restore operation fails or HC error is detected, re-initialize the HC during resume */
> >>> +     if ((temp & (STS_SRE | STS_HCE)) || hibernated) {
> >>> +             xhci_warn(xhci, "re-initialize HC during resume, USBSTS:%s\n",
> >>> +                       xhci_decode_usbsts(str, temp));
> >>>
> >>>               if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
> >>>                               !(xhci_all_ports_seen_u0(xhci))) {
> >>>
> >>
> >> Ended up modifying this patch a bit more than I first intended,
> >> - don't print warning in hibernation case, only error.
> >> - maybe using a lot of stack for a debug string isn't really needed.
> >> - make sure we read the usbsts register before checking for the HCE bit.
> >>
> >> Does the below work for you? If yes, and you agree I'll apply it instead
> >
> > Hi Mathias,
> > Yes, your patch works for me, thanks!
> > Will you submit a new patch? or should I update to a new version?
> > Thanks.
>
> I'll submit it

Hi Mathias,
Could I know when you will submit the new patch?
We will sync the patch to our project.
Thank you for your effort!

>
> Thanks
> -Mathias
