Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3819FA707A
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbfICQjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:39:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730408AbfICQZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E73A523717;
        Tue,  3 Sep 2019 16:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527932;
        bh=AsxPs8o9ObK/Jj5GSq7R8RNxsQx5b8ropXh2gycQvB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aw9ACrtDI8yy5DNnJ8yfCRFrFBSi96c6F4Z/9749f6KNRfmoYciQsB5OdDwYnv+j/
         nrKZgA+38xWzlLH7zxWd7rola9tV9vqKHfQxxak0VxH907gUr7ba9DOjfoKGNcf6IK
         slmpF6sJ0MYTHB0NrLEKxec5mmvg4/EPjvzVxpJE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dexuan Cui <decui@microsoft.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 006/167] Drivers: hv: kvp: Fix two "this statement may fall through" warnings
Date:   Tue,  3 Sep 2019 12:22:38 -0400
Message-Id: <20190903162519.7136-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit fc62c3b1977d62e6374fd6e28d371bb42dfa5c9d ]

We don't need to call process_ib_ipinfo() if message->kvp_hdr.operation is
KVP_OP_GET_IP_INFO in kvp_send_key(), because here we just need to pass on
the op code from the host to the userspace; when the userspace returns
the info requested by the host, we pass the info on to the host in
kvp_respond_to_host() -> process_ob_ipinfo(). BTW, the current buggy code
actually doesn't cause any harm, because only message->kvp_hdr.operation
is used by the userspace, in the case of KVP_OP_GET_IP_INFO.

The patch also adds a missing "break;" in kvp_send_key(). BTW, the current
buggy code actually doesn't cause any harm, because in the case of
KVP_OP_SET, the unexpected fall-through corrupts
message->body.kvp_set.data.key_size, but that is not really used: see
the definition of struct hv_kvp_exchg_msg_value.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hv_kvp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 5eed1e7da15c4..57715a0c81202 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -353,7 +353,6 @@ static void process_ib_ipinfo(void *in_msg, void *out_msg, int op)
 
 		out->body.kvp_ip_val.dhcp_enabled = in->kvp_ip_val.dhcp_enabled;
 
-	default:
 		utf16s_to_utf8s((wchar_t *)in->kvp_ip_val.adapter_id,
 				MAX_ADAPTER_ID_SIZE,
 				UTF16_LITTLE_ENDIAN,
@@ -406,7 +405,7 @@ kvp_send_key(struct work_struct *dummy)
 		process_ib_ipinfo(in_msg, message, KVP_OP_SET_IP_INFO);
 		break;
 	case KVP_OP_GET_IP_INFO:
-		process_ib_ipinfo(in_msg, message, KVP_OP_GET_IP_INFO);
+		/* We only need to pass on message->kvp_hdr.operation.  */
 		break;
 	case KVP_OP_SET:
 		switch (in_msg->body.kvp_set.data.value_type) {
@@ -446,6 +445,9 @@ kvp_send_key(struct work_struct *dummy)
 			break;
 
 		}
+
+		break;
+
 	case KVP_OP_GET:
 		message->body.kvp_set.data.key_size =
 			utf16s_to_utf8s(
-- 
2.20.1

