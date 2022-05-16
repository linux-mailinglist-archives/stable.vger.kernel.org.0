Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67654529058
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347539AbiEPUGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348921AbiEPT7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E773EB82;
        Mon, 16 May 2022 12:52:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C46260AB8;
        Mon, 16 May 2022 19:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8A8C34115;
        Mon, 16 May 2022 19:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730775;
        bh=LZKZnEYoLnDZneRSDTYPINYW/YQOWGqnwVmuCRn10DY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqj/L/xUma3z1B9qGucHmL25uz5yAxkiQotQ3XZQzmEElhPVC+l0TwkY0TYUiaTvS
         EkbFUl5a5/vzuOtijakScrotAp2ZbwFe7MQoljdlc4xd236UPsSGiTG7kXJITApAiD
         o2WN+CW2YrnHCGFDV+p99kCoXuQ14ljIUjD5JJcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charan Teja Reddy <quic_charante@quicinc.com>,
        "T.J. Mercier" <tjmercier@google.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.15 097/102] dma-buf: call dma_buf_stats_setup after dmabuf is in valid list
Date:   Mon, 16 May 2022 21:37:11 +0200
Message-Id: <20220516193626.785652716@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charan Teja Reddy <quic_charante@quicinc.com>

commit ef3a6b70507a2add2cd2e01f5eb9b54d561bacb9 upstream.

When dma_buf_stats_setup() fails, it closes the dmabuf file which
results into the calling of dma_buf_file_release() where it does
list_del(&dmabuf->list_node) with out first adding it to the proper
list. This is resulting into panic in the below path:
__list_del_entry_valid+0x38/0xac
dma_buf_file_release+0x74/0x158
__fput+0xf4/0x428
____fput+0x14/0x24
task_work_run+0x178/0x24c
do_notify_resume+0x194/0x264
work_pending+0xc/0x5f0

Fix it by moving the dma_buf_stats_setup() after dmabuf is added to the
list.

Fixes: bdb8d06dfefd ("dmabuf: Add the capability to expose DMA-BUF stats in sysfs")
Signed-off-by: Charan Teja Reddy <quic_charante@quicinc.com>
Tested-by: T.J. Mercier <tjmercier@google.com>
Acked-by: T.J. Mercier <tjmercier@google.com>
Cc: <stable@vger.kernel.org> # 5.15.x+
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1652125797-2043-1-git-send-email-quic_charante@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-buf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -572,10 +572,6 @@ struct dma_buf *dma_buf_export(const str
 	file->f_mode |= FMODE_LSEEK;
 	dmabuf->file = file;
 
-	ret = dma_buf_stats_setup(dmabuf);
-	if (ret)
-		goto err_sysfs;
-
 	mutex_init(&dmabuf->lock);
 	INIT_LIST_HEAD(&dmabuf->attachments);
 
@@ -583,6 +579,10 @@ struct dma_buf *dma_buf_export(const str
 	list_add(&dmabuf->list_node, &db_list.head);
 	mutex_unlock(&db_list.lock);
 
+	ret = dma_buf_stats_setup(dmabuf);
+	if (ret)
+		goto err_sysfs;
+
 	return dmabuf;
 
 err_sysfs:


