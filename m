Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840155065EF
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 09:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349413AbiDSHfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 03:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349407AbiDSHf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 03:35:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6554DF75;
        Tue, 19 Apr 2022 00:32:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 20DC1CE12DE;
        Tue, 19 Apr 2022 07:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAF5C385A5;
        Tue, 19 Apr 2022 07:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650353564;
        bh=AtLdnmmiZNlurJGrTnfMD9k/HdsS6uYM11PWqEV6XUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HXloVfp/8DIYPKJm98sOldFXbJrUduZwOFukmS1GAl4E8JHhHkpIIgFLos6tPkm9D
         RLUIKjFJJw0PFO0KyUOMsdQ9Pu/14IrQCuSm4kyJiu40Ip6YhVj9/frXVeL6jx9b0G
         k8rACwtQnot2xL/QwFGSmLOieWjeDYY2nkWjOsy0=
Date:   Tue, 19 Apr 2022 09:32:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Subject: Re: [PATCH 5.15 000/189] 5.15.35-rc1 review
Message-ID: <Yl5lmQKCd2VxVxkG@kroah.com>
References: <20220418121200.312988959@linuxfoundation.org>
 <ec6408b7-14f4-fc97-3371-3f6cd9a46d24@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ec6408b7-14f4-fc97-3371-3f6cd9a46d24@applied-asynchrony.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 04:07:11PM +0200, Holger Hoffstätte wrote:
> On 2022-04-18 14:10, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.35 release.
> > There are 189 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c: In function hubbub31_verify_allow_pstate_change_high':
> drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c:994:17: error: implicit declaration of function 'udelay' [-Werror=implicit-function-declaration]
>   994 |                 udelay(1);
>       |                 ^~~~~~
> 
> Caused by "drm-amd-display-add-pstate-verification-and-recovery-for-dcn31.patch".
> Explicitly includng <linux/delay.h> in dcn31_hubbub.c fixes it.
> 
> Current mainline version of dcn31_hubbub.c does not explicitly include
> <linux/delay.h>, so there seems to be some general inconsistency wrt.
> which dcn module includes what.

Odd that my build testing didn't find that 'allmodconfig' doesn't catch
it :(

Anyway, thanks for letting me know, I've pushed out a -rc2 now with this
fix.  Or hopeful fix...

greg k-h
