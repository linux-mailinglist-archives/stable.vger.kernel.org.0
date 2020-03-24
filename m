Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA31D19101F
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgCXNZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbgCXNZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:25:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE0AF206F6;
        Tue, 24 Mar 2020 13:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056323;
        bh=gFYnGMRQ2z2WDGa1Ce7kJVmXByTCRC8DYYrHILf9p74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEJoue3HquKmPLuRBX0DDXOftbbfcgvGKTMlPk2R+gVLUu7Pgxaf5gLqM8+Bm5ZE0
         8z4HwN7l2p/0ysXddFWsgr7AAaVsaOez45wjKLOv4RJ+viJj4ogcopsGTu2XnWkDSP
         Gr6f/8jVNa3pKMn4q2lm0euLgYj+QP//xUYHiI6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.5 091/119] stm class: sys-t: Fix the use of time_after()
Date:   Tue, 24 Mar 2020 14:11:16 +0100
Message-Id: <20200324130817.286646453@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 283f87c0d5d32b4a5c22636adc559bca82196ed3 upstream.

The operands of time_after() are in a wrong order in both instances in
the sys-t driver. Fix that.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: 39f10239df75 ("stm class: p_sys-t: Add support for CLOCKSYNC packets")
Fixes: d69d5e83110f ("stm class: Add MIPI SyS-T protocol support")
Cc: stable@vger.kernel.org # v4.20+
Link: https://lore.kernel.org/r/20200317062215.15598-3-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/stm/p_sys-t.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hwtracing/stm/p_sys-t.c
+++ b/drivers/hwtracing/stm/p_sys-t.c
@@ -238,7 +238,7 @@ static struct configfs_attribute *sys_t_
 static inline bool sys_t_need_ts(struct sys_t_output *op)
 {
 	if (op->node.ts_interval &&
-	    time_after(op->ts_jiffies + op->node.ts_interval, jiffies)) {
+	    time_after(jiffies, op->ts_jiffies + op->node.ts_interval)) {
 		op->ts_jiffies = jiffies;
 
 		return true;
@@ -250,8 +250,8 @@ static inline bool sys_t_need_ts(struct
 static bool sys_t_need_clock_sync(struct sys_t_output *op)
 {
 	if (op->node.clocksync_interval &&
-	    time_after(op->clocksync_jiffies + op->node.clocksync_interval,
-		       jiffies)) {
+	    time_after(jiffies,
+		       op->clocksync_jiffies + op->node.clocksync_interval)) {
 		op->clocksync_jiffies = jiffies;
 
 		return true;


