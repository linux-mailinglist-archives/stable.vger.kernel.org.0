Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84E767DFCE
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 10:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbjA0JPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 04:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjA0JPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 04:15:15 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290407753A
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 01:15:14 -0800 (PST)
Received: from [2a02:8108:963f:de38:4bc7:2566:28bd:b73c]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pLKpC-00042p-Pj; Fri, 27 Jan 2023 10:15:10 +0100
Message-ID: <36e72298-e9d3-967e-8b14-7197719953cb@leemhuis.info>
Date:   Fri, 27 Jan 2023 10:15:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US, de-DE
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        stanislav.lisovskiy@intel.com, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        amd-gfx@lists.freedesktop.org, Wayne Lin <Wayne.Lin@amd.com>,
        Guenter Roeck <linux@roeck-us.net>, bskeggs@redhat.com
References: <20230112085044.1706379-1-Wayne.Lin@amd.com>
 <20230120174634.GA889896@roeck-us.net>
 <a9deecb3-5955-ee4e-c76f-2654ee9f1a92@amd.com> <Y9N/wiIL758c3ozv@kroah.com>
From:   "Linux kernel regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [PATCH] Revert "drm/display/dp_mst: Move all payload info into
 the atomic state"
In-Reply-To: <Y9N/wiIL758c3ozv@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1674810914;28913ce1;
X-HE-SMSGID: 1pLKpC-00042p-Pj
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.01.23 08:39, Greg KH wrote:
> On Fri, Jan 20, 2023 at 11:51:04AM -0600, Limonciello, Mario wrote:
>> On 1/20/2023 11:46, Guenter Roeck wrote:
>>> On Thu, Jan 12, 2023 at 04:50:44PM +0800, Wayne Lin wrote:
>>>> This reverts commit 4d07b0bc403403438d9cf88450506240c5faf92f.
>>>>
>>>> [Why]
>>>> Changes cause regression on amdgpu mst.
>>>> E.g.
>>>> In fill_dc_mst_payload_table_from_drm(), amdgpu expects to add/remove payload
>>>> one by one and call fill_dc_mst_payload_table_from_drm() to update the HW
>>>> maintained payload table. But previous change tries to go through all the
>>>> payloads in mst_state and update amdpug hw maintained table in once everytime
>>>> driver only tries to add/remove a specific payload stream only. The newly
>>>> design idea conflicts with the implementation in amdgpu nowadays.
>>>>
>>>> [How]
>>>> Revert this patch first. After addressing all regression problems caused by
>>>> this previous patch, will add it back and adjust it.
>>>
>>> Has there been any progress on this revert, or on fixing the underlying
>>> problem ?
>>>
>>> Thanks,
>>> Guenter
>>
>> Hi Guenter,
>>
>> Wayne is OOO for CNY, but let me update you.
>>
>> Harry has sent out this series which is a collection of proper fixes.
>> https://patchwork.freedesktop.org/series/113125/
>>
>> Once that's reviewed and accepted, 4 of them are applicable for 6.1.
> 
> Any hint on when those will be reviewed and accepted?  patchwork doesn't
> show any activity on them, or at least I can't figure it out...

I didn't look closer (hence please correct me if I'm wrong), but the
core changes afaics are in the DRM pull airlied send a few hours ago to
Linus (note the "amdgpu […] DP MST fixes" line):

https://lore.kernel.org/all/CAPM%3D9tzuu4xnx6T5v7sKsK%2BA5HEaPOc1ieMyzNSYQZGztJ%3D6Qw@mail.gmail.com/

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
