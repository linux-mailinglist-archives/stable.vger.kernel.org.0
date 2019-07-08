Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD9EC621C0
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbfGHPTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733185AbfGHPTK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:19:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B05521537;
        Mon,  8 Jul 2019 15:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599149;
        bh=pACI6D3myO5JNSRbPWXUf6hK64xGN3l01pdmArsudig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0R2fdVMhUzfuzXa89YWTeuraVhj+RG4x6vbwBk9Ib31fGar3OgSvLajffDWoBig6
         jgfXYi905q8jGWfI4xL5hUe0JfzozG6nfSbsqPUbAHOmvz4ZSlncy5B6s99LH9cIE4
         mBx49F9BetWA0XS48UlvGtS6isLbOZthWHo5oD5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "George G. Davis" <george_davis@mentor.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 021/102] scripts/checkstack.pl: Fix arm64 wrong or unknown architecture
Date:   Mon,  8 Jul 2019 17:12:14 +0200
Message-Id: <20190708150527.302732202@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4f45d62a52297b10ded963412a158685647ecdec ]

The following error occurs for the `make ARCH=arm64 checkstack` case:

aarch64-linux-gnu-objdump -d vmlinux $(find . -name '*.ko') | \
perl ./scripts/checkstack.pl arm64
wrong or unknown architecture "arm64"

As suggested by Masahiro Yamada, fix the above error using regular
expressions in the same way it was fixed for the `ARCH=x86` case via
commit fda9f9903be6 ("scripts/checkstack.pl: automatically handle
32-bit and 64-bit mode for ARCH=x86").

Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: George G. Davis <george_davis@mentor.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/checkstack.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkstack.pl b/scripts/checkstack.pl
index 12a6940741fe..b8f616545277 100755
--- a/scripts/checkstack.pl
+++ b/scripts/checkstack.pl
@@ -45,7 +45,7 @@ my (@stack, $re, $dre, $x, $xs, $funcre);
 	$x	= "[0-9a-f]";	# hex character
 	$xs	= "[0-9a-f ]";	# hex character or space
 	$funcre = qr/^$x* <(.*)>:$/;
-	if ($arch eq 'aarch64') {
+	if ($arch =~ '^(aarch|arm)64$') {
 		#ffffffc0006325cc:       a9bb7bfd        stp     x29, x30, [sp, #-80]!
 		$re = qr/^.*stp.*sp, \#-([0-9]{1,8})\]\!/o;
 	} elsif ($arch eq 'arm') {
-- 
2.20.1



