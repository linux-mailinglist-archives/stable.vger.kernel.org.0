Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E89469A7E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347169AbhLFPIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346003AbhLFPG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:06:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA49C061354;
        Mon,  6 Dec 2021 07:02:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9F6EB810F1;
        Mon,  6 Dec 2021 15:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3A8C341C1;
        Mon,  6 Dec 2021 15:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802977;
        bh=Sn8tndyMRnu26tV783OUTcsuI7UKqTEhnAAgF7tTOSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYC5pBTBt9vpXuFfKdM4UZsYDW7VOLVf1BT+Kh8rokisw1ja+wUcAISdTjTIH3BNP
         Q+iScTC6jDfSyJOg3CFaVsv3qMQG9DrGIDq24EU99Xb+jGDEdrk1B+UsUkyUfyyics
         z38sWPejuVUd8esnBFgkPNEGQKm1qvTwHsImbwmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 15/62] net: ieee802154: handle iftypes as u32
Date:   Mon,  6 Dec 2021 15:55:58 +0100
Message-Id: <20211206145549.693477854@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
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



