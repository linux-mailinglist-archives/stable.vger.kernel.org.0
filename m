Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C62B3D28BE
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhGVP6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233169AbhGVP6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CADB61362;
        Thu, 22 Jul 2021 16:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626971916;
        bh=yzfqksNj7oNVJn8O8zX3vmVQU9l6Gxdoz/UyKqeStlo=;
        h=From:To:Cc:Subject:Date:From;
        b=twtWw+AZ9oUr6oxFKndtTxd2wXWFr3XuzLyfwzjSeIDF8Hw0mN2W5W3MlblahTTpH
         NduRju7jJ3/x7xLfZe9rX017fzsGR6keVnkX0Gjkb9IpgF2xs40jrQeyainMXM6p/b
         IRu3pUco4HB3+3hEj5Q9lEa51pvwFRIKIlALTVgP5cRLaP5PRKjdC5E/uk+N4WmASL
         qqPwfMRy2J2ab8lXIpToduGCpgPvrbpcHC+JUg5Cy9lGbwGzafg1/CRzRCEb0vsryg
         KsnJ8B3luiSI7wmns/Lf1WJ2U5PHMhQnLbPCMyCGOyx94b9NuuBjX0QjRA7Qg5pyGD
         Xm1yuU4RfDmIw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.19] net: dsa: mv88e6xxx: use correct .stats_set_histogram() on Topaz
Date:   Thu, 22 Jul 2021 18:38:32 +0200
Message-Id: <20210722163832.22971-1-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 11527f3c4725640e6c40a2b7654e303f45e82a6c upstream.

Commit 40cff8fca9e3 ("net: dsa: mv88e6xxx: Fix stats histogram mode")
introduced wrong .stats_set_histogram() method for Topaz family.

The Peridot method should be used instead.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 40cff8fca9e3 ("net: dsa: mv88e6xxx: Fix stats histogram mode")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7c50d27bab76..1df7aed5ae15 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3051,7 +3051,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
-	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
+	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,
@@ -3672,7 +3672,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
-	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
+	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,
-- 
2.31.1

