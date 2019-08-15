Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFDBD8E723
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 10:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbfHOImv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 04:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfHOImu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 04:42:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AB7521851;
        Thu, 15 Aug 2019 08:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565858569;
        bh=USPxJNoL/CR/1yf8im0Lr+aG9FevNu7XoPSdWfFzoY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qBaE/V/WnxoBUOWHFCvINR6p0sz3eQvRN2yid0KMoDHJqjxQVW2x+PFhvWdpqMEpe
         7ii8nxtr+GPMD8cBZeJNYgO88xDk6kwM5XlGbe8nyQvYXdIjjOVEKlU9oPaPl9QqCI
         2dRk52YVsU5Sz9+rB/XIInzYwvPBfo88MYM4pU1w=
Date:   Thu, 15 Aug 2019 10:42:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hui Wang <hui.wang@canonical.com>
Cc:     alsa-devel@alsa-project.org, tiwai@suse.de, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ALSA: hda - Add a new match function for only undef
 configurations
Message-ID: <20190815084246.GA3512@kroah.com>
References: <20190815083001.3793-1-hui.wang@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815083001.3793-1-hui.wang@canonical.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 04:30:00PM +0800, Hui Wang wrote:
> With the existing pintbl, we already have many entries in it. it is
> better to figure out a new match to reduce the size of the pintbl.
> 
> For example, there are over 10 entries in the pintbl for:
> 0x10ec0255, 0x1028, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE
> 
> If we define a new tbl like below, and with the new adding match
> function, we can remove those over 10 entries:
> SND_HDA_PIN_QUIRK(0x10ec0255, 0x1028, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
> 	{0x19, 0x40000000},
> 	{0x1a, 0x40000000},),
> 
> Here we put 0x19 and 0x1a in the tbl just because these two pins are
> undefined on Dell laptops with the codec alc255, and these two pins
> will be overwritten by ALC255_FIXUP_DELL1_MIC_NO_PRESENCE.
> 
> In summary: the new match will check vendor id and codec id first,
> then check the pin_cfg defined in the tbl, only all pin_cfgs in the
> tbl are undef and the corresponding pin_cfgs on the laptop are undef
> too, this match returns true.
> 
> This new match function has lower priority than existing match
> functions, so the existing tbls still work as before after applying this
> patch.
> 
> My plan is to change the existing tbl to undef tbl for MIC_NO_PRESENCE
> fixups gradually.
> 
> Signed-off-by: Hui Wang <hui.wang@canonical.com>
> ---
>  sound/pci/hda/hda_auto_parser.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
