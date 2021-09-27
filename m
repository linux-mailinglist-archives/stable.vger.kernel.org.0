Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FFB419B1D
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236770AbhI0RP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237247AbhI0ROV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:14:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B82561368;
        Mon, 27 Sep 2021 17:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762601;
        bh=ZrRD7oMHPRs5Sk0v2ji7HnUTsw7NxsFNLUm5POw8/uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qaD2UE9km2yMX3t9WAjxKI8S7+rqP0HMQuOL3Usj6kkyVhTqmRCzsI2+OMgXNPbFy
         jlQIsyskpwCTTXqg81ECCEfoYw8TKGNx39lapWDe1nkASihtrBxEL2WmB7a/IA2ag1
         XhhrFbORCnb3nj+Ln5yrJfdYHV5p+91m7UiXqUbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Moritz Fischer <mdf@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/103] fpga: machxo2-spi: Fix missing error code in machxo2_write_complete()
Date:   Mon, 27 Sep 2021 19:02:30 +0200
Message-Id: <20210927170227.774396374@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
index 7688ff3b31e4..9eef18349eee 100644
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



