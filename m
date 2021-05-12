Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303F337C452
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhELPab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234938AbhELPZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:25:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9198561968;
        Wed, 12 May 2021 15:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832269;
        bh=62e+VPSc6q2nY4krZKy2kVcHaUgzvH2sO35gJgrK2IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7Jv9q0jBPT1A7UYS3dmASgWEI77VQ6v3BD354OFUfL6b2Ha1KvdX1AW/ZRXaIAlf
         Q0qJtkh9zd5kN5gZT1Beib6qzmVTatybnVPPGJ1oHeupUZP3wpCFays02H5IFH3T+7
         bAn3rhqdpPEwwZlmsqEQU/GpNqx8789eZejVldw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Spencer E. Olson" <olsonse@umich.edu>,
        Ian Abbott <abbotti@mev.co.uk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 209/530] staging: comedi: tests: ni_routes_test: Fix compilation error
Date:   Wed, 12 May 2021 16:45:19 +0200
Message-Id: <20210512144826.710791921@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index eaefaf596a37..02606e39625a 100644
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



