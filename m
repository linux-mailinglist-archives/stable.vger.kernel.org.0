Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13725505A9E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 17:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244181AbiDRPMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 11:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345196AbiDRPMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 11:12:07 -0400
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAF336148;
        Mon, 18 Apr 2022 07:07:13 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd7616.dip0.t-ipconnect.de [93.221.118.22])
        by mail.itouring.de (Postfix) with ESMTPSA id CE356124EC0;
        Mon, 18 Apr 2022 16:07:11 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 7FD75F01601;
        Mon, 18 Apr 2022 16:07:11 +0200 (CEST)
Subject: Re: [PATCH 5.15 000/189] 5.15.35-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
References: <20220418121200.312988959@linuxfoundation.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <ec6408b7-14f4-fc97-3371-3f6cd9a46d24@applied-asynchrony.com>
Date:   Mon, 18 Apr 2022 16:07:11 +0200
MIME-Version: 1.0
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-04-18 14:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.35 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c: In function hubbub31_verify_allow_pstate_change_high':
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c:994:17: error: implicit declaration of function 'udelay' [-Werror=implicit-function-declaration]
   994 |                 udelay(1);
       |                 ^~~~~~

Caused by "drm-amd-display-add-pstate-verification-and-recovery-for-dcn31.patch".
Explicitly includng <linux/delay.h> in dcn31_hubbub.c fixes it.

Current mainline version of dcn31_hubbub.c does not explicitly include
<linux/delay.h>, so there seems to be some general inconsistency wrt.
which dcn module includes what.

CC'ing Nicholas Kazlauskas.

-h
