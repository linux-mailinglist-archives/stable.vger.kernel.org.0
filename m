Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658FE451E78
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345042AbhKPAgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344972AbhKOTZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A46F633FC;
        Mon, 15 Nov 2021 19:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003267;
        bh=LIfUoqHWMbW5VOX9oBhir4yAM0kUIioz9ouV1UYo+/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/BXZHvp6t/sJJMWALrjOTelWJRm3LGiw+Z2lXq0u3gwc8+WOqccGNh91QbHpGzKz
         1fb4ecgY52fC2SvbkCHuCrxdt1irXrJ58rVHRoMTL1nqB737sjCfeXq/I1z5bJGnti
         Q8iCCxWid95v4b4QHDrq86LTgpEN+RN6V0KtSND0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 845/917] thermal: int340x: fix build on 32-bit targets
Date:   Mon, 15 Nov 2021 18:05:40 +0100
Message-Id: <20211115165457.694027481@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit d9c8e52ff9e84ff1a406330f9ea4de7c5eb40282 ]

Commit aeb58c860dc5 ("thermal/drivers/int340x: processor_thermal: Suppot
64 bit RFIM responses") started using 'readq()' to read 64-bit status
responses from the int340x hardware.

That's all fine and good, but on 32-bit targets a 64-bit 'readq()' is
ambiguous, since it's no longer an atomic access.  Some hardware might
require 64-bit accesses, and other hardware might want low word first or
high word first.

It's quite likely that the driver isn't relevant in a 32-bit environment
any more, and there's a patch floating around to just make it depend on
X86_64, but let's make it buildable on x86-32 anyway.

The driver previously just read the low 32 bits, so the hardware
certainly is ok with 32-bit reads, and in a little-endian environment
the low word first model is the natural one.

So just add the include for the 'io-64-nonatomic-lo-hi.h' version.

Fixes: aeb58c860dc5 ("thermal/drivers/int340x: processor_thermal: Suppot 64 bit RFIM responses")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
index 59e93b04f0a9e..66cd0190bc035 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 #include "processor_thermal_device.h"
 
 #define MBOX_CMD_WORKLOAD_TYPE_READ	0x0E
-- 
2.33.0



