Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1349E548E9D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349336AbiFMMtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356753AbiFMMs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:48:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E2762A03;
        Mon, 13 Jun 2022 04:11:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A94B060B6E;
        Mon, 13 Jun 2022 11:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1CCC34114;
        Mon, 13 Jun 2022 11:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118703;
        bh=GD58cBIdSxPfPincYJeN8P9cK/RPIAzic1vPkX1SmqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZtDdzeoAdcku+Q3rU/fzQmeXL6sdE4UV9hxKT8gkNN5iDaVf6JJnAaScitky6F+h8
         nQ572F+9YPjQsj3LsD8EvHfn2dClkk6hrx4Rpwaz96x6+DtKsamNWr1Tjnw9fiQXd/
         yrwFM/whqiyLphsoCKaS2YERaPsRIh7wO9fYCHIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 5.10 172/172] zonefs: fix handling of explicit_open option on mount
Date:   Mon, 13 Jun 2022 12:12:12 +0200
Message-Id: <20220613094923.492554004@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit a2a513be7139b279f1b5b2cee59c6c4950c34346 upstream.

Ignoring the explicit_open mount option on mount for devices that do not
have a limit on the number of open zones must be done after the mount
options are parsed and set in s_mount_opts. Move the check to ignore
the explicit_open option after the call to zonefs_parse_options() in
zonefs_fill_super().

Fixes: b5c00e975779 ("zonefs: open/close zone on file open/close")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/super.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1706,11 +1706,6 @@ static int zonefs_fill_super(struct supe
 	sbi->s_mount_opts = ZONEFS_MNTOPT_ERRORS_RO;
 	sbi->s_max_open_zones = bdev_max_open_zones(sb->s_bdev);
 	atomic_set(&sbi->s_open_zones, 0);
-	if (!sbi->s_max_open_zones &&
-	    sbi->s_mount_opts & ZONEFS_MNTOPT_EXPLICIT_OPEN) {
-		zonefs_info(sb, "No open zones limit. Ignoring explicit_open mount option\n");
-		sbi->s_mount_opts &= ~ZONEFS_MNTOPT_EXPLICIT_OPEN;
-	}
 
 	ret = zonefs_read_super(sb);
 	if (ret)
@@ -1729,6 +1724,12 @@ static int zonefs_fill_super(struct supe
 	zonefs_info(sb, "Mounting %u zones",
 		    blkdev_nr_zones(sb->s_bdev->bd_disk));
 
+	if (!sbi->s_max_open_zones &&
+	    sbi->s_mount_opts & ZONEFS_MNTOPT_EXPLICIT_OPEN) {
+		zonefs_info(sb, "No open zones limit. Ignoring explicit_open mount option\n");
+		sbi->s_mount_opts &= ~ZONEFS_MNTOPT_EXPLICIT_OPEN;
+	}
+
 	/* Create root directory inode */
 	ret = -ENOMEM;
 	inode = new_inode(sb);


