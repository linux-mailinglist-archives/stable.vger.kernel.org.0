Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D44D1FB86E
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732515AbgFPP4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730949AbgFPPzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:55:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31BFF207C4;
        Tue, 16 Jun 2020 15:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322947;
        bh=lz0QmYUpdiPvamXMQCfnRLqqLSzc8DlZx7YXj9CHO6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5S+A5U8J9rB5USbo6PNAY4zut07Btd2rteMjA3yzn9NghhH69Vcuyz29cBNL49Lr
         QBz4jGYJ/lz3bTlwIXnn+pxt2asn7JDQhCfghlYTdzqEFhUf7fc0RX4oTjSz/O+vgm
         M9nFeOtgiQKR5vLgMFGcRn2JfhNUacYR5FIu2NEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.6 135/161] scsi: megaraid_sas: Replace undefined MFI_BIG_ENDIAN macro with __BIG_ENDIAN_BITFIELD macro
Date:   Tue, 16 Jun 2020 17:35:25 +0200
Message-Id: <20200616153112.793384651@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

commit b9d5e3e7f370a817c742fb089ac1a86dfe8947dc upstream.

MFI_BIG_ENDIAN macro used in drivers structure bitfield to check the CPU
big endianness is undefined which would break the code on big endian
machine. __BIG_ENDIAN_BITFIELD kernel macro should be used in places of
MFI_BIG_ENDIAN macro.

Link: https://lore.kernel.org/r/20200508085130.23339-1-chandrakanth.patil@broadcom.com
Fixes: a7faf81d7858 ("scsi: megaraid_sas: Set no_write_same only for Virtual Disk")
Cc: <stable@vger.kernel.org> # v5.6+
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/megaraid/megaraid_sas.h        |    4 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

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


