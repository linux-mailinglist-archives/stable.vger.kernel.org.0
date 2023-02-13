Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB08693DC0
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 06:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjBMFK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 00:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBMFK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 00:10:57 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8450AD525;
        Sun, 12 Feb 2023 21:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676265056; x=1707801056;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sfMbRQgYhuaUUurCh5gYtFI6ckde5TQLtj2tdTJFaOM=;
  b=pHGEMn7lhKURtzC3yx/KjgFZ/x09KgQrBS232KOlu6qWNlZEWfrWq5cN
   zYVyFlAtg9ZgxZkheqN1UUoFAeOrqPw1cLURopprotkWhRe+wM9ZMuspJ
   sy003871/2WrkgIfG9Z5/ozFT1ongSQSMo1Ux+XjnLUU/6iNtej/fDOIV
   CrugWTSClSNfZdr33aTleYuEd0Oz18OAj6eyHh/v6RH6bl6jrEUZky+vN
   KRpN8TgJB5QljCbaxrXjzvCYbvxEGo1v+p6eOeUiNZekPEu7BeC8DxJyU
   /sJahZr/a/adsCyawhuaT9bQkPsMVhgQSNBtxwTYycLPMSn/Z3IJmp+aZ
   A==;
X-IronPort-AV: E=Sophos;i="5.97,293,1669046400"; 
   d="scan'208";a="327447297"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Feb 2023 13:10:55 +0800
IronPort-SDR: GHOSHN0cH1NeRlxiIz3imwKk3Ce/SZL5DZ5aSHeHqVslskf0wHvKXdrYMEyjB3Y1QO6gCEKl2K
 ukVUYrLMumaOrIF1k56/XdsPZ537KMyDm4GHhYkBGAGyAa/v7k8AplpJdOz6+6S1/tVuUOTpD+
 r9rv19K9uhXQSuGrm31sqGox8p9njWrhQBBPWMTQ/d4iBc+Zpu4ZumznyxE5L7WC0oB6q0FvDh
 s94havVsOCye7Tk4EhV9ERAlc5O+iGJLwkiGBQpDHuwTxIaoNrhH5GwuOLjJyqF3sKOJ1iuUFi
 z1A=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Feb 2023 20:22:20 -0800
IronPort-SDR: s7+Rr0pjZJWW63cP0Txn+qM2yd/n3CzTVikXkzrLHsgZNGt2arxODfQcNqIAy1PdNz01uJbw8r
 EpF2FRLqkczbLRMt/zRVJBHW6eS/tCZr59+/ZSKPgHo3/G4qvqJT/UDxKIi7R/G5DfAAzLHvQR
 OraF/wQy33RCFrnf1xdte+oPYiOUIMdpQ9v6XJpeBYCaHniEsHMRHcf4V/KayXCNqFTSGT+ntl
 Qdkn2fG15/3yLm3kk+L/cuwVmZk8UZ0el4e6DKLv2U4+8UIAXrHiQy47MabsLFeOon8/miuyDC
 Jrg=
WDCIronportException: Internal
Received: from 5cg217420j.ad.shared (HELO naota-xeon.wdc.com) ([10.225.48.77])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Feb 2023 21:10:55 -0800
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: fix unnecessary increment of read error stat on write error
Date:   Mon, 13 Feb 2023 14:10:38 +0900
Message-Id: <29145a990313cb8759b8131b07f29694cc183ab3.1676265001.git.naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Current btrfs_log_dev_io_error() increases the read error count even if the
erroneous IO is a WRITE request. This is because it forget to use "else
if", and all the error WRITE requests counts as READ error as there is (of
course) no REQ_RAHEAD bit set.

Fixes: c3a62baf21ad ("btrfs: use chained bios when cloning")
CC: stable@vger.kernel.org # 6.1
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index d8b90f95b157..726592868e9c 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -287,7 +287,7 @@ static void btrfs_log_dev_io_error(struct bio *bio, struct btrfs_device *dev)
 
 	if (btrfs_op(bio) == BTRFS_MAP_WRITE)
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
-	if (!(bio->bi_opf & REQ_RAHEAD))
+	else if (!(bio->bi_opf & REQ_RAHEAD))
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_READ_ERRS);
 	if (bio->bi_opf & REQ_PREFLUSH)
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_FLUSH_ERRS);
-- 
2.39.1

