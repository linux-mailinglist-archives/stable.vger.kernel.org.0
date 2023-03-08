Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC2B6AFF96
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 08:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCHHTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 02:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjCHHTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 02:19:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C0B95BEC;
        Tue,  7 Mar 2023 23:19:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3384F60B4B;
        Wed,  8 Mar 2023 07:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F931C433EF;
        Wed,  8 Mar 2023 07:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678259969;
        bh=T79gADW5BJP58DL1ihiPjZCsFdOC5qR/ClSIWFq1bfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MnBfyA4CPK+uMi2a/tdZgGM/O3AAsRJtwj0xtgWMWz5hqiJxeY+J6UlU62FLAwk6V
         1PySqQONH2JXPd0E7N93ObfM2/PNivUXvzhTwIMF8uulVHph4LFvkkzBX50FFke+C9
         rXcWaq6OXWhnceUTt3BjUtoxF6euCQEx8tQXgx9Y=
Date:   Wed, 8 Mar 2023 08:19:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Darren Kenny <darren.kenny@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 5.15 000/567] 5.15.99-rc1 review
Message-ID: <ZAg2989Hzuc1Wmlp@kroah.com>
References: <20230307165905.838066027@linuxfoundation.org>
 <6f792ece-b7c0-3af0-b1c0-631f1cc4f5fb@oracle.com>
 <583f7dd7-dc40-724e-aa49-33287754cc5c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <583f7dd7-dc40-724e-aa49-33287754cc5c@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 09:12:48PM +0100, Vegard Nossum wrote:
> 
> On 3/7/23 21:02, Harshit Mogalapalli wrote:
> > On 07/03/23 10:25 pm, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.99 release.
> > > There are 567 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > 
> > While trying to build 5.15.99-rc1 with
> > * make -C tools/perf all
> > 
> > The following build errors are seen.
> > 
> > util/intel-pt-decoder/intel-pt-decoder.c: In function
> > 'intel_pt_eptw_lookahead_cb':
> > util/intel-pt-decoder/intel-pt-decoder.c:1445:14: error: 'INTEL_PT_CFE'
> [...]
> > 
> > [PATCH 5.15 264/567] perf intel-pt: Add support for emulated ptwrite
> > is causing this error.
> 
> In addition, cherry-picking this fixes the build (but we haven't done a
> full test with it):
> 
> commit 2750af50a360b52c6df1f5652ae728878bececc0
> Author: Adrian Hunter <adrian.hunter@intel.com>
> Date:   Mon Jan 24 10:41:39 2022 +0200
> 
>     perf intel-pt: pkt-decoder: Add CFE and EVD packets
> 
> Greg: Do you prefer this kind of error report go to the 0/N email (like
> in this case) or to the specific problematic patch email if we've
> already identified it?

Either works for me, I'll go queue this up now, thanks!

greg k-h
