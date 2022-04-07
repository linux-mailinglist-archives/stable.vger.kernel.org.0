Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370F84F8715
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 20:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbiDGSbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 14:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiDGSbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 14:31:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95551158B85;
        Thu,  7 Apr 2022 11:29:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 401CAB82954;
        Thu,  7 Apr 2022 18:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A97AC385A4;
        Thu,  7 Apr 2022 18:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649356170;
        bh=3ESWRa8y3Crt+FGw6DXenQcOcGcaggrhqxa3bNagFq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cXPIEQoT1+cyaYC/bmQ1rejmpgLH+87EXzUqTajntsEDwYwjg6GSBJQ/3JQBecmkd
         Srf+GO03/OZ4e82bHzWVOlAOgybPuvIxoc133sg64+EOIgI+pDDDGoRnGyLK4vV14r
         uQQZQWzoPJgXz/35gvJUe3DqUOfyAJiBU8ijl/iQ=
Date:   Thu, 7 Apr 2022 20:29:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc2 review
Message-ID: <Yk8th5hj6cW7kSPZ@kroah.com>
References: <20220406133013.264188813@linuxfoundation.org>
 <7d1903b5-7139-94df-11ec-02de782b8008@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d1903b5-7139-94df-11ec-02de782b8008@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 07, 2022 at 10:42:15AM -0700, Guenter Roeck wrote:
> On 4/6/22 06:43, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.110 release.
> > There are 597 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Trying again ...
> 
> Test results for v5.10.109-598-gf8a7d8111f45:
> 
> Build results:
> 	total: 161 pass: 150 fail: 11
> Failed builds:
> 	alpha:defconfig
> 	alpha:allmodconfig
> 	csky:defconfig
> 	m68k:defconfig
> 	m68k:allmodconfig
> 	m68k:sun3_defconfig
> 	m68k_nommu:m5475evb_defconfig
> 	microblaze:mmu_defconfig
> 	nds32:defconfig
> 	nds32:allmodconfig
> 	um:defconfig
> Qemu test results:
> 	total: 477 pass: 453 fail: 24
> Failed tests:
> 	<all alpha>
> 	q800:m68040:mac_defconfig:initrd
> 	q800:m68040:mac_defconfig:rootfs
> 	<all microblaze>
> 
> Common error is:
> 
> fs/binfmt_elf.c: In function 'fill_note_info':
> fs/binfmt_elf.c:2056:53: error: 'regs' undeclared
> 
> Looks like a bad backport of upstream commit 9ec7d3230717
> ("coredump/elf: Pass coredump_params into fill_note_info").
> Only seen on architectures defining CORE_DUMP_USE_REGSET.

Ugh, I'll try to fix this up again, thanks for letting me know...
