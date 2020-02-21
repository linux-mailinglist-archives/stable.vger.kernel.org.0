Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB6F716726B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbgBUIDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:03:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731324AbgBUIDR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:03:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 408A7206ED;
        Fri, 21 Feb 2020 08:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272195;
        bh=SADULr2v8CoS9zmj1WlBhdagSQ+W/CvrBu4siprNm2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9sEmRjfmDDlPq65d2kbN2+u5m4oCWUdbsfBNjt6TUSihMhS4ljoIyh8CrFyCy3s/
         Vt5+HDUbnAoY9Ji26xodqrvpqPY5eK8tnWU5xQrUg8e8rT/+yY6jO5Bk/7ic6Xo9+E
         UT1W+NOMdbguyd/F70KjuIs+D/I+PLnepu3oSKC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/344] MIPS: Loongson: Fix potential NULL dereference in loongson3_platform_init()
Date:   Fri, 21 Feb 2020 08:37:30 +0100
Message-Id: <20200221072353.716410465@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 72d052e28d1d2363f9107be63ef3a3afdea6143c ]

If kzalloc fails, it should return -ENOMEM, otherwise may trigger a NULL
pointer dereference.

Fixes: 3adeb2566b9b ("MIPS: Loongson: Improve LEFI firmware interface")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Huacai Chen <chenhc@lemote.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson64/loongson-3/platform.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/mips/loongson64/loongson-3/platform.c b/arch/mips/loongson64/loongson-3/platform.c
index 13f3404f00300..9674ae1361a85 100644
--- a/arch/mips/loongson64/loongson-3/platform.c
+++ b/arch/mips/loongson64/loongson-3/platform.c
@@ -27,6 +27,9 @@ static int __init loongson3_platform_init(void)
 			continue;
 
 		pdev = kzalloc(sizeof(struct platform_device), GFP_KERNEL);
+		if (!pdev)
+			return -ENOMEM;
+
 		pdev->name = loongson_sysconf.sensors[i].name;
 		pdev->id = loongson_sysconf.sensors[i].id;
 		pdev->dev.platform_data = &loongson_sysconf.sensors[i];
-- 
2.20.1



