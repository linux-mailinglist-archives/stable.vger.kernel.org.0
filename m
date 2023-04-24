Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69C86ECF0B
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbjDXNhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjDXNhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21804A257
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:37:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4347B623A0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54079C4339C;
        Mon, 24 Apr 2023 13:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343391;
        bh=XC+s04Jtqfzms3y+YfWFRhcEeWozxnmpayaJrj3kvsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvD4i1ysJ1BKtCVu/IRBqTej4I9MdsLNz3MKTCguYgzMVvc/5VCsGQZbMncyLteqU
         PKbbpZZUtG7CNRb+IFYQiIw0Tgr9ZVdaZRsbx2TSBc1QCmzUvSCwmUBrYnC81zA3CX
         iSYj47XwZT3l2x9dftlM0brI/+opbdiCHGFts/7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miklos Szeredi <mszeredi@redhat.com>,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 5.10 49/68] virtiofs: clean up error handling in virtio_fs_get_tree()
Date:   Mon, 24 Apr 2023 15:18:20 +0200
Message-Id: <20230424131129.549192504@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 833c5a42e28beeefa1f9bd476a63fe8050c1e8ca upstream.

Avoid duplicating error cleanup.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/virtio_fs.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1440,22 +1440,14 @@ static int virtio_fs_get_tree(struct fs_
 		return -EINVAL;
 	}
 
+	err = -ENOMEM;
 	fc = kzalloc(sizeof(struct fuse_conn), GFP_KERNEL);
-	if (!fc) {
-		mutex_lock(&virtio_fs_mutex);
-		virtio_fs_put(fs);
-		mutex_unlock(&virtio_fs_mutex);
-		return -ENOMEM;
-	}
+	if (!fc)
+		goto out_err;
 
 	fm = kzalloc(sizeof(struct fuse_mount), GFP_KERNEL);
-	if (!fm) {
-		mutex_lock(&virtio_fs_mutex);
-		virtio_fs_put(fs);
-		mutex_unlock(&virtio_fs_mutex);
-		kfree(fc);
-		return -ENOMEM;
-	}
+	if (!fm)
+		goto out_err;
 
 	fuse_conn_init(fc, fm, fsc->user_ns, &virtio_fs_fiq_ops, fs);
 	fc->release = fuse_free_conn;
@@ -1483,6 +1475,13 @@ static int virtio_fs_get_tree(struct fs_
 	WARN_ON(fsc->root);
 	fsc->root = dget(sb->s_root);
 	return 0;
+
+out_err:
+	kfree(fc);
+	mutex_lock(&virtio_fs_mutex);
+	virtio_fs_put(fs);
+	mutex_unlock(&virtio_fs_mutex);
+	return err;
 }
 
 static const struct fs_context_operations virtio_fs_context_ops = {


