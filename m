Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A78049A4EC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387656AbiAYAFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842314AbiAXX2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3C9C0A8879;
        Mon, 24 Jan 2022 13:34:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CAE5B811FB;
        Mon, 24 Jan 2022 21:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F056C340E4;
        Mon, 24 Jan 2022 21:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060062;
        bh=03pwDSBP+lXwFiG1Ofa2EZe72cX38XTIjIzWaZXLmhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLPouGICItox9sqtJ5AZ4RjANKPWQKmVSYbcPgy5Pg7NRSUT9ghWBFlpcmFryrqZo
         cLTBbEk3myb8x7PUSFguVvTXTI3ka+p10+5We5oeypqYMQE9lDlej5okGUdrcfELm+
         i2uwBqj/2O2oByBGHbC7gX85e9ZreTrc6+u32xAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0825/1039] i3c: master: dw: check return of dw_i3c_master_get_free_pos()
Date:   Mon, 24 Jan 2022 19:43:34 +0100
Message-Id: <20220124184153.023358481@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 13462ba1815db5a96891293a9cfaa2451f7bd623 ]

Clang static analysis reports this problem
dw-i3c-master.c:799:9: warning: The result of the left shift is
  undefined because the left operand is negative
                      COMMAND_PORT_DEV_INDEX(pos) |
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~

pos can be negative because dw_i3c_master_get_free_pos() can return an
error.  So check for an error.

Fixes: 1dd728f5d4d4 ("i3c: master: Add driver for Synopsys DesignWare IP")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220108150948.3988790-1-trix@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 03a368da51b95..51a8608203de7 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -793,6 +793,10 @@ static int dw_i3c_master_daa(struct i3c_master_controller *m)
 		return -ENOMEM;
 
 	pos = dw_i3c_master_get_free_pos(master);
+	if (pos < 0) {
+		dw_i3c_master_free_xfer(xfer);
+		return pos;
+	}
 	cmd = &xfer->cmds[0];
 	cmd->cmd_hi = 0x1;
 	cmd->cmd_lo = COMMAND_PORT_DEV_COUNT(master->maxdevs - pos) |
-- 
2.34.1



