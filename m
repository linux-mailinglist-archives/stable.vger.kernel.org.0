Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9CB1D0D4D
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387706AbgEMJvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387717AbgEMJvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:51:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26B3920769;
        Wed, 13 May 2020 09:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363513;
        bh=aKb5U538qSsKZkravWBvY2Sfhu2vQEnzoSvfdD6rAF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uA34h+UG1itGwTA2AtP25H4eI46QpLKrp+pR9HpFBlcqwO/cu+CZVA/zMe20vgfkS
         EgUonadAsWkG68jgrqmxVHSeSi835SyuswN/w+aXehlhy/xwZSxPNpw9AEqTyQ8C4O
         uCZrSaPLa0IIMxjThlbErHlOBWm40yo6sCLDOTXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 015/118] devlink: fix return value after hitting end in region read
Date:   Wed, 13 May 2020 11:43:54 +0200
Message-Id: <20200513094419.041871434@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 610a9346c138b9c2c93d38bf5f3728e74ae9cbd5 ]

Commit d5b90e99e1d5 ("devlink: report 0 after hitting end in region read")
fixed region dump, but region read still returns a spurious error:

$ devlink region read netdevsim/netdevsim1/dummy snapshot 0 addr 0 len 128
0000000000000000 a6 f4 c4 1c 21 35 95 a6 9d 34 c3 5b 87 5b 35 79
0000000000000010 f3 a0 d7 ee 4f 2f 82 7f c6 dd c4 f6 a5 c3 1b ae
0000000000000020 a4 fd c8 62 07 59 48 03 70 3b c7 09 86 88 7f 68
0000000000000030 6f 45 5d 6d 7d 0e 16 38 a9 d0 7a 4b 1e 1e 2e a6
0000000000000040 e6 1d ae 06 d6 18 00 85 ca 62 e8 7e 11 7e f6 0f
0000000000000050 79 7e f7 0f f3 94 68 bd e6 40 22 85 b6 be 6f b1
0000000000000060 af db ef 5e 34 f0 98 4b 62 9a e3 1b 8b 93 fc 17
devlink answers: Invalid argument
0000000000000070 61 e8 11 11 66 10 a5 f7 b1 ea 8d 40 60 53 ed 12

This is a minimal fix, I'll follow up with a restructuring
so we don't have two checks for the same condition.

Fixes: fdd41ec21e15 ("devlink: Return right error code in case of errors for region read")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devlink.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4030,6 +4030,11 @@ static int devlink_nl_cmd_region_read_du
 		end_offset = nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);
 		end_offset += nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]);
 		dump = false;
+
+		if (start_offset == end_offset) {
+			err = 0;
+			goto nla_put_failure;
+		}
 	}
 
 	err = devlink_nl_region_read_snapshot_fill(skb, devlink,


