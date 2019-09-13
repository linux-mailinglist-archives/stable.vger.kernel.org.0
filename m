Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3551BB200A
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388974AbfIMNO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389520AbfIMNO0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:26 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2E4F214AE;
        Fri, 13 Sep 2019 13:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380465;
        bh=3mAQ9lNo8/G4qstAGCcxNn9wlempJnmli19RkMJo0Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxDP5eUh/YdGM9uum1qe2mB2svR1SdoaxarlmIDzoT6zF+D5AMhdW0oGmYVZowcwX
         liZaNF89iKeO+ahGJFvgq/dxS7tkGne+8+04AGtWWrRT911pZ0tWznsC4rRETzI743
         6C/rIWDJO6rkqgiE15e7EGLJEtrAem8CkS/9ciFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/190] Drivers: hv: kvp: Fix the recent regression caused by incorrect clean-up
Date:   Fri, 13 Sep 2019 14:05:05 +0100
Message-Id: <20190913130603.776628737@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



