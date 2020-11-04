Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F5A2A62C4
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 11:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgKDK6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 05:58:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbgKDK6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 05:58:42 -0500
Received: from saruman (88-113-213-94.elisa-laajakaista.fi [88.113.213.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1737E20867;
        Wed,  4 Nov 2020 10:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604487521;
        bh=xki9bngSa4snlKbOvPlqi/0KUccXUedV0J7hHCCzcOw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=g8vUvK2Ge8OOSCUrk3Ry/IgFLWrPqzt2RbTYXEHsvoCwoIKt4yS1HPI9/70XHZkf9
         0q9E4qNjnK30JPnhPUQm0+AXsmohqC4K5GuoS9j847iEh9qVmPrH112LwYpQ05v93W
         q84Fmjc7hBfh54adp6LQh+3RmCNRzj3ZuizTKF+8=
From:   Felipe Balbi <balbi@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 5.9 000/391] 5.9.4-rc1 review
In-Reply-To: <CA+G9fYsrppNwC0S4vkrS8jGW4k2fgmbAzy=oMLV6X9=DHkznpw@mail.gmail.com>
References: <20201103203348.153465465@linuxfoundation.org>
 <CA+G9fYsrppNwC0S4vkrS8jGW4k2fgmbAzy=oMLV6X9=DHkznpw@mail.gmail.com>
Date:   Wed, 04 Nov 2020 12:58:33 +0200
Message-ID: <87mtzxqtgm.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

Naresh Kamboju <naresh.kamboju@linaro.org> writes:

> On Wed, 4 Nov 2020 at 02:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.9.4 release.
>> There are 391 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch=
-5.9.4-rc1.gz
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git linux-5.9.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>
> Results from Linaro=E2=80=99s test farm.
> No regressions on arm64, arm, x86_64, and i386.
>
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> NOTE:
> The kernel warning noticed on arm64 nxp ls2088 device with KASAN config
> enabled while booting the device. We are not considering this as regressi=
on
> because this is the first arm64 KASAN config enabled on nxp ls2088 device.
>
> [    3.301882] dwc3 3100000.usb3: Failed to get clk 'ref': -2
> [    3.307433] ------------[ cut here ]------------
> [    3.312048] dwc3 3100000.usb3: request value same as default, ignoring

fix your DTS :-)

You're requesting to change a register value that shouldn't be changed
(it should be properly set during coreConsultant
instantiation). Whenever the requested value is the same as the reset
value of the register we WARN to let users know that the register
shouldn't be touched.

--=20
balbi
