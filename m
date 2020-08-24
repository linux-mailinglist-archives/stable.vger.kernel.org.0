Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C3424FAAF
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgHXIeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgHXIeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:34:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 627A92074D;
        Mon, 24 Aug 2020 08:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258042;
        bh=tpw+/6/+QISjO9o4rVZsj04GqJFEc56uTfd9A5kKfmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DYRi4oxvrIqWV1dqrAvkENnMNBcAnCX2Hul/QXdPjv+cp+3rWkbrc2b79MC4hP13s
         IOEKFYOiKla4Ju4Z3CAFyKV+lHof3+pqYpgVckQZB7aaxRidSKh+k7k7obhInU1vgJ
         +FOAepE2yTNrym2ow0VKkHnBNQcEU5TrvsEVy2FU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajendra Nayak <rnayak@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.8 023/148] opp: Put opp table in dev_pm_opp_set_rate() for empty tables
Date:   Mon, 24 Aug 2020 10:28:41 +0200
Message-Id: <20200824082415.077693170@linuxfoundation.org>
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

From: Stephen Boyd <swboyd@chromium.org>

commit 8979ef70850eb469e1094279259d1ef393ffe85f upstream.

We get the opp_table pointer at the top of the function and so we should
put the pointer at the end of the function like all other exit paths
from this function do.

Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
Fixes: aca48b61f963 ("opp: Manage empty OPP tables with clk handle")
Reviewed-by: Rajendra Nayak <rnayak@codeaurora.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
[ Viresh: Split the patch into two ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/opp/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -862,8 +862,10 @@ int dev_pm_opp_set_rate(struct device *d
 		 * have OPP table for the device, while others don't and
 		 * opp_set_rate() just needs to behave like clk_set_rate().
 		 */
-		if (!_get_opp_count(opp_table))
-			return 0;
+		if (!_get_opp_count(opp_table)) {
+			ret = 0;
+			goto put_opp_table;
+		}
 
 		if (!opp_table->required_opp_tables && !opp_table->regulators &&
 		    !opp_table->paths) {


