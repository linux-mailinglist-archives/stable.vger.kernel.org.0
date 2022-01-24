Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A34D499DB9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586130AbiAXWZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584673AbiAXWVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3B9C0424FF;
        Mon, 24 Jan 2022 12:52:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D83A60B1A;
        Mon, 24 Jan 2022 20:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FFBC340E5;
        Mon, 24 Jan 2022 20:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057565;
        bh=oU1yhBx4X3gpiRFYKACsx0VjucLmePk1ClNeD1aA/CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWnKxo9w4U2i7vyFvhb6JlQwUStMkiS8/Is+uuAeXhro+Ff0/LMGQzqvKfOXmmPZP
         UNR35JpLQZfBaP+yg4aZTt2Pc53iyr/5rVRuoESqamQwxcFH6OjKTBFOnSS6SmTc3W
         Tadhy76ROLCfEk14z2GVG8sgjVZmhcZRBHqCTz1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 823/846] devlink: Remove misleading internal_flags from health reporter dump
Date:   Mon, 24 Jan 2022 19:45:40 +0100
Message-Id: <20220124184129.292263767@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

commit e9538f8270db24d272659e15841854c7ea11119e upstream.

DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET command doesn't have .doit callback
and has no use in internal_flags at all. Remove this misleading assignment.

Fixes: e44ef4e4516c ("devlink: Hang reporter's dump method on a dumpit cb")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devlink.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8795,8 +8795,6 @@ static const struct genl_small_ops devli
 			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		.dumpit = devlink_nl_cmd_health_reporter_dump_get_dumpit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR,


