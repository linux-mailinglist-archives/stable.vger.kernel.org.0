Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580442E3A9F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391395AbgL1Njb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:39:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391407AbgL1Nja (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:39:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 211EB205CB;
        Mon, 28 Dec 2020 13:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162754;
        bh=OqhHtuOdgaauMQMONCSX+P4cGrOeVwc6S4p25cYuAAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FudFa4GLSwtXQNN9yFQW73sSAuErJ9G4ARtnlAYXEz0uFqvkRooAcE7FxN5CzvzCR
         x8+2X2TSoHBbEkw8M0h9dF77sGGnyQaavrim/YuHQQB6wJu5MilHfh1ADHJuM5LJJ3
         OkLzIIal2I3fw5aeBr9eZFSfakaBxm//nNaOA22w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.4 051/453] usb: mtu3: fix memory corruption in mtu3_debugfs_regset()
Date:   Mon, 28 Dec 2020 13:44:47 +0100
Message-Id: <20201228124939.712874728@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3f6f6343a29d9ea7429306b83b18e66dc1331d5c upstream.

This code is using the wrong sizeof() so it does not allocate enough
memory.  It allocates 32 bytes but 72 are required.  That will lead to
memory corruption.

Fixes: ae07809255d3 ("usb: mtu3: add debugfs interface files")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/X8ikqc4Mo2/0G72j@mwanda
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/mtu3/mtu3_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/mtu3/mtu3_debugfs.c
+++ b/drivers/usb/mtu3/mtu3_debugfs.c
@@ -127,7 +127,7 @@ static void mtu3_debugfs_regset(struct m
 	struct debugfs_regset32 *regset;
 	struct mtu3_regset *mregs;
 
-	mregs = devm_kzalloc(mtu->dev, sizeof(*regset), GFP_KERNEL);
+	mregs = devm_kzalloc(mtu->dev, sizeof(*mregs), GFP_KERNEL);
 	if (!mregs)
 		return;
 


