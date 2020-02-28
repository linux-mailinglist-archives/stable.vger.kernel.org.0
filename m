Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E95C81736ED
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 13:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgB1MMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 07:12:43 -0500
Received: from mail1.ugh.no ([178.79.162.34]:54600 "EHLO mail1.ugh.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgB1MMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 07:12:42 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Feb 2020 07:12:42 EST
Received: from localhost (localhost [127.0.0.1])
        by mail1.ugh.no (Postfix) with ESMTP id 26943250BAB;
        Fri, 28 Feb 2020 13:06:01 +0100 (CET)
Received: from mail1.ugh.no ([127.0.0.1])
        by localhost (catastrophix.ugh.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CWY9zWlYCLhq; Fri, 28 Feb 2020 13:06:00 +0100 (CET)
Received: from [10.255.64.11] (unknown [185.176.245.143])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: andre@tomt.net)
        by mail.ugh.no (Postfix) with ESMTPSA id 78AB1250B11;
        Fri, 28 Feb 2020 13:06:00 +0100 (CET)
Subject: Re: [PATCH 5.5 000/150] 5.5.7-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200227132232.815448360@linuxfoundation.org>
From:   Andre Tomt <andre@tomt.net>
Message-ID: <d6212f9e-7e8d-95bd-18ca-8c44de224b28@tomt.net>
Date:   Fri, 28 Feb 2020 13:06:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.02.2020 14:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.7 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.

There is something going on with USB in this release. My AMD X570 board 
is constantly having ports stop working, while a older AMD X399 board 
seems fine (maybe, there is an ATEN USB extender involved on the X570 
system)

I've only had time to do very rudimentary debugging, but reverting all 
usb and xhci related patches seems to have solved it, eg:

> usb-dwc2-fix-in-isoc-request-length-checking.patch
> usb-gadget-composite-fix-bmaxpower-for-superspeedplus.patch
> usb-dwc3-debug-fix-string-position-formatting-mixup-with-ret-and-len.patch
> usb-dwc3-gadget-check-for-ioc-lst-bit-in-trb-ctrl-fields.patch
> usb-dwc2-fix-set-clear_feature-and-get_status-flows.patch
> usb-hub-fix-the-broken-detection-of-usb3-device-in-smsc-hub.patch
> usb-hub-don-t-record-a-connect-change-event-during-reset-resume.patch
> usb-fix-novation-sourcecontrol-xl-after-suspend.patch
> usb-uas-fix-a-plug-unplug-racing.patch
> usb-quirks-blacklist-duplicate-ep-on-sound-devices-usbpre2.patch
> usb-core-add-endpoint-blacklist-quirk.patch
> xhci-fix-memory-leak-when-caching-protocol-extended-capability-psi-tables-take-2.patch
> xhci-apply-xhci_pme_stuck_quirk-to-intel-comet-lake-platforms.patch
> xhci-fix-runtime-pm-enabling-for-quirky-intel-hosts.patch
> xhci-force-maximum-packet-size-for-full-speed-bulk-devices-to-valid-range.patch
> usb-serial-ch341-fix-receiver-regression.patch
> usb-misc-iowarrior-add-support-for-the-100-device.patch
> usb-misc-iowarrior-add-support-for-the-28-and-28l-devices.patch
> usb-misc-iowarrior-add-support-for-2-oemed-devices.patch

I might be able to narrow it down in a day or two.
