Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECF51CABAF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbgEHMp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729013AbgEHMp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D2302497E;
        Fri,  8 May 2020 12:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941958;
        bh=zUnkXcQRBvuYJ0/G7/p5WFW1qIEpPSAVojHP16/RYtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tf6q72dS1HrQmsBBrZSpO8KYGp1Trvo7W9Wg0hqONDnoB751Thm4c5NX/xPZ2RZK7
         bm7L6jddxpNbDp8wQr52l980HCpP+WzDjQrhqiSETiSnYJ5WDeDBmUlX4ML/VIpQcQ
         VfKSJNwFIYyvnUdpNCLNt8O0gTZzwhViFTPeCn1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcin Nowakowski <marcin.nowakowski@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 241/312] MIPS: perf: Remove incorrect odd/even counter handling for I6400
Date:   Fri,  8 May 2020 14:33:52 +0200
Message-Id: <20200508123141.375764266@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>

commit f7a31b5e7874f77464a4eae0a8ba84b9ae0b3a54 upstream.

All performance counters on I6400 (odd and even) are capable of counting
any of the available events, so drop current logic of using the extra
bit to determine which counter to use.

Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Fixes: 4e88a8621301 ("MIPS: Add cases for CPU_I6400")
Fixes: fd716fca10fc ("MIPS: perf: Fix I6400 event numbers")
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/15991/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/perf_event_mipsxx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -1606,7 +1606,6 @@ static const struct mips_perf_event *mip
 #endif
 		break;
 	case CPU_P5600:
-	case CPU_I6400:
 		/* 8-bit event numbers */
 		raw_id = config & 0x1ff;
 		base_id = raw_id & 0xff;
@@ -1619,6 +1618,11 @@ static const struct mips_perf_event *mip
 		raw_event.range = P;
 #endif
 		break;
+	case CPU_I6400:
+		/* 8-bit event numbers */
+		base_id = config & 0xff;
+		raw_event.cntr_mask = CNTR_EVEN | CNTR_ODD;
+		break;
 	case CPU_1004K:
 		if (IS_BOTH_COUNTERS_1004K_EVENT(base_id))
 			raw_event.cntr_mask = CNTR_EVEN | CNTR_ODD;


