Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188043ED566
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbhHPNLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239135AbhHPNJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B19EA61A7A;
        Mon, 16 Aug 2021 13:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119320;
        bh=UDGrsDOzRgCA/grhzvmXw437X+dpszg1H4mzPRnPOHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtyRysds3oSf9UwhlMQiflU13l/pV/JpTLbILdgxT0NrWLISX0NgeEek6ABqt2MYV
         hj/7KxpoAHNCkPt7ZdVP0ENMQa5O+L6Kk0b+1kb6TcODrjlsMlzfa+H22bi/fJuErK
         G7Xi6TKFp8XuDpVJjCYvedpU5sbWIH0WpBtzE5ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dai <ben.dai@unisoc.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 78/96] genirq/timings: Prevent potential array overflow in __irq_timings_store()
Date:   Mon, 16 Aug 2021 15:02:28 +0200
Message-Id: <20210816125437.588003499@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dai <ben.dai@unisoc.com>

commit b9cc7d8a4656a6e815852c27ab50365009cb69c1 upstream.

When the interrupt interval is greater than 2 ^ PREDICTION_BUFFER_SIZE *
PREDICTION_FACTOR us and less than 1s, the calculated index will be greater
than the length of irqs->ema_time[]. Check the calculated index before
using it to prevent array overflow.

Fixes: 23aa3b9a6b7d ("genirq/timings: Encapsulate storing function")
Signed-off-by: Ben Dai <ben.dai@unisoc.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210425150903.25456-1-ben.dai9703@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/timings.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/irq/timings.c
+++ b/kernel/irq/timings.c
@@ -453,6 +453,11 @@ static __always_inline void __irq_timing
 	 */
 	index = irq_timings_interval_index(interval);
 
+	if (index > PREDICTION_BUFFER_SIZE - 1) {
+		irqs->count = 0;
+		return;
+	}
+
 	/*
 	 * Store the index as an element of the pattern in another
 	 * circular array.


