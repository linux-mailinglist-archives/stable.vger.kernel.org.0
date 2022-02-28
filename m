Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BF94C7562
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiB1Ryu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239186AbiB1Rwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:52:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9629FA88AF;
        Mon, 28 Feb 2022 09:39:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7897B815A6;
        Mon, 28 Feb 2022 17:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2399BC340E7;
        Mon, 28 Feb 2022 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069989;
        bh=FROV+zPqYpPQOdFvQIVrfIS9k5Y0q6tyv8NMkTAUAbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQP4Z+XlfNqPOTiqs19pTZlTZOOiniXclGL75yKuJwO0fHi+PDPL2jCeO2us2ftcR
         HSXXqoiu/nJ2P2De6RsPelx3CHq6vDONMLq1t3LNAVlxSR+XT5mMVHMXV8qsqFqq2D
         XM4pff59VXPujU767IJErHNKOp1aloQBXKsaJ39w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 083/139] net/mlx5e: kTLS, Use CHECKSUM_UNNECESSARY for device-offloaded packets
Date:   Mon, 28 Feb 2022 18:24:17 +0100
Message-Id: <20220228172356.403347463@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

commit 7eaf1f37b8817c608c4e959d69986ef459d345cd upstream.

For RX TLS device-offloaded packets, the HW spec guarantees checksum
validation for the offloaded packets, but does not define whether the
CQE.checksum field matches the original packet (ciphertext) or
the decrypted one (plaintext). This latitude allows architetctural
improvements between generations of chips, resulting in different decisions
regarding the value type of CQE.checksum.

Hence, for these packets, the device driver should not make use of this CQE
field. Here we block CHECKSUM_COMPLETE usage for RX TLS device-offloaded
packets, and use CHECKSUM_UNNECESSARY instead.

Value of the packet's tcp_hdr.csum is not modified by the HW, and it always
matches the original ciphertext.

Fixes: 1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -987,7 +987,8 @@ static inline void mlx5e_handle_csum(str
 	}
 
 	/* True when explicitly set via priv flag, or XDP prog is loaded */
-	if (test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state))
+	if (test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state) ||
+	    get_cqe_tls_offload(cqe))
 		goto csum_unnecessary;
 
 	/* CQE csum doesn't cover padding octets in short ethernet


