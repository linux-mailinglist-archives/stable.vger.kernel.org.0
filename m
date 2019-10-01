Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 154B8C36C9
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 16:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfJAOOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 10:14:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbfJAOOL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 10:14:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F4BA20815;
        Tue,  1 Oct 2019 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569939250;
        bh=STgf7+FbaGU5/VYVJYHRq14qTaGE356BK4R+vbraD8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sxFE2cbVhKVW7TtQCq1uUOIvTDWUti9fs7a7oHXRzjm/CRDiv2WmbPVTvA38Dvjsn
         7YAt2o38xamUnGAs2mbgmuSBR7+nLAmAWf4INjTViGdisgpWoyzHkdiFKOAVp6dJZx
         E+suYug9rxTMajeh8o58m4dNiLXhG+mYVnM6sZRk=
Date:   Tue, 1 Oct 2019 16:14:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steffen Maier <maier@linux.ibm.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] zfcp: fix reaction on bit error theshold notification
 with adapter close
Message-ID: <20191001141408.GB3129841@kroah.com>
References: <yq1d0fhw2ex.fsf@oracle.com>
 <20191001104949.42810-1-maier@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001104949.42810-1-maier@linux.ibm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 12:49:49PM +0200, Steffen Maier wrote:
> On excessive bit errors for the FCP channel ingress fibre path, the channel
> notifies us. Previously, we only emitted a kernel message and a trace record.
> Since performance can become suboptimal with I/O timeouts due to
> bit errors, we now stop using an FCP device by default on channel
> notification so multipath on top can timely failover to other paths.
> A new module parameter zfcp.ber_stop can be used to get zfcp old behavior.

Ugh, module parameters?  This isn't the 1990's anymore :(

Why not just make this a dynamic sysfs variable, that way you properly
can set this on whatever device you want, not just "all or nothing"?

thanks,

greg k-h
