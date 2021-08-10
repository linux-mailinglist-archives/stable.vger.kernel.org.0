Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846DA3E8239
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbhHJSGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236925AbhHJSCw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:02:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F3F61247;
        Tue, 10 Aug 2021 17:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617660;
        bh=RppSVzZqd8zSzFsHTKg6i3gLtAu1TbuZZDHjEaEfkS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+rkSUZOGbt+I6AJQSAkn1clPW8aG8YoeQR/p/JM8TpjCrsXEGBFXFS/AoKvd23md
         n4caMf662SWCZiagFsn9gXbM9ZwxLstnk5m//06ur9uu5b/X3NzCCDw6qQL20Rgsww
         gMjilwmdJDi3z5Meh78RWidaMjI5BUoiSQaT5dRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Tipton <mdtipton@codeaurora.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 5.13 156/175] interconnect: Zero initial BW after sync-state
Date:   Tue, 10 Aug 2021 19:31:04 +0200
Message-Id: <20210810173006.108102440@linuxfoundation.org>
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

commit 456a9dace42ecfcec7ce6e17c18d1985d628dcd0 upstream.

The initial BW values may be used by providers to enforce floors. Zero
these values after sync-state so that providers know when to stop
enforcing them.

Fixes: b1d681d8d324 ("interconnect: Add sync state support")
Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
Link: https://lore.kernel.org/r/20210721175432.2119-2-mdtipton@codeaurora.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1106,6 +1106,8 @@ void icc_sync_state(struct device *dev)
 		dev_dbg(p->dev, "interconnect provider is in synced state\n");
 		list_for_each_entry(n, &p->nodes, node_list) {
 			if (n->init_avg || n->init_peak) {
+				n->init_avg = 0;
+				n->init_peak = 0;
 				aggregate_requests(n);
 				p->set(n, n);
 			}


