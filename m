Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7098A627F36
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbiKNM4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237562AbiKNM4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:56:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA32027DE6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:56:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20C5E61184
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E8CC433C1;
        Mon, 14 Nov 2022 12:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430592;
        bh=nBlm+v1dOqo1wbfiEy6ePI7Hn9qcD82yOUJzcIHMbHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IiiNS2CsrVQwYeuZHrKCZo+wg/YhP/F9vhe1abqrfaB43ywpG1k1z0D9vEdcjwC6l
         FHK5LbVrRMpvySUoKNFvx/8GUen2YcU4FuEKDU1+hOY/4AAzj5ia4OHmPVl6XHgYF0
         5UlEAUJY07l4T2p/NYs5TGTQ1I7KX7J8NxNrSSY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Antoine Tenart <atenart@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/131] net: atlantic: macsec: clear encryption keys from the stack
Date:   Mon, 14 Nov 2022 13:45:43 +0100
Message-Id: <20221114124451.838394029@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 879785def0f5e71d54399de0f8a5cb399db14171 ]

Commit aaab73f8fba4 ("macsec: clear encryption keys from the stack after
setting up offload") made sure to clean encryption keys from the stack
after setting up offloading, but the atlantic driver made a copy and did
not clear it. Fix this.

[4 Fixes tags below, all part of the same series, no need to split this]

Fixes: 9ff40a751a6f ("net: atlantic: MACSec ingress offload implementation")
Fixes: b8f8a0b7b5cb ("net: atlantic: MACSec ingress offload HW bindings")
Fixes: 27736563ce32 ("net: atlantic: MACSec egress offload implementation")
Fixes: 9d106c6dd81b ("net: atlantic: MACSec egress offload HW bindings")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/aquantia/atlantic/aq_macsec.c |  2 ++
 .../aquantia/atlantic/macsec/macsec_api.c      | 18 +++++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 7c6e0811f2e6..ee823a18294c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -585,6 +585,7 @@ static int aq_update_txsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 
 	ret = aq_mss_set_egress_sakey_record(hw, &key_rec, sa_idx);
 
+	memzero_explicit(&key_rec, sizeof(key_rec));
 	return ret;
 }
 
@@ -932,6 +933,7 @@ static int aq_update_rxsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 
 	ret = aq_mss_set_ingress_sakey_record(hw, &sa_key_record, sa_idx);
 
+	memzero_explicit(&sa_key_record, sizeof(sa_key_record));
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
index 36c7cf05630a..431924959520 100644
--- a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
@@ -757,6 +757,7 @@ set_ingress_sakey_record(struct aq_hw_s *hw,
 			 u16 table_index)
 {
 	u16 packed_record[18];
+	int ret;
 
 	if (table_index >= NUMROWS_INGRESSSAKEYRECORD)
 		return -EINVAL;
@@ -789,9 +790,12 @@ set_ingress_sakey_record(struct aq_hw_s *hw,
 
 	packed_record[16] = rec->key_len & 0x3;
 
-	return set_raw_ingress_record(hw, packed_record, 18, 2,
-				      ROWOFFSET_INGRESSSAKEYRECORD +
-					      table_index);
+	ret = set_raw_ingress_record(hw, packed_record, 18, 2,
+				     ROWOFFSET_INGRESSSAKEYRECORD +
+				     table_index);
+
+	memzero_explicit(packed_record, sizeof(packed_record));
+	return ret;
 }
 
 int aq_mss_set_ingress_sakey_record(struct aq_hw_s *hw,
@@ -1739,14 +1743,14 @@ static int set_egress_sakey_record(struct aq_hw_s *hw,
 	ret = set_raw_egress_record(hw, packed_record, 8, 2,
 				    ROWOFFSET_EGRESSSAKEYRECORD + table_index);
 	if (unlikely(ret))
-		return ret;
+		goto clear_key;
 	ret = set_raw_egress_record(hw, packed_record + 8, 8, 2,
 				    ROWOFFSET_EGRESSSAKEYRECORD + table_index -
 					    32);
-	if (unlikely(ret))
-		return ret;
 
-	return 0;
+clear_key:
+	memzero_explicit(packed_record, sizeof(packed_record));
+	return ret;
 }
 
 int aq_mss_set_egress_sakey_record(struct aq_hw_s *hw,
-- 
2.35.1



