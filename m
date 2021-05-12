Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BDC37C881
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhELQJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237752AbhELQEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:04:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73C0F61C4F;
        Wed, 12 May 2021 15:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833663;
        bh=qvm9VcArMm0AhiWc9+5N3LqnkjMo8499m5COWMpnwDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szZ5TEIQh51j8A/3s+QYR/xApMTCnHD8GxSwCNten6Tov/pEqgKIhc3zcW2kQI3W3
         3KFUpqVIO3kgzfjfRE+92ulGMJGCSb9JaJ0q89eaw7gXs2CykeBJvEQQWx8UUnydxg
         EXwQhvVgfDK8xU+YTuQKP5r3x0tZi/6IP90bmPkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Spencer E. Olson" <olsonse@umich.edu>,
        Ian Abbott <abbotti@mev.co.uk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 239/601] staging: comedi: tests: ni_routes_test: Fix compilation error
Date:   Wed, 12 May 2021 16:45:16 +0200
Message-Id: <20210512144835.701772543@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit 6db58ed2b2d9bb1792eace4f9aa70e8bdd730ffc ]

The `ni_routes_test` module is not currently selectable using the
Kconfig files, but can be built by specifying `CONFIG_COMEDI_TESTS=m` on
the "make" command line.  It currently fails to compile due to an extra
parameter added to the `ni_assign_device_routes` function by
commit e3b7ce73c578 ("staging: comedi: ni_routes: Allow alternate board
name for routes").  Fix it by supplying the value `NULL` for the added
`alt_board_name` parameter (which specifies that there is no alternate
board name).

Fixes: e3b7ce73c578 ("staging: comedi: ni_routes: Allow alternate board name for routes")
Cc: Spencer E. Olson <olsonse@umich.edu>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210407140142.447250-2-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/tests/ni_routes_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/tests/ni_routes_test.c b/drivers/staging/comedi/drivers/tests/ni_routes_test.c
index 4061b3b5f8e9..68defeb53de4 100644
--- a/drivers/staging/comedi/drivers/tests/ni_routes_test.c
+++ b/drivers/staging/comedi/drivers/tests/ni_routes_test.c
@@ -217,7 +217,8 @@ void test_ni_assign_device_routes(void)
 	const u8 *table, *oldtable;
 
 	init_pci_6070e();
-	ni_assign_device_routes(ni_eseries, pci_6070e, &private.routing_tables);
+	ni_assign_device_routes(ni_eseries, pci_6070e, NULL,
+				&private.routing_tables);
 	devroutes = private.routing_tables.valid_routes;
 	table = private.routing_tables.route_values;
 
@@ -253,7 +254,8 @@ void test_ni_assign_device_routes(void)
 	olddevroutes = devroutes;
 	oldtable = table;
 	init_pci_6220();
-	ni_assign_device_routes(ni_mseries, pci_6220, &private.routing_tables);
+	ni_assign_device_routes(ni_mseries, pci_6220, NULL,
+				&private.routing_tables);
 	devroutes = private.routing_tables.valid_routes;
 	table = private.routing_tables.route_values;
 
-- 
2.30.2



