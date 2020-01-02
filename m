Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB6912ECBB
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728961AbgABWVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:21:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728957AbgABWVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:21:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 856EE21582;
        Thu,  2 Jan 2020 22:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003673;
        bh=HGgnOYkB19A8Cw6IPyxZwHC7IDJme7G/UiR6JnagRPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fATuGpeOZryiEr1Pd76QvzL/ZTj3NwCXqrB0/S1q+9oUSMAy1YG0z6eUmsKuiIn4j
         6ND6e8OeG8L08Vw+2hCmnmJA40dfdtxkbxf5LBsOO1B2copP10w1LDCrXf/F6DdpRm
         5CDsL09NEIeDpjgPgd2PRX6nNpYLjYj6Ewa5OAp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/114] s390/zcrypt: handle new reply code FILTERED_BY_HYPERVISOR
Date:   Thu,  2 Jan 2020 23:07:18 +0100
Message-Id: <20200102220035.719088798@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 6733775a92eacd612ac88afa0fd922e4ffeb2bc7 ]

This patch introduces support for a new architectured reply
code 0x8B indicating that a hypervisor layer (if any) has
rejected an ap message.

Linux may run as a guest on top of a hypervisor like zVM
or KVM. So the crypto hardware seen by the ap bus may be
restricted by the hypervisor for example only a subset like
only clear key crypto requests may be supported. Other
requests will be filtered out - rejected by the hypervisor.
The new reply code 0x8B will appear in such cases and needs
to get recognized by the ap bus and zcrypt device driver zoo.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_error.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/crypto/zcrypt_error.h b/drivers/s390/crypto/zcrypt_error.h
index 2e1a27bd97d1..2126f4cc6d37 100644
--- a/drivers/s390/crypto/zcrypt_error.h
+++ b/drivers/s390/crypto/zcrypt_error.h
@@ -62,6 +62,7 @@ struct error_hdr {
 #define REP82_ERROR_EVEN_MOD_IN_OPND	    0x85
 #define REP82_ERROR_RESERVED_FIELD	    0x88
 #define REP82_ERROR_INVALID_DOMAIN_PENDING  0x8A
+#define REP82_ERROR_FILTERED_BY_HYPERVISOR  0x8B
 #define REP82_ERROR_TRANSPORT_FAIL	    0x90
 #define REP82_ERROR_PACKET_TRUNCATED	    0xA0
 #define REP82_ERROR_ZERO_BUFFER_LEN	    0xB0
@@ -92,6 +93,7 @@ static inline int convert_error(struct zcrypt_queue *zq,
 	case REP82_ERROR_INVALID_DOMAIN_PRECHECK:
 	case REP82_ERROR_INVALID_DOMAIN_PENDING:
 	case REP82_ERROR_INVALID_SPECIAL_CMD:
+	case REP82_ERROR_FILTERED_BY_HYPERVISOR:
 	//   REP88_ERROR_INVALID_KEY		// '82' CEX2A
 	//   REP88_ERROR_OPERAND		// '84' CEX2A
 	//   REP88_ERROR_OPERAND_EVEN_MOD	// '85' CEX2A
-- 
2.20.1



