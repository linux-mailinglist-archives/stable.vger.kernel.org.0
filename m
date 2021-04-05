Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A667E353ED0
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238140AbhDEJIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238528AbhDEJIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:08:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C52FE61398;
        Mon,  5 Apr 2021 09:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613674;
        bh=n4KazJf4TpJvLsPlFKEsRrEybWv3CSa+V22IoslR6hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLgFOgfJPncKJSJnGj5MkxRs0CIUmyZBNYNDkilo8E9WKgMFXpsrK606bb6v2F/in
         WuqIVbRIdh/uRR6m1kWJy4yeJNEqWEJD++bO0FKcXt03zbyACKULi/o3lwXa99rGos
         OHkiwNGRZ56UdRmduPkmDhutmVgoeRK6KqjN58Bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/126] net: ipa: fix register write command validation
Date:   Mon,  5 Apr 2021 10:53:33 +0200
Message-Id: <20210405085032.724159388@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 2d65ed76924bc772d3974b0894d870b1aa63b34a ]

In ipa_cmd_register_write_valid() we verify that values we will
supply to a REGISTER_WRITE IPA immediate command will fit in
the fields that need to hold them.  This patch fixes some issues
in that function and ipa_cmd_register_write_offset_valid().

The dev_err() call in ipa_cmd_register_write_offset_valid() has
some printf format errors:
  - The name of the register (corresponding to the string format
    specifier) was not supplied.
  - The IPA base offset and offset need to be supplied separately to
    match the other format specifiers.
Also make the ~0 constant used there to compute the maximum
supported offset value explicitly unsigned.

There are two other issues in ipa_cmd_register_write_valid():
  - There's no need to check the hash flush register for platforms
    (like IPA v4.2) that do not support hashed tables
  - The highest possible endpoint number, whose status register
    offset is computed, is COUNT - 1, not COUNT.

Fix these problems, and add some additional commentary.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_cmd.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index d92dd3f09b73..46d8b7336d8f 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2021 Linaro Ltd.
  */
 
 #include <linux/types.h>
@@ -244,11 +244,15 @@ static bool ipa_cmd_register_write_offset_valid(struct ipa *ipa,
 	if (ipa->version != IPA_VERSION_3_5_1)
 		bit_count += hweight32(REGISTER_WRITE_FLAGS_OFFSET_HIGH_FMASK);
 	BUILD_BUG_ON(bit_count > 32);
-	offset_max = ~0 >> (32 - bit_count);
+	offset_max = ~0U >> (32 - bit_count);
 
+	/* Make sure the offset can be represented by the field(s)
+	 * that holds it.  Also make sure the offset is not outside
+	 * the overall IPA memory range.
+	 */
 	if (offset > offset_max || ipa->mem_offset > offset_max - offset) {
 		dev_err(dev, "%s offset too large 0x%04x + 0x%04x > 0x%04x)\n",
-				ipa->mem_offset + offset, offset_max);
+			name, ipa->mem_offset, offset, offset_max);
 		return false;
 	}
 
@@ -261,12 +265,24 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 	const char *name;
 	u32 offset;
 
-	offset = ipa_reg_filt_rout_hash_flush_offset(ipa->version);
-	name = "filter/route hash flush";
-	if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
-		return false;
+	/* If hashed tables are supported, ensure the hash flush register
+	 * offset will fit in a register write IPA immediate command.
+	 */
+	if (ipa->version != IPA_VERSION_4_2) {
+		offset = ipa_reg_filt_rout_hash_flush_offset(ipa->version);
+		name = "filter/route hash flush";
+		if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
+			return false;
+	}
 
-	offset = IPA_REG_ENDP_STATUS_N_OFFSET(IPA_ENDPOINT_COUNT);
+	/* Each endpoint can have a status endpoint associated with it,
+	 * and this is recorded in an endpoint register.  If the modem
+	 * crashes, we reset the status endpoint for all modem endpoints
+	 * using a register write IPA immediate command.  Make sure the
+	 * worst case (highest endpoint number) offset of that endpoint
+	 * fits in the register write command field(s) that must hold it.
+	 */
+	offset = IPA_REG_ENDP_STATUS_N_OFFSET(IPA_ENDPOINT_COUNT - 1);
 	name = "maximal endpoint status";
 	if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
 		return false;
-- 
2.30.1



