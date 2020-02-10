Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E938157C24
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbgBJNfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:35:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727874AbgBJMfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:21 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E527824677;
        Mon, 10 Feb 2020 12:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338120;
        bh=6LPYwNgMg2Zty4VqDRfkyulou1wsGateYOpua2AaXV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzy/jrEXVVDXzv1Ft9k5BzJcCb+SzUuMz0lbFUpLXBfgDFm0q6Qv9BycZSOhQ9NDI
         as/kKsPzt7pulfactgD+alvH7w6bJ/ki0a2ur90nbGep7NvHEmOM7S2s6WkpxP7C4O
         i3rB5yLw81wUiTiGJNU91GPaAJU9udKP+vziILMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pingfan Liu <kernelfans@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 055/195] powerpc/pseries: Advance pfn if section is not present in lmb_is_removable()
Date:   Mon, 10 Feb 2020 04:31:53 -0800
Message-Id: <20200210122311.402516130@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pingfan Liu <kernelfans@gmail.com>

commit fbee6ba2dca30d302efe6bddb3a886f5e964a257 upstream.

In lmb_is_removable(), if a section is not present, it should continue
to test the rest of the sections in the block. But the current code
fails to do so.

Fixes: 51925fb3c5c9 ("powerpc/pseries: Implement memory hotplug remove in the kernel")
Cc: stable@vger.kernel.org # v4.1+
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1578632042-12415-1-git-send-email-kernelfans@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/hotplug-memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -366,8 +366,10 @@ static bool lmb_is_removable(struct drme
 
 	for (i = 0; i < scns_per_block; i++) {
 		pfn = PFN_DOWN(phys_addr);
-		if (!pfn_present(pfn))
+		if (!pfn_present(pfn)) {
+			phys_addr += MIN_MEMORY_BLOCK_SIZE;
 			continue;
+		}
 
 		rc &= is_mem_section_removable(pfn, PAGES_PER_SECTION);
 		phys_addr += MIN_MEMORY_BLOCK_SIZE;


