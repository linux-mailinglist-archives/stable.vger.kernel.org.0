Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA97603D4A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiJSJAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiJSI7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3601C915E8;
        Wed, 19 Oct 2022 01:54:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C555561812;
        Wed, 19 Oct 2022 08:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB02DC433B5;
        Wed, 19 Oct 2022 08:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169014;
        bh=tI+zdfLWq2WDPFJtTUntPD5m6A/o/lCJZwMbVoHVPPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZry+AhEsa/edDmHgT5wKfTTr+XNoZsoYADt9sG8o7mj7Re2Y8VGsKj8O/otqKLL1
         32iCKA4sfwyUmMgYm6Lih6IxFiPGPjJwoE3Td79wLVnsFkytSmvt8qWuRMgu4TV49H
         3sqNHvqXapiy9/1e6kEzHX4dZsnMPX36DSN/49hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eunhee Rho <eunhee83.rho@samsung.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.0 129/862] f2fs: allow direct read for zoned device
Date:   Wed, 19 Oct 2022 10:23:36 +0200
Message-Id: <20221019083255.670387512@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 689fe57e7ecefd2eeba76c32aa569bb3e1e790d9 upstream.

This reverts dbf8e63f48af ("f2fs: remove device type check for direct IO"),
and apply the below first version, since it contributed out-of-order DIO writes.

For zoned devices, f2fs forbids direct IO and forces buffered IO
to serialize write IOs. However, the constraint does not apply to
read IOs.

Cc: stable@vger.kernel.org
Fixes: dbf8e63f48af ("f2fs: remove device type check for direct IO")
Signed-off-by: Eunhee Rho <eunhee83.rho@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4513,7 +4513,12 @@ static inline bool f2fs_force_buffered_i
 	/* disallow direct IO if any of devices has unaligned blksize */
 	if (f2fs_is_multi_device(sbi) && !sbi->aligned_blksize)
 		return true;
-
+	/*
+	 * for blkzoned device, fallback direct IO to buffered IO, so
+	 * all IOs can be serialized by log-structured write.
+	 */
+	if (f2fs_sb_has_blkzoned(sbi) && (rw == WRITE))
+		return true;
 	if (f2fs_lfs_mode(sbi) && (rw == WRITE)) {
 		if (block_unaligned_IO(inode, iocb, iter))
 			return true;


