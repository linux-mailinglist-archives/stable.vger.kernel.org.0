Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59EDB594473
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345034AbiHOWTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350533AbiHOWR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:17:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6605D1232D6;
        Mon, 15 Aug 2022 12:41:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51E9CB80EAB;
        Mon, 15 Aug 2022 19:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE9EC433D6;
        Mon, 15 Aug 2022 19:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592461;
        bh=NNc+ZgAIT93P7mkNlp5ZcQKWVmmubeiDsVrAA3uW0tI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqBFGDj83NFXm4Wl1/slM5gE1c0T6j5CpWhNgAz47+c2DwcVS4lKV5F5Hv8FSMyKq
         RMjdVDW2kkGAFRNGGjnN1LpCbQYuL51w5UgtX+vNmJlryL4Jkts6qpPEf5Qoof13fW
         Tg88RWq3zxxqSP1gMVk93YUxEvE80CQ9PZknea8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.19 0113/1157] fuse: limit nsec
Date:   Mon, 15 Aug 2022 19:51:09 +0200
Message-Id: <20220815180444.150408212@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 47912eaa061a6a81e4aa790591a1874c650733c0 upstream.

Limit nanoseconds to 0..999999999.

Fixes: d8a5ba45457e ("[PATCH] FUSE - core")
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -180,6 +180,12 @@ void fuse_change_attributes_common(struc
 	inode->i_uid     = make_kuid(fc->user_ns, attr->uid);
 	inode->i_gid     = make_kgid(fc->user_ns, attr->gid);
 	inode->i_blocks  = attr->blocks;
+
+	/* Sanitize nsecs */
+	attr->atimensec = min_t(u32, attr->atimensec, NSEC_PER_SEC - 1);
+	attr->mtimensec = min_t(u32, attr->mtimensec, NSEC_PER_SEC - 1);
+	attr->ctimensec = min_t(u32, attr->ctimensec, NSEC_PER_SEC - 1);
+
 	inode->i_atime.tv_sec   = attr->atime;
 	inode->i_atime.tv_nsec  = attr->atimensec;
 	/* mtime from server may be stale due to local buffered write */


