Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACE82E1E0B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgLWPeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728691AbgLWPeU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC4AB233F8;
        Wed, 23 Dec 2020 15:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737616;
        bh=OqhHtuOdgaauMQMONCSX+P4cGrOeVwc6S4p25cYuAAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hz6RY7Ue//j4F2FLScpiSuLgzGZPQMhh8624gxX5eMKqEyz4mhMUmlhJPBPOoEVc
         ZV4UHOpCkw5OdSgjgjGk+eJ8TkwSw6sxYTSSh9+ez296r9CKluUcyHR74SKQlc5WcK
         BB3ox/pWz3mUSjtVqZPGsozqirJvgTi4DogKSVdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.10 05/40] usb: mtu3: fix memory corruption in mtu3_debugfs_regset()
Date:   Wed, 23 Dec 2020 16:33:06 +0100
Message-Id: <20201223150515.830504325@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
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
 


