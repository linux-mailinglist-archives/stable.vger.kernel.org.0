Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D25A32C68
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbfFCJLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728294AbfFCJLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:11:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DA8C27E4A;
        Mon,  3 Jun 2019 09:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553066;
        bh=vYK+S5IoxQQVHRo385/3aZ7IkzTAkxVmmcV5eHatUJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdsN7P74QyK+K6v3x4YXXhiS7f4ZMyCgsTPV09DHK3xDmnmy0ShxZsHDgxYZPCaNf
         yNdyFnNbWPQWf0lI3J8DCGX2nMPNJOY52KcTOXoDXIGltXCY/IDGcN+ybLgjFl2DZx
         YRGB5vKqQROJyLI/Ue/LtPvVJ1btJ+09nz3ayBjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 09/32] net: dsa: mv88e6xxx: fix handling of upper half of STATS_TYPE_PORT
Date:   Mon,  3 Jun 2019 11:08:03 +0200
Message-Id: <20190603090311.307798518@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
References: <20190603090308.472021390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

[ Upstream commit 84b3fd1fc9592d431e23b077e692fa4e3fd0f086 ]

Currently, the upper half of a 4-byte STATS_TYPE_PORT statistic ends
up in bits 47:32 of the return value, instead of bits 31:16 as they
should.

Fixes: 6e46e2d821bb ("net: dsa: mv88e6xxx: Fix u64 statistics")
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -877,7 +877,7 @@ static uint64_t _mv88e6xxx_get_ethtool_s
 			err = mv88e6xxx_port_read(chip, port, s->reg + 1, &reg);
 			if (err)
 				return U64_MAX;
-			high = reg;
+			low |= ((u32)reg) << 16;
 		}
 		break;
 	case STATS_TYPE_BANK1:


