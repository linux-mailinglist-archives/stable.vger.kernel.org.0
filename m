Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0DF7EDC2
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 09:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389997AbfHBHqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 03:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726601AbfHBHqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 03:46:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 550EF206A3;
        Fri,  2 Aug 2019 07:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564731959;
        bh=og+PcUAcawa0pxhF+8LjM3zslgcyoi4eYixhRIR4OEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KBJiR6fnl/Gc34nkqDX9SdvhZPG/FhbbAwwHVV06ar5j5XD+c5uAIw3anamyH3TRO
         NciMxTZ3QzOa/2Gg+xafPy/Hodl40Yt9xEdz73lb663sGNe45ZhPb7o8EqBh8cp+WT
         L6hShx6G6wAYh6ZGC4qRwDLbEo3Zkk0eWyzvMOzM=
Date:   Fri, 2 Aug 2019 09:45:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ian Abbott <abbotti@mev.co.uk>
Cc:     stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH stable 3.15 to 3.18] staging: comedi: dt282x: fix a null
 pointer deref on interrupt
Message-ID: <20190802074557.GF26174@kroah.com>
References: <20190712140237.15847-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712140237.15847-1-abbotti@mev.co.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 03:02:37PM +0100, Ian Abbott wrote:
> commit b8336be66dec06bef518030a0df9847122053ec5 upstream.
> 
> The interrupt handler `dt282x_interrupt()` causes a null pointer
> dereference for those supported boards that have no analog output
> support.  For these boards, `dev->write_subdev` will be `NULL` and
> therefore the `s_ao` subdevice pointer variable will be `NULL`.  In that
> case, the following call near the end of the interrupt handler results
> in a null pointer dereference:
> 
> 	cfc_handle_events(dev, s_ao);
> 
> [ Upstream equivalent:
> 	comedi_handle_events(dev, s_ao);
>   -- IA ]
> 
> Fix it by only calling the above function if `s_ao` is valid.
> 
> (There are other uses of `s_ao` by the interrupt handler that may or may
> not be reached depending on values of hardware registers.  Trust that
> they are reliable for now.)
> 
> Fixes: f21c74fa4cfe ("staging: comedi: dt282x: use cfc_handle_events()")
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/comedi/drivers/dt282x.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Thanks for the patch, I've taken it for my 3.18-android tree.

greg k-h
