Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 351DC16787E
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgBUHpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:45:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgBUHpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:45:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6DE824656;
        Fri, 21 Feb 2020 07:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271151;
        bh=YExDrIvfA5R9KIwpFUW4yNC9o8yjfp9sWdgL77Juibk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdEa9AccMcdo9PGotWFth/DXfEuaRUvjU9Dlo7mzdQE/i7jSTODITzvBE9cV1kFen
         C4kRql6WHF0yMqkq7qCpAH0ME6q+a/q2/xmDm9e+lOCc6uvW3KHaeM560AcwUC145h
         HAHn8N9o6lipXLHwtL+QhUVxLWTD3VnZxpzLhoI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 058/399] sparc: Add .exit.data section.
Date:   Fri, 21 Feb 2020 08:36:23 +0100
Message-Id: <20200221072407.992468463@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 548f0b9a5f4cffa0cecf62eb12aa8db682e4eee6 ]

This fixes build errors of all sorts.

Also, emit .exit.text unconditionally.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/vmlinux.lds.S | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index 7ec79918b566b..f99e99e58075f 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -171,12 +171,14 @@ SECTIONS
 	}
 	PERCPU_SECTION(SMP_CACHE_BYTES)
 
-#ifdef CONFIG_JUMP_LABEL
 	. = ALIGN(PAGE_SIZE);
 	.exit.text : {
 		EXIT_TEXT
 	}
-#endif
+
+	.exit.data : {
+		EXIT_DATA
+	}
 
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
-- 
2.20.1



