Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28179505860
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244018AbiDROCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245044AbiDROAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:00:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15522C66B;
        Mon, 18 Apr 2022 06:09:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 798DEB80EE4;
        Mon, 18 Apr 2022 13:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD526C385A1;
        Mon, 18 Apr 2022 13:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287314;
        bh=MQ80TICDoU0k4gTgTnLQ3uHrBBGBTGfzc7zcAeNUXYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BeFzdhQcqk/rJr3RE7csAbb8ZrpsTHZo7D8Bub/L+LAAUZkNpC3Hn4EBarp2Bn6o0
         PnXMbrpvibz0QhhPKyegt9w8gXI3KD0g7ZkacnBiM29zCmZyVnsSbJY7mM9UQq9Row
         qtbAowGrQxYNG29RP0viruvC+b5Kb35RgQvuEVw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 121/218] qlcnic: dcb: default to returning -EOPNOTSUPP
Date:   Mon, 18 Apr 2022 14:13:07 +0200
Message-Id: <20220418121203.054580796@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 1521db37f0d42334a88e8ff28198a27d1ed5cd7b ]

Clang static analysis reports this issue
qlcnic_dcb.c:382:10: warning: Assigned value is
  garbage or undefined
  mbx_out = *val;
          ^ ~~~~

val is set in the qlcnic_dcb_query_hw_capability() wrapper.
If there is no query_hw_capability op in dcp, success is
returned without setting the val.

For this and similar wrappers, return -EOPNOTSUPP.

Fixes: 14d385b99059 ("qlcnic: dcb: Query adapter DCB capabilities.")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
index f4aa6331b367..0a9d24e86715 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
@@ -52,7 +52,7 @@ static inline int qlcnic_dcb_get_hw_capability(struct qlcnic_dcb *dcb)
 	if (dcb && dcb->ops->get_hw_capability)
 		return dcb->ops->get_hw_capability(dcb);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline void qlcnic_dcb_free(struct qlcnic_dcb *dcb)
@@ -66,7 +66,7 @@ static inline int qlcnic_dcb_attach(struct qlcnic_dcb *dcb)
 	if (dcb && dcb->ops->attach)
 		return dcb->ops->attach(dcb);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline int
@@ -75,7 +75,7 @@ qlcnic_dcb_query_hw_capability(struct qlcnic_dcb *dcb, char *buf)
 	if (dcb && dcb->ops->query_hw_capability)
 		return dcb->ops->query_hw_capability(dcb, buf);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline void qlcnic_dcb_get_info(struct qlcnic_dcb *dcb)
@@ -90,7 +90,7 @@ qlcnic_dcb_query_cee_param(struct qlcnic_dcb *dcb, char *buf, u8 type)
 	if (dcb && dcb->ops->query_cee_param)
 		return dcb->ops->query_cee_param(dcb, buf, type);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline int qlcnic_dcb_get_cee_cfg(struct qlcnic_dcb *dcb)
@@ -98,7 +98,7 @@ static inline int qlcnic_dcb_get_cee_cfg(struct qlcnic_dcb *dcb)
 	if (dcb && dcb->ops->get_cee_cfg)
 		return dcb->ops->get_cee_cfg(dcb);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline void qlcnic_dcb_aen_handler(struct qlcnic_dcb *dcb, void *msg)
-- 
2.34.1



