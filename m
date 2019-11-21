Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 000581053ED
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 15:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfKUOG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 09:06:59 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:46721 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUOG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 09:06:58 -0500
Received: from mail-qt1-f173.google.com ([209.85.160.173]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MjSwu-1i8vgx0xeE-00l1CM; Thu, 21 Nov 2019 15:06:57 +0100
Received: by mail-qt1-f173.google.com with SMTP id y10so3802523qto.3;
        Thu, 21 Nov 2019 06:06:56 -0800 (PST)
X-Gm-Message-State: APjAAAUrl0lI7hXamErTIju93Fg+1fBCFlJL8tDiayClAwfy1XAkb8g/
        QtPIajCm+qMxK0c2ScVOTS7ylrWVCxrU4200aUw=
X-Google-Smtp-Source: APXvYqyn5Lx35EkdSAutFn/ZC76Cd/+HMa/DwlvSD1S0lYJha4tUVi779GkaPHUr7AA2usbua6dyeouYogDMU+OyQh8=
X-Received: by 2002:ac8:67d9:: with SMTP id r25mr8536345qtp.7.1574345215874;
 Thu, 21 Nov 2019 06:06:55 -0800 (PST)
MIME-Version: 1.0
References: <20191108203435.112759-1-arnd@arndb.de> <20191108203435.112759-8-arnd@arndb.de>
 <a79f4e894bf05816d2b279c2706a0108f130d75b.camel@codethink.co.uk>
In-Reply-To: <a79f4e894bf05816d2b279c2706a0108f130d75b.camel@codethink.co.uk>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 21 Nov 2019 15:06:39 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3vEBepxkP-UmcpHHqrpq2m3woxyxVf2DSL125UYb9Ktg@mail.gmail.com>
Message-ID: <CAK8P3a3vEBepxkP-UmcpHHqrpq2m3woxyxVf2DSL125UYb9Ktg@mail.gmail.com>
Subject: Re: [Y2038] [PATCH 7/8] ppdev: fix PPGETTIME/PPSETTIME ioctls
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:+tdk/Jxu8GkFAzuWtdQicNRB88arDy2lXjJUe7zhrg85K64PPvv
 LwBHnUXcTuZXyyNnVCaacXdS/2SQJotqxcUAnGwB+ZjUFsPNdh+ikPFeDw6acWT0B0lRF4X
 AuzX43yUGSAzF5kujdDYp2mHDOlUV2yHO8TdDBr3vyIuDIoKVdegdIsXTUaPaKmwUcv1Xh7
 2xWe/u0jqb6p58wUMCidg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:S/SclWgH6Nw=:+PtMHx2iRJqE6DCC5AV8IT
 ORAmRXIDHjP/LqbvXgLJr4id1/5iQ3MkqMmPj2mNfDkwpFER5ZJ57JW0pBcHKQO+bOyz5tuhX
 lDVeX8vIaOasXVyXi8vvQzq6aMZX9qGIVERUTLG1ZFnSdWz7hDuzQWHxWtUZ049ds0a0YN/mO
 TSJMejtr6TZyRFB71ngmZqTEdnNipsN5/ZoNqzUHN3FWEC9+2/Q+Y/yd+YgIccJl9TtmYpA5X
 wycmeLyCoKckpsPUXhyiocNTLAz0JUdwf2RDYU4HNIY9a5zqxBqicPHm+F6+lDo752SbuuWk5
 4+74Zlwej2S2ET4IPn89VrqGebUkzgnJviWGw6XiPzXRbXQ6d7t7bIfck1ZL0c3MUpBJrGqt7
 XhQInWInebTxk8585Xc2XI8Zb21wDcNKoao6YNqiUpZOOLf20qcgTF9xDIYUdjR+jC0iZY0td
 HF8ClmoIKySpI9sLcbL9j8VgNMsDq0HjC+Jdif5kuzqZngYP3GBQ/iZZ6O92aXkVrQFKU9kAQ
 4ygurkAoSBdAe/YaAPBqsZmIh0daFtVr5Z2lASP1It6JADk6gghhYuunknRulgBMRIx9j5L7d
 TJBOJClAVchSUy2AFb51FhfxH47dxm8XQqHIRyzF9HQzv3C/UGzVZJRL8dDlUbKgFmMztppul
 Syyjw9L74d2SO1iTR13NefD4BVNx9v1eCWh0Q8wQqXKLkZmdSofc2TetV7owRwdlAywNzqo0h
 s8CQfIJki4YpkP1MzOmSCUT93tfE8YJEkpVqL+kQqNSVMo0TMkVFUraNA7C+pTWG18DPrKkQy
 SakQxhgWzXAnU+W5emvwC8tOtzM9ye5kUqrUBZ+PVcxgtzqHhAIwBHlhtthmQ4n3ulVlWkcQn
 BoJAc3oMDjKVKtsW+UAw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 20, 2019 at 8:29 PM Ben Hutchings
<ben.hutchings@codethink.co.uk> wrote:
>
> On Fri, 2019-11-08 at 21:34 +0100, Arnd Bergmann wrote:
> > Going through the uses of timeval in the user space API,
> > I noticed two bugs in ppdev that were introduced in the y2038
> > conversion:
> >
> > * The range check was accidentally moved from ppsettime to
> >   ppgettime
> >
> > * On sparc64, the microseconds are in the other half of the
> >   64-bit word.
> >
> > Fix both, and mark the fix for stable backports.
>
> Like the patch for lpdev, this also doesn't completely fix sparc64.

I think the same applies as in the other patch:

- it actually works correctly because of the alignment
- it's already merged in linux-next
- if you wish, I can add another cleanup patch on top, but I'd
  prefer to just leave it as it is.

      Arnd
