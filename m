Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07019FF354
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbfKPPmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:42:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728160AbfKPPmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:07 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 854042075E;
        Sat, 16 Nov 2019 15:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918926;
        bh=94EP+6CJbPi2gxqtqgE+/k68giV31iWUvYrmgWMNFuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUKGtUiJ9z95RwH7zh/Qh5JvWjm2joLNMrnDOoVERArCRe/ilmH3PrzZKQ4ZxDrbH
         dM1nYAAXCXDDKf9U8hXysxnyGyCZbpkOn3zbbHfpotSzlWUbBdPxJCiWZ/seNYqmUz
         sowC89IALvlsFB79phrQnPxvWi6l756Eh4hned0c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 053/237] scsi: bfa: Avoid implicit enum conversion in bfad_im_post_vendor_event
Date:   Sat, 16 Nov 2019 10:38:08 -0500
Message-Id: <20191116154113.7417-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 761c830ec7b3d0674b3ad89cefd77a692634e305 ]

Clang warns when one enumerated type is implicitly converted to another.

drivers/scsi/bfa/bfa_fcs_lport.c:379:26: warning: implicit conversion
from enumeration type 'enum bfa_lport_aen_event' to different
enumeration type 'enum bfa_ioc_aen_event' [-Wenum-conversion]
                                  BFA_AEN_CAT_LPORT, event);
                                                     ^~~~~

The root cause of these warnings is the bfad_im_post_vendor_event
function, which expects a value from enum bfa_ioc_aen_event but there
are multiple instances of values from enums bfa_port_aen_event,
bfa_audit_aen_event, and bfa_lport_aen_event being used in this
function.

Given that this doesn't appear to be a problem since cat helps with
differentiating the events, just change evt's type to int so that no
conversion needs to happen and Clang won't warn. Update aen_type's type
in bfa_aen_entry_s as members that hold enumerated types should be int.

Link: https://github.com/ClangBuiltLinux/linux/issues/147
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bfa/bfa_defs_svc.h | 2 +-
 drivers/scsi/bfa/bfad_im.h      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_defs_svc.h b/drivers/scsi/bfa/bfa_defs_svc.h
index 3d0c96a5c8735..c19c26e0e405e 100644
--- a/drivers/scsi/bfa/bfa_defs_svc.h
+++ b/drivers/scsi/bfa/bfa_defs_svc.h
@@ -1453,7 +1453,7 @@ union bfa_aen_data_u {
 struct bfa_aen_entry_s {
 	struct list_head	qe;
 	enum bfa_aen_category   aen_category;
-	u32                     aen_type;
+	int                     aen_type;
 	union bfa_aen_data_u    aen_data;
 	u64			aen_tv_sec;
 	u64			aen_tv_usec;
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index e61ed8dad0b4f..bd4ac187fd8e7 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -143,7 +143,7 @@ struct bfad_im_s {
 static inline void bfad_im_post_vendor_event(struct bfa_aen_entry_s *entry,
 					     struct bfad_s *drv, int cnt,
 					     enum bfa_aen_category cat,
-					     enum bfa_ioc_aen_event evt)
+					     int evt)
 {
 	struct timespec64 ts;
 
-- 
2.20.1

