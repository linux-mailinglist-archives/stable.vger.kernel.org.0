Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE413ED505
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbhHPNH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237308AbhHPNGP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:06:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F19C632A8;
        Mon, 16 Aug 2021 13:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119142;
        bh=UDGrsDOzRgCA/grhzvmXw437X+dpszg1H4mzPRnPOHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZT4bUw3Hf39+3O7fstQKI2hV8yuiye0bxRrb5TgORyw61nk52aS5+0f+FrPYIm5PL
         02oXZyPsCu8Hyjl2mHlU0xuDnW/oOKdmRYi61oAqSq1OaGLl9nSHC+EscTokMcMIN7
         3mrAKDbvT2YErpIs+y+oUr8sf6T5SSZYWvlelYiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dai <ben.dai@unisoc.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 48/62] genirq/timings: Prevent potential array overflow in __irq_timings_store()
Date:   Mon, 16 Aug 2021 15:02:20 +0200
Message-Id: <20210816125429.857450393@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
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


