Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801E64699CA
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345174AbhLFPED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:04:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36148 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345220AbhLFPDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:03:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32FF2B81117;
        Mon,  6 Dec 2021 14:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754DFC341C1;
        Mon,  6 Dec 2021 14:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802780;
        bh=7RwrxL3JhpPhvWN7Mt0fw7/0UQgXiXVZCmgQhNDtWnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXGpyOjrD3Chx1QQIRGOjwDuOzeYGwJ5FGPE10eZywjZDwIWXaZhEpuzrxIHRdheC
         uFPp9+ts3ZOARZ4nq3ILhkw++eKB3PaYUoHJa4aas585aNyb4Wz9TnRqoMQsuLbcu4
         kgCXbAli0yrjPIpCnH0OuRS4eQb2iysmybvwqIBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 13/52] net: ieee802154: handle iftypes as u32
Date:   Mon,  6 Dec 2021 15:55:57 +0100
Message-Id: <20211206145548.353497916@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 451dc48c806a7ce9fbec5e7a24ccf4b2c936e834 ]

This patch fixes an issue that an u32 netlink value is handled as a
signed enum value which doesn't fit into the range of u32 netlink type.
If it's handled as -1 value some BIT() evaluation ends in a
shift-out-of-bounds issue. To solve the issue we set the to u32 max which
is s32 "-1" value to keep backwards compatibility and let the followed enum
values start counting at 0. This brings the compiler to never handle the
enum as signed and a check if the value is above NL802154_IFTYPE_MAX should
filter -1 out.

Fixes: f3ea5e44231a ("ieee802154: add new interface command")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20211112030916.685793-1-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/nl802154.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index 32cb3e591e07b..53f140fc1983c 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -19,6 +19,8 @@
  *
  */
 
+#include <linux/types.h>
+
 #define NL802154_GENL_NAME "nl802154"
 
 enum nl802154_commands {
@@ -143,10 +145,9 @@ enum nl802154_attrs {
 };
 
 enum nl802154_iftype {
-	/* for backwards compatibility TODO */
-	NL802154_IFTYPE_UNSPEC = -1,
+	NL802154_IFTYPE_UNSPEC = (~(__u32)0),
 
-	NL802154_IFTYPE_NODE,
+	NL802154_IFTYPE_NODE = 0,
 	NL802154_IFTYPE_MONITOR,
 	NL802154_IFTYPE_COORD,
 
-- 
2.33.0



