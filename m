Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F044D004E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 14:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbiCGNmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 08:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbiCGNmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 08:42:11 -0500
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7284185BE3;
        Mon,  7 Mar 2022 05:41:17 -0800 (PST)
Received: from tux.applied-asynchrony.com (p5ddd7616.dip0.t-ipconnect.de [93.221.118.22])
        by mail.itouring.de (Postfix) with ESMTPSA id D115711DD40;
        Mon,  7 Mar 2022 14:41:15 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 8663DF01605;
        Mon,  7 Mar 2022 14:41:15 +0100 (CET)
Subject: Re: [PATCH 5.15 000/262] 5.15.27-rc1 review
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Sasha Levin <sashal@kernel.org>
References: <20220307091702.378509770@linuxfoundation.org>
 <fe8b46f5-6c24-d749-668f-29ea51fa5d58@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <5e048582-5c63-38c2-bbcb-6a0c20cb47e4@applied-asynchrony.com>
Date:   Mon, 7 Mar 2022 14:41:15 +0100
MIME-Version: 1.0
In-Reply-To: <fe8b46f5-6c24-d749-668f-29ea51fa5d58@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-03-07 11:44, Holger Hoffstätte wrote:
> On 2022-03-07 10:15, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.27 release.
>> There are 262 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn301/dcn301_fpu.o
> drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn301/dcn301_fpu.c:30:10: fatal error: dml/dcn20/dcn20_fpu.h: No such file or directory
>     30 | #include "dml/dcn20/dcn20_fpu.h"
>        |          ^~~~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> 
> Culprit is "drm-amd-display-move-fpu-associated-dcn301-code-to-d.patch"
> 
> Looking over the git history of the dml/dnc20 directory I think the correct fix would
> be to also apply upstream commit ee37341199c61558b73113659695c90bf4736eb2 aka
> "drm/amd/display: Re-arrange FPU code structure for dcn2x"
> 
> CC'ing Qingqing Zhuo for confirmation.

I can confirm that applying a modified ee37341199c6 fixes the issue. \o/
The hunk that refers to drivers/gpu/drm/amd/display/dc/dcn201 needs to be removed,
since that directory (support for "cyan_skillfish") does not exist in 5.15.x.

cheers
Holger
