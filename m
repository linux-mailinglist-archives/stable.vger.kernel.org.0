Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64CE5507EF
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfFXKGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729489AbfFXKGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:06:14 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1767212F5;
        Mon, 24 Jun 2019 10:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370774;
        bh=2Oz6+lcMk60ggBjHIz3gvLIYXQiQ1JfdMB6XD2gj2Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AuJBAhsQp20jJ+6lSSMqxjM8u3P/yRV1S1XioiDwUElvJuQyyaKmrP2LSZPgT2DZ2
         23+s1sC6EDWf0WR/8r+MUU8LQOixKf85/XG61uhGTebHEKu8g7KUe+ACEZqxDQtJXz
         y12+B+GEohxYaXDBqskQ74dbe5SCLQrmyD8zWiys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gen Zhang <blackgod016574@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/90] mdesc: fix a missing-check bug in get_vdev_port_node_info()
Date:   Mon, 24 Jun 2019 17:56:41 +0800
Message-Id: <20190624092317.544998019@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 80caf43549e7e41a695c6d1e11066286538b336f ]

In get_vdev_port_node_info(), 'node_info->vdev_port.name' is allcoated
by kstrdup_const(), and it returns NULL when fails. So
'node_info->vdev_port.name' should be checked.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/mdesc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index 39a2503fa3e1..51028abe5e90 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -357,6 +357,8 @@ static int get_vdev_port_node_info(struct mdesc_handle *md, u64 node,
 
 	node_info->vdev_port.id = *idp;
 	node_info->vdev_port.name = kstrdup_const(name, GFP_KERNEL);
+	if (!node_info->vdev_port.name)
+		return -1;
 	node_info->vdev_port.parent_cfg_hdl = *parent_cfg_hdlp;
 
 	return 0;
-- 
2.20.1



