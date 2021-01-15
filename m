Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4572F7BE4
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732553AbhAONGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:06:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:36412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732513AbhAOMbP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B1EE224F9;
        Fri, 15 Jan 2021 12:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713843;
        bh=ibyoc2rBqcrmn0fTDfCqzTf+/6rTCjCX10lhVzwFgL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9GOKv76a0W5xsdeFMa3dJw+cZCReG1j7+YbRJ/67YAb70FU8cy40Vg0qSuKb8Nro
         Cb6CMcONzReyK5U4isydk+41YvLjQL0rhxV0Aj3Z29jvy2eb0udwObP8f3UuqxZ9F0
         uG7THeOd9HtpipHHg3xTwpds9IbT2hXsoPUtyXeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 06/25] target: add XCOPY target/segment desc sense codes
Date:   Fri, 15 Jan 2021 13:27:37 +0100
Message-Id: <20210115121956.996737941@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.679956165@linuxfoundation.org>
References: <20210115121956.679956165@linuxfoundation.org>
User-Agent: quilt/0.66
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
index e738b4621cbba..ecd707f74ddcb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1736,6 +1736,10 @@ void transport_generic_request_failure(struct se_cmd *cmd,
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
@@ -2886,6 +2890,26 @@ static const struct sense_info sense_info_table[] = {
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
index 30f99ce4c6cea..8a70d38f13329 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -178,6 +178,10 @@ enum tcm_sense_reason_table {
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



