Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5332A0B92
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 17:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgJ3Qph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 12:45:37 -0400
Received: from schatzi.steelbluetech.co.uk ([92.63.139.240]:42757 "EHLO
        schatzi.steelbluetech.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbgJ3Qph (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 12:45:37 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Oct 2020 12:45:37 EDT
Received: from [10.0.5.25] (tv.ehuk.net [10.0.5.25])
        by schatzi.steelbluetech.co.uk (Postfix) with ESMTP id 89D72BFBC4;
        Fri, 30 Oct 2020 16:39:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.10.3 schatzi.steelbluetech.co.uk 89D72BFBC4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ehuk.net; s=default;
        t=1604075963; bh=KvsvgqsUoKW97rC5X8q/vTeBR02YT9qoeTJpH/Pc2XY=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=uVRjAUx6OV/pDmE/itYaVqE0jo4E7Xpocb1pUdZsnnN2lZtMV6Trv/tAPcQRJ57Ay
         6Qcx1HsU4p/QdZdrInJzb6nXLwkhqXyuf+6og5iM/9spTsMEC3tR6CcEXg9qOPKAQC
         PP0SyESbLkuVmt7zDP7Fbm09hTwotwgPzipuBrDQ=
Reply-To: eddie@ehuk.net
Subject: Re: Linux 4.19.153
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net, jslaby@suse.cz
References: <160396822019115@kroah.com> <20201030082653.GA29475@amd>
 <20201030084915.GB1625087@kroah.com> <20201030091416.GA1759200@kroah.com>
 <20201030144438.GH87646@sasha-vm>
From:   Eddie Chapman <eddie@ehuk.net>
Message-ID: <7cd7053d-bf03-42a2-b4e7-bc2ff547d65b@ehuk.net>
Date:   Fri, 30 Oct 2020 16:39:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201030144438.GH87646@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/10/2020 14:44, Sasha Levin wrote:
> On Fri, Oct 30, 2020 at 10:14:16AM +0100, Greg Kroah-Hartman wrote:
>> On Fri, Oct 30, 2020 at 09:49:15AM +0100, Greg Kroah-Hartman wrote:
>>> On Fri, Oct 30, 2020 at 09:26:54AM +0100, Pavel Machek wrote:
>>> > Hi!
>>> >
>>> > > I'm announcing the release of the 4.19.153 kernel.
>>> > >
>>> > > All users of the 4.19 kernel series must upgrade.
>>> > >
>>> > > The updated 4.19.y git tree can be found at:
>>> > >     
>>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git 
>>> linux-4.19.y
>>> > > and can be browsed at the normal kernel.org git web browser:
>>> > >     
>>> https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary 
>>>
>>> >
>>> > Did something go seriously wrong here?
>>> >
>>> > The original 4.19.153-rc1 series had 264 patches. "powerpc/tau: Remove
>>> > duplicated set_thresholds() call" is 146/264 of the series, but it is
>>> > last one in 4.19.153 as released. "178/264 ext4: limit entries
>>> > returned when counting...", for example, is not present in
>>> > 4.19.153... as are others, for example "net: korina: cast KSEG0
>>> > address to pointer in kfree". Looks like 118 or so patches are
>>> > missing.
>>> >
>>> > They are not in origin/queue/4.19, either.
>>>
>>> Wow, something did go wrong here, thanks for catching this.
>>>
>>> Let me dig and see what happened, the whole series did not apply, which
>>> makes me wonder if the same thing happened for other branches as well...
>>>
>>> thanks for checking up and finding this.
>>>
>>> Give me a bit...
>>
>> Ok, figure3d it out.
>>
>> Sasha changed a powerpc patch to build properly but didn't realize that
>> later powerpc patches would not apply because of that.  I didn't run my
>> "apply all patches to make sure they are clean" script before doing the
>> release after he did that, so 'git quiltimport' failed when applying the
>> series at the place where the powerpc path failed to apply.
>>
>> My scripts don't check for the result of 'git quiltimport' being
>> successful or not (I don't even know if it return an error for this type
>> of thing), and just moved on in the release process.
>>
>> I'll go do a new 4.19 release with the rest of the patches missed here,
>> thank you for finding this.
>>
>> And I'll go make my release scripts more robust to failures like this as
>> well.
>>
>> thanks so much!
> 
> You're right, sorry :( And thanks Pavel!

Hey Greg and Sasha, just want to express my gratitude for all the work 
you guys do maintaining a gazillion stable kernels :-) There is bound to 
be a hiccup in the process every once in a while.
