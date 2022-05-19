Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A06852DB6B
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 19:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242714AbiESRgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 13:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242656AbiESRgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 13:36:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBB060D8D;
        Thu, 19 May 2022 10:36:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90543B8277B;
        Thu, 19 May 2022 17:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0477C385AA;
        Thu, 19 May 2022 17:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652981810;
        bh=tomQ0qDGj4ULRGU5hAAEzRh9FfcnE05twNEaADV8Vc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YVBJxjDge+rULCmuCAuXyO7D1T/FassimWpQdsrFKh88haTw4yMWD9uf/DxVGJdFQ
         pmLhEko51YkTA0RVT4rZdHBXdyUccfNps8k3t3fJ4mUAs9gjCcgn15HPsn3hQY7IeC
         78sRSE1hbUDwTr7MjiaHIPKUZSwvVUUZGzccshJs=
Date:   Thu, 19 May 2022 19:36:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Denis Efremov <denis.e.efremov@oracle.com>,
        Larry.Finger@lwfinger.net, phil@philpotter.co.uk,
        straube.linux@gmail.com, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] staging: r8188eu: prevent ->Ssid overflow in
 rtw_wx_set_scan()
Message-ID: <YoaAL2+blNORtC4V@kroah.com>
References: <YEHymwsnHewzoam7@mwanda>
 <20220518070052.108287-1-denis.e.efremov@oracle.com>
 <YoZmG98rI7oK5qgf@kroah.com>
 <20220519171628.GW4009@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519171628.GW4009@kadam>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 19, 2022 at 08:16:28PM +0300, Dan Carpenter wrote:
> On Thu, May 19, 2022 at 05:45:31PM +0200, Greg KH wrote:
> > On Wed, May 18, 2022 at 11:00:52AM +0400, Denis Efremov wrote:
> > > This code has a check to prevent read overflow but it needs another
> > > check to prevent writing beyond the end of the ->Ssid[] array.
> > > 
> > > Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
> > > Cc: stable <stable@vger.kernel.org>
> > > Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
> > > ---
> > > 
> > > This patch is a copy of Dan's 74b6b20df8cf (CVE-2021-28660).
> > > Drivers r8188eu and rtl8188eu share the same code.
> > 
> > This does not apply to my tree at all. This file is not present anymore,
> > what tree did you make it against?
> > 
> 
> That's weird.  It applies fine for me on today's linux-next.

Ok, really wierd, it worked this time.  I'll blame my email setup
somehow, I was churning through lots of patches at once...

thanks for checking.

greg k-h
