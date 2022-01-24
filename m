Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EB9499BB9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349209AbiAXVy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:54:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33010 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445470AbiAXVnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:43:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90CB46150B;
        Mon, 24 Jan 2022 21:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CF2C340E4;
        Mon, 24 Jan 2022 21:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060616;
        bh=F0Fefbr5CTrGbQwVRWajkOardZ0wutxowsrDiXU7x6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1agiTswl8NpVBX90LJm7fjUXvboe2qqPr/PsxwO2P3UtiwyATfwYs8t96lATbSuR6
         DXPvcgPAUz5LsROFRvLDYgc37RtGfxz0tMzxv5/EzFOVipJxg5UNnVwt1AhcpfS6f+
         YKzLItPliJ17eSicmb5kdtpCBHvxBqoypVMd9ZtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 1006/1039] devlink: Remove misleading internal_flags from health reporter dump
Date:   Mon, 24 Jan 2022 19:46:35 +0100
Message-Id: <20220124184159.107965939@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -8840,8 +8840,6 @@ static const struct genl_small_ops devli
 			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		.dumpit = devlink_nl_cmd_health_reporter_dump_get_dumpit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR,


