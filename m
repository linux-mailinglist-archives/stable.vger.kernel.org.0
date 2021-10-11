Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EE04290EF
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241062AbhJKOOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:14:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238454AbhJKOLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:11:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3513861266;
        Mon, 11 Oct 2021 14:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960999;
        bh=2HgE90nFJwJ1CQ9bdOOFsOSnLkwiOLVj6PfJOwxHRjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJd7qNNj6Aa2SivhRvUYDPATwNDcwXzyaSElrcwGigd58uOFrNl/x/CumRnypgNAd
         cLjj6o6ueEkiCFWQTbSaMT0z8Mi+1Q1yLk/dT7REzP5fuIrscXbhU1+e5IAPnS2OO5
         UoRnCCSBU/ghjaeRbHzochVFolBQdmCeXG66X/8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Jeroen de Borst <jeroendb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 110/151] gve: Properly handle errors in gve_assign_qpl
Date:   Mon, 11 Oct 2021 15:46:22 +0200
Message-Id: <20211011134521.374064291@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

[ Upstream commit d4b111fda69a01e0a7439d05993f5dad567c93aa ]

Ignored errors would result in crash.

Fixes: ede3fcf5ec67f ("gve: Add support for raw addressing to the rx path")
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index bb8261368250..94941d4e4744 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -104,8 +104,14 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 	if (!rx->data.page_info)
 		return -ENOMEM;
 
-	if (!rx->data.raw_addressing)
+	if (!rx->data.raw_addressing) {
 		rx->data.qpl = gve_assign_rx_qpl(priv);
+		if (!rx->data.qpl) {
+			kvfree(rx->data.page_info);
+			rx->data.page_info = NULL;
+			return -ENOMEM;
+		}
+	}
 	for (i = 0; i < slots; i++) {
 		if (!rx->data.raw_addressing) {
 			struct page *page = rx->data.qpl->pages[i];
-- 
2.33.0



