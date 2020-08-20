Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB01424BD80
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgHTNHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbgHTJie (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:38:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C06522B49;
        Thu, 20 Aug 2020 09:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916313;
        bh=UpYTKo9YBI4Wb/ngMmtCZOnOgqcl6SDDieR0IfyJbOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TR+BfDMVKf8NO9DQ3//Pfyd8WLi8ISJN1fB4yhvmERILr4YOvUo0QG1p/tb3ASxEW
         cEcVbKy1tKhUglXhwdzXKN0Bvmb1CqnAJCgdknZ8yOHONSsU4h5G7BNLzF6/Qxx7lc
         LISg5X7P2s+2ezLaBUOemtN4zgFSdkcADMLqWF/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Blanchard <anton@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.7 085/204] pseries: Fix 64 bit logical memory block panic
Date:   Thu, 20 Aug 2020 11:19:42 +0200
Message-Id: <20200820091610.587579219@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
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
@@ -27,7 +27,7 @@ static bool rtas_hp_event;
 unsigned long pseries_memory_block_size(void)
 {
 	struct device_node *np;
-	unsigned int memblock_size = MIN_MEMORY_BLOCK_SIZE;
+	u64 memblock_size = MIN_MEMORY_BLOCK_SIZE;
 	struct resource r;
 
 	np = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");


