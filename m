Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35364F38C7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377182AbiDEL2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349711AbiDEJvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:51:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9389DEF2;
        Tue,  5 Apr 2022 02:49:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60FBFB81B14;
        Tue,  5 Apr 2022 09:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE497C385A2;
        Tue,  5 Apr 2022 09:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152142;
        bh=eI/tG81nC1saJgPatTgG7icD/lGlD5gWAo+K+jBtukE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfSQ7Jfx4ipHTDL8+TTham6Ez6K53Rroj7o1hXoPk1rBkZmzc7OX8uXzo0fFeLDRf
         Aqz/YxtvroeS5KWOM6bLL6Yhmo2pm5FsSXPxYJ9UatrvwJ8oHRLrDuXUskOvjyUrRr
         3rXvYmDi+2kb/zDatA+BbQdqJry5XW/ImL+lebKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 671/913] qlcnic: dcb: default to returning -EOPNOTSUPP
Date:   Tue,  5 Apr 2022 09:28:53 +0200
Message-Id: <20220405070359.949755467@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 5d79ee4370bc..7519773eaca6 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
@@ -51,7 +51,7 @@ static inline int qlcnic_dcb_get_hw_capability(struct qlcnic_dcb *dcb)
 	if (dcb && dcb->ops->get_hw_capability)
 		return dcb->ops->get_hw_capability(dcb);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline void qlcnic_dcb_free(struct qlcnic_dcb *dcb)
@@ -65,7 +65,7 @@ static inline int qlcnic_dcb_attach(struct qlcnic_dcb *dcb)
 	if (dcb && dcb->ops->attach)
 		return dcb->ops->attach(dcb);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline int
@@ -74,7 +74,7 @@ qlcnic_dcb_query_hw_capability(struct qlcnic_dcb *dcb, char *buf)
 	if (dcb && dcb->ops->query_hw_capability)
 		return dcb->ops->query_hw_capability(dcb, buf);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline void qlcnic_dcb_get_info(struct qlcnic_dcb *dcb)
@@ -89,7 +89,7 @@ qlcnic_dcb_query_cee_param(struct qlcnic_dcb *dcb, char *buf, u8 type)
 	if (dcb && dcb->ops->query_cee_param)
 		return dcb->ops->query_cee_param(dcb, buf, type);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline int qlcnic_dcb_get_cee_cfg(struct qlcnic_dcb *dcb)
@@ -97,7 +97,7 @@ static inline int qlcnic_dcb_get_cee_cfg(struct qlcnic_dcb *dcb)
 	if (dcb && dcb->ops->get_cee_cfg)
 		return dcb->ops->get_cee_cfg(dcb);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline void qlcnic_dcb_aen_handler(struct qlcnic_dcb *dcb, void *msg)
-- 
2.34.1



