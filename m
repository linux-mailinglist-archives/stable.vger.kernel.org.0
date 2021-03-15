Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7CD33B7EF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhCOOBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232499AbhCON7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67E8464F4A;
        Mon, 15 Mar 2021 13:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816771;
        bh=ZZ+YeAks4pW1cWLAxWfu5jU4iiFdjFcSyOTYi8m24OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XW1OrsK0E9vZ35GLMbJwZPpOtSnT3uq1naEITIfSZGlg786vVtGh4L5IXvtfZm61V
         am9Dd4D9lyqQgCRa+fg6QwpdTvD+PYp2FV3up5lakyUIqjm1BqrOvGNf8RuQfs7YTh
         b41JgdIP79Gjs5M5UiBrw1TdNQgRKwx3UquM0g2o=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 115/306] sh_eth: fix TRSCER mask for R7S9210
Date:   Mon, 15 Mar 2021 14:52:58 +0100
Message-Id: <20210315135511.536003669@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
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


