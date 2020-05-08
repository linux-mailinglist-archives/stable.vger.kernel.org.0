Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87B21CA690
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 10:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgEHIvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 04:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgEHIvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 04:51:45 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37F5C05BD43
        for <stable@vger.kernel.org>; Fri,  8 May 2020 01:51:44 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u16so9715901wmc.5
        for <stable@vger.kernel.org>; Fri, 08 May 2020 01:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=GTjfeLZr6qS9lCebo0Oi2u+gWYCLyvnmU1MVj1pW/Tc=;
        b=dGxd/hii6j+GES6t/mDi2Arr/f8FWTzss8lXWYrY2wLyGjkKVy4kB4Cnln5gMKv2+u
         jNuaDMYwDCRwAB9zaykC0CPyzC2Y7Yu5wQIJ2DxrYwytHuvfsIlkhM+JfTinuWevF7bL
         lG7wsmfGcDHQfNjs9pwOzCXNsdiy3nwEk5UqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GTjfeLZr6qS9lCebo0Oi2u+gWYCLyvnmU1MVj1pW/Tc=;
        b=ZK72qOmTqwJM2fdmNV43KxtnPDmIbS46OD3/qK7apPsztpxsABF8tKyZhTVCWgifl8
         JIqO/l/y35Cw+iiBPiCPbywXa6bf8hd4gBRy4A+GwlbeW3FAbXyAfnZwuqnuhlQBgrt2
         SDs1qmuwMeKDL+WcXKkMRVwYT91C43g5ihaUZbpPP7c0E5h31IYemt6nU1ycsy/Iw83X
         TgM4iRjz9ap/qHizb8WkBw9oatzPTbSlbe+uo6DfYRoDSCfepAsupja0KrIHC7LALu1+
         IOD+zbOjYpCWrhlcguS9eTxO8zz7DmmtPqxkmopr99y+zTYO15m9cTAFZavsTEAeSCTM
         UWLw==
X-Gm-Message-State: AGi0Pua0KMOMeYmBq4YwoaY16K9/LwBL6bGBFymcZdYqTBI4rpmqy3nO
        MOsxrUEYjdbm1Cd4Vg/zqgkaCQ==
X-Google-Smtp-Source: APiQypJweP82VQB3J7E+aqGejvIAep37uz3nqCleBy34hPBOzfiO/mJT1tufHfGKNAwidM1XGaJrsg==
X-Received: by 2002:a1c:5402:: with SMTP id i2mr14350587wmb.2.1588927903277;
        Fri, 08 May 2020 01:51:43 -0700 (PDT)
Received: from it_dev_server1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p8sm8048387wma.45.2020.05.08.01.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 01:51:42 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        "# v5 . 6+" <stable@vger.kernel.org>
Subject: [PATCH 3/5] megaraid_sas: Replace undefined MFI_BIG_ENDIAN macro with __BIG_ENDIAN_BITFIELD macro
Date:   Fri,  8 May 2020 14:21:30 +0530
Message-Id: <20200508085130.23339-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.9.5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

MFI_BIG_ENDIAN macro used in drivers structure bitfield to check
the CPU big endianness is undefined which would break the code on
big endian machine. __BIG_ENDIAN_BITFIELD kernel macro should be
used in places of MFI_BIG_ENDIAN macro.

Fixes: a7faf81d7858 ("scsi: megaraid_sas: Set no_write_same only for Virtual Disk")
Cc: <stable@vger.kernel.org> # v5.6+
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 4 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 83d8c4c..9882736 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -511,7 +511,7 @@ union MR_PROGRESS {
  */
 struct MR_PD_PROGRESS {
 	struct {
-#ifndef MFI_BIG_ENDIAN
+#ifndef __BIG_ENDIAN_BITFIELD
 		u32     rbld:1;
 		u32     patrol:1;
 		u32     clear:1;
@@ -537,7 +537,7 @@ struct MR_PD_PROGRESS {
 	};
 
 	struct {
-#ifndef MFI_BIG_ENDIAN
+#ifndef __BIG_ENDIAN_BITFIELD
 		u32     rbld:1;
 		u32     patrol:1;
 		u32     clear:1;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index d57ecc7..30de4b0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -774,7 +774,7 @@ struct MR_SPAN_BLOCK_INFO {
 struct MR_CPU_AFFINITY_MASK {
 	union {
 		struct {
-#ifndef MFI_BIG_ENDIAN
+#ifndef __BIG_ENDIAN_BITFIELD
 		u8 hw_path:1;
 		u8 cpu0:1;
 		u8 cpu1:1;
@@ -866,7 +866,7 @@ struct MR_LD_RAID {
 	__le16     seqNum;
 
 struct {
-#ifndef MFI_BIG_ENDIAN
+#ifndef __BIG_ENDIAN_BITFIELD
 	u32 ldSyncRequired:1;
 	u32 regTypeReqOnReadIsValid:1;
 	u32 isEPD:1;
@@ -889,7 +889,7 @@ struct {
 	/* 0x30 - 0x33, Logical block size for the LD */
 	u32 logical_block_length;
 	struct {
-#ifndef MFI_BIG_ENDIAN
+#ifndef __BIG_ENDIAN_BITFIELD
 	/* 0x34, P_I_EXPONENT from READ CAPACITY 16 */
 	u32 ld_pi_exp:4;
 	/* 0x34, LOGICAL BLOCKS PER PHYSICAL
-- 
2.9.5

