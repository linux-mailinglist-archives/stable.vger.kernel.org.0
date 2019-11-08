Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF086F5767
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389511AbfKHTVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:21:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389366AbfKHTAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66B7E224ED;
        Fri,  8 Nov 2019 18:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239545;
        bh=A3uqWeLulKyaW7+d0XIyZEE7zNmEG+d7VfGmmdfZ+n0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0zLn+Rzx/nZBw1drtVy+O91uok+GvADJF33cA0CTeeRtlvtS+vwzJQ8/FqXpPUE0
         61wnB/idJTQN5bPnlAw6NmBANqwo1f3dsmkNHXJjnFBf3Gbv6q8IrJTzXNogMY7k8K
         O/HzK36jfk/GKf+Zk4Bo2xfQfBYUJQQQBFc6l3F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 40/62] net: dsa: fix switch tree list
Date:   Fri,  8 Nov 2019 19:50:28 +0100
Message-Id: <20191108174748.430097798@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>

[ Upstream commit 50c7d2ba9de20f60a2d527ad6928209ef67e4cdd ]

If there are multiple switch trees on the device, only the last one
will be listed, because the arguments of list_add_tail are swapped.

Fixes: 83c0afaec7b7 ("net: dsa: Add new binding implementation")
Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/dsa2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -62,7 +62,7 @@ static struct dsa_switch_tree *dsa_add_d
 		return NULL;
 	dst->tree = tree;
 	INIT_LIST_HEAD(&dst->list);
-	list_add_tail(&dsa_switch_trees, &dst->list);
+	list_add_tail(&dst->list, &dsa_switch_trees);
 	kref_init(&dst->refcount);
 
 	return dst;


