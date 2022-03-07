Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121CD4CF791
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbiCGJqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237557AbiCGJmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:42:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69610B17;
        Mon,  7 Mar 2022 01:41:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED9AD6133D;
        Mon,  7 Mar 2022 09:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E379AC340F5;
        Mon,  7 Mar 2022 09:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646074;
        bh=03pwDSBP+lXwFiG1Ofa2EZe72cX38XTIjIzWaZXLmhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVomNK3YUPpUJsHq0XJEys+aS+1j0cmwgtZbtxcaS91iAk3jvNrTz69r7t7OdRR0f
         H6iHEvAWbipsmCgLtuBiY1FE7a1nJ3JsaDFQBTfD+Y8iCavo+hbxfbVJMMl98uNYiv
         gDYCHuEOLSipv6qeJDmVcOkZeV4uGmkvi6Qw2sv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/262] i3c: master: dw: check return of dw_i3c_master_get_free_pos()
Date:   Mon,  7 Mar 2022 10:17:12 +0100
Message-Id: <20220307091704.964098126@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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



