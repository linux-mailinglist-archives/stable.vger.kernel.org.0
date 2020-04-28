Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C6D1BC929
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgD1SjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:39:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbgD1SjJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:39:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 042DA20B1F;
        Tue, 28 Apr 2020 18:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099148;
        bh=DssGh3cFfTGPk2oqSA/BtLjd5L3+hLW+cPnbRN+og6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhplbMIK98odAK45PqhgEKI13hukQ+Xie8+em5A1Nnt/K8BR/PmK7MZrSVoK+LvAh
         iJqB9KNoLaarDuAtMlHlhWrHZqF/ldFGAnB3VhU5oopcQvfAy19QEYVizHYOJBNDav
         E585nYxhQZJMt53hkscVbEuYUKfoWBjjJxIuC3Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Qian Cai <cai@lca.pw>, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.6 133/167] powerpc/setup_64: Set cache-line-size based on cache-block-size
Date:   Tue, 28 Apr 2020 20:25:09 +0200
Message-Id: <20200428182242.259609463@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

commit 94c0b013c98583614e1ad911e8795ca36da34a85 upstream.

If {i,d}-cache-block-size is set and {i,d}-cache-line-size is not, use
the block-size value for both. Per the devicetree spec cache-line-size
is only needed if it differs from the block size.

Originally the code would fallback from block size to line size. An
error message was printed if both properties were missing.

Later the code was refactored to use clearer names and logic but it
inadvertently made line size a required property, meaning on systems
without a line size property we fall back to the default from the
cputable.

On powernv (OPAL) platforms, since the introduction of device tree CPU
features (5a61ef74f269 ("powerpc/64s: Support new device tree binding
for discovering CPU features")), that has led to the wrong value being
used, as the fallback value is incorrect for Power8/Power9 CPUs.

The incorrect values flow through to the VDSO and also to the sysconf
values, SC_LEVEL1_ICACHE_LINESIZE etc.

Fixes: bd067f83b084 ("powerpc/64: Fix naming of cache block vs. cache line")
Cc: stable@vger.kernel.org # v4.11+
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reported-by: Qian Cai <cai@lca.pw>
[mpe: Add even more detail to change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200416221908.7886-1-chris.packham@alliedtelesis.co.nz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/setup_64.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -534,6 +534,8 @@ static bool __init parse_cache_info(stru
 	lsizep = of_get_property(np, propnames[3], NULL);
 	if (bsizep == NULL)
 		bsizep = lsizep;
+	if (lsizep == NULL)
+		lsizep = bsizep;
 	if (lsizep != NULL)
 		lsize = be32_to_cpu(*lsizep);
 	if (bsizep != NULL)


