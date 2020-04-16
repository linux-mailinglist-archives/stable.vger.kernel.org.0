Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41DA1AB59D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 03:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbgDPBqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 21:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbgDPBqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 21:46:02 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84F032064A;
        Thu, 16 Apr 2020 01:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587001561;
        bh=c2xKREQm3PT1NX7twv3UUcLaqZaQQxBsgyJLNMklD68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QimMJZUbMiHyk+oWPoojkiOFrLqWTUqiDAETybM2ZkHKfzhoy+tuMYRBvl3oo12dM
         eZT1Oi+xBB2YifH9V1NMhJBKYklxyu/8C4rurDmPW8c7Zrj2jBiLaAvKxpgHSFbTMR
         kt0OsPnbSPPJ8U+UVXbkWVPf5ugf4PBHWAXva0RA=
Date:   Wed, 15 Apr 2020 21:46:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     jsmart2021@gmail.com, dick.kennedy@broadcom.com,
        martin.petersen@oracle.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: lpfc: Fix broken Credit Recovery
 after driver load" failed to apply to 5.4-stable tree
Message-ID: <20200416014600.GU1068@sasha-vm>
References: <1586949527184166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1586949527184166@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:18:47PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
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
>From 835214f5d5f516a38069bc077c879c7da00d6108 Mon Sep 17 00:00:00 2001
>From: James Smart <jsmart2021@gmail.com>
>Date: Mon, 27 Jan 2020 16:23:03 -0800
>Subject: [PATCH] scsi: lpfc: Fix broken Credit Recovery after driver load
>
>When driver is set to enable bb credit recovery, the switch displayed the
>setting as inactive.  If the link bounces, it switches to Active.
>
>During link up processing, the driver currently does a MBX_READ_SPARAM
>followed by a MBX_CONFIG_LINK. These mbox commands are queued to be
>executed, one at a time and the completion is processed by the worker
>thread.  Since the MBX_READ_SPARAM is done BEFORE the MBX_CONFIG_LINK, the
>BB_SC_N bit is never set the the returned values. BB Credit recovery status
>only gets set after the driver requests the feature in CONFIG_LINK, which
>is done after the link up. Thus the ordering of READ_SPARAM needs to follow
>the CONFIG_LINK.
>
>Fix by reordering so that READ_SPARAM is done after CONFIG_LINK.  Added a
>HBA_DEFER_FLOGI flag so that any FLOGI handling waits until after the
>READ_SPARAM is done so that the proper BB credit value is set in the FLOGI
>payload.
>
>Fixes: 6bfb16208298 ("scsi: lpfc: Fix configuration of BB credit recovery in service parameters")
>Cc: <stable@vger.kernel.org> # v5.4+
>Link: https://lore.kernel.org/r/20200128002312.16346-4-jsmart2021@gmail.com
>Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
>Signed-off-by: James Smart <jsmart2021@gmail.com>
>Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

I've grabbed these additional fixes to address the conflict:

6bfb16208298 ("scsi: lpfc: Fix configuration of BB credit recovery in service parameters")
e3ba04c9bad1 ("scsi: lpfc: Fix Fabric hostname registration if system hostname changes")
93a4d6f40198 ("scsi: lpfc: Add registration for CPU Offline/Online events")

-- 
Thanks,
Sasha
