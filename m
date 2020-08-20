Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB31D24B6DF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbgHTKne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:43:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730920AbgHTKQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:16:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9FDB20738;
        Thu, 20 Aug 2020 10:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918581;
        bh=n1tyt8Ic+jDu6mBJzRy5u6bIJ0NLjShugkDcSv7r33U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1aBVBnp02jcb02bskyOrtGUB8JCwTThbNMuPuWwbVGj59JhZDsw5W/G/1IPpezAED
         bHC4t8fi+/heBkPp4llQxJwibYNtIv6mFpHFhdcLmRsEOpsXKNlicIWjFl9uB4Sdpi
         GoLSQCitHhvqxfYU0TSEtDRFHq0WwmfnCoQ/rWj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Blanchard <anton@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 192/228] pseries: Fix 64 bit logical memory block panic
Date:   Thu, 20 Aug 2020 11:22:47 +0200
Message-Id: <20200820091617.155546675@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Blanchard <anton@ozlabs.org>

commit 89c140bbaeee7a55ed0360a88f294ead2b95201b upstream.

Booting with a 4GB LMB size causes us to panic:

  qemu-system-ppc64: OS terminated: OS panic:
      Memory block size not suitable: 0x0

Fix pseries_memory_block_size() to handle 64 bit LMBs.

Cc: stable@vger.kernel.org
Signed-off-by: Anton Blanchard <anton@ozlabs.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200715000820.1255764-1-anton@ozlabs.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/hotplug-memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -30,7 +30,7 @@ static bool rtas_hp_event;
 unsigned long pseries_memory_block_size(void)
 {
 	struct device_node *np;
-	unsigned int memblock_size = MIN_MEMORY_BLOCK_SIZE;
+	u64 memblock_size = MIN_MEMORY_BLOCK_SIZE;
 	struct resource r;
 
 	np = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");


