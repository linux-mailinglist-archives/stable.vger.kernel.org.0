Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0281F359AB2
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhDIKBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233936AbhDIJ7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9C506121F;
        Fri,  9 Apr 2021 09:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962326;
        bh=VxoJmc3w8Jg63Gj0JpCAQ8fEFiA7dFne0yZFtGuMaCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCd1I6p347OPUlPxIdE7qG5wQrS0F3pmLdSnBQ0i9fuwahOFRZJXylj/qZVIJ+Uxi
         OAXg5aieK0Fmy2XLPP1Kz91HK2pEo4lcUqaPoKXfDAPxt/XWAeaSHu++caFDRjXJE/
         vguM+tIZ9f20NO94bRiQFBgKprfHCk4relJHZZV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/41] net: ipa: fix init header command validation
Date:   Fri,  9 Apr 2021 11:53:38 +0200
Message-Id: <20210409095305.361379304@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit b4afd4b90a7cfe54c7cd9db49e3c36d552325eac ]

We use ipa_cmd_header_valid() to ensure certain values we will
program into hardware are within range, well in advance of when we
actually program them.  This way we avoid having to check for errors
when we actually program the hardware.

Unfortunately the dev_err() call for a bad offset value does not
supply the arguments to match the format specifiers properly.
Fix this.

There was also supposed to be a check to ensure the size to be
programmed fits in the field that holds it.  Add this missing check.

Rearrange the way we ensure the header table fits in overall IPA
memory range.

Finally, update ipa_cmd_table_valid() so the format of messages
printed for errors matches what's done in ipa_cmd_header_valid().

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_cmd.c | 50 ++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 46d8b7336d8f..a47378b7d9b2 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -175,21 +175,23 @@ bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
 			    : field_max(IP_FLTRT_FLAGS_NHASH_ADDR_FMASK);
 	if (mem->offset > offset_max ||
 	    ipa->mem_offset > offset_max - mem->offset) {
-		dev_err(dev, "IPv%c %s%s table region offset too large "
-			      "(0x%04x + 0x%04x > 0x%04x)\n",
-			      ipv6 ? '6' : '4', hashed ? "hashed " : "",
-			      route ? "route" : "filter",
-			      ipa->mem_offset, mem->offset, offset_max);
+		dev_err(dev, "IPv%c %s%s table region offset too large\n",
+			ipv6 ? '6' : '4', hashed ? "hashed " : "",
+			route ? "route" : "filter");
+		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
+			ipa->mem_offset, mem->offset, offset_max);
+
 		return false;
 	}
 
 	if (mem->offset > ipa->mem_size ||
 	    mem->size > ipa->mem_size - mem->offset) {
-		dev_err(dev, "IPv%c %s%s table region out of range "
-			      "(0x%04x + 0x%04x > 0x%04x)\n",
-			      ipv6 ? '6' : '4', hashed ? "hashed " : "",
-			      route ? "route" : "filter",
-			      mem->offset, mem->size, ipa->mem_size);
+		dev_err(dev, "IPv%c %s%s table region out of range\n",
+			ipv6 ? '6' : '4', hashed ? "hashed " : "",
+			route ? "route" : "filter");
+		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
+			mem->offset, mem->size, ipa->mem_size);
+
 		return false;
 	}
 
@@ -205,22 +207,36 @@ static bool ipa_cmd_header_valid(struct ipa *ipa)
 	u32 size_max;
 	u32 size;
 
+	/* In ipa_cmd_hdr_init_local_add() we record the offset and size
+	 * of the header table memory area.  Make sure the offset and size
+	 * fit in the fields that need to hold them, and that the entire
+	 * range is within the overall IPA memory range.
+	 */
 	offset_max = field_max(HDR_INIT_LOCAL_FLAGS_HDR_ADDR_FMASK);
 	if (mem->offset > offset_max ||
 	    ipa->mem_offset > offset_max - mem->offset) {
-		dev_err(dev, "header table region offset too large "
-			      "(0x%04x + 0x%04x > 0x%04x)\n",
-			      ipa->mem_offset + mem->offset, offset_max);
+		dev_err(dev, "header table region offset too large\n");
+		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
+			ipa->mem_offset, mem->offset, offset_max);
+
 		return false;
 	}
 
 	size_max = field_max(HDR_INIT_LOCAL_FLAGS_TABLE_SIZE_FMASK);
 	size = ipa->mem[IPA_MEM_MODEM_HEADER].size;
 	size += ipa->mem[IPA_MEM_AP_HEADER].size;
-	if (mem->offset > ipa->mem_size || size > ipa->mem_size - mem->offset) {
-		dev_err(dev, "header table region out of range "
-			      "(0x%04x + 0x%04x > 0x%04x)\n",
-			      mem->offset, size, ipa->mem_size);
+
+	if (size > size_max) {
+		dev_err(dev, "header table region size too large\n");
+		dev_err(dev, "    (0x%04x > 0x%08x)\n", size, size_max);
+
+		return false;
+	}
+	if (size > ipa->mem_size || mem->offset > ipa->mem_size - size) {
+		dev_err(dev, "header table region out of range\n");
+		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
+			mem->offset, size, ipa->mem_size);
+
 		return false;
 	}
 
-- 
2.30.2



