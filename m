Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33014C769E
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239653AbiB1SF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240260AbiB1SDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D57B18B6;
        Mon, 28 Feb 2022 09:46:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F01D60748;
        Mon, 28 Feb 2022 17:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380A2C36AE2;
        Mon, 28 Feb 2022 17:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070404;
        bh=2liIzuPif238qtc1zzeUUOVI7Y28db2Sn2eLXFxMt6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R10Nvaz5AkcXrTtcdt7T8zE9R9GlsyVSopL7nkQwqk3EXWD5Wmh4MO03E/TCFVA2n
         LVZtWZhu4v6C+SIXhNttEMOb1ZssgbTLFvvAGRTQ+pDB/VndsIsjXnIu+ZTDLTwpjE
         GWEoY2yR5iMzwqDgk+W4sVmLqPMY5NOQpxQI2koE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 095/164] net/mlx5e: kTLS, Use CHECKSUM_UNNECESSARY for device-offloaded packets
Date:   Mon, 28 Feb 2022 18:24:17 +0100
Message-Id: <20220228172408.400648731@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
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
@@ -1348,7 +1348,8 @@ static inline void mlx5e_handle_csum(str
 	}
 
 	/* True when explicitly set via priv flag, or XDP prog is loaded */
-	if (test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state))
+	if (test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state) ||
+	    get_cqe_tls_offload(cqe))
 		goto csum_unnecessary;
 
 	/* CQE csum doesn't cover padding octets in short ethernet


