Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B193865A3CB
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 12:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiLaLsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 06:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiLaLsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 06:48:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910977658;
        Sat, 31 Dec 2022 03:48:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28916B8037A;
        Sat, 31 Dec 2022 11:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52156C433D2;
        Sat, 31 Dec 2022 11:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672487314;
        bh=FCsl+9+rqlT6sQHBhJsMEJUwJX1ovN1MLUNUhrMRw7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PxkgMZz+2RVJYD35wFYDDkokpDhTzrZgyLm9TMqtBG6WGcxVXYf/XpiogXfEp832A
         g6SjF7nXvU1BmcL+oAZaSCtDr4FazXfGDnvYMX1Cr5kCSbqV740wlmWBpxFvSgnyjf
         WcKEH02cY99TOIJfh/yRFYB+eqwuTlOaFHoFjGb0=
Date:   Sat, 31 Dec 2022 12:48:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Conor Dooley <conor@kernel.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
Message-ID: <Y7AhkCvo6sGFr6gX@kroah.com>
References: <20221230094059.698032393@linuxfoundation.org>
 <Y699qYnUYUwFuQ/E@spud>
 <20221231055203.GA2926213@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221231055203.GA2926213@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 30, 2022 at 09:52:03PM -0800, Guenter Roeck wrote:
> On Sat, Dec 31, 2022 at 12:09:13AM +0000, Conor Dooley wrote:
> > Hey Greg,
> > 
> > On Fri, Dec 30, 2022 at 10:49:23AM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.0.16 release.
> > > There are 1066 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> > > Anything received after that time might be too late.
> > 
> > > Paulo Alcantara <pc@cjr.nz>
> > >     cifs: improve symlink handling for smb2+
> > 
> > This patch here appears to fail allmodconfig + LLVM on RISC-V:
> > ../fs/cifs/smb2inode.c:419:4: error: variable 'idata' is uninitialized when used here [-Werror,-Wuninitialized]
> >                         idata->symlink_target = kstrdup(cfile->symlink_target, GFP_KERNEL);
> >                         ^~~~~
> > ../fs/cifs/smb2inode.c:76:35: note: initialize the variable 'idata' to silence this warning
> >         struct cifs_open_info_data *idata;
> >                                          ^
> >                                           = NULL
> > 1 error generated.
> 
> Fixed with upstream commit 69ccafdd35cdf ("cifs: fix uninitialised var in
> smb2_compound_op()").

Now queued up, thanks.

greg k-h
