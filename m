Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E841F23B1
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgFHXPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728687AbgFHXPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEFBE20774;
        Mon,  8 Jun 2020 23:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658147;
        bh=9ypWvacEgRLRkAV2bi+phq1m4tvvc4shRDpMJxiW5eQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=us0yvymqlIcad4rxXyKZeb4wugvJoJD4B5PuSEuX+QZv19qTDNzAO59odbBodwPI7
         MX1nZ4hL9czKSXTp9XVmaV+7A9RjWZpKKEocto5T7esVPyMm2y4MRi3EA4CDXSIECG
         2n0lkpsdtR+HOgFzNcqXDqNz9MmSTCLXOtjj5nlU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Klaus Doth <kdlnx@doth.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 5.6 180/606] misc: rtsx: Add short delay after exit from ASPM
Date:   Mon,  8 Jun 2020 19:05:05 -0400
Message-Id: <20200608231211.3363633-180-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Klaus Doth <kdlnx@doth.eu>

commit 7a839dbab1be59f5ed3b3b046de29e166784c9b4 upstream.

DMA transfers to and from the SD card stall for 10 seconds and run into
timeout on RTS5260 card readers after ASPM was enabled.

Adding a short msleep after disabling ASPM fixes the issue on several
Dell Precision 7530/7540 systems I tested.

This function is only called when waking up after the chip went into
power-save after not transferring data for a few seconds. The added
msleep does therefore not change anything in data transfer speed or
induce any excessive waiting while data transfers are running, or the
chip is sleeping. Only the transition from sleep to active is affected.

Signed-off-by: Klaus Doth <kdlnx@doth.eu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/4434eaa7-2ee3-a560-faee-6cee63ebd6d4@doth.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rtsx_pcr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index 06038b325b02..55da6428ceb0 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -142,6 +142,9 @@ static void rtsx_comm_pm_full_on(struct rtsx_pcr *pcr)
 
 	rtsx_disable_aspm(pcr);
 
+	/* Fixes DMA transfer timout issue after disabling ASPM on RTS5260 */
+	msleep(1);
+
 	if (option->ltr_enabled)
 		rtsx_set_ltr_latency(pcr, option->ltr_active_latency);
 
-- 
2.25.1

