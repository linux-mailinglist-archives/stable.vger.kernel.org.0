Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953EB2F78F0
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731718AbhAOMaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:30:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730762AbhAOM36 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:29:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7521023884;
        Fri, 15 Jan 2021 12:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713757;
        bh=N3DfWHgcMp2MEn31Bqgxb5fuuYYA4puUoXIF+3Y5LIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mw21P/f4PSl4s337s5IPT4Zd0xDyYzvMtL3ksqL5jwalwQ5TJMYqLbsSVW0WKlYmP
         zp2iZYJl42sIPGITHjuFKeH3m0jMav3TyxGUC2jp8ANZtGeoOdS/J6XxLf4Lnak5Uq
         jSQchH7Tzy5Nuzbogjiby1QnYdzYeppfHPRqR9YE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/18] target: add XCOPY target/segment desc sense codes
Date:   Fri, 15 Jan 2021 13:27:29 +0100
Message-Id: <20210115121955.187411823@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121955.112329537@linuxfoundation.org>
References: <20210115121955.112329537@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit e864212078ded276bdb272b2e0ee6a979357ca8a ]

As defined in http://www.t10.org/lists/asc-num.htm. To be used during
validation of XCOPY target and segment descriptor lists.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 24 ++++++++++++++++++++++++
 include/target/target_core_base.h      |  4 ++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7199bac673335..96cf2448a1f4f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1730,6 +1730,10 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	case TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED:
 	case TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED:
 	case TCM_COPY_TARGET_DEVICE_NOT_REACHABLE:
+	case TCM_TOO_MANY_TARGET_DESCS:
+	case TCM_UNSUPPORTED_TARGET_DESC_TYPE_CODE:
+	case TCM_TOO_MANY_SEGMENT_DESCS:
+	case TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE:
 		break;
 	case TCM_OUT_OF_RESOURCES:
 		sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -2864,6 +2868,26 @@ static const struct sense_info sense_info_table[] = {
 		.key = ILLEGAL_REQUEST,
 		.asc = 0x26, /* INVALID FIELD IN PARAMETER LIST */
 	},
+	[TCM_TOO_MANY_TARGET_DESCS] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x26,
+		.ascq = 0x06, /* TOO MANY TARGET DESCRIPTORS */
+	},
+	[TCM_UNSUPPORTED_TARGET_DESC_TYPE_CODE] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x26,
+		.ascq = 0x07, /* UNSUPPORTED TARGET DESCRIPTOR TYPE CODE */
+	},
+	[TCM_TOO_MANY_SEGMENT_DESCS] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x26,
+		.ascq = 0x08, /* TOO MANY SEGMENT DESCRIPTORS */
+	},
+	[TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x26,
+		.ascq = 0x09, /* UNSUPPORTED SEGMENT DESCRIPTOR TYPE CODE */
+	},
 	[TCM_PARAMETER_LIST_LENGTH_ERROR] = {
 		.key = ILLEGAL_REQUEST,
 		.asc = 0x1a, /* PARAMETER LIST LENGTH ERROR */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 0eed9fd79ea55..5aa8e0e62e309 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -181,6 +181,10 @@ enum tcm_sense_reason_table {
 	TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED	= R(0x16),
 	TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED	= R(0x17),
 	TCM_COPY_TARGET_DEVICE_NOT_REACHABLE	= R(0x18),
+	TCM_TOO_MANY_TARGET_DESCS		= R(0x19),
+	TCM_UNSUPPORTED_TARGET_DESC_TYPE_CODE	= R(0x1a),
+	TCM_TOO_MANY_SEGMENT_DESCS		= R(0x1b),
+	TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE	= R(0x1c),
 #undef R
 };
 
-- 
2.27.0



