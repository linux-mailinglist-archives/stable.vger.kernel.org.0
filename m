Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D4539625D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbhEaOzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234041AbhEaOxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D51AB61CAB;
        Mon, 31 May 2021 13:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469519;
        bh=8VXHNWCK7AGK9cnWLvPrdHbOKwzor6W1humTzPDrbf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7gc7ZzPaS+OoSu5ANF7O/z9Wjb+hmCdCRv5tf+0DKsPSRKLIRcaKrVt4zQbKPiL+
         5tGyo3Uz62JL1JzajpyxNUzPrtTzmEY7YMPFy1mTq8e3UWSeVtFy552gUasqruP0B2
         iaSV7o3lh8k/9tLp7hz/gcfbtydydOBobSnU2Zas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 228/296] net: ipa: memory region array is variable size
Date:   Mon, 31 May 2021 15:14:43 +0200
Message-Id: <20210531130711.487772273@linuxfoundation.org>
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

From: Alex Elder <elder@linaro.org>

[ Upstream commit 440c3247cba3d9433ac435d371dd7927d68772a7 ]

IPA configuration data includes an array of memory region
descriptors.  That was a fixed-size array at one time, but
at some point we started defining it such that it was only
as big as required for a given platform.  The actual number
of entries in the array is recorded in the configuration data
along with the array.

A loop in ipa_mem_config() still assumes the array has entries
for all defined memory region IDs.  As a result, this loop can
go past the end of the actual array and attempt to write
"canary" values based on nonsensical data.

Fix this, by stashing the number of entries in the array, and
using that rather than IPA_MEM_COUNT in the initialization loop
found in ipa_mem_config().

The only remaining use of IPA_MEM_COUNT is in a validation check
to ensure configuration data doesn't have too many entries.
That's fine for now.

Fixes: 3128aae8c439a ("net: ipa: redefine struct ipa_mem_data")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa.h     | 2 ++
 drivers/net/ipa/ipa_mem.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 802077631371..2734a5164b92 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -56,6 +56,7 @@ enum ipa_flag {
  * @mem_virt:		Virtual address of IPA-local memory space
  * @mem_offset:		Offset from @mem_virt used for access to IPA memory
  * @mem_size:		Total size (bytes) of memory at @mem_virt
+ * @mem_count:		Number of entries in the mem array
  * @mem:		Array of IPA-local memory region descriptors
  * @imem_iova:		I/O virtual address of IPA region in IMEM
  * @imem_size;		Size of IMEM region
@@ -102,6 +103,7 @@ struct ipa {
 	void *mem_virt;
 	u32 mem_offset;
 	u32 mem_size;
+	u32 mem_count;
 	const struct ipa_mem *mem;
 
 	unsigned long imem_iova;
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index f25029b9ec85..c1294d7ebdad 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -181,7 +181,7 @@ int ipa_mem_config(struct ipa *ipa)
 	 * for the region, write "canary" values in the space prior to
 	 * the region's base address.
 	 */
-	for (mem_id = 0; mem_id < IPA_MEM_COUNT; mem_id++) {
+	for (mem_id = 0; mem_id < ipa->mem_count; mem_id++) {
 		const struct ipa_mem *mem = &ipa->mem[mem_id];
 		u16 canary_count;
 		__le32 *canary;
@@ -488,6 +488,7 @@ int ipa_mem_init(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 	ipa->mem_size = resource_size(res);
 
 	/* The ipa->mem[] array is indexed by enum ipa_mem_id values */
+	ipa->mem_count = mem_data->local_count;
 	ipa->mem = mem_data->local;
 
 	ret = ipa_imem_init(ipa, mem_data->imem_addr, mem_data->imem_size);
-- 
2.30.2



