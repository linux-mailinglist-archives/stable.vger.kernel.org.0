Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6D4529109
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244207AbiEPULD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351104AbiEPUCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:02:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF06110CA;
        Mon, 16 May 2022 12:58:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59DF260BAC;
        Mon, 16 May 2022 19:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E697AC385AA;
        Mon, 16 May 2022 19:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731135;
        bh=CqH4xe6KG8LRjCPJexU/WdwJvqdGzxQINgu8FGtrpgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TzCL1iATw44b1O4ISt3gZtPn7rnAA8urfUYN/K0kULl5YHkl2N6AqS58QPL5kNce
         XwgXlBXx67omHlLB1n8qJCx0TvAspW6qe0DpDTvwT3fOCUm/GALtHJa+3IQnwMkScB
         ZoyGKPpNs3DXmw7UQWoVQDlZ/ytfULKdk5i+bWiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charan Teja Reddy <quic_charante@quicinc.com>,
        "T.J. Mercier" <tjmercier@google.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.17 111/114] dma-buf: call dma_buf_stats_setup after dmabuf is in valid list
Date:   Mon, 16 May 2022 21:37:25 +0200
Message-Id: <20220516193628.660304886@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
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
@@ -543,10 +543,6 @@ struct dma_buf *dma_buf_export(const str
 	file->f_mode |= FMODE_LSEEK;
 	dmabuf->file = file;
 
-	ret = dma_buf_stats_setup(dmabuf);
-	if (ret)
-		goto err_sysfs;
-
 	mutex_init(&dmabuf->lock);
 	INIT_LIST_HEAD(&dmabuf->attachments);
 
@@ -554,6 +550,10 @@ struct dma_buf *dma_buf_export(const str
 	list_add(&dmabuf->list_node, &db_list.head);
 	mutex_unlock(&db_list.lock);
 
+	ret = dma_buf_stats_setup(dmabuf);
+	if (ret)
+		goto err_sysfs;
+
 	return dmabuf;
 
 err_sysfs:


