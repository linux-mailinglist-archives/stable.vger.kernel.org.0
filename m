Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2506023A7
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 07:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJRFMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 01:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJRFMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 01:12:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B672989933;
        Mon, 17 Oct 2022 22:12:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ECA7B81CD7;
        Tue, 18 Oct 2022 05:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7464DC433D6;
        Tue, 18 Oct 2022 05:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666069971;
        bh=2lsr5bXa9CV+Fpw3dmizmkB0iZ/EtjWWsMDb21f9zVE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CTpszAlj+EfckPAQ+wZS1eXAiQXX0cc9rQds7XG+Zc+4omn1mhvrwRQnFWDAqYk9M
         FyeM70mBCDDGwnswZtkKaFpFHW9/RMPeyx6ynDtfNZXUrylJP2ZqNb4z3/qGyJyf/M
         Mv5nOqnzOauERimyaOxDNAlEJ6XDlHmMx059WsLA=
Date:   Tue, 18 Oct 2022 07:13:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dan Vacura <w36195@motorola.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-usb@vger.kernel.org,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jeff Vanhoof <qjv001@motorola.com>, stable@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Paul Elder <paul.elder@ideasonboard.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: uvc: fix dropped frame after missed isoc
Message-ID: <Y042AZ2iA05no5U5@kroah.com>
References: <20221017205446.523796-1-w36195@motorola.com>
 <20221017205446.523796-2-w36195@motorola.com>
 <f7029f41-4f8c-9ba7-3e3b-268a743998d5@gmail.com>
 <Y04MT0+jKApYFfcG@p1g3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y04MT0+jKApYFfcG@p1g3>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 09:15:43PM -0500, Dan Vacura wrote:
> On Tue, Oct 18, 2022 at 08:50:03AM +0700, Bagas Sanjaya wrote:
> > On 10/18/22 03:54, Dan Vacura wrote:
> > > With the re-use of the previous completion status in 0d1c407b1a749
> > > ("usb: dwc3: gadget: Return proper request status") it could be possible
> > > that the next frame would also get dropped if the current frame has a
> > > missed isoc error. Ensure that an interrupt is requested for the start
> > > of a new frame.
> > > 
> > 
> > Shouldn't the subject line says [PATCH v3 1/6]?
> 
> Yes. Clerical error on my side not updating this after resolving a
> check-patch error... Not sure if it matters as this patch can exist on
> it's own. Or if I can send this again with fixed subject line, but that
> may confuse others, since there's no code difference.

Our tools (b4) will complain it can not find patch 1 in the series, so
yes, please resend with them properly numbered so that we can find them
all when going to apply them to the tree.

thanks,

greg k-h
