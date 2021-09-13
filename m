Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B4B408FE5
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241594AbhIMNrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244291AbhIMNpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:45:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F32660F25;
        Mon, 13 Sep 2021 13:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539902;
        bh=Fawx4chld2JZpyvMRE7kMDYjf/jNi1OZy/CJ95maXLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcHU9m5TV+hOOl7aakDXmMKyaOZsH8c7l8pqadRbOMl3LGvM1BSuFMDnAaq/11Hpz
         1UxF3SCJVXTOrDYuAzGSESE0p3vZdkAvDltrR1GwLO6ygKBA+lKmgYOhtGUmV1Plms
         efpd3hLVXr7/VRBVHU+lDuV2gMWNe5AVGw7Lo6t8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Kevin Mitchell <kevmitch@arista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/236] lkdtm: replace SCSI_DISPATCH_CMD with SCSI_QUEUE_RQ
Date:   Mon, 13 Sep 2021 15:14:39 +0200
Message-Id: <20210913131106.292460294@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Mitchell <kevmitch@arista.com>

[ Upstream commit d1f278da6b11585f05b2755adfc8851cbf14a1ec ]

When scsi_dispatch_cmd was moved to scsi_lib.c and made static, some
compilers (i.e., at least gcc 8.4.0) decided to compile this
inline. This is a problem for lkdtm.ko, which inserted a kprobe
on this function for the SCSI_DISPATCH_CMD crashpoint.

Move this crashpoint one function up the call chain to
scsi_queue_rq. Though this is also a static function, it should never be
inlined because it is assigned as a structure entry. Therefore,
kprobe_register should always be able to find it.

Fixes: 82042a2cdb55 ("scsi: move scsi_dispatch_cmd to scsi_lib.c")
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
Link: https://lore.kernel.org/r/20210819022940.561875-2-kevmitch@arista.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/fault-injection/provoke-crashes.rst | 2 +-
 drivers/misc/lkdtm/core.c                         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/fault-injection/provoke-crashes.rst b/Documentation/fault-injection/provoke-crashes.rst
index a20ba5d93932..18de17354206 100644
--- a/Documentation/fault-injection/provoke-crashes.rst
+++ b/Documentation/fault-injection/provoke-crashes.rst
@@ -29,7 +29,7 @@ recur_count
 cpoint_name
 	Where in the kernel to trigger the action. It can be
 	one of INT_HARDWARE_ENTRY, INT_HW_IRQ_EN, INT_TASKLET_ENTRY,
-	FS_DEVRW, MEM_SWAPOUT, TIMERADD, SCSI_DISPATCH_CMD,
+	FS_DEVRW, MEM_SWAPOUT, TIMERADD, SCSI_QUEUE_RQ,
 	IDE_CORE_CP, or DIRECT
 
 cpoint_type
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index c802db9aaeb0..32b3d77368e3 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -81,7 +81,7 @@ static struct crashpoint crashpoints[] = {
 	CRASHPOINT("FS_DEVRW",		 "ll_rw_block"),
 	CRASHPOINT("MEM_SWAPOUT",	 "shrink_inactive_list"),
 	CRASHPOINT("TIMERADD",		 "hrtimer_start"),
-	CRASHPOINT("SCSI_DISPATCH_CMD",	 "scsi_dispatch_cmd"),
+	CRASHPOINT("SCSI_QUEUE_RQ",	 "scsi_queue_rq"),
 	CRASHPOINT("IDE_CORE_CP",	 "generic_ide_ioctl"),
 #endif
 };
-- 
2.30.2



