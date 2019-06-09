Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5385C3A989
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733187AbfFIRCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388169AbfFIRCB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:02:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6A35206DF;
        Sun,  9 Jun 2019 17:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099721;
        bh=lxsZoQAD5/d/XAwBegYHEkjc7o8O926s15fiCs88V0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozN9H2g5jABcCjCRPbFUqtfvOZBdwFBATjp680BQz7nCHD/BQm7B2tixLvBtS4EBS
         Q8zsPkcsKY+WdfrCwHQksS8iKkGtfloUyYE3Do+tsnFVbKt2ewjgLr/Y03zcy5hZlD
         /2yNioWV8oeroqL/T6QDcNJzk+urpvfo1opuH2e0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 099/241] brcm80211: potential NULL dereference in brcmf_cfg80211_vndr_cmds_dcmd_handler()
Date:   Sun,  9 Jun 2019 18:40:41 +0200
Message-Id: <20190609164150.652739731@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
index 8eff2753abade..d493021f60318 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
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



