Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831DD2AAC23
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 17:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgKHQRV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 8 Nov 2020 11:17:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:55549 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727570AbgKHQRV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Nov 2020 11:17:21 -0500
IronPort-SDR: mKCd1juH7vxvASpt0r080pgNAk+ZfIvYbfB0+NUhHlZuSHQITugBw/qhFXi1LfKhKhhgVXDuST
 uS6O+coJtYbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="166203565"
X-IronPort-AV: E=Sophos;i="5.77,461,1596524400"; 
   d="scan'208";a="166203565"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 08:17:20 -0800
IronPort-SDR: 3ZxeBRFZbMMreUPvHJJ2Ey+k68QI4ilDh52fFEYPUHmS+T3RX9hoaDFVFU9CfgmXCMsgWfAg47
 omc+luBodAOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,461,1596524400"; 
   d="scan'208";a="540502546"
Received: from irsmsx604.ger.corp.intel.com ([163.33.146.137])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2020 08:17:17 -0800
Received: from irsmsx601.ger.corp.intel.com (163.33.146.7) by
 IRSMSX604.ger.corp.intel.com (163.33.146.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 8 Nov 2020 16:17:16 +0000
Received: from irsmsx601.ger.corp.intel.com ([163.33.146.7]) by
 irsmsx601.ger.corp.intel.com ([163.33.146.7]) with mapi id 15.01.1713.004;
 Sun, 8 Nov 2020 16:17:16 +0000
From:   "Rojewski, Cezary" <cezary.rojewski@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Gorski, Mateusz" <mateusz.gorski@linux.intel.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@kernel.org>
Subject: RE: [PATCH] ASoC: Intel: Skylake: Add alternative topology binary
 name
Thread-Topic: [PATCH] ASoC: Intel: Skylake: Add alternative topology binary
 name
Thread-Index: AQHWsesetrmyqB6A606/K4JDH1AqQKm2iiKAgAFSVACAAAM7AIAGkXhQ
Date:   Sun, 8 Nov 2020 16:17:16 +0000
Message-ID: <0f6a673556974a289c2b81f3a8cc7536@intel.com>
References: <20201103141047.15053-1-mateusz.gorski@linux.intel.com>
 <20201103153541.GC3267686@kroah.com>
 <d6006431-420f-55c7-0f78-977507e11fcf@linux.intel.com>
 <20201104115810.GA1694250@kroah.com>
In-Reply-To: <20201104115810.GA1694250@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [163.33.253.164]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-11-04 12:58 PM, Greg KH wrote:
> On Wed, Nov 04, 2020 at 12:46:36PM +0100, Gorski, Mateusz wrote:
>>
>>>> [ Upstream commit 1b290ef023b3eeb4f4688b582fecb773915ef937 ]
>>>>
>>>> Add alternative topology binary file name based on used machine driver
>>>> and fallback to use this name after failed attempt to load topology file
>>>> with name based on NHLT.
>>>> This change addresses multiple issues with current mechanism, for
>>>> example - there are devices without NHLT table, and that currently
>>>> results in tplg_name being empty.
...

>>> What problems are people facing, and what kernel(s) are you asking for
>>> this to be ported to, and why can't people just use 5.8 or newer if they
>>> have this new hardware?
>>>
>>
>> I forgot to add - I wanted this change to be merged to stable 5.4 kernel.
>> Please let me know if I should resend this patch with this information
>> included.
>>
>> As for the user issues - topology binary file name is currently created
>> according to information from NHLT. The problem is, that some laptops (for
>> example Dell XPS 13) do not have NHLT at all. This results in topology
>> binary name being empty (" ").
>> This patch adds alternative name based on loaded machine driver.
>>
>> It applies not only to new hardware, please note that the mentioned Dell XPS
>> 13 is based on Kabylake. This issue existed on upstream from the beginning
>> of Skylake driver and was only recently addressed.
> 
> When was that laptop released and is this the only change that is needed
> in order for the 5.4.y kernel to work properly on it?
> 

Sorry for the late answer, Greg. To address your concerns and questions
let me elaborate:

Indeed, this change is not the only one required to enable DMIC + HDA
configuration for customers. The following series is essential:

[PATCH 0/7] ASoC: Intel: Skylake: Fix HDaudio and Dmic
https://lore.kernel.org/alsa-devel/20200305145314.32579-1-cezary.rojewski@intel.com/

as it's not just enabling said configuration, it is fixing several
issues along the road with /skylake and HDA. And the issues are
certainly not limited to just Dell XPS 13, these trouble many
SKL/KBL/AML laptop models available on the market - those where AudioDSP
configuration is enabled by default.

Backport presented in this very patch provided by Mateusz touches on yet
another subject. More often than not, incomplete -or- incorrect topology
binary is the cause of configuration issues and updating it usually
resolves them. Unfortunately, user needed to be very precise when naming
the new topology file. Name is quite complicated as it is based on data
coming from NHLT's (ACPI table) header. Asking user to either provide
their NHLT or decode the header themselves is inconvenient to say
the least. And thus alternative-topology-name patch came to life.

I'll check what's missing on v5.4.y and get to porting mentioned series.
Should happen early next week.

Thanks,
Czarek

