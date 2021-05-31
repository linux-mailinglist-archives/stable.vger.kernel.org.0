Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2673962B6
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhEaPAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234116AbhEaO5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:57:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3ED961CC7;
        Mon, 31 May 2021 14:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469647;
        bh=C2WS6xhbObfd+1D9ZcNUvJNVM3eLmKUdDTfjOjdcOco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uP4V42TztLAMKv7T4sd5LyDhVurf+sRzx8nyXye+adxj6lF9SuqZy/9B8G5+oOrlx
         8rxWXfU5t8kw64ZqZSYeVL22V5P0MGJ9JUbforpOin7zkFlTNbFdFNSR97UxPJK1sh
         bGVC43WaSoqDahBsepuAiXTwQS/4pn060mp/WixY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 276/296] scsi: aic7xxx: Restore several defines for aic7xxx firmware build
Date:   Mon, 31 May 2021 15:15:31 +0200
Message-Id: <20210531130713.013680144@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 7e7606330b167a0ff483fb02caed9267bfab69ee ]

With CONFIG_AIC7XXX_BUILD_FIRMWARE, there is this representative error:

  aicasm: Stopped at file ./drivers/scsi/aic7xxx/aic7xxx.seq,
    line 271 - Undefined symbol MSG_SIMPLE_Q_TAG referenced

MSG_SIMPLE_Q_TAG used to be defined in drivers/scsi/aic7xxx/scsi_message.h
as:

  #define MSG_SIMPLE_Q_TAG	0x20 /* O/O */

The new definition in include/scsi/scsi.h is:

  #define SIMPLE_QUEUE_TAG    0x20

But aicasm can not handle the all the preprocessor directives in scsi.h, so
add MSG_SIMPLE_Q_TAB and other required defines back to scsi_message.h.

Link: https://lore.kernel.org/r/20210517132451.1832233-1-trix@redhat.com
Fixes: d8cd784ff7b3 ("scsi: aic7xxx: aic79xx: Drop internal SCSI message definition"
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic7xxx/scsi_message.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/aic7xxx/scsi_message.h b/drivers/scsi/aic7xxx/scsi_message.h
index a7515c3039ed..53343a6d8ae1 100644
--- a/drivers/scsi/aic7xxx/scsi_message.h
+++ b/drivers/scsi/aic7xxx/scsi_message.h
@@ -3,6 +3,17 @@
  * $FreeBSD: src/sys/cam/scsi/scsi_message.h,v 1.2 2000/05/01 20:21:29 peter Exp $
  */
 
+/* Messages (1 byte) */		     /* I/T (M)andatory or (O)ptional */
+#define MSG_SAVEDATAPOINTER	0x02 /* O/O */
+#define MSG_RESTOREPOINTERS	0x03 /* O/O */
+#define MSG_DISCONNECT		0x04 /* O/O */
+#define MSG_MESSAGE_REJECT	0x07 /* M/M */
+#define MSG_NOOP		0x08 /* M/M */
+
+/* Messages (2 byte) */
+#define MSG_SIMPLE_Q_TAG	0x20 /* O/O */
+#define MSG_IGN_WIDE_RESIDUE	0x23 /* O/O */
+
 /* Identify message */		     /* M/M */	
 #define MSG_IDENTIFYFLAG	0x80 
 #define MSG_IDENTIFY_DISCFLAG	0x40 
-- 
2.30.2



