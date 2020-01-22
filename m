Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D07BB145505
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgAVNSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:18:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729083AbgAVNSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:18:08 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3298A20678;
        Wed, 22 Jan 2020 13:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699087;
        bh=mFIdlyVdzWS60cUgX/WY3zhoTOF/ycY5ekNherhcZE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7IfDP7CUtHV1m9xC+sX6ZEYxyXfKub5MwcCbQswpgmiloxa1xcgJAzdb6Oh+PNb0
         1VWIL8RV+Nfhq/qObTdkYY1WSjw3Ki3OdDiAOlD03bBWvJ6wG1Mt6MB0GQHrgX8jzX
         2bQDG+cEHXz5odHOP+VkKsSH0zyZIh2KKYPnzMWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.4 009/222] bus: ti-sysc: Fix iterating over clocks
Date:   Wed, 22 Jan 2020 10:26:35 +0100
Message-Id: <20200122092834.033352861@linuxfoundation.org>
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

From: Tony Lindgren <tony@atomide.com>

commit 2c81f0f6d3f52ac222a5dc07a6e5c06e1543e88b upstream.

Commit d878970f6ce1 ("bus: ti-sysc: Add separate functions for handling
clocks") separated handling of optional clocks from the main clocks, but
introduced an issue where we do not necessarily allocate a slot for both
fck and ick clocks, but still assume fixed slots for enumerating over the
clocks.

Let's fix the issue by ensuring we always have slots for both fck and ick
even if we don't use ick, and don't attempt to enumerate optional clocks
if not allocated.

In the long run we might want to simplify things a bit by only allocating
space only for the optional clocks as we have only few devices with
optional clocks.

Fixes: d878970f6ce1 ("bus: ti-sysc: Add separate functions for handling clocks")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bus/ti-sysc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -343,6 +343,12 @@ static int sysc_get_clocks(struct sysc *
 		return -EINVAL;
 	}
 
+	/* Always add a slot for main clocks fck and ick even if unused */
+	if (!nr_fck)
+		ddata->nr_clocks++;
+	if (!nr_ick)
+		ddata->nr_clocks++;
+
 	ddata->clocks = devm_kcalloc(ddata->dev,
 				     ddata->nr_clocks, sizeof(*ddata->clocks),
 				     GFP_KERNEL);
@@ -421,7 +427,7 @@ static int sysc_enable_opt_clocks(struct
 	struct clk *clock;
 	int i, error;
 
-	if (!ddata->clocks)
+	if (!ddata->clocks || ddata->nr_clocks < SYSC_OPTFCK0 + 1)
 		return 0;
 
 	for (i = SYSC_OPTFCK0; i < SYSC_MAX_CLOCKS; i++) {
@@ -455,7 +461,7 @@ static void sysc_disable_opt_clocks(stru
 	struct clk *clock;
 	int i;
 
-	if (!ddata->clocks)
+	if (!ddata->clocks || ddata->nr_clocks < SYSC_OPTFCK0 + 1)
 		return;
 
 	for (i = SYSC_OPTFCK0; i < SYSC_MAX_CLOCKS; i++) {


