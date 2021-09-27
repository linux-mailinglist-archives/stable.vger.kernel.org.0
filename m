Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDE5419AFE
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236515AbhI0ROv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237063AbhI0RNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:13:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 955416135D;
        Mon, 27 Sep 2021 17:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762572;
        bh=gSz0yTjE+ewpU95IFOTpLpew02WoggiBF2lOB4DLaGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWGJ3Ae3zO5F88TusrTB/S+awO3V7O2lABPn28EdugZWGzoXqJddrRRN4d0oCE23p
         pQy1lckPzzmkg/kFGYiNtHYZ1m/q6d54LDFYDM9GhCR+8Wsk0vx6/Bg/+2NOa7vDZd
         ADet1eH8UpUbMIaL53rD5ulxwa0sFrxxP+F7LuoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/103] fpga: machxo2-spi: Return an error on failure
Date:   Mon, 27 Sep 2021 19:02:29 +0200
Message-Id: <20210927170227.733780085@linuxfoundation.org>
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

From: Tom Rix <trix@redhat.com>

[ Upstream commit 34331739e19fd6a293d488add28832ad49c9fc54 ]

Earlier successes leave 'ret' in a non error state, so these errors are
not reported. Set ret to -EINVAL before going to the error handler.

This addresses two issues reported by smatch:
drivers/fpga/machxo2-spi.c:229 machxo2_write_init()
  warn: missing error code 'ret'

drivers/fpga/machxo2-spi.c:316 machxo2_write_complete()
  warn: missing error code 'ret'

[mdf@kernel.org: Reworded commit message]
Fixes: 88fb3a002330 ("fpga: lattice machxo2: Add Lattice MachXO2 support")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/machxo2-spi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/fpga/machxo2-spi.c b/drivers/fpga/machxo2-spi.c
index b316369156fe..7688ff3b31e4 100644
--- a/drivers/fpga/machxo2-spi.c
+++ b/drivers/fpga/machxo2-spi.c
@@ -225,8 +225,10 @@ static int machxo2_write_init(struct fpga_manager *mgr,
 		goto fail;
 
 	get_status(spi, &status);
-	if (test_bit(FAIL, &status))
+	if (test_bit(FAIL, &status)) {
+		ret = -EINVAL;
 		goto fail;
+	}
 	dump_status_reg(&status);
 
 	spi_message_init(&msg);
@@ -313,6 +315,7 @@ static int machxo2_write_complete(struct fpga_manager *mgr,
 	dump_status_reg(&status);
 	if (!test_bit(DONE, &status)) {
 		machxo2_cleanup(mgr);
+		ret = -EINVAL;
 		goto fail;
 	}
 
-- 
2.33.0



