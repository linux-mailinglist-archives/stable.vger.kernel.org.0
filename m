Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED7B55874A
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbiFWSX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237608AbiFWSXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:23:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FA4C2C41;
        Thu, 23 Jun 2022 10:25:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48D3061DC6;
        Thu, 23 Jun 2022 17:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8AEC3411B;
        Thu, 23 Jun 2022 17:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656005132;
        bh=jBL5LPWzIe5LTcpmUu/vq8dj06VeJFEUWnOKZtuluVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGB3Qvrj7MLD4qVt6r7yfJ8Vit1uUOiv9hb5TFTrMop9bdnJWbg41f2VDtl9z/z6W
         8YsyxONI0wBJiT/nV89dGF/7IjTAmPhbawkmAfDcy1CMifHiqXc8JhBGg4FYe/C61r
         cse/q33sPiM4nfbul/YvA+y9MjsVDX5gv5hkmLR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.18 04/11] eth: sun: cassini: remove dead code
Date:   Thu, 23 Jun 2022 18:45:16 +0200
Message-Id: <20220623164322.444430614@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164322.315085512@linuxfoundation.org>
References: <20220623164322.315085512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Liška <mliska@suse.cz>

commit 32329216ca1d6ee29c41215f18b3053bb6158541 upstream.

Fixes the following GCC warning:

drivers/net/ethernet/sun/cassini.c:1316:29: error: comparison between two arrays [-Werror=array-compare]
drivers/net/ethernet/sun/cassini.c:3783:34: error: comparison between two arrays [-Werror=array-compare]

Note that 2 arrays should be compared by comparing of their addresses:
note: use ‘&cas_prog_workaroundtab[0] == &cas_prog_null[0]’ to compare the addresses

Signed-off-by: Martin Liska <mliska@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sun/cassini.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -1313,7 +1313,7 @@ static void cas_init_rx_dma(struct cas *
 	writel(val, cp->regs + REG_RX_PAGE_SIZE);
 
 	/* enable the header parser if desired */
-	if (CAS_HP_FIRMWARE == cas_prog_null)
+	if (&CAS_HP_FIRMWARE[0] == &cas_prog_null[0])
 		return;
 
 	val = CAS_BASE(HP_CFG_NUM_CPU, CAS_NCPUS > 63 ? 0 : CAS_NCPUS);
@@ -3780,7 +3780,7 @@ static void cas_reset(struct cas *cp, in
 
 	/* program header parser */
 	if ((cp->cas_flags & CAS_FLAG_TARGET_ABORT) ||
-	    (CAS_HP_ALT_FIRMWARE == cas_prog_null)) {
+	    (&CAS_HP_ALT_FIRMWARE[0] == &cas_prog_null[0])) {
 		cas_load_firmware(cp, CAS_HP_FIRMWARE);
 	} else {
 		cas_load_firmware(cp, CAS_HP_ALT_FIRMWARE);


