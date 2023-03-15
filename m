Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8186BB20A
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbjCOMcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbjCOMcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:32:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02166265BC
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:31:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9AA9B81E02
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F465C4339E;
        Wed, 15 Mar 2023 12:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883478;
        bh=cJyn5if9UHzNMhCT6qOO4Ca+N/e7eaTdLc59LvGpKzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKvF27HYRWIpKXXXmlKUGjsDC8rxo/o7LdlEK9YLO/PHDUYT5H0r2x70HXstwRKNP
         fXgoRMtjFsf9wH0XCW/rl1qLjGm4myl2/nPBAQfMAmad0wKt1ldlPiFQnrj1XNn1NA
         MTJ+SUx9pHv39m2ovcrMjSgggjyW7e2fXBQg+olI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yue Hu <huyue2@coolpad.com>,
        Chao Yu <chao@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.1 005/143] erofs: fix wrong kunmap when using LZMA on HIGHMEM platforms
Date:   Wed, 15 Mar 2023 13:11:31 +0100
Message-Id: <20230315115740.611783864@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 8f121dfb15f7b4ab345992ce96003eb63fd608f4 upstream.

As the call trace shown, the root cause is kunmap incorrect pages:

 BUG: kernel NULL pointer dereference, address: 00000000
 CPU: 1 PID: 40 Comm: kworker/u5:0 Not tainted 6.2.0-rc5 #4
 Workqueue: erofs_worker z_erofs_decompressqueue_work
 EIP: z_erofs_lzma_decompress+0x34b/0x8ac
  z_erofs_decompress+0x12/0x14
  z_erofs_decompress_queue+0x7e7/0xb1c
  z_erofs_decompressqueue_work+0x32/0x60
  process_one_work+0x24b/0x4d8
  ? process_one_work+0x1a4/0x4d8
  worker_thread+0x14c/0x3fc
  kthread+0xe6/0x10c
  ? rescuer_thread+0x358/0x358
  ? kthread_complete_and_exit+0x18/0x18
  ret_from_fork+0x1c/0x28
 ---[ end trace 0000000000000000 ]---

The bug is trivial and should be fixed now.  It has no impact on
!HIGHMEM platforms.

Fixes: 622ceaddb764 ("erofs: lzma compression support")
Cc: <stable@vger.kernel.org> # 5.16+
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230305134455.88236-1-hsiangkao@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/decompressor_lzma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -278,7 +278,7 @@ again:
 		}
 	}
 	if (no < nrpages_out && strm->buf.out)
-		kunmap(rq->in[no]);
+		kunmap(rq->out[no]);
 	if (ni < nrpages_in)
 		kunmap(rq->in[ni]);
 	/* 4. push back LZMA stream context to the global list */


