Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1692F677
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfE3DKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727905AbfE3DKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:02 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE5A724492;
        Thu, 30 May 2019 03:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185801;
        bh=w3IVtbtJNkqRBo+VDM/Lw8cnn4ALV8HzJvwSy/aYl6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYGpDtuecTUv7aZX81WC3aR44GhFIwjmIo4rGc/6V1QHbpTt2H2sfL0K9Li5xUTd/
         RV/X0tnwIU9pi8q96dqX4mGvGVJwsIOUUO1YAFK4uuXef5TciOG458aRJAAIW/JcpM
         U2DH8PE2XL74WshK7g99hWoEOETqQulzUphLkGAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 081/405] brcm80211: potential NULL dereference in brcmf_cfg80211_vndr_cmds_dcmd_handler()
Date:   Wed, 29 May 2019 20:01:19 -0700
Message-Id: <20190530030545.099894528@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e025da3d7aa4770bb1d1b3b0aa7cc4da1744852d ]

If "ret_len" is negative then it could lead to a NULL dereference.

The "ret_len" value comes from nl80211_vendor_cmd(), if it's negative
then we don't allocate the "dcmd_buf" buffer.  Then we pass "ret_len" to
brcmf_fil_cmd_data_set() where it is cast to a very high u32 value.
Most of the functions in that call tree check whether the buffer we pass
is NULL but there are at least a couple places which don't such as
brcmf_dbg_hex_dump() and brcmf_msgbuf_query_dcmd().  We memcpy() to and
from the buffer so it would result in a NULL dereference.

The fix is to change the types so that "ret_len" can't be negative.  (If
we memcpy() zero bytes to NULL, that's a no-op and doesn't cause an
issue).

Fixes: 1bacb0487d0e ("brcmfmac: replace cfg80211 testmode with vendor command")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
index 8eff2753abade..d493021f60318 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
@@ -35,9 +35,10 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
 	struct brcmf_if *ifp;
 	const struct brcmf_vndr_dcmd_hdr *cmdhdr = data;
 	struct sk_buff *reply;
-	int ret, payload, ret_len;
+	unsigned int payload, ret_len;
 	void *dcmd_buf = NULL, *wr_pointer;
 	u16 msglen, maxmsglen = PAGE_SIZE - 0x100;
+	int ret;
 
 	if (len < sizeof(*cmdhdr)) {
 		brcmf_err("vendor command too short: %d\n", len);
@@ -65,7 +66,7 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
 			brcmf_err("oversize return buffer %d\n", ret_len);
 			ret_len = BRCMF_DCMD_MAXLEN;
 		}
-		payload = max(ret_len, len) + 1;
+		payload = max_t(unsigned int, ret_len, len) + 1;
 		dcmd_buf = vzalloc(payload);
 		if (NULL == dcmd_buf)
 			return -ENOMEM;
-- 
2.20.1



