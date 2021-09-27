Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02798419C69
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbhI0R3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237939AbhI0R0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:26:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C254461381;
        Mon, 27 Sep 2021 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762993;
        bh=6arZk5bDlsZ3qKgGv9/B4dfMRJkJRRp+HuLTnWuC5rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgq/55Wl+ap3J2A6divMsBSAbtZo1avxaacweJtLra7M4sUtUwfce9yI1lNX0xD53
         z99fmTNDC9sxGLWm5D5ckHke1bRdlJff7Q54GnVXgA78dm8ZCBOA9EJaahVQas6fPD
         QIWpxbry1YNIxSq/gInhZXU3yX0vMHLsE6S4u3AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Moritz Fischer <mdf@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 096/162] fpga: machxo2-spi: Fix missing error code in machxo2_write_complete()
Date:   Mon, 27 Sep 2021 19:02:22 +0200
Message-Id: <20210927170236.765181439@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit a1e4470823d99e75b596748086e120dea169ed3c ]

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'ret'.

Eliminate the follow smatch warning:

drivers/fpga/machxo2-spi.c:341 machxo2_write_complete()
  warn: missing error code 'ret'.

[mdf@kernel.org: Reworded commit message]
Fixes: 88fb3a002330 ("fpga: lattice machxo2: Add Lattice MachXO2 support")
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/machxo2-spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/fpga/machxo2-spi.c b/drivers/fpga/machxo2-spi.c
index b4a530a31302..ea2ec3c6815c 100644
--- a/drivers/fpga/machxo2-spi.c
+++ b/drivers/fpga/machxo2-spi.c
@@ -338,6 +338,7 @@ static int machxo2_write_complete(struct fpga_manager *mgr,
 			break;
 		if (++refreshloop == MACHXO2_MAX_REFRESH_LOOP) {
 			machxo2_cleanup(mgr);
+			ret = -EINVAL;
 			goto fail;
 		}
 	} while (1);
-- 
2.33.0



