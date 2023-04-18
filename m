Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC696E6366
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjDRMkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbjDRMkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A40F13C05
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1565E632E8
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28424C433EF;
        Tue, 18 Apr 2023 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821616;
        bh=GrbFPr1uIDerg+g5dzeCl7cYj+L0Zd2Sk5UU7sEuDGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UECbu9wD0d74j/pFOVMRtlyzLg80fej+paFNHzNxMD9L1rPMXhZ6dwiuyLd4GFEW5
         X/iBjwy/54nX3Pbilc/He9fmFOa5D760609+jq/UIPrIEKN5ActfrmRuj6BiZQcQGi
         v2vcEsouuc4MW1dSUVPmP9FoG9nfr4dtUCDHgAac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Nicolas Schichan <nschichan@freebox.fr>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 67/91] ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size
Date:   Tue, 18 Apr 2023 14:22:11 +0200
Message-Id: <20230418120307.899201795@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 1e020e1b96afdecd20680b5b5be2a6ffc3d27628 upstream.

Following process will make ubi attaching failed since commit
1b42b1a36fc946 ("ubi: ensure that VID header offset ... size"):

ID="0xec,0xa1,0x00,0x15" # 128M 128KB 2KB
modprobe nandsim id_bytes=$ID
flash_eraseall /dev/mtd0
modprobe ubi mtd="0,2048"  # set vid_hdr offset as 2048 (one page)
(dmesg):
  ubi0 error: ubi_attach_mtd_dev [ubi]: VID header offset 2048 too large.
  UBI error: cannot attach mtd0
  UBI error: cannot initialize UBI, error -22

Rework original solution, the key point is making sure
'vid_hdr_shift + UBI_VID_HDR_SIZE < ubi->vid_hdr_alsize',
so we should check vid_hdr_shift rather not vid_hdr_offset.
Then, ubi still support (sub)page aligined VID header offset.

Fixes: 1b42b1a36fc946 ("ubi: ensure that VID header offset ... size")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Tested-by: Nicolas Schichan <nschichan@freebox.fr>
Tested-by: Miquel Raynal <miquel.raynal@bootlin.com> # v5.10, v4.19
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/ubi/build.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -664,12 +664,6 @@ static int io_init(struct ubi_device *ub
 	ubi->ec_hdr_alsize = ALIGN(UBI_EC_HDR_SIZE, ubi->hdrs_min_io_size);
 	ubi->vid_hdr_alsize = ALIGN(UBI_VID_HDR_SIZE, ubi->hdrs_min_io_size);
 
-	if (ubi->vid_hdr_offset && ((ubi->vid_hdr_offset + UBI_VID_HDR_SIZE) >
-	    ubi->vid_hdr_alsize)) {
-		ubi_err(ubi, "VID header offset %d too large.", ubi->vid_hdr_offset);
-		return -EINVAL;
-	}
-
 	dbg_gen("min_io_size      %d", ubi->min_io_size);
 	dbg_gen("max_write_size   %d", ubi->max_write_size);
 	dbg_gen("hdrs_min_io_size %d", ubi->hdrs_min_io_size);
@@ -687,6 +681,21 @@ static int io_init(struct ubi_device *ub
 						ubi->vid_hdr_aloffset;
 	}
 
+	/*
+	 * Memory allocation for VID header is ubi->vid_hdr_alsize
+	 * which is described in comments in io.c.
+	 * Make sure VID header shift + UBI_VID_HDR_SIZE not exceeds
+	 * ubi->vid_hdr_alsize, so that all vid header operations
+	 * won't access memory out of bounds.
+	 */
+	if ((ubi->vid_hdr_shift + UBI_VID_HDR_SIZE) > ubi->vid_hdr_alsize) {
+		ubi_err(ubi, "Invalid VID header offset %d, VID header shift(%d)"
+			" + VID header size(%zu) > VID header aligned size(%d).",
+			ubi->vid_hdr_offset, ubi->vid_hdr_shift,
+			UBI_VID_HDR_SIZE, ubi->vid_hdr_alsize);
+		return -EINVAL;
+	}
+
 	/* Similar for the data offset */
 	ubi->leb_start = ubi->vid_hdr_offset + UBI_VID_HDR_SIZE;
 	ubi->leb_start = ALIGN(ubi->leb_start, ubi->min_io_size);


