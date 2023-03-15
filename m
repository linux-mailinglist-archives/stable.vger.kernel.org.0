Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A526BB206
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbjCOMcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbjCOMbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBA3CC28
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:31:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDFA6B81E03
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4208EC433EF;
        Wed, 15 Mar 2023 12:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883470;
        bh=S+HWvcBHvuViWIPRtZcMvd5xYpaf8PssR3zgXbNJBOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+6nIaU/WSmKRmvgFv941zJoigg9I5UYj6KudYfG0niDygB5OR2bvZdQDU2HGWoGW
         N0YIiYRsS5WnKFlBOzHz7ZaQzpPPaoY29ZxI/JWdTPVFpraFNrXu1HAqWCKL9/vN9N
         1R6ka8CEfcJZAYlzUJeVdgWOUsapyIcEcncTCriU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 002/143] btrfs: fix unnecessary increment of read error stat on write error
Date:   Wed, 15 Mar 2023 13:11:28 +0100
Message-Id: <20230315115740.515545016@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 98e8d36a26c2ed22f78316df7d4bf33e554b9f9f upstream.

Current btrfs_log_dev_io_error() increases the read error count even if the
erroneous IO is a WRITE request. This is because it forget to use "else
if", and all the error WRITE requests counts as READ error as there is (of
course) no REQ_RAHEAD bit set.

Fixes: c3a62baf21ad ("btrfs: use chained bios when cloning")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6739,7 +6739,7 @@ static void btrfs_log_dev_io_error(struc
 
 	if (btrfs_op(bio) == BTRFS_MAP_WRITE)
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
-	if (!(bio->bi_opf & REQ_RAHEAD))
+	else if (!(bio->bi_opf & REQ_RAHEAD))
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_READ_ERRS);
 	if (bio->bi_opf & REQ_PREFLUSH)
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_FLUSH_ERRS);


