Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 521F9C3952
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 17:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389434AbfJAPmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 11:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727302AbfJAPmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 11:42:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B00352086A;
        Tue,  1 Oct 2019 15:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569944531;
        bh=k0W7e2si2Vcx0gzomk1QiHlnoTpUZarg+lyFE5CNArg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QEeD2au9hZKSmGTMJEvCv0/W91JbZIahSo/L5PKLMeNcK9Vk8Ov0I6pzy/rEOS5v/
         5Jshb/XjslEJTsZJRrx+g+XQN3oVFKa+w0hldEW3rOZyK80e9p2bDksdq8+MPoB17x
         N5LHM94n5hxWVo+ggHILwM07rhYla7CPMxgJQddM=
Date:   Tue, 1 Oct 2019 17:42:08 +0200
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
Message-ID: <20191001154208.GB3523275@kroah.com>
References: <yq1d0fhw2ex.fsf@oracle.com>
 <20191001104949.42810-1-maier@linux.ibm.com>
 <20191001141408.GB3129841@kroah.com>
 <71b8fc68-23a8-a591-1018-f290d6e3312a@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71b8fc68-23a8-a591-1018-f290d6e3312a@linux.ibm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 05:07:50PM +0200, Steffen Maier wrote:
> On 10/1/19 4:14 PM, Greg KH wrote:
> > On Tue, Oct 01, 2019 at 12:49:49PM +0200, Steffen Maier wrote:
> > > On excessive bit errors for the FCP channel ingress fibre path, the channel
> > > notifies us. Previously, we only emitted a kernel message and a trace record.
> > > Since performance can become suboptimal with I/O timeouts due to
> > > bit errors, we now stop using an FCP device by default on channel
> > > notification so multipath on top can timely failover to other paths.
> > > A new module parameter zfcp.ber_stop can be used to get zfcp old behavior.
> > 
> > Ugh, module parameters?  This isn't the 1990's anymore :(
> > 
> > Why not just make this a dynamic sysfs variable, that way you properly
> > can set this on whatever device you want, not just "all or nothing"?
> 
> Since we can see many more (virtual) FCP devices than we want to actually
> use, we defer probing. It means, we only start allocating structures and
> sysfs entries on setting an FCP "online" for the first time. Setting online
> works through another sysfs attribute owned by our ccw bus code component
> called "cio". IIRC, setting online does not emit a uevent. On setting
> online, the (add) uevent of hot-/coldplug of an FCP device had already
> happened, so we could not easily have end users craft udev rules to
> automatically/persistently configure a new sysfs attribute (which is
> FCP-device-specific and appears late) to disable the new code behavior.
> 
> Not sure if that could ever become a problem for end users: Even if we were
> to write into a new sysfs attribute, the attribute only appears during
> setting online so this might race with starting to actually use the FCP
> device with the new default behavior and could potentially disable I/O paths
> before the sysfs attribute write could become effective to disable the new
> behavor.

Ok, then why make this a module option that you will have to support for
the next 20+ years anyway if you feel this fix is the correct way that
it should be done instead?

module options are tough to manage and support, only add them as a very
last thing, when all other options have been ruled out.

thanks,

greg k-h
