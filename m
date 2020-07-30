Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD34F232D09
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgG3IGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729297AbgG3IGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:06:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACD3B20656;
        Thu, 30 Jul 2020 08:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096377;
        bh=uiZlRAIDfr7V5wkzLLJktwI7L8k50wgm0ffRF+1OxbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDY/mH6o6Vwpfwjx5ANAk50OIjNGivUqipQcLsqJE5t3Tn1DgGJZjeHaRnktrZ/AF
         zzpnO/B1T3UdiUliLcrCcWJty0jKvqx+Bber93lmV+CJKgCnottCr2awSSF5d8qs5S
         /qoHai1wEhSTrIk2+2NYQJhjWfx1f2IDNsK3rwUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhuguangqing <zhuguangqing@xiaomi.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 18/19] PM: wakeup: Show statistics for deleted wakeup sources again
Date:   Thu, 30 Jul 2020 10:04:20 +0200
Message-Id: <20200730074421.402316044@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.502923740@linuxfoundation.org>
References: <20200730074420.502923740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhuguangqing <zhuguangqing@xiaomi.com>

commit e976eb4b91e906f20ec25b20c152d53c472fc3fd upstream.

After commit 00ee22c28915 (PM / wakeup: Use seq_open() to show wakeup
stats), print_wakeup_source_stats(m, &deleted_ws) is not called from
wakeup_sources_stats_seq_show() any more.

Because deleted_ws is one of the wakeup sources, it should be shown
too, so add it to the end of all other wakeup sources.

Signed-off-by: zhuguangqing <zhuguangqing@xiaomi.com>
[ rjw: Subject & changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/wakeup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -1073,6 +1073,9 @@ static void *wakeup_sources_stats_seq_ne
 		break;
 	}
 
+	if (!next_ws)
+		print_wakeup_source_stats(m, &deleted_ws);
+
 	return next_ws;
 }
 


