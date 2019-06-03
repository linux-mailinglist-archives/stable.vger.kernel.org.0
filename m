Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E039C32B96
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfFCJJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbfFCJJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:09:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABCEB27E1E;
        Mon,  3 Jun 2019 09:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559552984;
        bh=ZAwey9El/ODFZAWcujVsTBv2WCksD9veMZj0nHo1jek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHv/aGMr5pTGQxTCXI0uUVf251M9YnzXHnt9C+F1lVUdCcxKfan4kQuDhnOWOTaRr
         hB5g3Okwx8JM/6sYCqOMMJJTNSKOFe+3QqYEYylp4WwKS+XWbKNcr2RXFr0Pku8KRE
         jYzRt6aXPAus5oZ1m6iaO34VIAUURpEWAho79gfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 02/32] cxgb4: offload VLAN flows regardless of VLAN ethtype
Date:   Mon,  3 Jun 2019 11:07:56 +0200
Message-Id: <20190603090308.830894857@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
References: <20190603090308.472021390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>

[ Upstream commit b5730061d1056abf317caea823b94d6e12b5b4f6 ]

VLAN flows never get offloaded unless ivlan_vld is set in filter spec.
It's not compulsory for vlan_ethtype to be set.

So, always enable ivlan_vld bit for offloading VLAN flows regardless of
vlan_ethtype is set or not.

Fixes: ad9af3e09c (cxgb4: add tc flower match support for vlan)
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -228,6 +228,9 @@ static void cxgb4_process_flow_match(str
 		fs->val.ivlan = vlan_tci;
 		fs->mask.ivlan = vlan_tci_mask;
 
+		fs->val.ivlan_vld = 1;
+		fs->mask.ivlan_vld = 1;
+
 		/* Chelsio adapters use ivlan_vld bit to match vlan packets
 		 * as 802.1Q. Also, when vlan tag is present in packets,
 		 * ethtype match is used then to match on ethtype of inner
@@ -238,8 +241,6 @@ static void cxgb4_process_flow_match(str
 		 * ethtype value with ethtype of inner header.
 		 */
 		if (fs->val.ethtype == ETH_P_8021Q) {
-			fs->val.ivlan_vld = 1;
-			fs->mask.ivlan_vld = 1;
 			fs->val.ethtype = 0;
 			fs->mask.ethtype = 0;
 		}


