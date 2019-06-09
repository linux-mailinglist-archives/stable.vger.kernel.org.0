Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5DE3AA5A
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732011AbfFIQvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732007AbfFIQvn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:51:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3185206C3;
        Sun,  9 Jun 2019 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099103;
        bh=texK9FUv8q7wPo068mvK+ku/cUBgXjXAArtYKVHTGrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3yqDgEIKWY3WjV2bqGnK33pTgfwxfN3dfyrroQRpLDpJsO3RqhfMapU5PVIC9f3m
         UU7QpejWLMjc4pCSBMGihbPnyjryv2O5gNh+VRSEYO+z7+9zFKlrhNgJrgpOBrKxhX
         l0vn5wIO23c1YlS77sDPHLj+9hckZMe2cyW7/Bq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 11/83] net: dsa: mv88e6xxx: fix handling of upper half of STATS_TYPE_PORT
Date:   Sun,  9 Jun 2019 18:41:41 +0200
Message-Id: <20190609164128.510928735@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
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
@@ -789,7 +789,7 @@ static uint64_t _mv88e6xxx_get_ethtool_s
 			err = mv88e6xxx_port_read(chip, port, s->reg + 1, &reg);
 			if (err)
 				return UINT64_MAX;
-			high = reg;
+			low |= ((u32)reg) << 16;
 		}
 		break;
 	case BANK0:


