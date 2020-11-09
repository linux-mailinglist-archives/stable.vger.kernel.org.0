Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AE62ABA35
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731217AbgKINQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387527AbgKINQo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 000D4206D8;
        Mon,  9 Nov 2020 13:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927803;
        bh=+LcolaTozObX7AgxMLRbgCPq4c8a4FZGqaYDtNkdGjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lELxAOTNscjzV1tH+OugOPvircHD0jWJ5pZZ0yt0Z/VnRgMJl5lbyU8ryyq6+xw0i
         SSK5GsEjMIKRjYnj4RjZDYaGJ+02bWwqN+T9AEJrawLFlKbxOO6E/oq5o3L7TMBthz
         5xf1TPX1WPWUwuZrD9EoXaDaGf47BPUQESs4sycM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 026/133] dpaa_eth: update the buffer layout for non-A050385 erratum scenarios
Date:   Mon,  9 Nov 2020 13:54:48 +0100
Message-Id: <20201109125031.980390869@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Camelia Groza <camelia.groza@nxp.com>

[ Upstream commit acef159a0cb2a978d62b641e2366a33ad1d5afef ]

Impose a larger RX private data area only when the A050385 erratum is
present on the hardware. A smaller buffer size is sufficient in all
other scenarios. This enables a wider range of linear Jumbo frame
sizes in non-erratum scenarios, instead of turning to multi
buffer Scatter/Gather frames. The maximum linear frame size is
increased by 128 bytes for non-erratum arm64 platforms.

Cleanup the hardware annotations header defines in the process.

Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -174,12 +174,17 @@ MODULE_PARM_DESC(tx_timeout, "The Tx tim
 #define DPAA_PARSE_RESULTS_SIZE sizeof(struct fman_prs_result)
 #define DPAA_TIME_STAMP_SIZE 8
 #define DPAA_HASH_RESULTS_SIZE 8
+#define DPAA_HWA_SIZE (DPAA_PARSE_RESULTS_SIZE + DPAA_TIME_STAMP_SIZE \
+		       + DPAA_HASH_RESULTS_SIZE)
+#define DPAA_RX_PRIV_DATA_DEFAULT_SIZE (DPAA_TX_PRIV_DATA_SIZE + \
+					dpaa_rx_extra_headroom)
 #ifdef CONFIG_DPAA_ERRATUM_A050385
-#define DPAA_RX_PRIV_DATA_SIZE (DPAA_A050385_ALIGN - (DPAA_PARSE_RESULTS_SIZE\
-	 + DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE))
+#define DPAA_RX_PRIV_DATA_A050385_SIZE (DPAA_A050385_ALIGN - DPAA_HWA_SIZE)
+#define DPAA_RX_PRIV_DATA_SIZE (fman_has_errata_a050385() ? \
+				DPAA_RX_PRIV_DATA_A050385_SIZE : \
+				DPAA_RX_PRIV_DATA_DEFAULT_SIZE)
 #else
-#define DPAA_RX_PRIV_DATA_SIZE	(u16)(DPAA_TX_PRIV_DATA_SIZE + \
-					dpaa_rx_extra_headroom)
+#define DPAA_RX_PRIV_DATA_SIZE DPAA_RX_PRIV_DATA_DEFAULT_SIZE
 #endif
 
 #define DPAA_ETH_PCD_RXQ_NUM	128
@@ -2854,8 +2859,7 @@ static inline u16 dpaa_get_headroom(stru
 	 *
 	 * Also make sure the headroom is a multiple of data_align bytes
 	 */
-	headroom = (u16)(bl->priv_data_size + DPAA_PARSE_RESULTS_SIZE +
-		DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE);
+	headroom = (u16)(bl->priv_data_size + DPAA_HWA_SIZE);
 
 	return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
 }


