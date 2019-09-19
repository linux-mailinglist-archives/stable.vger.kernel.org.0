Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2290CB8466
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405703AbfISWKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405693AbfISWKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:10:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AF6821907;
        Thu, 19 Sep 2019 22:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931033;
        bh=D8BjZR/3dK83sXzD9E06btJTybonkgJLwdB8DhwSuVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTdylbTfretBRUU2McgPM9KPFf3S75bhByPKuvSNdyvPaMesafkOwqSQ5196q/eAA
         pCFlwGoi2l5+waHA1oOk/ooiirJ9eGlHKPZVBWJEaQQUnEK/poONWkqHqTfF1hpHdl
         DY0AxZ9LmAzwhjhzLD5iUnNIC9PSYPfTNF/TSqME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 102/124] net: aquantia: fix removal of vlan 0
Date:   Fri, 20 Sep 2019 00:03:10 +0200
Message-Id: <20190919214822.916609969@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

[ Upstream commit 6fdc060d7476ef73c8029b652d252c1a7b4de948 ]

Due to absence of checking against the rx flow rule when vlan 0 is being
removed, the other rule could be removed instead of the rule with vlan 0

Fixes: 7975d2aff5afb ("net: aquantia: add support of rx-vlan-filter offload")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
index 2c1111a7fc435..3dbf3ff1c4506 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -431,7 +431,8 @@ int aq_del_fvlan_by_vlan(struct aq_nic_s *aq_nic, u16 vlan_id)
 		if (be16_to_cpu(rule->aq_fsp.h_ext.vlan_tci) == vlan_id)
 			break;
 	}
-	if (rule && be16_to_cpu(rule->aq_fsp.h_ext.vlan_tci) == vlan_id) {
+	if (rule && rule->type == aq_rx_filter_vlan &&
+	    be16_to_cpu(rule->aq_fsp.h_ext.vlan_tci) == vlan_id) {
 		struct ethtool_rxnfc cmd;
 
 		cmd.fs.location = rule->aq_fsp.location;
-- 
2.20.1



