Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D89228B8D5
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390452AbgJLNzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389660AbgJLNpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 360A220678;
        Mon, 12 Oct 2020 13:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510264;
        bh=YCJeFEQUUtkoREajJ56LdPxx2G771ijx7vNc714/OTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/5aYKhsuJoFHeFZMUOzbR/Y48p/O8+pb6Lh5s279NFp5zUr5wcYYLvuyOg3R3rPC
         kAHd3pGxhje4LEmXL7VshdpnKuOi0NpSk3yYBoPw/5+tK45gdmFVW2wZmwbnikcFrC
         s0EJYB+G4dhUogigQFJ5iTNHbPCKPS7PO8mbgFiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.8 017/124] Platform: OLPC: Fix memleak in olpc_ec_probe
Date:   Mon, 12 Oct 2020 15:30:21 +0200
Message-Id: <20201012133147.684221628@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit 4fd9ac6bd3044734a7028bd993944c3617d1eede upstream.

When devm_regulator_register() fails, ec should be
freed just like when olpc_ec_cmd() fails.

Fixes: 231c0c216172a ("Platform: OLPC: Add a regulator for the DCON")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/olpc/olpc-ec.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -439,7 +439,9 @@ static int olpc_ec_probe(struct platform
 								&config);
 	if (IS_ERR(ec->dcon_rdev)) {
 		dev_err(&pdev->dev, "failed to register DCON regulator\n");
-		return PTR_ERR(ec->dcon_rdev);
+		err = PTR_ERR(ec->dcon_rdev);
+		kfree(ec);
+		return err;
 	}
 
 	ec->dbgfs_dir = olpc_ec_setup_debugfs();


