Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBD65072A
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbfFXKFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729462AbfFXKE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:04:58 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8085D213F2;
        Mon, 24 Jun 2019 10:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370698;
        bh=GdduGoebxResOs2KZ9dutZNRWAcnWTyZBPIAgOWiSIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zarx5ukoMB/10VkPujR/Blew1K5HVkzkTah3/f4Zdvu1nfs2HR+gKQu5DJ4AvVrPF
         HB6WADtPk7T1Jjm6J8l6xNmN/kr2lF9s0TVoSXPPtIEXuZMODH4anzGdbYOaGVov5r
         uSGxVK6hrJIEgLH5s/F86qfu+JOHdgoLb+SLkgOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "George G. Davis" <george_davis@mentor.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 59/90] scripts/checkstack.pl: Fix arm64 wrong or unknown architecture
Date:   Mon, 24 Jun 2019 17:56:49 +0800
Message-Id: <20190624092317.966389889@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
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
index 34414c6efad6..a2c9e7f98e06 100755
--- a/scripts/checkstack.pl
+++ b/scripts/checkstack.pl
@@ -46,7 +46,7 @@ my (@stack, $re, $dre, $x, $xs, $funcre);
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



