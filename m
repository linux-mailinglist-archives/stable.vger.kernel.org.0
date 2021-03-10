Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6F7333855
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 10:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhCJJJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 04:09:18 -0500
Received: from esa3.hc3370-68.iphmx.com ([216.71.145.155]:32749 "EHLO
        esa3.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbhCJJJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 04:09:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1615367349;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=4VmRMA+z46nfmAF79aPtxD7G3DEltQtHlbCtG5CBYG4=;
  b=Oq+822VZ5t8P44vyOUntHqzho2aGrkWNEYrjMLxAg/hOhCwevf7ur+C8
   Q78qeD/eqetdQdwtEdS5j5ooAZd7aISCyAMHCfpXgu7ZhJpSvImbUdKVK
   arJ9t6mqbuUKAHiC4do5BO82ld79tSGMzcDaLaJufYyvbj7v7Ghktwwvl
   Q=;
Authentication-Results: esa3.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: +BTeAh8Uamfyx7JXECtHe4MHBr+LasAM5IXnbCFVbC7EHr7AXjhpZ2DwltkQWS/F20JUriuzsK
 yA5Ums4mSHCc8c4kJo1ffSBruToMR/0xTG6++UDBIcucvS/OvayHRSpbeMhDloJihYTntaNyfa
 jqEn4uvZWBAZ+riECrRqYQ3GbIVyT8sXD7xh9a04GX7/ut8T9qZklS1VhoeCKg5MZXjDg8V1Yx
 2w+5DjAbQJ9y7wGBDeYwVdahccCzVTRTFQyNi3lPb7BZqcVSOErEkrrdzjhPrJtpRcNvfkEfvQ
 zxE=
X-SBRS: 4.0
X-MesageID: 38931597
X-Ironport-Server: esa3.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.81,237,1610427600"; 
   d="scan'208";a="38931597"
Subject: Re: [PATCH v4 2/3] xen/events: don't unmask an event channel when an
 eoi is pending
From:   Ross Lagerwall <ross.lagerwall@citrix.com>
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
CC:     Stefano Stabellini <sstabellini@kernel.org>,
        <stable@vger.kernel.org>, Julien Grall <julien@xen.org>,
        Julien Grall <jgrall@amazon.com>
References: <20210306161833.4552-1-jgross@suse.com>
 <20210306161833.4552-3-jgross@suse.com>
 <ff9fb99f-12ca-c04e-e4bc-1b1c67381cc2@oracle.com>
 <d6a1ab2e-4b77-7b14-e397-74aa71efb70d@suse.com>
 <b6d41422-47cf-956c-9c4a-98998c64b103@citrix.com>
Message-ID: <3880be9d-1176-8beb-b192-20078cd39038@citrix.com>
Date:   Wed, 10 Mar 2021 09:08:34 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <b6d41422-47cf-956c-9c4a-98998c64b103@citrix.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-09 08:57, Ross Lagerwall wrote:
> On 2021-03-09 05:14, Jürgen Groß wrote:
>> On 08.03.21 21:33, Boris Ostrovsky wrote:
>>>
>>> On 3/6/21 11:18 AM, Juergen Gross wrote:
>>>> An event channel should be kept masked when an eoi is pending for it.
>>>> When being migrated to another cpu it might be unmasked, though.
>>>>
>>>> In order to avoid this keep three different flags for each event channel
>>>> to be able to distinguish "normal" masking/unmasking from eoi related
>>>> masking/unmasking and temporary masking. The event channel should only
>>>> be able to generate an interrupt if all flags are cleared.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 54c9de89895e0a36047 ("xen/events: add a new late EOI evtchn framework")
>>>> Reported-by: Julien Grall <julien@xen.org>
>>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>>> Reviewed-by: Julien Grall <jgrall@amazon.com>
>>>> ---
>>>> V2:
>>>> - introduce a lock around masking/unmasking
>>>> - merge patch 3 into this one (Jan Beulich)
>>>> V4:
>>>> - don't set eoi masking flag in lateeoi_mask_ack_dynirq()
>>>
>>>
>>> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>>
>>>
>>> Ross, are you planning to test this?
>>
>> Just as another data point: With the previous version of the patches
>> a reboot loop of a guest needed max 33 reboots to loose network in
>> my tests (those were IIRC 6 test runs). With this patch version I
>> stopped the test after about 1300 reboots without having seen any
>> problems.
>>
> 
> Thanks, I'll test it today and get back to you.
> 

Tested-by: Ross Lagerwall <ross.lagerwall@citrix.com>

The updated patch seems fine in testing.

Thanks
Ross
