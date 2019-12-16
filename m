Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE7261216EE
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbfLPSJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:09:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730126AbfLPSJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:09:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A99DF206B7;
        Mon, 16 Dec 2019 18:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519784;
        bh=vT09+Y2atmoIbCV7QqkXaUqPrSgl4UOEZ/3qeExbu4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJNmDjFZ+glGnqhimh7fkMBT4WjLtQqdgDrmyHAN6EQFYE6GLHji8cavuaGVtTZjv
         5smYLqsiG78Sur6OcAErVWmc+jsD4hrJBiTy/i/hbluYB+ETgdx/wt6Vp2oQtrp3qp
         GO5Oem3YJ9yGyLhOEMh7OoLZMWW1aLqGYaK2FAvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.3 066/180] lib: raid6: fix awk build warnings
Date:   Mon, 16 Dec 2019 18:48:26 +0100
Message-Id: <20191216174829.872645949@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 702600eef73033ddd4eafcefcbb6560f3e3a90f7 upstream.

Newer versions of awk spit out these fun warnings:
	awk: ../lib/raid6/unroll.awk:16: warning: regexp escape sequence `\#' is not a known regexp operator

As commit 700c1018b86d ("x86/insn: Fix awk regexp warnings") showed, it
turns out that there are a number of awk strings that do not need to be
escaped and newer versions of awk now warn about this.

Fix the string up so that no warning is produced.  The exact same kernel
module gets created before and after this patch, showing that it wasn't
needed.

Link: https://lore.kernel.org/r/20191206152600.GA75093@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/raid6/unroll.awk |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/raid6/unroll.awk
+++ b/lib/raid6/unroll.awk
@@ -13,7 +13,7 @@ BEGIN {
 	for (i = 0; i < rep; ++i) {
 		tmp = $0
 		gsub(/\$\$/, i, tmp)
-		gsub(/\$\#/, n, tmp)
+		gsub(/\$#/, n, tmp)
 		gsub(/\$\*/, "$", tmp)
 		print tmp
 	}


