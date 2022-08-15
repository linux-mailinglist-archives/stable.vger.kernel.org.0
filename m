Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98622594998
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245462AbiHOXRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353474AbiHOXQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:16:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A391484E5;
        Mon, 15 Aug 2022 13:03:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62B38B81142;
        Mon, 15 Aug 2022 20:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51EDC433C1;
        Mon, 15 Aug 2022 20:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593799;
        bh=VBA4o0Mb7y8Az4iYRvFH18ZYSc8JyfxdBkwdZbQ+Q28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fHQr2UIIzKmFK6xp8m92rXfJQn8Eg8mgajLq2iPdk6Qo1dNM+sImHdgs8lU09fLVJ
         kb1EA9LnptXG89CsJ4LlvrLNxKkq55Mx+jjQXGhmgVhL7Kn4e6X5T702D5JPrT6IWh
         aATqMwjex6tVJEskTLOlgNOaDzIGDGPg7QdE89uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunhao Tian <t123yh.xyz@gmail.com>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0327/1157] drm/mipi-dbi: align max_chunk to 2 in spi_transfer
Date:   Mon, 15 Aug 2022 19:54:43 +0200
Message-Id: <20220815180452.735746838@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yunhao Tian <t123yh.xyz@gmail.com>

[ Upstream commit 435c249008cba04ed6a7975e9411f3b934620204 ]

In __spi_validate, there's a validation that no partial transfers
are accepted (xfer->len % w_size must be zero). When
max_chunk is not a multiple of bpw (e.g. max_chunk = 65535,
bpw = 16), the transfer will be rejected.

This patch aligns max_chunk to 2 bytes (the maximum value of bpw is 16),
so that no partial transfer will occur.

Fixes: d23d4d4dac01 ("drm/tinydrm: Move tinydrm_spi_transfer()")

Signed-off-by: Yunhao Tian <t123yh.xyz@gmail.com>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220510030219.2486687-1-t123yh.xyz@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mipi_dbi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/drm_mipi_dbi.c b/drivers/gpu/drm/drm_mipi_dbi.c
index 9314f2ead79f..09e4edb5a992 100644
--- a/drivers/gpu/drm/drm_mipi_dbi.c
+++ b/drivers/gpu/drm/drm_mipi_dbi.c
@@ -1199,6 +1199,13 @@ int mipi_dbi_spi_transfer(struct spi_device *spi, u32 speed_hz,
 	size_t chunk;
 	int ret;
 
+	/* In __spi_validate, there's a validation that no partial transfers
+	 * are accepted (xfer->len % w_size must be zero).
+	 * Here we align max_chunk to multiple of 2 (16bits),
+	 * to prevent transfers from being rejected.
+	 */
+	max_chunk = ALIGN_DOWN(max_chunk, 2);
+
 	spi_message_init_with_transfers(&m, &tr, 1);
 
 	while (len) {
-- 
2.35.1



