Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92623E820B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhHJSFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234493AbhHJSDN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:03:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E611961241;
        Tue, 10 Aug 2021 17:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617662;
        bh=pDdLwGfN7E6ybMm18yH4Jbx6PvgDlvXVc+EYZDqlKyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5xDtGYYmqflluVdGNHIB7+Ajc/IizUH/+d9XWZNwuH1RRmi0eVWsTFRfGZI7SmOP
         Vu+JPRrhj/ZOHtli8OJq0A+UekXzSPI0Hod1nvDoIP0monjpmWMQtCKFpeTG9T/EWe
         EbdVx3TZCxp51Z9+LDM6dVmudgFgdusFtfrX+8pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Tipton <mdtipton@codeaurora.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 5.13 157/175] interconnect: Always call pre_aggregate before aggregate
Date:   Tue, 10 Aug 2021 19:31:05 +0200
Message-Id: <20210810173006.139418823@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Tipton <mdtipton@codeaurora.org>

commit 73606ba9242f8e32023699b500b7922b4cf2993c upstream.

The pre_aggregate callback isn't called in all cases before calling
aggregate. Add the missing calls so providers can rely on consistent
framework behavior.

Fixes: d3703b3e255f ("interconnect: Aggregate before setting initial bandwidth")
Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
Link: https://lore.kernel.org/r/20210721175432.2119-3-mdtipton@codeaurora.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -973,9 +973,14 @@ void icc_node_add(struct icc_node *node,
 	}
 	node->avg_bw = node->init_avg;
 	node->peak_bw = node->init_peak;
+
+	if (provider->pre_aggregate)
+		provider->pre_aggregate(node);
+
 	if (provider->aggregate)
 		provider->aggregate(node, 0, node->init_avg, node->init_peak,
 				    &node->avg_bw, &node->peak_bw);
+
 	provider->set(node, node);
 	node->avg_bw = 0;
 	node->peak_bw = 0;


