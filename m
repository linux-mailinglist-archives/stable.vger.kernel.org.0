Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A961380BE
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgAKKdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:33:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731497AbgAKKdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:33:37 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE14E20842;
        Sat, 11 Jan 2020 10:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738816;
        bh=KAZGPNOUpXPjKxUQxVo2QmQRLvQcbRjYGdHWikqgbPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTBXLOKCm2C8wMoiLc4whJPMIW7CsBkBz3Ba+j12e+JPbS5JD0DD44Q9mJgajVUAq
         XJ9QC2qBcPyHk+YAWp7hAXmGGp7Dc5BUjPYqc+8UtlpETnl/Tg9QioIOlbHBR3UgcT
         5RNfKk1oY4ucglRFI9u4sLq/99iXJruJ157meBUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 151/165] mlxsw: spectrum_qdisc: Ignore grafting of invisible FIFO
Date:   Sat, 11 Jan 2020 10:51:10 +0100
Message-Id: <20200111094940.710293947@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit 3971a535b839489e4ea31796cc086e6ce616318c ]

The following patch will change PRIO to replace a removed Qdisc with an
invisible FIFO, instead of NOOP. mlxsw will see this replacement due to the
graft message that is generated. But because FIFO does not issue its own
REPLACE message, when the graft operation takes place, the Qdisc that mlxsw
tracks under the indicated band is still the old one. The child
handle (0:0) therefore does not match, and mlxsw rejects the graft
operation, which leads to an extack message:

    Warning: Offloading graft operation failed.

Fix by ignoring the invisible children in the PRIO graft handler. The
DESTROY message of the removed Qdisc is going to follow shortly and handle
the removal.

Fixes: 32dc5efc6cb4 ("mlxsw: spectrum: qdiscs: prio: Handle graft command")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -650,6 +650,13 @@ mlxsw_sp_qdisc_prio_graft(struct mlxsw_s
 	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle == p->child_handle)
 		return 0;
 
+	if (!p->child_handle) {
+		/* This is an invisible FIFO replacing the original Qdisc.
+		 * Ignore it--the original Qdisc's destroy will follow.
+		 */
+		return 0;
+	}
+
 	/* See if the grafted qdisc is already offloaded on any tclass. If so,
 	 * unoffload it.
 	 */


