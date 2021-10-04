Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B11D420D23
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbhJDNMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235303AbhJDNKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:10:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6D4B61B60;
        Mon,  4 Oct 2021 13:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352626;
        bh=XZAz01FjaUwXQY2PbwZnx+052zXgSR09x1NumYH45vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W12OrZ8x457RtsZJx5YXsWh9svKewJ5+4qCpL516LiUdzKaxmM0hKTqhYYIDxzQb4
         3lR1UFXbRgppWfAvXvRlr2c0v2418ZW0+9SXORia8JFXMPNXirPdkgcIevMvYVoNUq
         nJF1dzEkqjp0HsbjDmNz6Sd+Pvo09oVdo+/D5Jms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/95] fpga: machxo2-spi: Return an error on failure
Date:   Mon,  4 Oct 2021 14:51:56 +0200
Message-Id: <20211004125034.407990015@linuxfoundation.org>
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
index a582e0000c97..e3cbd7ff9dc9 100644
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



