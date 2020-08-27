Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF852547FD
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 16:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgH0O51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 10:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:32916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgH0O5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 10:57:24 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AE992054F;
        Thu, 27 Aug 2020 14:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598540244;
        bh=Z7P+7hiMd79KLmI6tlzXL561bZiTIl8fEN+AwfIJqpk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n7qz6OSdJ+oIhqBjm6J2T7/fzx67BnwMKed+2+VAaF5P3/0OccIuIEyUcBshGiocB
         OAlntivuTDGN/OeiLCUExUMd+grFrPKq1tDhb5Vr1URkAYrlJsuhR5VoZjoekQC6jZ
         T2tUZyfsU7d2oRaZM5yLL+JOLtlE0cO9lOQ68eTk=
Date:   Thu, 27 Aug 2020 10:57:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc:     stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH stable v4.4] powerpc/pseries: Do not initiate shutdown
 when system is running on UPS
Message-ID: <20200827145723.GO8670@sasha-vm>
References: <20200827074307.522970-1-hegdevasant@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200827074307.522970-1-hegdevasant@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 27, 2020 at 01:13:07PM +0530, Vasant Hegde wrote:
>commit 90a9b102eddf6a3f987d15f4454e26a2532c1c98 upstream.
>
>As per PAPR we have to look for both EPOW sensor value and event
>modifier to identify the type of event and take appropriate action.
>
>In LoPAPR v1.1 section 10.2.2 includes table 136 "EPOW Action Codes":
>
>  SYSTEM_SHUTDOWN 3
>
>  The system must be shut down. An EPOW-aware OS logs the EPOW error
>  log information, then schedules the system to be shut down to begin
>  after an OS defined delay internal (default is 10 minutes.)
>
>Then in section 10.3.2.2.8 there is table 146 "Platform Event Log
>Format, Version 6, EPOW Section", which includes the "EPOW Event
>Modifier":
>
>  For EPOW sensor value = 3
>  0x01 = Normal system shutdown with no additional delay
>  0x02 = Loss of utility power, system is running on UPS/Battery
>  0x03 = Loss of system critical functions, system should be shutdown
>  0x04 = Ambient temperature too high
>  All other values = reserved
>
>We have a user space tool (rtas_errd) on LPAR to monitor for
>EPOW_SHUTDOWN_ON_UPS. Once it gets an event it initiates shutdown
>after predefined time. It also starts monitoring for any new EPOW
>events. If it receives "Power restored" event before predefined time
>it will cancel the shutdown. Otherwise after predefined time it will
>shutdown the system.
>
>Commit 79872e35469b ("powerpc/pseries: All events of
>EPOW_SYSTEM_SHUTDOWN must initiate shutdown") changed our handling of
>the "on UPS/Battery" case, to immediately shutdown the system. This
>breaks existing setups that rely on the userspace tool to delay
>shutdown and let the system run on the UPS.
>
>Fixes: 79872e35469b ("powerpc/pseries: All events of EPOW_SYSTEM_SHUTDOWN must initiate shutdown")
>Cc: stable@vger.kernel.org # v4.0+
>Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
>[mpe: Massage change log and add PAPR references]
>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>Link: https://lore.kernel.org/r/20200820061844.306460-1-hegdevasant@linux.vnet.ibm.com
>Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
>---
>Hi,
>  Please apply this patch to linux-stable-v4.4 branch. Its already applied to
>  other required stable branches.

Queued up, thanks!

-- 
Thanks,
Sasha
