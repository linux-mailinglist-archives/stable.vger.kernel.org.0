Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE324F56CD
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391985AbfKHTLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391983AbfKHTLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:11:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAA84206A3;
        Fri,  8 Nov 2019 19:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240270;
        bh=5U2KoR/x+eZQqF9wvUyyyqcjxdn5SHVLosdDW4FvFbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dy312iFB/fa6jc9z1YmCokJJnjmFZnHwHmoCxwsBgyM16X+Z2SdzUV7mC95U01pm0
         zUI3w++fBxlegjRIo6HZx/o5GN8hzL68eOj8480oyC2Ac4wrGe6qUSSYRFefEZjTnJ
         p3E8LonyJc7ckZiENd2NVUg40G9hYv7sYa+dZyro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 123/140] net: dsa: fix switch tree list
Date:   Fri,  8 Nov 2019 19:50:51 +0100
Message-Id: <20191108174912.478465365@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
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
@@ -46,7 +46,7 @@ static struct dsa_switch_tree *dsa_tree_
 	dst->index = index;
 
 	INIT_LIST_HEAD(&dst->list);
-	list_add_tail(&dsa_tree_list, &dst->list);
+	list_add_tail(&dst->list, &dsa_tree_list);
 
 	kref_init(&dst->refcount);
 


