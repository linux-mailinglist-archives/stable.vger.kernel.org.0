Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B75C0CD6F0
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbfJFRvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728034AbfJFRu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:50:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2CDA222D0;
        Sun,  6 Oct 2019 17:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383952;
        bh=IAvCUtQoEkkm/ms8EqboKBC0qzh6TVyhRsg0uyoDaFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXuwVu7rDla4UV9TQ5eNKxcnidvG+3DimOQ0qdBFzsQMKLX78wWNNRqUsGmDvBwym
         jiUbjLvsZs/cET0VC6x901gKCGjb65s+0/jF/ioZtFfS/Ug9yFZYQ/NhTS3+lvqFq6
         elzzTpkPbMHX7Q44Mkk6ID1iPOp48WKXyCay05/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 156/166] net: sched: cbs: Avoid division by zero when calculating the port rate
Date:   Sun,  6 Oct 2019 19:22:02 +0200
Message-Id: <20191006171226.022911349@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 83c8c3cf45163f0c823db37be6ab04dfcf8ac751 ]

As explained in the "net: sched: taprio: Avoid division by zero on
invalid link speed" commit, it is legal for the ethtool API to return
zero as a link speed. So guard against it to ensure we don't perform a
division by zero in kernel.

Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_cbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -306,7 +306,7 @@ static void cbs_set_port_rate(struct net
 	if (err < 0)
 		goto skip;
 
-	if (ecmd.base.speed != SPEED_UNKNOWN)
+	if (ecmd.base.speed && ecmd.base.speed != SPEED_UNKNOWN)
 		speed = ecmd.base.speed;
 
 skip:


