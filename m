Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CEB599F93
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350570AbiHSPzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350571AbiHSPyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:54:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FBB106FBA;
        Fri, 19 Aug 2022 08:49:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4039161724;
        Fri, 19 Aug 2022 15:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F54FC433D7;
        Fri, 19 Aug 2022 15:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924178;
        bh=2mjJAQmsdN9zFTMGHiXbeqb7KdcpnHmUaKz7zq041e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s71VWx7695HR8+cn5swIoLZsHGy1hYZGOOa+Ek1lWt4r8mH295WEDRZOId6/7Nz3o
         OTjDAZ6XUux5IP536QIPmW5W3AZET2uj6krhsnliU03pq3GM9myf6uuji6bdAGTMO5
         v7Gc4q5J9EBqCsxisAMY4EUfGCLURQlHFZMonrzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 053/545] fuse: limit nsec
Date:   Fri, 19 Aug 2022 17:37:03 +0200
Message-Id: <20220819153831.603561318@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
@@ -182,6 +182,12 @@ void fuse_change_attributes_common(struc
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


