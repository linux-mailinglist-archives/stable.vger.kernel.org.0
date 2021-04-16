Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6D03628BE
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 21:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbhDPTjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 15:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236021AbhDPTjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 15:39:35 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BBAC061756
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 12:39:06 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id n8so46558241lfh.1
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 12:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a5bSORGkB+4sOSDlbG0QBhoLiar3A6Hf9oRh/5+9RR0=;
        b=rlq5x4iVPdZwyLylfCSNLIcnsW+s2lyHhqZ00X5nq6jQBqX7F7D0pAGeZLERuelZ3Z
         Z7Hhey54gSfMsQKDUGrq9iM3vq/50mOUlvoxhLYhpmbaQyoYM4+VT3agV0P1pivA7Mi2
         duSIV1nG6RL5Tvv1n88bzP/0Y0gMYxUqtqlvpURVXy+UxpIm37+g8QdR6c9o19RZPDNA
         Mfec1CQBRG89PrGnl6G0i9b/dFewUpEVhJ9McYv+EQyFvt4NZkHRdW4XuzF1HTqvRX52
         MkyqGXuf2rPlKsx4mLLeJv2uiaV9bsPkimARdkDBSNeDJxWi6MrHuhKsuGsLmwcg+/jc
         aNYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a5bSORGkB+4sOSDlbG0QBhoLiar3A6Hf9oRh/5+9RR0=;
        b=siPYf2/0zQ28tSv5qtW0OOU721z3xOjotMDaOksmzk5Qq2l+ZectuozlX+ToqZH+fq
         HGbvYKrJM6Aq0ODXy45fdYMIJ3wRgbDohOi7Zy87RnhyIf/dkqNW2pya9xDz7qWhfjEg
         qXdh5eveop7Qycf3llRG2T6hAaHHFgQAmXd3Zh4G1qztr67+nJmnYUSdyYou/OyE0Wtq
         j2KMRSJgtEChInyzt7b9UpR5/Kbf6R9MMeEFDSJDow5UlP4d4kseOPda6WFwj/dGkiyx
         57LBwkfJol0Q68gOB0rlvtbcjANnfsfEQC2t/7Z5EOj1T+2tXYlODKDseIlLz/P8cRYL
         S9bg==
X-Gm-Message-State: AOAM533zKFI3w3rjFAXBnvLjckXoIuxrtP/AqKcxfqC468gv6iOo9WVG
        Q9YzLVmheyQ1tlZvSC4a7f9CDgf68uNIP360SKO1pg==
X-Google-Smtp-Source: ABdhPJwGuD2X+jasq9CekyPtz3NabVLrt6m35n2VwzK5MIL41IM2TYc2mzopTSq8PF41o2zD6ka6YJQPDNlP9bxNK/I=
X-Received: by 2002:a05:6512:11cc:: with SMTP id h12mr3960009lfr.567.1618601945471;
 Fri, 16 Apr 2021 12:39:05 -0700 (PDT)
MIME-Version: 1.0
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
 <87zgxymrph.fsf@kernel.org>
In-Reply-To: <87zgxymrph.fsf@kernel.org>
From:   John Stultz <john.stultz@linaro.org>
Date:   Fri, 16 Apr 2021 12:38:51 -0700
Message-ID: <CALAqxLUQn+m_JsjVrMSDc+Z=Ezo3jDD1e22ey7SZsruoEfQLjg@mail.gmail.com>
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
To:     Felipe Balbi <balbi@kernel.org>
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 16, 2021 at 3:47 AM Felipe Balbi <balbi@kernel.org> wrote:
>
>
> Hi,
>
> Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
>
> > From: Yu Chen <chenyu56@huawei.com>
> > From: John Stultz <john.stultz@linaro.org>
> >
> > According to the programming guide, to switch mode for DRD controller,
> > the driver needs to do the following.
> >
> > To switch from device to host:
> > 1. Reset controller with GCTL.CoreSoftReset
> > 2. Set GCTL.PrtCapDir(host mode)
> > 3. Reset the host with USBCMD.HCRESET
> > 4. Then follow up with the initializing host registers sequence
> >
> > To switch from host to device:
> > 1. Reset controller with GCTL.CoreSoftReset
> > 2. Set GCTL.PrtCapDir(device mode)
> > 3. Reset the device with DCTL.CSftRst
> > 4. Then follow up with the initializing registers sequence
> >
> > Currently we're missing step 1) to do GCTL.CoreSoftReset and step 3) of
> > switching from host to device. John Stult reported a lockup issue seen
> > with HiKey960 platform without these steps[1]. Similar issue is observed
> > with Ferry's testing platform[2].
> >
> > So, apply the required steps along with some fixes to Yu Chen's and John
> > Stultz's version. The main fixes to their versions are the missing wait
> > for clocks synchronization before clearing GCTL.CoreSoftReset and only
> > apply DCTL.CSftRst when switching from host to device.
> >
> > [1] https://lore.kernel.org/linux-usb/20210108015115.27920-1-john.stultz@linaro.org/
> > [2] https://lore.kernel.org/linux-usb/0ba7a6ba-e6a7-9cd4-0695-64fc927e01f1@gmail.com/
> >
> > Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Cc: Ferry Toth <fntoth@gmail.com>
> > Cc: Wesley Cheng <wcheng@codeaurora.org>
> > Cc: <stable@vger.kernel.org>
> > Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work properly")
> > Signed-off-by: Yu Chen <chenyu56@huawei.com>
> > Signed-off-by: John Stultz <john.stultz@linaro.org>
> > Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>
> I still have concerns about the soft reset, but I won't block you guys
> from fixing Hikey's problem :-)
>
> The only thing I would like to confirm is that this has been verified
> with hundreds of swaps happening as quickly as possible. DWC3 should
> still be functional after several hundred swaps.
>
> Can someone confirm this is the case? (I'm assuming this can be
> scripted)

I unfortunately don't have an easy way to automate the switching right
off. But I'll try to hack up the mux switch driver to provide an
interface we can script against.

thanks
-john
