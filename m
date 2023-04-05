Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298E76D8555
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 19:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbjDERz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 13:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbjDERz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 13:55:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D8076BE;
        Wed,  5 Apr 2023 10:55:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2478627FF;
        Wed,  5 Apr 2023 17:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F00C433EF;
        Wed,  5 Apr 2023 17:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680717299;
        bh=aObttJq9zWXUQ6YMs0Xu6VuSdtZtojeBYxbOHv1iaHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JG93bK/qnGdCbF/R6L4RF1cdCaFL1Loyg5mOhXTzbTgfYJwB8ONH8D8NsbTwgw3ya
         BbK0wPTl/PzPFiKB5K0h49H/eb+I/S47UXsRJR/5PXyk5FfQlecOtcXHhpu+giI1FK
         m+vAVDSm/1R6wZ8JS8t8GCf3Bajk3aeuG9UmlcYc=
Date:   Wed, 5 Apr 2023 19:54:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Pawel Laszczak <pawell@cadence.com>, peter.chen@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdnsp: Fixes error: uninitialized symbol 'len'
Message-ID: <2023040531-croak-glance-c49b@gregkh>
References: <20230331090600.454674-1-pawell@cadence.com>
 <2023040514-outspoken-librarian-3cde@gregkh>
 <ddba44b4-5c5c-0085-2678-9f8151811494@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddba44b4-5c5c-0085-2678-9f8151811494@suse.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 07:41:53PM +0200, Oliver Neukum wrote:
> On 05.04.23 19:23, Greg KH wrote:
> > On Fri, Mar 31, 2023 at 05:06:00AM -0400, Pawel Laszczak wrote:
> 
> > >   {
> > >   	struct usb_ctrlrequest *ctrl = &pdev->setup;
> > > -	int ret = 0;
> > > +	int ret = -EINVAL;
> > >   	u16 len;
> > >   	trace_cdnsp_ctrl_req(ctrl);
> > > @@ -424,7 +424,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
> > >   	if (pdev->gadget.state == USB_STATE_NOTATTACHED) {
> > >   		dev_err(pdev->dev, "ERR: Setup detected in unattached state\n");
> > > -		ret = -EINVAL;
> > 
> > That's a nice change, but I don't see the original error here that you
> > are saying this change fixes.
> > 
> > What am I missing?
> 
> The function has this check at its beginning:
> 
>        if (!pdev->gadget_driver)
>                 goto out;

Argh, I missed this at the top of the function.  I was looking further
down, sorry for the noise.

I'll go queue this up now, thanks.

greg k-h
