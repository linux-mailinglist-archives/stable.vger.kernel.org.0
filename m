Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C1BA2440
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbfH2SVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728667AbfH2SR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:17:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98F8A23428;
        Thu, 29 Aug 2019 18:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102648;
        bh=q787aqOs+wn5fPo24qMf/gdnY+NBvXrn0G+MKIb/fok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtEH2xcbjjf8QxD/ste1naQLf1Oyfp/nGmEHBcFWFPrjhjegb4BVf9Eu1Dvdft/oI
         oo/rKaDbUgEtyPYsUU3QEUXlowjAxrWvJT4syEBvsz4YaCru1rDkCG4Z7FgibUbSuQ
         VsQnuQ5VmYv7k7JlmQ7BpLdDJmswZLE3NAUh/cDI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 22/27] Tools: hv: kvp: eliminate 'may be used uninitialized' warning
Date:   Thu, 29 Aug 2019 14:16:48 -0400
Message-Id: <20190829181655.8741-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181655.8741-1-sashal@kernel.org>
References: <20190829181655.8741-1-sashal@kernel.org>
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
index 62c9a503ae052..bb245d4afc0cf 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -867,7 +867,7 @@ kvp_get_ip_info(int family, char *if_name, int op,
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

