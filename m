Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6464450F621
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244938AbiDZIs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346750AbiDZIpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E03205F8;
        Tue, 26 Apr 2022 01:35:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C88E618BF;
        Tue, 26 Apr 2022 08:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563C2C385A4;
        Tue, 26 Apr 2022 08:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962127;
        bh=oQ7J7Fd0YsOcOkKlCAaazGwXH++K/0LIJUsGqOlEJ5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zO88OxIRlk7JA8AFqZEXUC+3ksdbLzIsIZcyJnAhgjbUsGl9ie3XKnvybC48tNzlj
         soXcIWPV63cc1/Hy1ByDcnmz4ooAu+dvtw3m6Q7w2gWOIfcwiCDdSNQE0IkvN+JsI/
         R1UeKTR/kBrZC9aSSxPA93vNERMn+lvimfzskEe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 41/86] net: atlantic: Avoid out-of-bounds indexing
Date:   Tue, 26 Apr 2022 10:21:09 +0200
Message-Id: <20220426081742.392087785@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 8d3a6c37d50d5a0504c126c932cc749e6dd9c78f ]

UBSAN warnings are observed on atlantic driver:
[ 294.432996] UBSAN: array-index-out-of-bounds in /build/linux-Qow4fL/linux-5.15.0/drivers/net/ethernet/aquantia/atlantic/aq_nic.c:484:48
[ 294.433695] index 8 is out of range for type 'aq_vec_s *[8]'

The ring is dereferenced right before breaking out the loop, to prevent
that from happening, only use the index in the loop to fix the issue.

BugLink: https://bugs.launchpad.net/bugs/1958770
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
Link: https://lore.kernel.org/r/20220408022204.16815-1-kai.heng.feng@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  8 +++----
 .../net/ethernet/aquantia/atlantic/aq_vec.c   | 24 +++++++++----------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 0cf8ae8aeac8..2fb4126ae8d8 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -480,8 +480,8 @@ int aq_nic_start(struct aq_nic_s *self)
 	if (err < 0)
 		goto err_exit;
 
-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i]) {
+	for (i = 0U; self->aq_vecs > i; ++i) {
+		aq_vec = self->aq_vec[i];
 		err = aq_vec_start(aq_vec);
 		if (err < 0)
 			goto err_exit;
@@ -511,8 +511,8 @@ int aq_nic_start(struct aq_nic_s *self)
 		mod_timer(&self->polling_timer, jiffies +
 			  AQ_CFG_POLLING_TIMER_INTERVAL);
 	} else {
-		for (i = 0U, aq_vec = self->aq_vec[0];
-			self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i]) {
+		for (i = 0U; self->aq_vecs > i; ++i) {
+			aq_vec = self->aq_vec[i];
 			err = aq_pci_func_alloc_irq(self, i, self->ndev->name,
 						    aq_vec_isr, aq_vec,
 						    aq_vec_get_affinity_mask(aq_vec));
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index f4774cf051c9..6ab1f3212d24 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -43,8 +43,8 @@ static int aq_vec_poll(struct napi_struct *napi, int budget)
 	if (!self) {
 		err = -EINVAL;
 	} else {
-		for (i = 0U, ring = self->ring[0];
-			self->tx_rings > i; ++i, ring = self->ring[i]) {
+		for (i = 0U; self->tx_rings > i; ++i) {
+			ring = self->ring[i];
 			u64_stats_update_begin(&ring[AQ_VEC_RX_ID].stats.rx.syncp);
 			ring[AQ_VEC_RX_ID].stats.rx.polls++;
 			u64_stats_update_end(&ring[AQ_VEC_RX_ID].stats.rx.syncp);
@@ -182,8 +182,8 @@ int aq_vec_init(struct aq_vec_s *self, const struct aq_hw_ops *aq_hw_ops,
 	self->aq_hw_ops = aq_hw_ops;
 	self->aq_hw = aq_hw;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		err = aq_ring_init(&ring[AQ_VEC_TX_ID], ATL_RING_TX);
 		if (err < 0)
 			goto err_exit;
@@ -224,8 +224,8 @@ int aq_vec_start(struct aq_vec_s *self)
 	unsigned int i = 0U;
 	int err = 0;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		err = self->aq_hw_ops->hw_ring_tx_start(self->aq_hw,
 							&ring[AQ_VEC_TX_ID]);
 		if (err < 0)
@@ -248,8 +248,8 @@ void aq_vec_stop(struct aq_vec_s *self)
 	struct aq_ring_s *ring = NULL;
 	unsigned int i = 0U;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		self->aq_hw_ops->hw_ring_tx_stop(self->aq_hw,
 						 &ring[AQ_VEC_TX_ID]);
 
@@ -268,8 +268,8 @@ void aq_vec_deinit(struct aq_vec_s *self)
 	if (!self)
 		goto err_exit;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		aq_ring_tx_clean(&ring[AQ_VEC_TX_ID]);
 		aq_ring_rx_deinit(&ring[AQ_VEC_RX_ID]);
 	}
@@ -297,8 +297,8 @@ void aq_vec_ring_free(struct aq_vec_s *self)
 	if (!self)
 		goto err_exit;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		aq_ring_free(&ring[AQ_VEC_TX_ID]);
 		if (i < self->rx_rings)
 			aq_ring_free(&ring[AQ_VEC_RX_ID]);
-- 
2.35.1



