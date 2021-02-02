Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B5630C035
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhBBNvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:51:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232935AbhBBNt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:49:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA1BE64FA9;
        Tue,  2 Feb 2021 13:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273370;
        bh=y8JFE/VqcFyPjMVmP3r4ItbHDZdqffmmVNcvOGAVUtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=np55G4kGtCVJCKZzSSMRHo4JqxG3HRVtPoID7LdtRxsaCnwNr8ohQ7a6mMfKkCVfJ
         OLDSUKhhMYD/qijTmGqdztrSfWFELI57nRo9YC0ERyIEkfDccrilrKtZOWJgwg9rl9
         JtGnqAwX+u491Y8ttYX2JbmpnVYaj0gCjpY5uCoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Qi Zheng <arch0.zheng@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.10 074/142] ARM: zImage: atags_to_fdt: Fix node names on added root nodes
Date:   Tue,  2 Feb 2021 14:37:17 +0100
Message-Id: <20210202133000.769884813@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

commit 30596ae0547dbda469d31a2678d9072fb0a3fa27 upstream.

Commit 7536c7e03e74 ("of/fdt: Remove redundant kbasename function
call") exposed a bug creating DT nodes in the ATAGS to DT fixup code.
Non-existent nodes would mistaken get created with a leading '/'. The
problem was fdt_path_offset() takes a full path while creating a node
with fdt_add_subnode() takes just the basename.

Since this we only add root child nodes, we can just skip over the '/'.

Fixes: 7536c7e03e74 ("of/fdt: Remove redundant kbasename function call")
Reported-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: Qi Zheng <arch0.zheng@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Rob Herring <robh@kernel.org>
Tested-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20210126023905.1631161-1-robh@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/compressed/atags_to_fdt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/boot/compressed/atags_to_fdt.c
+++ b/arch/arm/boot/compressed/atags_to_fdt.c
@@ -15,7 +15,8 @@ static int node_offset(void *fdt, const
 {
 	int offset = fdt_path_offset(fdt, node_path);
 	if (offset == -FDT_ERR_NOTFOUND)
-		offset = fdt_add_subnode(fdt, 0, node_path);
+		/* Add the node to root if not found, dropping the leading '/' */
+		offset = fdt_add_subnode(fdt, 0, node_path + 1);
 	return offset;
 }
 


