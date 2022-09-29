Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60AEA5EEE68
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 09:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbiI2HG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 03:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbiI2HGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 03:06:20 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3CA1114CA
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 00:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1664434802;
    s=strato-dkim-0002; d=garloff.de;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=AcI2rkfVeijKqXm1LJxGarnuPd5idq7pXYXFMaSTKTM=;
    b=dhUl5qED60qQxUSGwPt12hsUaXCU78ur5chSin/XprIVhGwrxLGIXgZHIzRE1YYA9U
    K2r2RQo5/qvAXLsIWvlrPeWf8zMAQJLijA9lyyMAev+6uDMDo5qTqvQUUAi3xd01hsAh
    aqZRCwXZeCIsA/OqlYddfloO5x8mgl07D+R1gYSUwCzw1bs5UaG3tN9vPW+eNaEkYiLx
    azHMPX6MLsuDNHj9AAWanliUXasi04BzgnG+R2jL7d2CH3wo5XOyHeNwNN0mx8EXxA46
    b1sejryklduKapG6dtT4VH21tGkaloFnys4wfXKw9kwf7ZDAf4DLSJvsGaiaRKZEQLlV
    apDg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":J3kWYWCveu3U88BfwGxYwcN+YZ41GOdzWdTW9IJoHV1zocjVWQ2FeSNmljTMRpK4ZL0="
X-RZG-CLASS-ID: mo00
Received: from mail.garloff.de
    by smtp.strato.de (RZmta 48.1.3 DYNA|AUTH)
    with ESMTPSA id t2737by8T70227e
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 29 Sep 2022 09:00:02 +0200 (CEST)
Received: from [192.168.155.202] (ap5.garloff.de [192.168.155.10])
        by mail.garloff.de (Postfix) with ESMTPSA id B61456302E;
        Thu, 29 Sep 2022 09:00:01 +0200 (CEST)
Message-ID: <34652266-06a6-b076-dec4-2abfa4c1b01b@garloff.de>
Date:   Thu, 29 Sep 2022 09:00:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: nfs_scan_commit: BUG: unable to handle page fault for address:
 000000001d473c07
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Sasha Levin <sashal@kernel.org>,
        "anna@kernel.org" <anna@kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "it+linux-nfs@molgen.mpg.de" <it+linux-nfs@molgen.mpg.de>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        Trond Myklebust <trondmy@hammerspace.com>
References: <c5d8485b-0dbc-5192-4dc6-10ef2b86b520@molgen.mpg.de>
 <e845f65cb78d31aa1982da4bc752ee2e5191f10f.camel@hammerspace.com>
 <ae96779e-e3a7-b4b5-78fc-e5b53d456ece@molgen.mpg.de>
 <ef08bf84da796db2a85549d882d655a370deb835.camel@hammerspace.com>
 <0e1263a1-9d3d-a6cf-deb7-197ab1eed437@leemhuis.info>
 <5dc1b00f-0451-bb0d-56e4-6c178d3c2ce7@garloff.de>
 <YzPvBLBTyISlNz4k@kroah.com>
Content-Language: en-US
From:   Kurt Garloff <kurt@garloff.de>
In-Reply-To: <YzPvBLBTyISlNz4k@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 28/09/2022 08:51, Greg KH wrote:
> On Tue, Sep 27, 2022 at 08:59:31PM +0200, Kurt Garloff wrote:
>> On 26/09/2022 08:00, Thorsten Leemhuis wrote:
>>
>>> Does cherry-picking commit 6e176d47160c ("NFSv4: Fixes for
>>>>>> nfs4_inode_return_delegation()") into 5.15.69 from the upstream
>>>>>> kernel
>>>>>> tree fix the problem?
>>>>>>
>>>>>> 8<---------------------------------------------------
>>>>>>   From 6e176d47160cec8bcaa28d9aa06926d72d54237c Mon Sep 17 00:00:00
>>>>>> 2001
>>>>>> From: Trond Myklebust <trond.myklebust@hammerspace.com>
>>>>>> Date: Sun, 10 Oct 2021 10:58:12 +0200
>>>>>> Subject: [PATCH] NFSv4: Fixes for nfs4_inode_return_delegation()
>>>>> […]
>>>>>
>>>>> Indeed with that commit, present since v5.16-rc1, we are unable to
>>>>> reproduce the issue, so it seems to be the fix. It looks like there
>>>>> are
>>>>> not a lot of 5.15 NFS users out there. ;-)
>>>>>
>>>> I believe this is a dependency that was introduced by the back port of
>>>> commit e591b298d7ec ("NFS: Save some space in the inode") into 5.15.68.
>>>> So the reason it wasn't seen is because the change is very recent.
>>> Side note: I wonder if that is causing this problem from Kurt as well:
>>> https://lore.kernel.org/all/f6755107-b62c-a388-0ab5-0a6633bf9082@garloff.de/
>> Looks like it:
>> After confirming that the 5.15.69 kernel worked again fine backing out
>> those last three NFS commits, I reapplied them and cherry-picked commit
>> 6e176d47160c as suggested. The kernel worked flawlessly thus far, so this
>> seems to indeed be a requirement for e591b298d7ec not to cause harm.
>> [...]
>> So by all means, Greg, please put this in the stable queue unless the
>> NFS wizards out there consider it safer to revert e591b298d7ec instead.
> Already queued up for the next 5.15.y release that will happen in a few
> hours, thanks for testing.

And -- unsurprisingly -- I can confirm that NFS in 5.15.71 does work again,
indeed.

Thanks!

-- 
Kurt Garloff <kurt@garloff.de>
Cologne, Germany




