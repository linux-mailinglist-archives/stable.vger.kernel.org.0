Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5946C67E
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392035AbfGRDPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392027AbfGRDPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:15:24 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B52C21848;
        Thu, 18 Jul 2019 03:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419723;
        bh=rGTmn1Do0fdE2xwr//1vrCgSU5zRYdNtOrcaVxu+SRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JG9UpmGzZ1nQBHzjXL/UfFwE4kiXStdsMAYd/94B97mftEJJtPsgzMEUdy8Hcjd07
         Kci5XMzncvI21hguXIsw0h4XTdnstv+RVSlK4Hw9Nscfa6/AgviX+V6XwyPKX/Ak49
         WmlaUx29g6oruXZBwzkFSckUGiyoEUozyIqPtkhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4.4 27/40] MIPS: Remove superfluous check for __linux__
Date:   Thu, 18 Jul 2019 12:02:23 +0900
Message-Id: <20190718030049.386724125@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
References: <20190718030039.676518610@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 1287533d3d95d5ad8b02773733044500b1be06bc upstream.

When building BPF code using "clang -target bpf -c", clang does not
define __linux__.

To build BPF IR decoders the include linux/lirc.h is needed which
includes linux/types.h. Currently this workaround is needed:

https://git.linuxtv.org/v4l-utils.git/commit/?id=dd3ff81f58c4e1e6f33765dc61ad33c48ae6bb07

This check might otherwise be useful to stop users from using a non-linux
compiler, but if you're doing that you are going to have a lot more
trouble anyway.

Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Patchwork: https://patchwork.linux-mips.org/patch/21149/
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/uapi/asm/sgidefs.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/mips/include/uapi/asm/sgidefs.h
+++ b/arch/mips/include/uapi/asm/sgidefs.h
@@ -11,14 +11,6 @@
 #define __ASM_SGIDEFS_H
 
 /*
- * Using a Linux compiler for building Linux seems logic but not to
- * everybody.
- */
-#ifndef __linux__
-#error Use a Linux compiler or give up.
-#endif
-
-/*
  * Definitions for the ISA levels
  *
  * With the introduction of MIPS32 / MIPS64 instruction sets definitions


