Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BA524F50A
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgHXIoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbgHXIn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:43:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F4BC20FC3;
        Mon, 24 Aug 2020 08:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258638;
        bh=ngj6WiQUPERZ5q4EO+GD7YhTNCR/Src7jBSoABAThGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBUR2ilJzx0nBLWbsJXi6YtUwpa0PZTnW/mI4g+Zby7vZJvyf2mjEMFhSBJCxsBNx
         kmPiOeW3P9rVnl1oImiihLIaB/rCrf8plSE48MQhAeTLcLIgBf5d3hUxK+kBKFclDP
         vDOKV0OsC5P1kTb+JcR8ax3Ff2EBpt84TORifj4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.7 117/124] powerpc/pseries: Do not initiate shutdown when system is running on UPS
Date:   Mon, 24 Aug 2020 10:30:51 +0200
Message-Id: <20200824082415.161754479@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>

commit 90a9b102eddf6a3f987d15f4454e26a2532c1c98 upstream.

As per PAPR we have to look for both EPOW sensor value and event
modifier to identify the type of event and take appropriate action.

In LoPAPR v1.1 section 10.2.2 includes table 136 "EPOW Action Codes":

  SYSTEM_SHUTDOWN 3

  The system must be shut down. An EPOW-aware OS logs the EPOW error
  log information, then schedules the system to be shut down to begin
  after an OS defined delay internal (default is 10 minutes.)

Then in section 10.3.2.2.8 there is table 146 "Platform Event Log
Format, Version 6, EPOW Section", which includes the "EPOW Event
Modifier":

  For EPOW sensor value = 3
  0x01 = Normal system shutdown with no additional delay
  0x02 = Loss of utility power, system is running on UPS/Battery
  0x03 = Loss of system critical functions, system should be shutdown
  0x04 = Ambient temperature too high
  All other values = reserved

We have a user space tool (rtas_errd) on LPAR to monitor for
EPOW_SHUTDOWN_ON_UPS. Once it gets an event it initiates shutdown
after predefined time. It also starts monitoring for any new EPOW
events. If it receives "Power restored" event before predefined time
it will cancel the shutdown. Otherwise after predefined time it will
shutdown the system.

Commit 79872e35469b ("powerpc/pseries: All events of
EPOW_SYSTEM_SHUTDOWN must initiate shutdown") changed our handling of
the "on UPS/Battery" case, to immediately shutdown the system. This
breaks existing setups that rely on the userspace tool to delay
shutdown and let the system run on the UPS.

Fixes: 79872e35469b ("powerpc/pseries: All events of EPOW_SYSTEM_SHUTDOWN must initiate shutdown")
Cc: stable@vger.kernel.org # v4.0+
Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
[mpe: Massage change log and add PAPR references]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200820061844.306460-1-hegdevasant@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/ras.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -184,7 +184,6 @@ static void handle_system_shutdown(char
 	case EPOW_SHUTDOWN_ON_UPS:
 		pr_emerg("Loss of system power detected. System is running on"
 			 " UPS/battery. Check RTAS error log for details\n");
-		orderly_poweroff(true);
 		break;
 
 	case EPOW_SHUTDOWN_LOSS_OF_CRITICAL_FUNCTIONS:


