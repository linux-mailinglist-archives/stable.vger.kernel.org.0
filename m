Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F94549034
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244131AbiFMKpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347825AbiFMKoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:44:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EBF205FA;
        Mon, 13 Jun 2022 03:25:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6399760EF1;
        Mon, 13 Jun 2022 10:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F9EC34114;
        Mon, 13 Jun 2022 10:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115910;
        bh=jFTFHDNRCnnfhoTZeJGZyYhUF/ipr1Goaz3b/TGMi/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2Yv4oJtzLqtxhw3hCkcFgjP/f3ttD7bcYJVtkI0r4HoJ46VmWh2zGJid5F7z2kj+
         0Hu721wYQVAvb2hrkjcuAf1H9MMXdSz5NQ0fK9F1w+Ozc/j6efoNhIS70XviOcGb1I
         uyL9HcgFuizq9SKRKKt7x3r1wilLNMGdgvgtD2CM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/218] scsi: fcoe: Fix Wstringop-overflow warnings in fcoe_wwn_from_mac()
Date:   Mon, 13 Jun 2022 12:09:04 +0200
Message-Id: <20220613094923.140639911@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 54db804d5d7d36709d1ce70bde3b9a6c61b290b6 ]

Fix the following Wstringop-overflow warnings when building with GCC-11:

drivers/scsi/fcoe/fcoe.c: In function ‘fcoe_netdev_config’:
drivers/scsi/fcoe/fcoe.c:744:32: warning: ‘fcoe_wwn_from_mac’ accessing 32 bytes in a region of size 6 [-Wstringop-overflow=]
  744 |                         wwnn = fcoe_wwn_from_mac(ctlr->ctl_src_addr, 1, 0);
      |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/fcoe/fcoe.c:744:32: note: referencing argument 1 of type ‘unsigned char *’
In file included from drivers/scsi/fcoe/fcoe.c:36:
./include/scsi/libfcoe.h:252:5: note: in a call to function ‘fcoe_wwn_from_mac’
  252 | u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN], unsigned int, unsigned int);
      |     ^~~~~~~~~~~~~~~~~
drivers/scsi/fcoe/fcoe.c:747:32: warning: ‘fcoe_wwn_from_mac’ accessing 32 bytes in a region of size 6 [-Wstringop-overflow=]
  747 |                         wwpn = fcoe_wwn_from_mac(ctlr->ctl_src_addr,
      |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  748 |                                                  2, 0);
      |                                                  ~~~~~
drivers/scsi/fcoe/fcoe.c:747:32: note: referencing argument 1 of type ‘unsigned char *’
In file included from drivers/scsi/fcoe/fcoe.c:36:
./include/scsi/libfcoe.h:252:5: note: in a call to function ‘fcoe_wwn_from_mac’
  252 | u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN], unsigned int, unsigned int);
      |     ^~~~~~~~~~~~~~~~~
  CC      drivers/scsi/bnx2fc/bnx2fc_io.o
In function ‘bnx2fc_net_config’,
    inlined from ‘bnx2fc_if_create’ at drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1543:7:
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:833:32: warning: ‘fcoe_wwn_from_mac’ accessing 32 bytes in a region of size 6 [-Wstringop-overflow=]
  833 |                         wwnn = fcoe_wwn_from_mac(ctlr->ctl_src_addr,
      |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  834 |                                                  1, 0);
      |                                                  ~~~~~
drivers/scsi/bnx2fc/bnx2fc_fcoe.c: In function ‘bnx2fc_if_create’:
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:833:32: note: referencing argument 1 of type ‘unsigned char *’
In file included from drivers/scsi/bnx2fc/bnx2fc.h:53,
                 from drivers/scsi/bnx2fc/bnx2fc_fcoe.c:17:
./include/scsi/libfcoe.h:252:5: note: in a call to function ‘fcoe_wwn_from_mac’
  252 | u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN], unsigned int, unsigned int);
      |     ^~~~~~~~~~~~~~~~~
In function ‘bnx2fc_net_config’,
    inlined from ‘bnx2fc_if_create’ at drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1543:7:
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:839:32: warning: ‘fcoe_wwn_from_mac’ accessing 32 bytes in a region of size 6 [-Wstringop-overflow=]
  839 |                         wwpn = fcoe_wwn_from_mac(ctlr->ctl_src_addr,
      |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  840 |                                                  2, 0);
      |                                                  ~~~~~
drivers/scsi/bnx2fc/bnx2fc_fcoe.c: In function ‘bnx2fc_if_create’:
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:839:32: note: referencing argument 1 of type ‘unsigned char *’
In file included from drivers/scsi/bnx2fc/bnx2fc.h:53,
                 from drivers/scsi/bnx2fc/bnx2fc_fcoe.c:17:
./include/scsi/libfcoe.h:252:5: note: in a call to function ‘fcoe_wwn_from_mac’
  252 | u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN], unsigned int, unsigned int);
      |     ^~~~~~~~~~~~~~~~~
drivers/scsi/qedf/qedf_main.c: In function ‘__qedf_probe’:
drivers/scsi/qedf/qedf_main.c:3520:30: warning: ‘fcoe_wwn_from_mac’ accessing 32 bytes in a region of size 6 [-Wstringop-overflow=]
 3520 |                 qedf->wwnn = fcoe_wwn_from_mac(qedf->mac, 1, 0);
      |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/qedf/qedf_main.c:3520:30: note: referencing argument 1 of type ‘unsigned char *’
In file included from drivers/scsi/qedf/qedf.h:9,
                 from drivers/scsi/qedf/qedf_main.c:23:
./include/scsi/libfcoe.h:252:5: note: in a call to function ‘fcoe_wwn_from_mac’
  252 | u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN], unsigned int, unsigned int);
      |     ^~~~~~~~~~~~~~~~~
drivers/scsi/qedf/qedf_main.c:3521:30: warning: ‘fcoe_wwn_from_mac’ accessing 32 bytes in a region of size 6 [-Wstringop-overflow=]
 3521 |                 qedf->wwpn = fcoe_wwn_from_mac(qedf->mac, 2, 0);
      |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/qedf/qedf_main.c:3521:30: note: referencing argument 1 of type ‘unsigned char *’
In file included from drivers/scsi/qedf/qedf.h:9,
                 from drivers/scsi/qedf/qedf_main.c:23:
./include/scsi/libfcoe.h:252:5: note: in a call to function ‘fcoe_wwn_from_mac’
  252 | u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN], unsigned int, unsigned int);
      |     ^~~~~~~~~~~~~~~~~

by changing the array size to the correct value of ETH_ALEN in the
argument declaration.

Also, fix a couple of checkpatch warnings:
WARNING: function definition argument 'unsigned int' should also have an identifier name

This helps with the ongoing efforts to globally enable
-Wstringop-overflow.

Link: https://github.com/KSPP/linux/issues/181
Fixes: 85b4aa4926a5 ("[SCSI] fcoe: Fibre Channel over Ethernet")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 2 +-
 include/scsi/libfcoe.h        | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index eaab59afd90c..1c8fa41aa3ab 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1978,7 +1978,7 @@ EXPORT_SYMBOL(fcoe_ctlr_recv_flogi);
  *
  * Returns: u64 fc world wide name
  */
-u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
+u64 fcoe_wwn_from_mac(unsigned char mac[ETH_ALEN],
 		      unsigned int scheme, unsigned int port)
 {
 	u64 wwn;
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 78b9ad2df0b1..6f3571f42529 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -261,7 +261,8 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *, struct fc_lport *,
 			 struct fc_frame *);
 
 /* libfcoe funcs */
-u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN], unsigned int, unsigned int);
+u64 fcoe_wwn_from_mac(unsigned char mac[ETH_ALEN], unsigned int scheme,
+		      unsigned int port);
 int fcoe_libfc_config(struct fc_lport *, struct fcoe_ctlr *,
 		      const struct libfc_function_template *, int init_fcp);
 u32 fcoe_fc_crc(struct fc_frame *fp);
-- 
2.35.1



