Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A193C4AF7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238272AbhGLGzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239719AbhGLGw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:52:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACE5E60FDB;
        Mon, 12 Jul 2021 06:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072611;
        bh=B1AECimhgtZobjOkyJSuFEf7xLqjXr/PlRwatGwfCPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q7B/coz3/I+A+ASPgOol4wpOPfX6vjCSB12chAaDNXb+LyPj1uURy2K8Wa637TI36
         A3NIjS2o1usicrGuICo96KNG0c4iP6rjIxEO769sUwYU5bq7oZyYDV/pVYYbMzRGg4
         j2nIjoYaon3UgwCkhBRidrWW7lYp6XMnwS8kGVIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 554/593] powerpc/papr_scm: Properly handle UUID types and API
Date:   Mon, 12 Jul 2021 08:11:54 +0200
Message-Id: <20210712060955.395063837@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0e8554b5d7801b0aebc6c348a0a9f7706aa17b3b ]

Parse to and export from UUID own type, before dereferencing.
This also fixes wrong comment (Little Endian UUID is something else)
and should eliminate the direct strict types assignments.

Fixes: 43001c52b603 ("powerpc/papr_scm: Use ibm,unit-guid as the iset cookie")
Fixes: 259a948c4ba1 ("powerpc/pseries/scm: Use a specific endian format for storing uuid from the device tree")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210616134303.58185-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 27 +++++++++++++++--------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 835163f54244..0693bc8d70ac 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -18,6 +18,7 @@
 #include <asm/plpar_wrappers.h>
 #include <asm/papr_pdsm.h>
 #include <asm/mce.h>
+#include <asm/unaligned.h>
 
 #define BIND_ANY_ADDR (~0ul)
 
@@ -1047,8 +1048,9 @@ static int papr_scm_probe(struct platform_device *pdev)
 	u32 drc_index, metadata_size;
 	u64 blocks, block_size;
 	struct papr_scm_priv *p;
+	u8 uuid_raw[UUID_SIZE];
 	const char *uuid_str;
-	u64 uuid[2];
+	uuid_t uuid;
 	int rc;
 
 	/* check we have all the required DT properties */
@@ -1090,16 +1092,23 @@ static int papr_scm_probe(struct platform_device *pdev)
 	p->is_volatile = !of_property_read_bool(dn, "ibm,cache-flush-required");
 
 	/* We just need to ensure that set cookies are unique across */
-	uuid_parse(uuid_str, (uuid_t *) uuid);
+	uuid_parse(uuid_str, &uuid);
+
 	/*
-	 * cookie1 and cookie2 are not really little endian
-	 * we store a little endian representation of the
-	 * uuid str so that we can compare this with the label
-	 * area cookie irrespective of the endian config with which
-	 * the kernel is built.
+	 * The cookie1 and cookie2 are not really little endian.
+	 * We store a raw buffer representation of the
+	 * uuid string so that we can compare this with the label
+	 * area cookie irrespective of the endian configuration
+	 * with which the kernel is built.
+	 *
+	 * Historically we stored the cookie in the below format.
+	 * for a uuid string 72511b67-0b3b-42fd-8d1d-5be3cae8bcaa
+	 *	cookie1 was 0xfd423b0b671b5172
+	 *	cookie2 was 0xaabce8cae35b1d8d
 	 */
-	p->nd_set.cookie1 = cpu_to_le64(uuid[0]);
-	p->nd_set.cookie2 = cpu_to_le64(uuid[1]);
+	export_uuid(uuid_raw, &uuid);
+	p->nd_set.cookie1 = get_unaligned_le64(&uuid_raw[0]);
+	p->nd_set.cookie2 = get_unaligned_le64(&uuid_raw[8]);
 
 	/* might be zero */
 	p->metadata_size = metadata_size;
-- 
2.30.2



