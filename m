Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49F6A23E1
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbfH2SST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730392AbfH2SSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:18:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 550692341C;
        Thu, 29 Aug 2019 18:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102696;
        bh=Wja6VqfCilwc3YHL7O41vyxi8Rnh2cRte0lRT6l2i8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPIBs0Kt60RjzTIegJrs4IDNvwHTiQPcsyMOjPFgWgOQAvsvU5rbGuNukFSyRNfhf
         7wWsxduacVJ9o0Zu4qCbn0BNucdqZykkpNaCAygqbeYJBJFd6Hunr6HykoEf3/uWjK
         vsoEh7Mp0LTxBDCON8uiJuWw+k3w0d1zI+4OVPcg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sasha Levin <sashal@kernel.org>, devel@linuxdriverproject.org
Subject: [PATCH AUTOSEL 4.4 12/15] Tools: hv: kvp: eliminate 'may be used uninitialized' warning
Date:   Thu, 29 Aug 2019 14:17:59 -0400
Message-Id: <20190829181802.9619-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181802.9619-1-sashal@kernel.org>
References: <20190829181802.9619-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 89eb4d8d25722a0a0194cf7fa47ba602e32a6da7 ]

When building hv_kvp_daemon GCC-8.3 complains:

hv_kvp_daemon.c: In function ‘kvp_get_ip_info.constprop’:
hv_kvp_daemon.c:812:30: warning: ‘ip_buffer’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  struct hv_kvp_ipaddr_value *ip_buffer;

this seems to be a false positive: we only use ip_buffer when
op == KVP_OP_GET_IP_INFO and it is only unset when op == KVP_OP_ENUMERATE.

Silence the warning by initializing ip_buffer to NULL.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/hv/hv_kvp_daemon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 1774800668168..a3ac283a985ae 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -878,7 +878,7 @@ kvp_get_ip_info(int family, char *if_name, int op,
 	int sn_offset = 0;
 	int error = 0;
 	char *buffer;
-	struct hv_kvp_ipaddr_value *ip_buffer;
+	struct hv_kvp_ipaddr_value *ip_buffer = NULL;
 	char cidr_mask[5]; /* /xyz */
 	int weight;
 	int i;
-- 
2.20.1

