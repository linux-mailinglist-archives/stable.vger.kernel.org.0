Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7FA2E6406
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404641AbgL1Ppr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404652AbgL1Noo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:44:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E62C322583;
        Mon, 28 Dec 2020 13:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163043;
        bh=MpvcWBcRcmHhhLO6Hi2HRC7lIUzhMPPVIXn4GXh1hM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1n853YJK5x06b5GS2iCTNxMryL3PVKPjeuVIqAt4zyVwSREFFjsDH+9TmZ0YdvHSq
         9Ub/Z0YebjFQ3RedrUCUdnAGOdB4VgzLGHmgYkBeln0rM9p+njHygcOMEySW7hn97/
         6r5oUaOyrGVOs3yzhVKvXMrtsKdaWkUzyHYU08uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/453] EDAC/mce_amd: Use struct cpuinfo_x86.cpu_die_id for AMD NodeId
Date:   Mon, 28 Dec 2020 13:46:26 +0100
Message-Id: <20201228124944.423928426@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit 8de0c9917cc1297bc5543b61992d5bdee4ce621a ]

The edac_mce_amd module calls decode_dram_ecc() on AMD Family17h and
later systems. This function is used in amd64_edac_mod to do
system-specific decoding for DRAM ECC errors. The function takes a
"NodeId" as a parameter.

In AMD documentation, NodeId is used to identify a physical die in a
system. This can be used to identify a node in the AMD_NB code and also
it is used with umc_normaddr_to_sysaddr().

However, the input used for decode_dram_ecc() is currently the NUMA node
of a logical CPU. In the default configuration, the NUMA node and
physical die will be equivalent, so this doesn't have an impact.

But the NUMA node configuration can be adjusted with optional memory
interleaving modes. This will cause the NUMA node enumeration to not
match the physical die enumeration. The mismatch will cause the address
translation function to fail or report incorrect results.

Use struct cpuinfo_x86.cpu_die_id for the node_id parameter to ensure the
physical ID is used.

Fixes: fbe63acf62f5 ("EDAC, mce_amd: Use cpu_to_node() to find the node ID")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20201109210659.754018-4-Yazen.Ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/mce_amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index ea622c6f3a393..c19640a453f22 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -975,7 +975,7 @@ static void decode_smca_error(struct mce *m)
 	}
 
 	if (bank_type == SMCA_UMC && xec == 0 && decode_dram_ecc)
-		decode_dram_ecc(cpu_to_node(m->extcpu), m);
+		decode_dram_ecc(topology_die_id(m->extcpu), m);
 }
 
 static inline void amd_decode_err_code(u16 ec)
-- 
2.27.0



