Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D595F428F75
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238500AbhJKN7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:59:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236766AbhJKN5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:57:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 332586115C;
        Mon, 11 Oct 2021 13:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960457;
        bh=muFfzpf137RI9NEMGG8Dw8zEjBIl0FHw7FCmns55K04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ja+NdQ0IyDd97Gsl8dElvxDtaUjq1RAOC3/ak8Zhk/KZXyDl3vgIbwTZH/ywvIR1/
         PbZ0Aqt+GAQX26JcO0DqS7yefmccGt2sdGBSXWMmoTo5VJtQipVmMkMJp1zxWx8SDq
         ko8RGR6SvjT5SxdMxbGBRzRJetUb1rhHzI6kv34M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Yangchun Fu <yangchun@google.com>,
        Kuo Zhao <kuozhao@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 63/83] gve: report 64bit tx_bytes counter from gve_handle_report_stats()
Date:   Mon, 11 Oct 2021 15:46:23 +0200
Message-Id: <20211011134510.560045999@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 17c37d748f2b122a95b6d0524d410302ff89a2b1 ]

Each tx queue maintains a 64bit counter for bytes, there is
no reason to truncate this to 32bit (or this has not been
documented)

Fixes: 24aeb56f2d38 ("gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yangchun Fu <yangchun@google.com>
Cc: Kuo Zhao <kuozhao@google.com>
Cc: David Awogbemila <awogbemila@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index b658bf9b5399..fd52218f4884 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -987,9 +987,10 @@ static void gve_handle_reset(struct gve_priv *priv)
 
 void gve_handle_report_stats(struct gve_priv *priv)
 {
-	int idx, stats_idx = 0, tx_bytes;
-	unsigned int start = 0;
 	struct stats *stats = priv->stats_report->stats;
+	int idx, stats_idx = 0;
+	unsigned int start = 0;
+	u64 tx_bytes;
 
 	if (!gve_get_report_stats(priv))
 		return;
-- 
2.33.0



