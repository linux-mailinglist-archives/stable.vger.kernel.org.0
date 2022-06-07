Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4C2540928
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350223AbiFGSFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349342AbiFGSC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:02:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7224C110458;
        Tue,  7 Jun 2022 10:47:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE47F616A3;
        Tue,  7 Jun 2022 17:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C581DC34115;
        Tue,  7 Jun 2022 17:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624024;
        bh=LSytcWcRLheFiFAeBtGB+s+5FczB82BvynKoYsa0pVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THx0CimuaA1oijWea2fCAHJ2ICSuTNCVoGPRbueKVJL79nDfg/tCrMxHgklFdxf6j
         deinYX4/nUFx7WZdBh3vmGzowB3iMr+QmMzZSQEQW+7YeWVzMARXrSHx7VsukwZiVF
         Kz54mBpXkl3p9PNVh+Rg4iBXo92cYpZVfEipvXrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        kernel test robot <lkp@intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.15 136/667] can: mcp251xfd: silence clangs -Wunaligned-access warning
Date:   Tue,  7 Jun 2022 18:56:41 +0200
Message-Id: <20220607164938.899820252@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 1a6dd9996699889313327be03981716a8337656b ]

clang emits a -Wunaligned-access warning on union
mcp251xfd_tx_ojb_load_buf.

The reason is that field hw_tx_obj (not declared as packed) is being
packed right after a 16 bits field inside a packed struct:

| union mcp251xfd_tx_obj_load_buf {
| 	struct __packed {
| 		struct mcp251xfd_buf_cmd cmd;
| 		  /* ^ 16 bits fields */
| 		struct mcp251xfd_hw_tx_obj_raw hw_tx_obj;
| 		  /* ^ not declared as packed */
| 	} nocrc;
| 	struct __packed {
| 		struct mcp251xfd_buf_cmd_crc cmd;
| 		struct mcp251xfd_hw_tx_obj_raw hw_tx_obj;
| 		__be16 crc;
| 	} crc;
| } ____cacheline_aligned;

Starting from LLVM 14, having an unpacked struct nested in a packed
struct triggers a warning. c.f. [1].

This is a false positive because the field is always being accessed
with the relevant put_unaligned_*() function. Adding __packed to the
structure declaration silences the warning.

[1] https://github.com/llvm/llvm-project/issues/55520

Link: https://lore.kernel.org/all/20220518114357.55452-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 0f322dabaf65..281856eea2ef 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -433,7 +433,7 @@ struct mcp251xfd_hw_tef_obj {
 /* The tx_obj_raw version is used in spi async, i.e. without
  * regmap. We have to take care of endianness ourselves.
  */
-struct mcp251xfd_hw_tx_obj_raw {
+struct __packed mcp251xfd_hw_tx_obj_raw {
 	__le32 id;
 	__le32 flags;
 	u8 data[sizeof_field(struct canfd_frame, data)];
-- 
2.35.1



