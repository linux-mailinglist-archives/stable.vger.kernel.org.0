Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428F03D2914
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhGVQA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233166AbhGVP6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5894D613B6;
        Thu, 22 Jul 2021 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971953;
        bh=fr8G74vxfVdDeYwCGK08x6KBeyFJ+5YY1WDEsdVOqzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCokn3GN3JS/PHedLK6fXvHEnJy/xXh7LCVUJhaam4aiR0Hh6yIN9Xgrz4GYR2VSU
         HBvpyfq1biVApMzkFAQNfFn0ouGIq74uIPWe3TOd+ZSdtUO17GEbl4X5vy/k6CvQFX
         FNMQiczzAH2Tv9a784zvbMRv5RbrvE08PvpZBR2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 091/125] net: dsa: mv88e6xxx: use correct .stats_set_histogram() on Topaz
Date:   Thu, 22 Jul 2021 18:31:22 +0200
Message-Id: <20210722155627.720987295@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit 11527f3c4725640e6c40a2b7654e303f45e82a6c upstream.

Commit 40cff8fca9e3 ("net: dsa: mv88e6xxx: Fix stats histogram mode")
introduced wrong .stats_set_histogram() method for Topaz family.

The Peridot method should be used instead.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 40cff8fca9e3 ("net: dsa: mv88e6xxx: Fix stats histogram mode")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3407,7 +3407,7 @@ static const struct mv88e6xxx_ops mv88e6
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
-	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
+	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,
@@ -4174,7 +4174,7 @@ static const struct mv88e6xxx_ops mv88e6
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
-	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
+	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,


