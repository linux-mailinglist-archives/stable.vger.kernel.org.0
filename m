Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65AF2CA48C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733002AbfJCQZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390958AbfJCQZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:25:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79B4220867;
        Thu,  3 Oct 2019 16:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119942;
        bh=kvo8e6FkZ7qO+5CeiOkhJiM1oUsYCDpijb9DiyqS2Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUh30/eWyVuCo3Wqxh2PoCYnVuuJE4ezug3WJfCIzrlqDM7zxZMaYmEGhSfUB1Gjb
         XSjCG7N1jkQt8cLxdR+DMUyZ2LuW9TX1jNV2LW6a3LTGPJZ3d0Rop+oFxdqLWu2jz6
         MXkS01c4xEql6ta2KVvninDI5XzdgKpHxxkGQouM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.2 006/313] net: qrtr: Stop rx_worker before freeing node
Date:   Thu,  3 Oct 2019 17:49:44 +0200
Message-Id: <20191003154534.142045176@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 73f0c11d11329a0d6d205d4312b6e5d2512af7c5 ]

As the endpoint is unregistered there might still be work pending to
handle incoming messages, which will result in a use after free
scenario. The plan is to remove the rx_worker, but until then (and for
stable@) ensure that the work is stopped before the node is freed.

Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Cc: stable@vger.kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/qrtr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -150,6 +150,7 @@ static void __qrtr_node_release(struct k
 	list_del(&node->item);
 	mutex_unlock(&qrtr_node_lock);
 
+	cancel_work_sync(&node->work);
 	skb_queue_purge(&node->rx_queue);
 	kfree(node);
 }


