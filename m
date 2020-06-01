Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8121EAE3D
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgFASwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730155AbgFASEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:04:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 070D92077D;
        Mon,  1 Jun 2020 18:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034642;
        bh=wl8/LpvoT/Kn9/NZk9s1s6pdy+LCKLKF8hAPKNt/+rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOhyHNyGCkOkpAO8jOaboXLiN9lHXPUPkYuX5lJJQn5sOMTE8auMAnRd+VVQj0nP9
         DE4qwvObMO9MG9Vnspe+0KLSWeDpDvFdpIwpkVx2E7gr8EHzYozdWS1Tv4vmUvqM+f
         v0z39LbIMyqHwQXhnvhnKxw6K3hHsQibMpWkq4jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/95] ARM: 8970/1: decompressor: increase tag size
Date:   Mon,  1 Jun 2020 19:53:45 +0200
Message-Id: <20200601174027.917219802@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Stelmach <l.stelmach@samsung.com>

[ Upstream commit 2c962369d72f286659e6446919f88d69b943cb4d ]

The size field of the tag header structure is supposed to be set to the
size of a tag structure including the header.

Fixes: c772568788b5f0 ("ARM: add additional table to compressed kernel")
Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/vmlinux.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/vmlinux.lds.S b/arch/arm/boot/compressed/vmlinux.lds.S
index 2b963d8e76dd..89a8f7588c78 100644
--- a/arch/arm/boot/compressed/vmlinux.lds.S
+++ b/arch/arm/boot/compressed/vmlinux.lds.S
@@ -46,7 +46,7 @@ SECTIONS
   }
   .table : ALIGN(4) {
     _table_start = .;
-    LONG(ZIMAGE_MAGIC(2))
+    LONG(ZIMAGE_MAGIC(4))
     LONG(ZIMAGE_MAGIC(0x5a534c4b))
     LONG(ZIMAGE_MAGIC(__piggy_size_addr - _start))
     LONG(ZIMAGE_MAGIC(_kernel_bss_size))
-- 
2.25.1



