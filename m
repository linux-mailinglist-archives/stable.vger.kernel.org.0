Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81133C532D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350612AbhGLHx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343578AbhGLHsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4915616E9;
        Mon, 12 Jul 2021 07:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075766;
        bh=e84PWtKvoCNX6p7L4TdyopFXQ0wsnRv0+CAu2wwhLbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLoECTivsYdg9BRbsfH+39gx1uk4PRUDo/z6bElc0u3TcLgYYzWzvsf2pU9GFVTPY
         a5aX2w2BgDAPTa5WVzeQaBz/0/22w2vXygH4z1M4QSaZtHjiAx6ZkjCdF4G0SbUQ2U
         XraiP/K9u02EnZhfdx1swkUZEEhKpmqfDHLouDoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Borislav Petkov <bp@suse.de>, Andrew Jeffery <andrew@aj.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 355/800] EDAC/aspeed: Use proper format string for printing resource
Date:   Mon, 12 Jul 2021 08:06:18 +0200
Message-Id: <20210712061004.859553627@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2e2f16d5cdb33e5f6fc53b7ad66c9f456d5f2950 ]

On ARMv7, resource_size_t can be 64-bit, which breaks printing
it as %x:

  drivers/edac/aspeed_edac.c: In function 'init_csrows':
  drivers/edac/aspeed_edac.c:257:28: error: format '%x' expects argument of \
    type 'unsigned int', but argument 4 has type 'resource_size_t' {aka 'long \
    long unsigned int'} [-Werror=format=]
  257 |         dev_dbg(mci->pdev, "dt: /memory node resources: first page \
    r.start=0x%x, resource_size=0x%x, PAGE_SHIFT macro=0x%x\n",

Use the special %pR format string to pretty-print the entire resource
instead.

Fixes: edfc2d73ca45 ("EDAC/aspeed: Add support for AST2400 and AST2600")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lkml.kernel.org/r/20210421135500.3518661-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/aspeed_edac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/aspeed_edac.c b/drivers/edac/aspeed_edac.c
index a46da56d6d54..6bd5f8815919 100644
--- a/drivers/edac/aspeed_edac.c
+++ b/drivers/edac/aspeed_edac.c
@@ -254,8 +254,8 @@ static int init_csrows(struct mem_ctl_info *mci)
 		return rc;
 	}
 
-	dev_dbg(mci->pdev, "dt: /memory node resources: first page r.start=0x%x, resource_size=0x%x, PAGE_SHIFT macro=0x%x\n",
-		r.start, resource_size(&r), PAGE_SHIFT);
+	dev_dbg(mci->pdev, "dt: /memory node resources: first page %pR, PAGE_SHIFT macro=0x%x\n",
+		&r, PAGE_SHIFT);
 
 	csrow->first_page = r.start >> PAGE_SHIFT;
 	nr_pages = resource_size(&r) >> PAGE_SHIFT;
-- 
2.30.2



