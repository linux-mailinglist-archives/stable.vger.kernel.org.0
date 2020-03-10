Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6A17FD12
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgCJM47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729710AbgCJM46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:56:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AB0D20674;
        Tue, 10 Mar 2020 12:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845017;
        bh=Wl0+KE9C/SRufqsS4c6gXXAq2SgYZzSGiUx6G6n4UQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hX7MuN4LUd0e6tIiOseZxBEq63a7BzHv9e3/bJQ9pUn5koK8aSAwI86XgEgqUL85i
         j8pTsHNZ4Cxw25Noa/ODirrFAn0NkDVV2LiAZcXOzYTMkrTelppOApedgvdjybK8OJ
         oMlCBZ1PenpdNHyNteIfhKyMyWSTMKkY+ZE4kElg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 031/189] net: atlantic: check rpc result and wait for rpc address
Date:   Tue, 10 Mar 2020 13:37:48 +0100
Message-Id: <20200310123642.589773698@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>

[ Upstream commit e7b5f97e6574dc4918e375d5f8d24ec31653cd6d ]

Artificial HW reliability tests revealed a possible hangup in
the driver. Normally, when device disappears from bus, all
register reads returns 0xFFFFFFFF.

At remote procedure invocation towards FW there is a logic
where result is compared with -1 in a loop.
That caused an infinite loop if hardware due to some issues
disappears from bus.

Add extra result checks to prevent this.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index f547baa6c9549..354705f9bc493 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -22,6 +22,7 @@
 #define HW_ATL_MIF_ADDR         0x0208U
 #define HW_ATL_MIF_VAL          0x020CU
 
+#define HW_ATL_MPI_RPC_ADDR     0x0334U
 #define HW_ATL_RPC_CONTROL_ADR  0x0338U
 #define HW_ATL_RPC_STATE_ADR    0x033CU
 
@@ -53,15 +54,14 @@ enum mcp_area {
 };
 
 static int hw_atl_utils_ver_match(u32 ver_expected, u32 ver_actual);
-
 static int hw_atl_utils_mpi_set_state(struct aq_hw_s *self,
 				      enum hal_atl_utils_fw_state_e state);
-
 static u32 hw_atl_utils_get_mpi_mbox_tid(struct aq_hw_s *self);
 static u32 hw_atl_utils_mpi_get_state(struct aq_hw_s *self);
 static u32 hw_atl_utils_mif_cmd_get(struct aq_hw_s *self);
 static u32 hw_atl_utils_mif_addr_get(struct aq_hw_s *self);
 static u32 hw_atl_utils_rpc_state_get(struct aq_hw_s *self);
+static u32 aq_fw1x_rpc_get(struct aq_hw_s *self);
 
 int hw_atl_utils_initfw(struct aq_hw_s *self, const struct aq_fw_ops **fw_ops)
 {
@@ -476,6 +476,10 @@ static int hw_atl_utils_init_ucp(struct aq_hw_s *self,
 					self, self->mbox_addr,
 					self->mbox_addr != 0U,
 					1000U, 10000U);
+	err = readx_poll_timeout_atomic(aq_fw1x_rpc_get, self,
+					self->rpc_addr,
+					self->rpc_addr != 0U,
+					1000U, 100000U);
 
 	return err;
 }
@@ -531,6 +535,12 @@ int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
 						self, fw.val,
 						sw.tid == fw.tid,
 						1000U, 100000U);
+		if (err < 0)
+			goto err_exit;
+
+		err = aq_hw_err_from_flags(self);
+		if (err < 0)
+			goto err_exit;
 
 		if (fw.len == 0xFFFFU) {
 			err = hw_atl_utils_fw_rpc_call(self, sw.len);
@@ -1025,6 +1035,11 @@ static u32 hw_atl_utils_rpc_state_get(struct aq_hw_s *self)
 	return aq_hw_read_reg(self, HW_ATL_RPC_STATE_ADR);
 }
 
+static u32 aq_fw1x_rpc_get(struct aq_hw_s *self)
+{
+	return aq_hw_read_reg(self, HW_ATL_MPI_RPC_ADDR);
+}
+
 const struct aq_fw_ops aq_fw_1x_ops = {
 	.init = hw_atl_utils_mpi_create,
 	.deinit = hw_atl_fw1x_deinit,
-- 
2.20.1



