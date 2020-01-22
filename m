Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6AE214560D
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbgAVNTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:19:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgAVNTo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:19:44 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 512AE2468A;
        Wed, 22 Jan 2020 13:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699183;
        bh=3gY41t3PBbf9Bh54MQwzN0iQ5H5WEPl331nOFmFK0gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1m+b2j1WYkCPfgGXQ4ApUXw60uFVkAwgTIRSvqd4c4Kya2VAX3dnnDxlS2OpbZRx
         OGM7Ne02G+Uj3r58knncanAuYj9ekVBOr/Xif8StS0O/2c7VTwUFG4zaHe2ucEBY5+
         ArEML+NxfdVug2lyvXwQ2lbtnW7RVLcjN6Tlp8nI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <like.xu@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 065/222] perf/x86/intel/uncore: Fix missing marker for snr_uncore_imc_freerunning_events
Date:   Wed, 22 Jan 2020 10:27:31 +0100
Message-Id: <20200122092838.375669008@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit fa694ae532836bd2f4cd659e9b4032abaf9fa9e5 upstream.

An Oops during the boot is found on some SNR machines.  It turns out
this is because the snr_uncore_imc_freerunning_events[] array was
missing an end-marker.

Fixes: ee49532b38dd ("perf/x86/intel/uncore: Add IMC uncore support for Snow Ridge")
Reported-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Like Xu <like.xu@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200116200210.18937-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/intel/uncore_snbep.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -4536,6 +4536,7 @@ static struct uncore_event_desc snr_unco
 	INTEL_UNCORE_EVENT_DESC(write,		"event=0xff,umask=0x21"),
 	INTEL_UNCORE_EVENT_DESC(write.scale,	"3.814697266e-6"),
 	INTEL_UNCORE_EVENT_DESC(write.unit,	"MiB"),
+	{ /* end: all zeroes */ },
 };
 
 static struct intel_uncore_ops snr_uncore_imc_freerunning_ops = {


