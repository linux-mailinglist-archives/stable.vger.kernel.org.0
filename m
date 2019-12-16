Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096691215C9
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731871AbfLPSS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:18:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731713AbfLPSS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:18:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFAB220CC7;
        Mon, 16 Dec 2019 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520337;
        bh=w8DpnLIqefWHHbyN99Kdhz6nhOOdKYSGyPbX7mF7uQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sh4UnMfQzz5mrbSiK8/b2zg8EbB/TzuTxvkWDRUoUnqn8Sj52rh6L3lchjzSpK8bD
         6KTm9FkY2Ro5eIZT2EKZrH78ikI8XTTFcSupg+2Gn7enuj4gdpv0XvJ35ic9j9SU33
         ZwyUBCcFV5uL1F4XlXonqOpAighpq69uNs7Dxzio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        "Hariharan T.S." <hari@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 113/177] powerpc/perf: Disable trace_imc pmu
Date:   Mon, 16 Dec 2019 18:49:29 +0100
Message-Id: <20191216174842.360082287@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>

commit 249fad734a25889a4f23ed014d43634af6798063 upstream.

When a root user or a user with CAP_SYS_ADMIN privilege uses any
trace_imc performance monitoring unit events, to monitor application
or KVM threads, it may result in a checkstop (System crash).

The cause is frequent switching of the "trace/accumulation" mode of
the In-Memory Collection hardware (LDBAR).

This patch disables the trace_imc PMU unit entirely to avoid
triggering the checkstop. A future patch will reenable it at a later
stage once a workaround has been developed.

Fixes: 012ae244845f ("powerpc/perf: Trace imc PMU functions")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Tested-by: Hariharan T.S. <hari@linux.ibm.com>
[mpe: Add pr_info_once() so dmesg shows the PMU has been disabled]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191118034452.9939-1-maddy@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/opal-imc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/powernv/opal-imc.c
+++ b/arch/powerpc/platforms/powernv/opal-imc.c
@@ -285,7 +285,14 @@ static int opal_imc_counters_probe(struc
 			domain = IMC_DOMAIN_THREAD;
 			break;
 		case IMC_TYPE_TRACE:
-			domain = IMC_DOMAIN_TRACE;
+			/*
+			 * FIXME. Using trace_imc events to monitor application
+			 * or KVM thread performance can cause a checkstop
+			 * (system crash).
+			 * Disable it for now.
+			 */
+			pr_info_once("IMC: disabling trace_imc PMU\n");
+			domain = -1;
 			break;
 		default:
 			pr_warn("IMC Unknown Device type \n");


