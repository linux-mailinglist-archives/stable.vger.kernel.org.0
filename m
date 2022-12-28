Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D366E657F50
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbiL1QDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbiL1QD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:03:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3E1192BF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:03:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8C3BB81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EC5C433D2;
        Wed, 28 Dec 2022 16:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243402;
        bh=y0lHDZrcIgidh16KnuWyzmlxz+0g7bavRTkyGNLA/j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFQuZmNrp6juuVG/n9JPlxotimgVHDH6Lu1FxPlWimo5kaqDwgsOpCTskSkAwiiY+
         isjuZHXrc/MRP2Cn2ep0KGBk/UsXAT0ei2NqyohqKhgM++FktPeqz7hUrszuXagWAV
         MYnlV5is8Fe0iVDKWigDB1BBBJlaHlY7nwRafb3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Layton <jlayton@kernel.org>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0489/1146] NFS: Allow very small rsize & wsize again
Date:   Wed, 28 Dec 2022 15:33:48 +0100
Message-Id: <20221228144343.466675061@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit a60214c2465493aac0b014d87ee19327b6204c42 ]

940261a19508 introduced nfs_io_size() to clamp the iosize to a multiple
of PAGE_SIZE. This had the unintended side effect of no longer allowing
iosizes less than a page, which could be useful in some situations.

UDP already has an exception that causes it to fall back on the
power-of-two style sizes instead. This patch adds an additional
exception for very small iosizes.

Reported-by: Jeff Layton <jlayton@kernel.org>
Fixes: 940261a19508 ("NFS: Allow setting rsize / wsize to a multiple of PAGE_SIZE")
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/internal.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 647fc3f547cb..ae7d4a8c728c 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -739,12 +739,10 @@ unsigned long nfs_io_size(unsigned long iosize, enum xprt_transports proto)
 		iosize = NFS_DEF_FILE_IO_SIZE;
 	else if (iosize >= NFS_MAX_FILE_IO_SIZE)
 		iosize = NFS_MAX_FILE_IO_SIZE;
-	else
-		iosize = iosize & PAGE_MASK;
 
-	if (proto == XPRT_TRANSPORT_UDP)
+	if (proto == XPRT_TRANSPORT_UDP || iosize < PAGE_SIZE)
 		return nfs_block_bits(iosize, NULL);
-	return iosize;
+	return iosize & PAGE_MASK;
 }
 
 /*
-- 
2.35.1



