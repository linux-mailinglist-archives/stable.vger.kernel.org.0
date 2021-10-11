Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64479429175
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240691AbhJKOS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243626AbhJKONQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:13:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A29E561278;
        Mon, 11 Oct 2021 14:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961048;
        bh=RY+0TqbUFWpr/jiEAPvuKo7HtWP6ZZMQ/NTVq3rkQ+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfwDuJW2/7cYC/6dAJJJ7sAeF+bxXThTKKghRusSHFnbg7JaDwMu/NdCS2YQldYv+
         I5PVfHIHp4Ua/3+zfzXJi3gFf8y9qi7EWCDG50UJpGH3GUmR0TCNDmJpnhBg8ijMch
         R8L4ROCsqtO9MuShGe6h/InufCIBzi3qgUv7VnH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.14 144/151] x86/platform/olpc: Correct ifdef symbol to intended CONFIG_OLPC_XO15_SCI
Date:   Mon, 11 Oct 2021 15:46:56 +0200
Message-Id: <20211011134522.466502690@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

commit 4758fd801f919b8b9acad78d2e49a195ec2be46b upstream.

The refactoring in the commit in Fixes introduced an ifdef
CONFIG_OLPC_XO1_5_SCI, however the config symbol is actually called
"CONFIG_OLPC_XO15_SCI".

Fortunately, ./scripts/checkkconfigsymbols.py warns:

OLPC_XO1_5_SCI
Referencing files: arch/x86/platform/olpc/olpc.c

Correct this ifdef condition to the intended config symbol.

Fixes: ec9964b48033 ("Platform: OLPC: Move EC-specific functionality out from x86")
Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20210803113531.30720-3-lukas.bulwahn@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/platform/olpc/olpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -274,7 +274,7 @@ static struct olpc_ec_driver ec_xo1_driv
 
 static struct olpc_ec_driver ec_xo1_5_driver = {
 	.ec_cmd = olpc_xo1_ec_cmd,
-#ifdef CONFIG_OLPC_XO1_5_SCI
+#ifdef CONFIG_OLPC_XO15_SCI
 	/*
 	 * XO-1.5 EC wakeups are available when olpc-xo15-sci driver is
 	 * compiled in


