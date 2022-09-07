Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75405B0359
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 13:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiIGLpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 07:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiIGLpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 07:45:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99D859259;
        Wed,  7 Sep 2022 04:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66D6561884;
        Wed,  7 Sep 2022 11:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469B2C433D6;
        Wed,  7 Sep 2022 11:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662551147;
        bh=iCruh3F71XWCMLrzlUiW6xEE4VqSZmHv7JC0V6p3YJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YTSbJm5/A4bsFXliFGZsp/aCCuKVEXHRkgxCyanEICmO1lssby+6XH7R4eNXTOs46
         zMqO03cNA8sIJYOiChUHZcp7r1YOO6Hshqn8II9bsRuDzKF24jtjozjCTK9kJEr52b
         J1LHOeHa356ojadCWF9S8Tx8L82oIOjcznkzKPNY=
Date:   Wed, 7 Sep 2022 13:45:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/107] 5.15.66-rc1 review
Message-ID: <YxiEaEEP9DC9sEoD@kroah.com>
References: <20220906132821.713989422@linuxfoundation.org>
 <YxhnDip9k6TfRCCc@debian>
 <CADVatmN3hoxBB-knoTO6BGb=1fstiOPwakCu3tXHbV21bHR8Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmN3hoxBB-knoTO6BGb=1fstiOPwakCu3tXHbV21bHR8Pw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 07, 2022 at 12:30:34PM +0100, Sudip Mukherjee wrote:
> On Wed, Sep 7, 2022 at 10:40 AM Sudip Mukherjee (Codethink)
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Hi Greg,
> >
> > On Tue, Sep 06, 2022 at 03:29:41PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.66 release.
> > > There are 107 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> > > Anything received after that time might be too late.
> >
> > Build test (gcc version 11.3.1 20220819):
> 
> Missed reporting that the build is full of "/bin/sh: 1:
> ./scripts/pahole-flags.sh: Permission denied".
> On checking it turns out, the execute permission is not set in the
> v5.15.y branch, but its set in v5.19.y branch.
> 
> On v5.19.y:
> $ ls -l scripts/pahole-flags.sh
> -rwxr-xr-x 1 sudip sudip 585 Sep  6 18:03 scripts/pahole-flags.sh
> 
> on v5.15.y:
> $ ls -l scripts/pahole-flags.sh
> -rw-r--r-- 1 sudip sudip 627 Sep  7 12:27 scripts/pahole-flags.sh

Known issue, see the thread here:
	https://lore.kernel.org/r/YxguwCpBEKAJJDU6@kroah.com

thanks,

greg k-h
