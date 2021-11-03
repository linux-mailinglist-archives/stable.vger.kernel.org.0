Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC99E4443CC
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 15:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhKCOrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 10:47:23 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:40352 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhKCOrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 10:47:22 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1A3EieVX008169;
        Wed, 3 Nov 2021 09:44:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1635950680;
        bh=3VlKYAYGeekLvefX8uPnEKHFYx4A386Rsik+RAkABuA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=oQf4J0mILH6oxE2oIoGQ8nJtaRHDEtBWkDefuQIQBOwgakutwDtpvwIJSeNCLrbqw
         BlxQ/iaLQoUoZmf01y4al8hNjUgf4/IjTZLlW0MreEPG6qpGmc3lBsSDWjK8c8WpRr
         1f+VOzi8IgYQWK5B4dEol5S53VOW6S+phw+QM1bg=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1A3EieF7129195
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 3 Nov 2021 09:44:40 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 3
 Nov 2021 09:44:39 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 3 Nov 2021 09:44:39 -0500
Received: from [10.250.233.204] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1A3EiaoU077528;
        Wed, 3 Nov 2021 09:44:37 -0500
Subject: Re: 5.14.14+ USB regression caused by "usb: core: hcd: Add support
 for deferring roothub registration" series
To:     Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
CC:     <stable@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <chris.chiu@canonical.com>, Mathias Nyman <mathias.nyman@intel.com>
References: <42bcbea6-5eb8-16c7-336a-2cb72e71bc36@redhat.com>
 <YYJRRg8QDBfy2PP7@kroah.com>
 <9e1abe71-d903-f227-38ae-a854ab9e5baf@redhat.com>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <5c95597b-289b-ea1c-4770-8be9e8511ae0@ti.com>
Date:   Wed, 3 Nov 2021 20:14:35 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9e1abe71-d903-f227-38ae-a854ab9e5baf@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Alan, Chris, Mathias, linux-usb

Hi Hans,

On 03/11/21 6:18 pm, Hans de Goede wrote:
> Hi,
> 
> On 11/3/21 10:07, Greg Kroah-Hartman wrote:
>> On Wed, Nov 03, 2021 at 10:02:52AM +0100, Hans de Goede wrote:
>>> Hi Greg,
>>>
>>> We (Fedora) have been receiving multiple reports about USB devices stopping
>>> working starting with 5.14.14 .
>>>
>>> An Arch Linux user has found that reverting the first 2 patches from this series:
>>> https://lore.kernel.org/all/20210909064200.16216-1-kishon@ti.com/
>>>
>>> Fixes things (the 3th patch is just some mostly unrelated refactoring/cleanup).
>>>
>>> See here for the Arch-linux discussion surrounding this:
>>> https://bbs.archlinux.org/viewtopic.php?pid=2000956#p2000956
>>>
>>> And here are 2 Fedora bug reports of Fedora users being unable to use their
>>> machines due their mouse + kbd not working:
>>>
>>> https://bugzilla.redhat.com/show_bug.cgi?id=2019542
>>> https://bugzilla.redhat.com/show_bug.cgi?id=2019576
>>>
>>> Can we get this patch-series reverted from the 5.14.y releases please ?
>>
>> Sure,
> 
> Thanks.
> 
>> but can you also submit patches to get into 5.15.y and 5.16-rc1
>> that revert these changes as they should still be an issue there, right?
> 
> Yes I assume this is still an issue there too, but I was hoping that
> Kishon can take a look and maybe actually fix things, since just
> reverting presumably regresses whatever these patches were addressing.
> 
> We've aprox 1-3 weeks before distros like Arch and Linux will switch
> to 5.15.y kernels.  So we have some time to come up with a fix
> there, where as for 5.14.y this is hitting users now.

Is the issue with PCIe USB devices or platform USB device? Is it specific to
super speed devices or high speed device?

Thanks,
Kishon
