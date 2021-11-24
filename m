Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C5145BEA2
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344087AbhKXMtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:49:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344358AbhKXMqg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:46:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CD2860232;
        Wed, 24 Nov 2021 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756833;
        bh=4Be/3x6HhN6MuCvXFQ+1O9rUNz0szmijicPv97g/qxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMsd8XPBcsCbAMxk9Wa+QZGCSxYebSB8G5oK2SbSOAIkm5yr+1DtciPflTV03t8ZQ
         XoXZ32N8hUqPLSyt6DDxLObdkWzmXmoakpuFEi0Bv1HUf9j1PSAtfTLs9rGi/x9Osj
         VCH+X+MLrD312+n4C39pS058a+LMg8KsvP5ZABM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 223/251] MIPS: generic/yamon-dt: fix uninitialized variable error
Date:   Wed, 24 Nov 2021 12:57:45 +0100
Message-Id: <20211124115718.034781025@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.i.king@googlemail.com>

[ Upstream commit 255e51da15baed47531beefd02f222e4dc01f1c1 ]

In the case where fw_getenv returns an error when fetching values
for ememsizea and memsize then variable phys_memsize is not assigned
a variable and will be uninitialized on a zero check of phys_memsize.
Fix this by initializing phys_memsize to zero.

Cleans up cppcheck error:
arch/mips/generic/yamon-dt.c:100:7: error: Uninitialized variable: phys_memsize [uninitvar]

Fixes: f41d2430bbd6 ("MIPS: generic/yamon-dt: Support > 256MB of RAM")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/generic/yamon-dt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/generic/yamon-dt.c b/arch/mips/generic/yamon-dt.c
index b408dac722ac7..e5fcaafea3a42 100644
--- a/arch/mips/generic/yamon-dt.c
+++ b/arch/mips/generic/yamon-dt.c
@@ -81,7 +81,7 @@ static unsigned int __init gen_fdt_mem_array(
 __init int yamon_dt_append_memory(void *fdt,
 				  const struct yamon_mem_region *regions)
 {
-	unsigned long phys_memsize, memsize;
+	unsigned long phys_memsize = 0, memsize;
 	__be32 mem_array[2 * MAX_MEM_ARRAY_ENTRIES];
 	unsigned int mem_entries;
 	int i, err, mem_off;
-- 
2.33.0



