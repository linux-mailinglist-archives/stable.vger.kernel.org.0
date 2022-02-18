Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9AD4BAE21
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 01:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiBRAHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 19:07:12 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiBRAHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 19:07:11 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E571550443;
        Thu, 17 Feb 2022 16:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1645142809;
        bh=GcOoDAx2rbLVn7mNmte+Od4jQktU4RdM2z+LxrfaAzA=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=l2cHauipbh1X09XzRe6aqijg8/UWg3AB4cFxY1yTys6PV3x+HnNtscTGwESovAH9E
         gafe8rGebSo/GofFt8oaByCxOhvcqR+kPOrSLxOlEz189vdOMQNEPBBtVcX6kTzJxh
         6TBNybkHhumbw0fX6Uxw72BZ9V2uQX0ceAghcctM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M8QS2-1nPGdk2gIS-004WU0; Fri, 18
 Feb 2022 01:06:49 +0100
Message-ID: <72e5d922-dff9-c564-e4f1-11413cc745fd@gmx.com>
Date:   Fri, 18 Feb 2022 08:06:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH for v5.15 1/2] btrfs: don't hold CPU for too long when
 defragging a file
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Cc:     Qu Wenruo <wqu@suse.com>, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
References: <cover.1644994950.git.wqu@suse.com>
 <67dd6f0e69c59a8554d7a2977939f94221af00c1.1644994950.git.wqu@suse.com>
 <Yg6bcq2stNcvDLOv@kroah.com>
 <60159313-2228-77e1-3748-97891a8e8f2e@applied-asynchrony.com>
 <Yg6mplO5BeK5kC7w@kroah.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <Yg6mplO5BeK5kC7w@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:v8wsv9O1ap8S5Xf6qdpdRIgHCfGduZeXphqfs2GVbb5RaKe/Ubw
 luBObrpFXYsppzOIRypBemXWYncHeh28v/sOYZHelI/a8de+D25ge+UyofMDusAY7LuQqZ7
 0PPZqF9guwyAa97VajjABdQ2sX2IKleFkH9gIoJiXipuSdpMiu4xBCrqK9dAOojrnGYeXv2
 F8FhtT8keggyPfCIInp1g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZV60SqkoEHA=:y3Eh0jNcrCQ09ESUZ1VIbd
 EaPYn/xtpRGBODqgFN4gEBUmpntLreZelwRFmR2jnEKSjvr+7pn8CHAyLMDUvchH9sEVx+vhJ
 G002iY/jzDU7F68l63R7dsjk3fKSL8G7IH6kMMtUZdY1y90mGAFuLN4o230OazrhIhIGpUz2x
 CncyO4xmCFDYF+3O2N3tASL8G0XxpzO8mJMvmoit3P4i6HWke1gZI8VuYlEP4B1WmQbtJ62KJ
 h43q9BoyAE6oJF/oUClLOSIx6jYrUpUQfGCrUfDHKf67cA3ju7icTU/ofTRgOTxH3VyiY7pNX
 40SgcA9QIkwzdNv41rqlyeTaaIPYwveOZbdHxYEB4hxqaOm3xssOK4XTv1YjbqdwORklcK29n
 ZeQIk2Kq3UwPIXtqoyl1acj1zssM0V4L7vcMCI9Kv2injJgoZjlUKPFuqCgdejjqb13Sm3vGG
 4cU4zp8KDZPj0rqUzIxHgxaKf2Maxid02OGcsMAwGJdcU9vo/LOYmQnrLZi9YY31FhJFoTC5r
 3ATvCNOZ8NHXUVi6u++DsCBECvN6AYi1/UIOav4EF6hz4LafW2OQe9t6JOHVhec2+4DX5Srgq
 mMi2SLKzGiwhTM38jkitw3kdEDVkrkxYS7HMlvAon0/xXwEfC/G2SZ/mge1PRmlT0hnrRe8mO
 XJQeDfZfn0WR4fXlKVMmCKoiZzoy2o0AsdDTSV5wUey+lv9Y1UbkMsRO8ubK+DiV6ap00ugTO
 0qhhUW9A+vgl/g4EOTnwdtpc5VcJxGnOPnRJJhvnDb0ZC8HQib8gx9Fq15tW+uNW7wuRDI4dR
 Uqpw9PDgYgVuWTOqxi+J5Ry8RD/RMQnGiJHawdPY+zQBzNgUtenrXaxd6efKZlQOCQzpyv8kM
 dwVbLP+ZkfIToRAJq9mtR5hnF0dcnOUoE+8EYs6MbSiGCPDHpBeUAhe5GG+qyV9Oe8ftMG/Li
 zcHEh/IrDw2483tnCCTLy2765GCopRABCsHecZcVAPQ90dfJTwG4jZvJ5jjM215OiMpMyp7WR
 uE+af1c2FHRjWwYVWLBtwpiWDZsNz2+ESI1zt8aYcYLm3mKGNpM4YpiUvM4Ke8Bq4aOi6tJ1C
 DQCm+YxR5Cqb/w=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/2/18 03:48, Greg KH wrote:
> On Thu, Feb 17, 2022 at 08:41:51PM +0100, Holger Hoffst=C3=A4tte wrote:
>> On 2022-02-17 20:01, Greg KH wrote:
>>> On Wed, Feb 16, 2022 at 03:09:07PM +0800, Qu Wenruo wrote:
>>>> commit 2d192fc4c1abeb0d04d1c8cd54405ff4a0b0255b upstream.
>>>
>>> This commit is already in 5.15.22.
>>
>> It most certainly is not
>
> Commit 2d192fc4c1abeb0d04d1c8cd54405ff4a0b0255b is in 5.15.22.
>
>> since it applies cleanly in 5.15.24.
>> The correct upstream commit of this patch is ea0eba69a2a8125229b1b60116=
44598039bc53aa
>
> Ah, no wonder the confusion.  For obvious reasons, I can not take this
> as-is :)

My bad, wrong commit hash...

>
> thanks,
>
> greg k-h
