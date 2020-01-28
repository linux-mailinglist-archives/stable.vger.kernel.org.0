Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F2A14BF5B
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 19:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgA1SPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 13:15:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbgA1SPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 13:15:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FD05214AF;
        Tue, 28 Jan 2020 18:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580235315;
        bh=dYG3LXwor/67vMcViqXYCwPbnJDeCucY5iwlCPtL8P8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yxxhWwAaXa1D7g9EE+1i5rniPf7gawzu4autS+7W6oWOLCxckWMSAhZHgZh4RV+XY
         GOzdMpgU2rawM26hqpci+TTHBrlsuX0QwenLzZE3x/K/+KwZx30YOeYAJwkroc3cNd
         zyuUWiSx8SJJLd5kDluYwLl27fnI81VfxOue929I=
Date:   Tue, 28 Jan 2020 19:15:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Masato Suzuki <masato.suzuki@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4.19 59/92] sd: Fix REQ_OP_ZONE_REPORT completion handling
Message-ID: <20200128181513.GC3673744@kroah.com>
References: <20200128135809.344954797@linuxfoundation.org>
 <20200128135816.802992447@linuxfoundation.org>
 <20200128180231.GA11577@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128180231.GA11577@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 07:02:31PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Masato Suzuki <masato.suzuki@wdc.com>
> > 
> >
> 
> > ZBC/ZAC report zones command may return less bytes than requested if the
> > number of matching zones for the report request is small. However, unlike
> > read or write commands, the remainder of incomplete report zones commands
> > cannot be automatically requested by the block layer: the start sector of
> > the next report cannot be known, and the report reply may not be 512B
> > aligned for SAS drives (a report zone reply size is always a multiple of
> > 64B). The regular request completion code executing bio_advance() and
> > restart of the command remainder part currently causes invalid zone
> > descriptor data to be reported to the caller if the report zone size is
> > smaller than 512B (a case that can happen easily for a report of the last
> > zones of a SAS drive for example).
> 
> What is the story here? Mainline does not seem to have this patch, so
> this is not the case of "upstream commit xxx" line simply missing. If
> the same bug is fixed in mainline different way, it would be nice to
> point to that commit..

Yes, this is not needed in 5.4 as it was rewritten differently there.

thanks,

greg k-h
