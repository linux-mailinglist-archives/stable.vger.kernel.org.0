Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3216D461E6E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347519AbhK2SgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:36:01 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52122 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378463AbhK2SeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:34:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3B5E5CE140F;
        Mon, 29 Nov 2021 18:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCFBC53FC7;
        Mon, 29 Nov 2021 18:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210640;
        bh=Sn8tndyMRnu26tV783OUTcsuI7UKqTEhnAAgF7tTOSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEyKChpkIf4AZ5D4inoV+EsRtCvKmvn1SLJTGwkWAD1nVBpyMuSqPKovZJLHmQjBG
         XBTHXoO41aLO9lN6V2qLthiq12e1ipmTk1GD6LR5TYGB8WK9vIEq7nGEHrk3r0YAoe
         Y57qqtiaWze4uskeobv2/9KriHkadh/bSQpci/mQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/121] net: ieee802154: handle iftypes as u32
Date:   Mon, 29 Nov 2021 19:18:03 +0100
Message-Id: <20211129181713.402107903@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
index ddcee128f5d9a..145acb8f25095 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -19,6 +19,8 @@
  *
  */
 
+#include <linux/types.h>
+
 #define NL802154_GENL_NAME "nl802154"
 
 enum nl802154_commands {
@@ -150,10 +152,9 @@ enum nl802154_attrs {
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



