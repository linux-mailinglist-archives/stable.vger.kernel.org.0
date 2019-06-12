Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 068DC42D09
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 19:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfFLRJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 13:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbfFLRJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 13:09:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8C6B21019;
        Wed, 12 Jun 2019 17:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560359376;
        bh=ymQ5z5KSWawiF21BTeZRBEC4DEdzTRxyA+90LIpPVmM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t4poHTEPuv/aE6CPSnUFhvbbR7+ncVgjYxaGpinyKpKjJhBYBhTFFm16aWxxkFqVF
         Vmb4Kig6nIPx3IZtkYpw488olRWwZpeyhz1EWUzJti7ak9VNUo0JYNinlk2mIenuGG
         B5cjPEXpzSVdwJ6vwIXTeNED9SlZvn9KXt1NDuo4=
Date:   Wed, 12 Jun 2019 19:09:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Sommer <alex@sommer-info.net>
Cc:     stable@vger.kernel.org
Subject: Re: Betreff: crashed linux mdadm raid
Message-ID: <20190612170933.GA6986@kroah.com>
References: <7ebdd1c4e0f955fa2b5bebc85547c975@sommer-info.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ebdd1c4e0f955fa2b5bebc85547c975@sommer-info.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 06:50:09PM +0200, Alexander Sommer wrote:
> Hello,
> 
> after a problem with my external disk enclosure my md-raid is broken.
> 
> if I do an assemble I got this:
> root@server:~ # mdadm --assemble /dev/md2 /dev/sd[lmnop]1
> mdadm: /dev/md2 assembled from 2 drives - not enough to start the array.
> 
> I assume the broblem is that the disks events counter has different
> states:
> 
> root@server:~ # mdadm --examine /dev/sd[lmpno]1 | egrep -e "/dev/sd" -e
> "Raid Level" -e Events -e "Device Role" -e "Array State"
> /dev/sdl1:
>      Raid Level : raid5
>          Events : 253626
>    Device Role : Active device 0
>    Array State : AA.AA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdm1:
>      Raid Level : raid5
>          Events : 253626
>    Device Role : Active device 1
>    Array State : AA.AA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdn1:
>      Raid Level : raid5
>          Events : 253618
>    Device Role : Active device 2
>    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdo1:
>      Raid Level : raid5
>          Events : 253618
>    Device Role : Active device 3
>    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdp1:
>      Raid Level : raid5
>          Events : 253618
>    Device Role : Active device 4
>    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> This raid is used for backup, I do rsync to this device and have for
> every day on directory and I need some of the old data, so I need only a
> way, to read some old files, and than it is no problem to clean the
> disks and create it new. So I do not need the realy last state. If I got
> the files which are some days old it will be ok, on this device normaly
> I do not delete something, there come only new files and hardlinks to
> the old ones.
> 
> So, do I have a chance to start it?

No idea, try contacting your distribution for support.

good luck!

greg k-h
