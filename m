Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44649420D26
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbhJDNMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235383AbhJDNKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:10:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A6F661AF9;
        Mon,  4 Oct 2021 13:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352629;
        bh=LAfmcfEVroKyQ/aId21cj4Yfr4CXpvoC9O0rdpbe+90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5+85SMQj2PAwnZXfBB4DXt0hnpq03UJsaGFC1KwEcaLOpzgiu/RUypl/zuyK2QcA
         DcbKhPnp2MvtI5o21+ilEPy9tjdBZXJ0JVc5lu/mKDsCgFGL33YiTKPouGLBSVa06/
         hCucUAMOYQcU4olDLOqG5elyVTOznxhc3IleXPwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Moritz Fischer <mdf@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/95] fpga: machxo2-spi: Fix missing error code in machxo2_write_complete()
Date:   Mon,  4 Oct 2021 14:51:57 +0200
Message-Id: <20211004125034.450954602@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
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
index e3cbd7ff9dc9..fa76239f979b 100644
--- a/drivers/fpga/machxo2-spi.c
+++ b/drivers/fpga/machxo2-spi.c
@@ -334,6 +334,7 @@ static int machxo2_write_complete(struct fpga_manager *mgr,
 			break;
 		if (++refreshloop == MACHXO2_MAX_REFRESH_LOOP) {
 			machxo2_cleanup(mgr);
+			ret = -EINVAL;
 			goto fail;
 		}
 	} while (1);
-- 
2.33.0



