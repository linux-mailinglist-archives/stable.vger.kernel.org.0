Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF33406348
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242553AbhIJArQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234467AbhIJAXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B9C4611BD;
        Fri, 10 Sep 2021 00:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233334;
        bh=m0SkfDEe4BupFPCc5cdIPFGZzcGkPqPOX8g2AK0Xpi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+uBH3sfOSHc5NHjc6cOCBn6XrTDz2PVh6g4aHfdwX93pEp7R1oq/5O/mByvhh2vn
         KTuD40XD7u2ifXJmm6jJDxDfrmgVPJKo3D+PnPm4i0bxtiwcHhomOHuVA9B/YQol/7
         QNznh6PC+G2LQJpKPHl6vr3YRktPHmxLhi2bRfB9k1CoCarxjb6eids5UKM5J5CBjm
         P3eMNRJXXiDM0k/+NhHJS/dkYT2FHoBvjfaDva55vZ9GtH6cgXTYevx99vcmdQ5aYm
         hjCjyPks6DHjmnFgL3x9SgGjlvkwkSC5pbiqqKV5BjUgVyhqo6oFbhqTZhHsXDo5FN
         0JG0Wfoa8UV1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/37] scsi: core: Fix missing FORCE for scsi_devinfo_tbl.c build rule
Date:   Thu,  9 Sep 2021 20:21:28 -0400
Message-Id: <20210910002143.175731-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002143.175731-1-sashal@kernel.org>
References: <20210910002143.175731-1-sashal@kernel.org>
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
index c00e3dd57990..7ac42eaa6250 100644
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

