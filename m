Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E522406182
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240762AbhIJAnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232359AbhIJASw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EBBF61206;
        Fri, 10 Sep 2021 00:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233047;
        bh=lyV1drbcabKhcUzz4eIB6I9TGQVmAT9UL6gRXdE0Rrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULKd6D3hSxzc5Yn0EBm/7W4Q6nlI/5YsMKyjhCoQ0hi2CIXSJMrcbgkiCy+UtvZ8r
         oXgw1MBLrtiLuTD+aLUe9EAmQlS0MYZwHSPfYnGxEq07DKzl/IeO316TmxNqnSgMHm
         ZG5fj/SklEwcOMhLTKXm2AEcPsb+FB7pYDJYmYYV48mNpGVTvdifhDCk5aUILr3uZz
         SC4WPLCuaQvkQDr39qwy8aT/WnM5aDFZ8k1R7QvMGEjHGfxQFjLzu85vlXRDX/8xBv
         /jag4UPOBusceDEFHZjOK/2uwBwON6TiGCIU/RzZzUV1NS1rodZ8CObUQeag404nk3
         BOdnjmtRAjL8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 64/99] scsi: core: Fix missing FORCE for scsi_devinfo_tbl.c build rule
Date:   Thu,  9 Sep 2021 20:15:23 -0400
Message-Id: <20210910001558.173296-64-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 98079418c53fff5f9e2d4087f08eaff2a9ce7714 ]

Add FORCE so that if_changed can detect the command line change.
scsi_devinfo_tbl.c must be added to 'targets' too.

Link: https://lore.kernel.org/r/20210819012339.709409-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 1748d1ec1338..77812ba3c4aa 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -183,7 +183,7 @@ CFLAGS_ncr53c8xx.o	:= $(ncr53c8xx-flags-y) $(ncr53c8xx-flags-m)
 zalon7xx-objs	:= zalon.o ncr53c8xx.o
 
 # Files generated that shall be removed upon make clean
-clean-files :=	53c700_d.h 53c700_u.h scsi_devinfo_tbl.c
+clean-files :=	53c700_d.h 53c700_u.h
 
 $(obj)/53c700.o: $(obj)/53c700_d.h
 
@@ -192,9 +192,11 @@ $(obj)/scsi_sysfs.o: $(obj)/scsi_devinfo_tbl.c
 quiet_cmd_bflags = GEN     $@
 	cmd_bflags = sed -n 's/.*define *BLIST_\([A-Z0-9_]*\) *.*/BLIST_FLAG_NAME(\1),/p' $< > $@
 
-$(obj)/scsi_devinfo_tbl.c: include/scsi/scsi_devinfo.h
+$(obj)/scsi_devinfo_tbl.c: include/scsi/scsi_devinfo.h FORCE
 	$(call if_changed,bflags)
 
+targets +=  scsi_devinfo_tbl.c
+
 # If you want to play with the firmware, uncomment
 # GENERATE_FIRMWARE := 1
 
-- 
2.30.2

