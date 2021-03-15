Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6066A33B7DA
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhCOOB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232648AbhCON7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2D5164F80;
        Mon, 15 Mar 2021 13:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816764;
        bh=ZZ+YeAks4pW1cWLAxWfu5jU4iiFdjFcSyOTYi8m24OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbhTPsMnO8W4Vq64AtzM8uJp7hqstWLxYUjOK4Rp4fRpe/M/2G/ZA4tkOYeXs0Neq
         XIVl5ACeJIGY7/mvEnnO2PG9F3thRZLHw0WN2fXZVgEu65+u/GZ5p0XOZ4j83zrJZc
         gW/M8KuI4/xjvLZbKHgLZgSGxVdHUlxL9LBXWQmM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 101/290] sh_eth: fix TRSCER mask for R7S9210
Date:   Mon, 15 Mar 2021 14:53:14 +0100
Message-Id: <20210315135545.329133422@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

commit 165bc5a4f30eee4735845aa7dbd6b738643f2603 upstream.

According  to the RZ/A2M Group User's Manual: Hardware, Rev. 2.00,
the TRSCER register has bit 9 reserved, hence we can't use the driver's
default TRSCER mask.  Add the explicit initializer for sh_eth_cpu_data::
trscer_err_mask for R7S9210.

Fixes: 6e0bb04d0e4f ("sh_eth: Add R7S9210 support")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/sh_eth.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -780,6 +780,8 @@ static struct sh_eth_cpu_data r7s9210_da
 
 	.fdr_value	= 0x0000070f,
 
+	.trscer_err_mask = DESC_I_RINT8 | DESC_I_RINT5,
+
 	.apr		= 1,
 	.mpr		= 1,
 	.tpauser	= 1,


