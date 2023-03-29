Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D546CD5AF
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 10:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjC2I7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 04:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjC2I7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 04:59:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFAE525A;
        Wed, 29 Mar 2023 01:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBE1761BFA;
        Wed, 29 Mar 2023 08:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0EEC433D2;
        Wed, 29 Mar 2023 08:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680080254;
        bh=rsH8BWa+4twVNjftcVhHAb8p/m9O88g/TFB33hUVlEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lpe2TpRT3pq6fh7/6Ri9VxGULvLVBidKu1YsZExwp4yVbGGKyvCSwPW8lYLnhocA+
         uBnMrqllQxPBPA7HerZiRNuXR/ySHq6CFR4sGjwEgChff2l1o0I/u2iL9HbnlL1KM8
         HYfok/8hXgUESlnQxDEqEe0naD3kRBD4SYky0Rek=
Date:   Wed, 29 Mar 2023 10:57:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     "peter.chen@kernel.org" <peter.chen@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: cdnsp: Fixes issue with redundant Status Stage
Message-ID: <ZCP9e26lUrRbKoVv@kroah.com>
References: <20230321124053.200483-1-pawell@cadence.com>
 <ZCP435eCZhIIxesr@kroah.com>
 <BYAPR07MB538165F56DB6C42E6732BB34DD899@BYAPR07MB5381.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR07MB538165F56DB6C42E6732BB34DD899@BYAPR07MB5381.namprd07.prod.outlook.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 29, 2023 at 08:52:43AM +0000, Pawel Laszczak wrote:
> >
> >On Tue, Mar 21, 2023 at 08:40:53AM -0400, Pawel Laszczak wrote:
> >> In some cases, driver trees to send Status Stage twice.
> >> The first one from upper layer of gadget usb subsystem and second time
> >> from controller driver.
> >> This patch fixes this issue and remove tricky handling of
> >> SET_INTERFACE from controller driver which is no longer needed.
> >>
> >> cc: <stable@vger.kernel.org>
> >> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence
> >> USBSSP DRD Driver")
> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> >>
> >> ---
> >> Changelog:
> >> v2:
> >> - removed Smatch static checker warning
> >
> >This is already in 6.3-rc4, right?
> >
> 
> v1 is in 6.3-rc4.
> 
> v2 fix the following issue: 
> The patch 5bc38d33a5a1: "usb: cdnsp: Fixes issue with redundant Status Stage" from Mar 7, 2023, leads to the following Smatch static checker warning:
> 
> 	drivers/usb/cdns3/cdnsp-ep0.c:470 cdnsp_setup_analyze()
> 	error: uninitialized symbol 'len'. 

I can't replace an existing commit in a tree, sorry, that's not how git
works.  Please send a fix-up change instead.

greg k-h
