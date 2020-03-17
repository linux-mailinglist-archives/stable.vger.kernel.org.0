Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A302C188046
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgCQLIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgCQLIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:08:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8F2520658;
        Tue, 17 Mar 2020 11:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443330;
        bh=moDZeG3Bq5WsFe3GGa6LbpjpT5cKm5f2KisslQaJFbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tt3l+w7YgWrejXQmlB8Co6KfaXn3G06irmLhiaQV7CCGK/lCq8m5Fwy5FZV/2TWUq
         qzjQKws59K8uiKu0WKUoviPIzaWymk5+anw7SL9bM8Gn1GIOXFSayPcIMwUjJiimu5
         LulTBBW6ZHSUwFvBg/Ne24/8v6S+5CVR+Wkyheu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 047/151] devlink: validate length of region addr/len
Date:   Tue, 17 Mar 2020 11:54:17 +0100
Message-Id: <20200317103329.941073777@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ff3b63b8c299b73ac599b120653b47e275407656 ]

DEVLINK_ATTR_REGION_CHUNK_ADDR and DEVLINK_ATTR_REGION_CHUNK_LEN
lack entries in the netlink policy. Corresponding nla_get_u64()s
may read beyond the end of the message.

Fixes: 4e54795a27f5 ("devlink: Add support for region snapshot read command")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devlink.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5924,6 +5924,8 @@ static const struct nla_policy devlink_n
 	[DEVLINK_ATTR_PARAM_VALUE_CMODE] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_REGION_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_REGION_SNAPSHOT_ID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_REGION_CHUNK_ADDR] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_REGION_CHUNK_LEN] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_HEALTH_REPORTER_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },


