Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F79C9137
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 20:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfJBS4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 14:56:21 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:38490 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJBS4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 14:56:20 -0400
Received: from pendragon.ideasonboard.com (unknown [132.205.229.212])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5EFB72BB;
        Wed,  2 Oct 2019 20:56:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1570042577;
        bh=PbWtfJfT3AWYLkOwJItUMiaSDU3tjjAskp4aOSEpGOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gJqpqcIy/Ynox93mO7HvGxTuyrOys4VaUqnoHi1rZFK1hsgiQV/ACZkRapmTILkXi
         wiMpzGtpraFthrkAfi22sMtR6n/fNUlbwwo83aPbWTfJqdQOUiABhm+n4YP4WHnO8t
         KustgNeyUlNXd85nXeh7sChLFAPD+n9zji2X3nog=
Date:   Wed, 2 Oct 2019 21:56:04 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Will Deacon <will@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        andreyknvl@google.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] media: uvc: Avoid cyclic entity chains due to malformed
 USB descriptors
Message-ID: <20191002185604.GF5262@pendragon.ideasonboard.com>
References: <20191002112753.21630-1-will@kernel.org>
 <20191002130913.GA5262@pendragon.ideasonboard.com>
 <20191002131928.yp5r4tyvtvwvuoba@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191002131928.yp5r4tyvtvwvuoba@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Will,

On Wed, Oct 02, 2019 at 02:19:29PM +0100, Will Deacon wrote:
> On Wed, Oct 02, 2019 at 04:09:13PM +0300, Laurent Pinchart wrote:
> > Thank you for the patch.
> 
> And thank you for the quick response.
> 
> > On Wed, Oct 02, 2019 at 12:27:53PM +0100, Will Deacon wrote:
> > > I don't have a way to reproduce the original issue, so this change is
> > > based purely on inspection. Considering I'm not familiar with USB nor
> > > UVC, I may well have missed something!
> > 
> > I may also be missing something, I haven't touched this code for a long
> > time :-)
> 
> Actually, that is pretty helpful because it will make backporting easier
> if we get to that :)
> 
> > uvc_scan_chain_entity(), at the end of the function, adds the entity to
> > the list of entities in the chain with
> > 
> > 	list_add_tail(&entity->chain, &chain->entities);
> 
> Yes.
> 
> > uvc_scan_chain_forward() is then called (from uvc_scan_chain()), and
> > iterates over all entities connected to the entity being scanned.
> > 
> > 	while (1) {
> > 		forward = uvc_entity_by_reference(chain->dev, entity->id,
> > 			forward);
> 
> Yes.
> 
> > At this point forward may be equal to entity, if entity references
> > itself.
> 
> Correct -- that's indicative of a malformed entity which we want to reject,
> right?

Right. We can reject the whole chain in that case. There's one case
where we still want to succeed though, which is handled by
uvc_scan_fallback().

Looking at the code, uvc_scan_device() does

                if (uvc_scan_chain(chain, term) < 0) {
                        kfree(chain);
                        continue;
                }

It seems that's missing removal of all entities that would have been
successfully added to the chain. This prevents, I think,
uvc_scan_fallback() from working properly in some cases.

> > 		if (forward == NULL)
> > 			break;
> > 		if (forward == prev)
> > 			continue;
> > 		if (forward->chain.next || forward->chain.prev) {
> > 			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
> > 				"entity %d already in chain.\n", forward->id);
> > 			return -EINVAL;
> > 		}
> > 
> > But then this check should trigger, as forward == entity and entity is
> > in the chain's list of entities.
> 
> Right, but this code is added by my patch, no? In mainline, the code only
> has the first two checks, which both end up comparing against NULL the first
> time around:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/media/usb/uvc/uvc_driver.c#n1489
> 
> Or are you referring to somewhere else?

Oops. This is embarassing... :-) You're of course right. The second hunk
seems fine too, even if I would have preferred centralising the check in
a single place. That should be possible, but it would involve
refactoring that isn't worth it at the moment.

-- 
Regards,

Laurent Pinchart
