Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C793E8088
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhHJRur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235248AbhHJRr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:47:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4F776023D;
        Tue, 10 Aug 2021 17:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617263;
        bh=pDdLwGfN7E6ybMm18yH4Jbx6PvgDlvXVc+EYZDqlKyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZ3p0G+gZ75uVjIXDMWOCOrxvo6wAsr9NLRi5xpns4n+e7Ej9+XXSeQNUW/BboOm1
         AWgwa11oVx3T2W8jV1IKGuurYWvQ0NfI6epfyIPEsOMvCp5tE60kKkT4OLHZr1IORK
         40FYObgn60bZi3speHHtfUskl0vRUWiNe2niYwy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Tipton <mdtipton@codeaurora.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 5.10 118/135] interconnect: Always call pre_aggregate before aggregate
Date:   Tue, 10 Aug 2021 19:30:52 +0200
Message-Id: <20210810172959.802675667@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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


