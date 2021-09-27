Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B039E419A70
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbhI0RJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236298AbhI0RH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:07:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF91E6113A;
        Mon, 27 Sep 2021 17:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762378;
        bh=f1vbufzgGMsKh72gZdItGN8QCkYypjboHPTeYAxtnmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4X+P7ooCzpYYAcrXwll0LHfTlCYW23VYl4jSNSOjTiLjul9qXQARfqV+dOTeYjFy
         IOWmvETuAN9EK8YdJBrHcSk9/IeCGrO5MzJecW0H5z3lmEbKOUdGhFPJBe/GmnRt+Y
         QV6g26RvPpc5fQ1udyXDJdLQ1fR9Qu7MlTClTowo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/68] fpga: machxo2-spi: Return an error on failure
Date:   Mon, 27 Sep 2021 19:02:32 +0200
Message-Id: <20210927170221.225201041@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
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
index 4d8a87641587..2fd097c3994b 100644
--- a/drivers/fpga/machxo2-spi.c
+++ b/drivers/fpga/machxo2-spi.c
@@ -223,8 +223,10 @@ static int machxo2_write_init(struct fpga_manager *mgr,
 		goto fail;
 
 	get_status(spi, &status);
-	if (test_bit(FAIL, &status))
+	if (test_bit(FAIL, &status)) {
+		ret = -EINVAL;
 		goto fail;
+	}
 	dump_status_reg(&status);
 
 	spi_message_init(&msg);
@@ -310,6 +312,7 @@ static int machxo2_write_complete(struct fpga_manager *mgr,
 	dump_status_reg(&status);
 	if (!test_bit(DONE, &status)) {
 		machxo2_cleanup(mgr);
+		ret = -EINVAL;
 		goto fail;
 	}
 
-- 
2.33.0



