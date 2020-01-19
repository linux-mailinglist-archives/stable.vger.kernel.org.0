Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3968E141EF0
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 16:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgASPxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 10:53:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgASPxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Jan 2020 10:53:46 -0500
Received: from localhost (96-81-74-198-static.hfc.comcastbusiness.net [96.81.74.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D71E20679;
        Sun, 19 Jan 2020 15:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579449226;
        bh=mXP11L3Rzg4DCKV1ZfhEPpDkkCXe9+Dm35EA647SK9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AI1VIAAt9XQ1EShdnP9iPHd6s1PGrZ/8gtf96HdeOck6JeJqryOg6dyJK0OU2X5e5
         pGIaGKwABVvmvwPYoD4aQbKrWUsbnu+mtiJTIc5vKlUISgCnLCBaaJbvx2rQX3FZuh
         9HcMu5mxnMDDjDrE69Wa3KMA97G4KihrT38lzSYY=
Date:   Sun, 19 Jan 2020 10:53:43 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     arnd@arndb.de, martin.petersen@oracle.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: fnic: fix invalid stack access"
 failed to apply to 4.9-stable tree
Message-ID: <20200119155343.GS1706@sasha-vm>
References: <157944140770121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157944140770121@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 19, 2020 at 02:43:27PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 42ec15ceaea74b5f7a621fc6686cbf69ca66c4cf Mon Sep 17 00:00:00 2001
>From: Arnd Bergmann <arnd@arndb.de>
>Date: Tue, 7 Jan 2020 21:15:49 +0100
>Subject: [PATCH] scsi: fnic: fix invalid stack access
>
>gcc -O3 warns that some local variables are not properly initialized:
>
>drivers/scsi/fnic/vnic_dev.c: In function 'fnic_dev_hang_notify':
>drivers/scsi/fnic/vnic_dev.c:511:16: error: 'a0' is used uninitialized in this function [-Werror=uninitialized]
>  vdev->args[0] = *a0;
>  ~~~~~~~~~~~~~~^~~~~
>drivers/scsi/fnic/vnic_dev.c:691:6: note: 'a0' was declared here
>  u64 a0, a1;
>      ^~
>drivers/scsi/fnic/vnic_dev.c:512:16: error: 'a1' is used uninitialized in this function [-Werror=uninitialized]
>  vdev->args[1] = *a1;
>  ~~~~~~~~~~~~~~^~~~~
>drivers/scsi/fnic/vnic_dev.c:691:10: note: 'a1' was declared here
>  u64 a0, a1;
>          ^~
>drivers/scsi/fnic/vnic_dev.c: In function 'fnic_dev_mac_addr':
>drivers/scsi/fnic/vnic_dev.c:512:16: error: 'a1' is used uninitialized in this function [-Werror=uninitialized]
>  vdev->args[1] = *a1;
>  ~~~~~~~~~~~~~~^~~~~
>drivers/scsi/fnic/vnic_dev.c:698:10: note: 'a1' was declared here
>  u64 a0, a1;
>          ^~
>
>Apparently the code relies on the local variables occupying adjacent memory
>locations in the same order, but this is of course not guaranteed.
>
>Use an array of two u64 variables where needed to make it work correctly.
>
>I suspect there is also an endianness bug here, but have not digged in deep
>enough to be sure.
>
>Fixes: 5df6d737dd4b ("[SCSI] fnic: Add new Cisco PCI-Express FCoE HBA")
>Fixes: mmtom ("init/Kconfig: enable -O3 for all arches")
>Cc: stable@vger.kernel.org
>Link: https://lore.kernel.org/r/20200107201602.4096790-1-arnd@arndb.de
>Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

I've grabbed 36fe90b0f0bd ("scsi: fnic: use kernel's '%pM' format option
to print MAC") to resolve this conflict and queued both for 4.9 and 4.4

-- 
Thanks,
Sasha
