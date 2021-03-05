Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A82132E83B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhCEMZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:25:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhCEMZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:25:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3518C6502B;
        Fri,  5 Mar 2021 12:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947126;
        bh=OxObYKVvhOUek42Mgl4cl7UIyzim7W0ivwfTCF4b3AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iO3UC5m6/ioBJS12pGLQ0EDNW40HmzUig0syp5mStvyRG+XEw2vPIj+tMTlWfWzv4
         fszk/2xbnbupRMAocuOQIE7iQvgWJ2aptZs6m/awCsbJEzbcVsWuLW7fCXgMA7lkB+
         vjafLy5fR6ibpYv6qgpqUDvI7URvyYHGARA7aCSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 056/104] net: ipa: avoid field overflow
Date:   Fri,  5 Mar 2021 13:21:01 +0100
Message-Id: <20210305120905.923306360@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit cd1150098f2cc7bd05740c105488c293f6761f5a ]

It's possible that the length passed to ipa_header_size_encoded()
is larger than what can be represented by the HDR_LEN field alone
(starting with IPA v4.5).  If we attempted that, u32_encode_bits()
would trigger a build-time error.

Avoid this problem by masking off high-order bits of the value
encoded as the lower portion of the header length.

The same sort of problem exists in ipa_metadata_offset_encoded(),
so implement the same fix there.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_reg.h | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index e6b0827a244e..732e691e9aa6 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -408,15 +408,18 @@ enum ipa_cs_offload_en {
 static inline u32 ipa_header_size_encoded(enum ipa_version version,
 					  u32 header_size)
 {
+	u32 size = header_size & field_mask(HDR_LEN_FMASK);
 	u32 val;
 
-	val = u32_encode_bits(header_size, HDR_LEN_FMASK);
-	if (version < IPA_VERSION_4_5)
+	val = u32_encode_bits(size, HDR_LEN_FMASK);
+	if (version < IPA_VERSION_4_5) {
+		/* ipa_assert(header_size == size); */
 		return val;
+	}
 
 	/* IPA v4.5 adds a few more most-significant bits */
-	header_size >>= hweight32(HDR_LEN_FMASK);
-	val |= u32_encode_bits(header_size, HDR_LEN_MSB_FMASK);
+	size = header_size >> hweight32(HDR_LEN_FMASK);
+	val |= u32_encode_bits(size, HDR_LEN_MSB_FMASK);
 
 	return val;
 }
@@ -425,15 +428,18 @@ static inline u32 ipa_header_size_encoded(enum ipa_version version,
 static inline u32 ipa_metadata_offset_encoded(enum ipa_version version,
 					      u32 offset)
 {
+	u32 off = offset & field_mask(HDR_OFST_METADATA_FMASK);
 	u32 val;
 
-	val = u32_encode_bits(offset, HDR_OFST_METADATA_FMASK);
-	if (version < IPA_VERSION_4_5)
+	val = u32_encode_bits(off, HDR_OFST_METADATA_FMASK);
+	if (version < IPA_VERSION_4_5) {
+		/* ipa_assert(offset == off); */
 		return val;
+	}
 
 	/* IPA v4.5 adds a few more most-significant bits */
-	offset >>= hweight32(HDR_OFST_METADATA_FMASK);
-	val |= u32_encode_bits(offset, HDR_OFST_METADATA_MSB_FMASK);
+	off = offset >> hweight32(HDR_OFST_METADATA_FMASK);
+	val |= u32_encode_bits(off, HDR_OFST_METADATA_MSB_FMASK);
 
 	return val;
 }
-- 
2.30.1



