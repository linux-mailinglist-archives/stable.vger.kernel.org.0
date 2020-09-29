Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E350227C8D8
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbgI2Lhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730242AbgI2Lhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EA1A2395A;
        Tue, 29 Sep 2020 11:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379386;
        bh=9LHSlaA2Hm05YczGqeSAK5+Erp4ymMiNdM7KFdW++2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixZVsIQpe6Z800hfdNC15pmZ08Tw3A2kINaLWQvQ9iooDENSuH7BXNwv2+Xh8IWAw
         k7Bxd6fgNDZhzqgj5MGY6ouBEjYno7l7U0rzGqCVdhTQbeN8bRPMJ/9ANEYKXgz5WT
         NJw7VTOlkxL6NaCu9BznphzptDb0r/IhUXRsEdE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/388] iavf: use tc_cls_can_offload_and_chain0() instead of chain check
Date:   Tue, 29 Sep 2020 12:57:50 +0200
Message-Id: <20200929110017.204172448@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

[ Upstream commit bb0858d8bc828ebc3eaa90be02a0f32bca3c2351 ]

Looks like the iavf code actually experienced a race condition, when a
developer took code before the check for chain 0 was put to helper.
So use tc_cls_can_offload_and_chain0() helper instead of direct check and
move the check to _cb() so this is similar to i40e code.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 34124c213d27c..222ae76809aa1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3077,9 +3077,6 @@ static int iavf_delete_clsflower(struct iavf_adapter *adapter,
 static int iavf_setup_tc_cls_flower(struct iavf_adapter *adapter,
 				    struct flow_cls_offload *cls_flower)
 {
-	if (cls_flower->common.chain_index)
-		return -EOPNOTSUPP;
-
 	switch (cls_flower->command) {
 	case FLOW_CLS_REPLACE:
 		return iavf_configure_clsflower(adapter, cls_flower);
@@ -3103,6 +3100,11 @@ static int iavf_setup_tc_cls_flower(struct iavf_adapter *adapter,
 static int iavf_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 				  void *cb_priv)
 {
+	struct iavf_adapter *adapter = cb_priv;
+
+	if (!tc_cls_can_offload_and_chain0(adapter->netdev, type_data))
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
 		return iavf_setup_tc_cls_flower(cb_priv, type_data);
-- 
2.25.1



