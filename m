Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6753A24F493
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbgHXIiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728488AbgHXIiA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:38:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E49022B47;
        Mon, 24 Aug 2020 08:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258279;
        bh=KfNoq6N2p+aGqJfVnuq17Kbyr3o0jWGxUz32+IgQyRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mba/tSEzVDpp5c+q5S/hvMp4vTglCDex1s0jTTuu49MSwGhOAfO4CFpb6zqp+mwyv
         clvuD1+mcxicV3sFIXBqFQvODvACuc1aR7Z0xiJhDmlyVld7yufpZUUWezpF15Ao/F
         kYhak2Pk5O23Rva/cD76nWEMoy9PU+4KkUjtxn5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Neuling <mikey@neuling.org>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.8 140/148] powerpc: Fix P10 PVR revision in /proc/cpuinfo for SMT4 cores
Date:   Mon, 24 Aug 2020 10:30:38 +0200
Message-Id: <20200824082420.725353079@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Neuling <mikey@neuling.org>

commit 030a2c689fb46e1690f7ded8b194bab7678efb28 upstream.

On POWER10 bit 12 in the PVR indicates if the core is SMT4 or SMT8.
Bit 12 is set for SMT4.

Without this patch, /proc/cpuinfo on a SMT4 DD1 POWER10 looks like
this:
  cpu             : POWER10, altivec supported
  revision        : 17.0 (pvr 0080 1100)

Fixes: a3ea40d5c736 ("powerpc: Add POWER10 architected mode")
Cc: stable@vger.kernel.org # v5.8
Signed-off-by: Michael Neuling <mikey@neuling.org>
Reviewed-by: Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200803035600.1820371-1-mikey@neuling.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/setup-common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -311,6 +311,7 @@ static int show_cpuinfo(struct seq_file
 				min = pvr & 0xFF;
 				break;
 			case 0x004e: /* POWER9 bits 12-15 give chip type */
+			case 0x0080: /* POWER10 bit 12 gives SMT8/4 */
 				maj = (pvr >> 8) & 0x0F;
 				min = pvr & 0xFF;
 				break;


