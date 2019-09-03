Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB730A6E66
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbfICQZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730513AbfICQZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D549C23717;
        Tue,  3 Sep 2019 16:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527955;
        bh=h+d4u5kndta5HqWAnAN9o4gvTNOwWTJ5yg5EuUBs6as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSdQDpKJYc2lN4Tw1RMTGAEluKXNuoctTjeICF9iHnjz7A6H7zlUubdOk8yiREz/q
         D6NdaIFr0VcQBH8JO+DEpeOY1RNgLs8G5DnwgcuyFVf2JD3sJpQfUSYXeEN1zNtubl
         HaOit7XRT8w26wWHK5QGaTn+rNng7o66AoE2CPks=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dexuan Cui <decui@microsoft.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 021/167] Drivers: hv: kvp: Fix the recent regression caused by incorrect clean-up
Date:   Tue,  3 Sep 2019 12:22:53 -0400
Message-Id: <20190903162519.7136-21-sashal@kernel.org>
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

[ Upstream commit e670de54c813b5bc3672dd1c67871dc60e9206f4 ]

In kvp_send_key(), we do need call process_ib_ipinfo() if
message->kvp_hdr.operation is KVP_OP_GET_IP_INFO, because it turns out
the userland hv_kvp_daemon needs the info of operation, adapter_id and
addr_family. With the incorrect fc62c3b1977d, the host can't get the
VM's IP via KVP.

And, fc62c3b1977d added a "break;", but actually forgot to initialize
the key_size/value in the case of KVP_OP_SET, so the default key_size of
0 is passed to the kvp daemon, and the pool files
/var/lib/hyperv/.kvp_pool_* can't be updated.

This patch effectively rolls back the previous fc62c3b1977d, and
correctly fixes the "this statement may fall through" warnings.

This patch is tested on WS 2012 R2 and 2016.

Fixes: fc62c3b1977d ("Drivers: hv: kvp: Fix two "this statement may fall through" warnings")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hv_kvp.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index a7513a8a8e372..d6106e1a0d4af 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -353,6 +353,9 @@ static void process_ib_ipinfo(void *in_msg, void *out_msg, int op)
 
 		out->body.kvp_ip_val.dhcp_enabled = in->kvp_ip_val.dhcp_enabled;
 
+		/* fallthrough */
+
+	case KVP_OP_GET_IP_INFO:
 		utf16s_to_utf8s((wchar_t *)in->kvp_ip_val.adapter_id,
 				MAX_ADAPTER_ID_SIZE,
 				UTF16_LITTLE_ENDIAN,
@@ -405,7 +408,11 @@ kvp_send_key(struct work_struct *dummy)
 		process_ib_ipinfo(in_msg, message, KVP_OP_SET_IP_INFO);
 		break;
 	case KVP_OP_GET_IP_INFO:
-		/* We only need to pass on message->kvp_hdr.operation.  */
+		/*
+		 * We only need to pass on the info of operation, adapter_id
+		 * and addr_family to the userland kvp daemon.
+		 */
+		process_ib_ipinfo(in_msg, message, KVP_OP_GET_IP_INFO);
 		break;
 	case KVP_OP_SET:
 		switch (in_msg->body.kvp_set.data.value_type) {
@@ -446,9 +453,9 @@ kvp_send_key(struct work_struct *dummy)
 
 		}
 
-		break;
-
-	case KVP_OP_GET:
+		/*
+		 * The key is always a string - utf16 encoding.
+		 */
 		message->body.kvp_set.data.key_size =
 			utf16s_to_utf8s(
 			(wchar_t *)in_msg->body.kvp_set.data.key,
@@ -456,6 +463,17 @@ kvp_send_key(struct work_struct *dummy)
 			UTF16_LITTLE_ENDIAN,
 			message->body.kvp_set.data.key,
 			HV_KVP_EXCHANGE_MAX_KEY_SIZE - 1) + 1;
+
+		break;
+
+	case KVP_OP_GET:
+		message->body.kvp_get.data.key_size =
+			utf16s_to_utf8s(
+			(wchar_t *)in_msg->body.kvp_get.data.key,
+			in_msg->body.kvp_get.data.key_size,
+			UTF16_LITTLE_ENDIAN,
+			message->body.kvp_get.data.key,
+			HV_KVP_EXCHANGE_MAX_KEY_SIZE - 1) + 1;
 		break;
 
 	case KVP_OP_DELETE:
-- 
2.20.1

