Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD41A6B59FC
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 10:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjCKJUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 04:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCKJUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 04:20:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E5C24C80;
        Sat, 11 Mar 2023 01:18:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05F75B8244C;
        Sat, 11 Mar 2023 09:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20334C433EF;
        Sat, 11 Mar 2023 09:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678526317;
        bh=tb4uSs6vec++ASwhKnSWiL5L83Xx0LcatZP9k0KMhag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BK0A50jGWeXZLX/enTQu1QWxs+1iAxMu1PWiJcmtlkgmT9443/97uAc/d69b9ldve
         rnGMHy7XjggR3mZ+yvgmwzZyqbRIx0SOyYbGXPO0sGTst+QX+Dc8nE1JW7JPqoSSCS
         Sv5wb3F6J6MeDxZtQUFYxwxX2Eoi6QLHe69eR1pY=
Date:   Sat, 11 Mar 2023 10:18:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/529] 5.10.173-rc1 review
Message-ID: <ZAxHZcKEXCqCFnFq@kroah.com>
References: <20230310133804.978589368@linuxfoundation.org>
 <7c6de5b8-dbc2-41b3-9e1f-5edb2876337b@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c6de5b8-dbc2-41b3-9e1f-5edb2876337b@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 01:02:35PM -0800, Guenter Roeck wrote:
> On Fri, Mar 10, 2023 at 02:32:23PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.173 release.
> > There are 529 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> > Anything received after that time might be too late.
> > 
> 
> s390:
> 
> drivers/s390/block/dasd_diag.c:656:23: error: initialization of 'int (*)(struct dasd_device *, __u8)' {aka 'int (*)(struct dasd_device *, unsigned char)'} from incompatible pointer type 'int (*)(struct dasd_device *, __u8,  __u8)' {aka 'int (*)(struct dasd_device *, unsigned char,  unsigned char)'} [-Werror=incompatible-pointer-types]
>   656 |         .pe_handler = dasd_diag_pe_handler,
> 
> This problem affects the v5.4.y and v5.10.y release candidates.

Ick, ok, that's my fault, I'll drop the patch I half-backported for
5.4.y and 5.10.y and push out -rc2 versions with the fix.

thanks,

greg k-h
