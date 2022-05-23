Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C9A531836
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240864AbiEWRji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241782AbiEWRgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:36:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCFF90CE8;
        Mon, 23 May 2022 10:29:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0A6960B2C;
        Mon, 23 May 2022 17:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9900C385A9;
        Mon, 23 May 2022 17:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326919;
        bh=2K0Ed2rmG9vLt8EFWi7OhhXbZZ/LsAZmEhrjRjuARM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYgwDuKlA+TNyRx4dXAXed3Ee8FKQOEEC3saczeCmQ9h0WjpbT9somWEqXucYsi7H
         P+CDDCYUaCC0ccxyTR83NgE/fRcWHF1EW3p7YEzeHW3sbe683QDxCcjHXpL4Lq7IyE
         6Lef+SdjJHItiySKX57HYvX1O2I3tdbq/ubyMcfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.17 067/158] dma-buf: ensure unique directory name for dmabuf stats
Date:   Mon, 23 May 2022 19:03:44 +0200
Message-Id: <20220523165841.999829287@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charan Teja Kalla <quic_charante@quicinc.com>

commit 370704e707a5f2d3c9a1d4ed8bd8cd67507d7bb5 upstream.

The dmabuf file uses get_next_ino()(through dma_buf_getfile() ->
alloc_anon_inode()) to get an inode number and uses the same as a
directory name under /sys/kernel/dmabuf/buffers/<ino>. This directory is
used to collect the dmabuf stats and it is created through
dma_buf_stats_setup(). At current, failure to create this directory
entry can make the dma_buf_export() to fail.

Now, as the get_next_ino() can definitely give a repetitive inode no
causing the directory entry creation to fail with -EEXIST. This is a
problem on the systems where dmabuf stats functionality is enabled on
the production builds can make the dma_buf_export(), though the dmabuf
memory is allocated successfully, to fail just because it couldn't
create stats entry.

This issue we are able to see on the snapdragon system within 13 days
where there already exists a directory with inode no "122602" so
dma_buf_stats_setup() failed with -EEXIST as it is trying to create
the same directory entry.

To make the dentry name as unique, use the dmabuf fs specific inode
which is based on the simple atomic variable increment. There is tmpfs
subsystem too which relies on its own inode generation rather than
relying on the get_next_ino() for the same reason of avoiding the
duplicate inodes[1].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/patch/?id=e809d5f0b5c912fe981dce738f3283b2010665f0

Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: <stable@vger.kernel.org> # 5.15.x+
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1652441296-1986-1-git-send-email-quic_charante@quicinc.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-buf.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -407,6 +407,7 @@ static inline int is_dma_buf_file(struct
 
 static struct file *dma_buf_getfile(struct dma_buf *dmabuf, int flags)
 {
+	static atomic64_t dmabuf_inode = ATOMIC64_INIT(0);
 	struct file *file;
 	struct inode *inode = alloc_anon_inode(dma_buf_mnt->mnt_sb);
 
@@ -416,6 +417,13 @@ static struct file *dma_buf_getfile(stru
 	inode->i_size = dmabuf->size;
 	inode_set_bytes(inode, dmabuf->size);
 
+	/*
+	 * The ->i_ino acquired from get_next_ino() is not unique thus
+	 * not suitable for using it as dentry name by dmabuf stats.
+	 * Override ->i_ino with the unique and dmabuffs specific
+	 * value.
+	 */
+	inode->i_ino = atomic64_add_return(1, &dmabuf_inode);
 	file = alloc_file_pseudo(inode, dma_buf_mnt, "dmabuf",
 				 flags, &dma_buf_fops);
 	if (IS_ERR(file))


