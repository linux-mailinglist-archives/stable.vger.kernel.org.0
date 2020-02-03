Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D65150C5E
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbgBCQfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730708AbgBCQfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:35:42 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC2F52051A;
        Mon,  3 Feb 2020 16:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747741;
        bh=Bjl/84MAqt36tPliX79YykcxfdCerORPjvbNJvHNhrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGbGlFm116FE+Tzvt/K/l8bBKp3UvioGr9/SptjgmGtChQ9X3GUNRm8eXeeCkd/qr
         AeLd43j2i6SNHcjC+U4cUpRRfscNgwhXo8e68IDGeEfrPfaAnrD+2XqRzklz6yabIV
         UFm58cFAHwZMiIHFekWMC4OCK/TGjleQryzlGxPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 49/90] parisc: Use proper printk format for resource_size_t
Date:   Mon,  3 Feb 2020 16:19:52 +0000
Message-Id: <20200203161923.915835469@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 4f80b70e1953cb846dbdd1ce72cb17333d4c8d11 ]

resource_size_t should be printed with its own size-independent format
to fix warnings when compiling on 64-bit platform (e.g. with
COMPILE_TEST):

    arch/parisc/kernel/drivers.c: In function 'print_parisc_device':
    arch/parisc/kernel/drivers.c:892:9: warning:
        format '%p' expects argument of type 'void *',
        but argument 4 has type 'resource_size_t {aka unsigned int}' [-Wformat=]

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/drivers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index a6c9f49c66128..a5f3e50fe9761 100644
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -889,8 +889,8 @@ static void print_parisc_device(struct parisc_device *dev)
 	static int count;
 
 	print_pa_hwpath(dev, hw_path);
-	pr_info("%d. %s at 0x%px [%s] { %d, 0x%x, 0x%.3x, 0x%.5x }",
-		++count, dev->name, (void*) dev->hpa.start, hw_path, dev->id.hw_type,
+	pr_info("%d. %s at %pap [%s] { %d, 0x%x, 0x%.3x, 0x%.5x }",
+		++count, dev->name, &(dev->hpa.start), hw_path, dev->id.hw_type,
 		dev->id.hversion_rev, dev->id.hversion, dev->id.sversion);
 
 	if (dev->num_addrs) {
-- 
2.20.1



