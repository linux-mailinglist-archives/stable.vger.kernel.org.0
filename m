Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0441332197
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 10:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhCIJFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 04:05:42 -0500
Received: from esa5.hc3370-68.iphmx.com ([216.71.155.168]:35948 "EHLO
        esa5.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhCIJFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 04:05:12 -0500
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2021 04:05:12 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1615280712;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ucEyClNY7Tik8Yk7WI9RZer5oJR2JMMqQHVmFQC9FDE=;
  b=QVONzvvlN7I7XsaRYUQCGNmh2ULqBq9zQrA/TQ0S0pkRkKnWaTW8SCrZ
   gj/21jE5kFIp2NMtw2vpwEMoosCY/AHJUiydPKRfTf4V1VlPDFtZB45HP
   AASZbA5TUuSthGPTvhPSpBuxjn/L6gxGBBuaXLPfAyVJj3/KEYOGIutr8
   w=;
Authentication-Results: esa5.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: ifhYFTrHtVgd68c/XUGtBuHNjVRWo6LfOxF3XIc6nQNmeHSBls/AkrbJ89p6twz1cYS0qfTMYE
 8tm4S8oS6YFEHMWGJKuMwDAScH2anoCglpbi60qWwpVBQcBGKwPYm/A0aEeGbZ0OfFdfGCxVHB
 vTkzH4T5pVvmrmdoHlz1NFEYy/WZD59qZSW6ilFF8vw6GqX2T6sJmQVlPCrcKpYXvQI3Netdin
 SS2On1Z3Azsqs9QyW25t8LjPLwIcVK1udb23wbHb6LXikGmvqMqYehSQ5PxdYJL3zywqd/12FN
 xtU=
X-SBRS: 4.0
X-MesageID: 38751923
X-Ironport-Server: esa5.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.81,234,1610427600"; 
   d="scan'208";a="38751923"
Subject: Re: [PATCH v4 2/3] xen/events: don't unmask an event channel when an
 eoi is pending
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
From:   Ross Lagerwall <ross.lagerwall@citrix.com>
Message-ID: <b6d41422-47cf-956c-9c4a-98998c64b103@citrix.com>
Date:   Tue, 9 Mar 2021 08:57:23 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <d6a1ab2e-4b77-7b14-e397-74aa71efb70d@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-09 05:14, Jürgen Groß wrote:
> On 08.03.21 21:33, Boris Ostrovsky wrote:
>>
>> On 3/6/21 11:18 AM, Juergen Gross wrote:
>>> An event channel should be kept masked when an eoi is pending for it.
>>> When being migrated to another cpu it might be unmasked, though.
>>>
>>> In order to avoid this keep three different flags for each event channel
>>> to be able to distinguish "normal" masking/unmasking from eoi related
>>> masking/unmasking and temporary masking. The event channel should only
>>> be able to generate an interrupt if all flags are cleared.
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 54c9de89895e0a36047 ("xen/events: add a new late EOI evtchn framework")
>>> Reported-by: Julien Grall <julien@xen.org>
>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>> Reviewed-by: Julien Grall <jgrall@amazon.com>
>>> ---
>>> V2:
>>> - introduce a lock around masking/unmasking
>>> - merge patch 3 into this one (Jan Beulich)
>>> V4:
>>> - don't set eoi masking flag in lateeoi_mask_ack_dynirq()
>>
>>
>> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>
>>
>> Ross, are you planning to test this?
> 
> Just as another data point: With the previous version of the patches
> a reboot loop of a guest needed max 33 reboots to loose network in
> my tests (those were IIRC 6 test runs). With this patch version I
> stopped the test after about 1300 reboots without having seen any
> problems.
> 

Thanks, I'll test it today and get back to you.

Ross
