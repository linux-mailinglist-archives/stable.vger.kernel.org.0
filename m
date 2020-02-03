Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E7D150D5E
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbgBCQnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:43:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730114AbgBCQce (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:32:34 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD0DC2051A;
        Mon,  3 Feb 2020 16:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747554;
        bh=0ef1BWJcFDjFGtlT09zlYGPAEVc9MTH5OEySSi1l4b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IEEiMfgQEjycfW/4i0ppC53zpbLSQQAKOkMAUtTj8I4z5st91DT2bgAT+7NBZFZar
         ingpqRqH3TnQcj/Df6c7b/+efLM7teM62TSniuNoLpnt5+FUwcMfAJnLqUbGyIJ4Cm
         vLa03ptqVu4nXmgnHYn/V/YcDehNaQ1bUzhy2BXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/70] parisc: Use proper printk format for resource_size_t
Date:   Mon,  3 Feb 2020 16:19:53 +0000
Message-Id: <20200203161918.317663938@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
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
index a1a5e4c59e6b2..4d5ad9cb0f692 100644
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -868,8 +868,8 @@ static void print_parisc_device(struct parisc_device *dev)
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



