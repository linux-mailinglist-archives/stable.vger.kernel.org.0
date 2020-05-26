Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487331E2D64
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390240AbgEZTJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391884AbgEZTJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:09:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43F2020873;
        Tue, 26 May 2020 19:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520174;
        bh=7IKmBvPJx1xr7hrSb/vIGF8kI12tcK/bonIHJ5QucHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5giwNQkrIegXUn0ODLLo4TI8Tt7HS/GartJLafk3q2SqalwpwjCFovz3NRlYBUbz
         JvY/qFipdOjP83fLb/095jOnu+4VCFQ6IylqGUAAw09G2+evzL0LyhzH0u6vco91gr
         J1/7plPGmzJP3qISoEaMEqtioAxigkvBEJq0HzoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Klaus Doth <kdlnx@doth.eu>
Subject: [PATCH 5.4 088/111] misc: rtsx: Add short delay after exit from ASPM
Date:   Tue, 26 May 2020 20:53:46 +0200
Message-Id: <20200526183941.276181108@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/misc/cardreader/rtsx_pcr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -143,6 +143,9 @@ static void rtsx_comm_pm_full_on(struct
 
 	rtsx_disable_aspm(pcr);
 
+	/* Fixes DMA transfer timout issue after disabling ASPM on RTS5260 */
+	msleep(1);
+
 	if (option->ltr_enabled)
 		rtsx_set_ltr_latency(pcr, option->ltr_active_latency);
 


