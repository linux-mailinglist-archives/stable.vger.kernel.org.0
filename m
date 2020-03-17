Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADCB187EFE
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgCQK5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbgCQK5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:57:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A81CE20658;
        Tue, 17 Mar 2020 10:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442666;
        bh=Htadm2BPqnsIRPxAqXoqmCkvxm6kz9DSJp3JnXe2igA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XA0ffnk5HMdb2hrvYfbpGJJfcfJwQzbEoHjrcdfEUqa957gbfV1c1MEhr8eUancdM
         kqbdYJXQrRG/dqjFBqHGM8TdBXuOFKZsxaWOdZzBnOqW5UC4MLtovkFL5SXG/H1qrN
         fdiaZaNZHGh7PrPxkL0uNh5z0m8/yl+x4G+Jv/vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 41/89] devlink: validate length of region addr/len
Date:   Tue, 17 Mar 2020 11:54:50 +0100
Message-Id: <20200317103304.746202481@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
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
@@ -3607,6 +3607,8 @@ static const struct nla_policy devlink_n
 	[DEVLINK_ATTR_PARAM_VALUE_CMODE] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_REGION_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_REGION_SNAPSHOT_ID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_REGION_CHUNK_ADDR] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_REGION_CHUNK_LEN] = { .type = NLA_U64 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {


