Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6C56AF56D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbjCGTZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbjCGTYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:24:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD689E30D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:10:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55C15B818C4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDE2C4339B;
        Tue,  7 Mar 2023 19:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216247;
        bh=0VEvw8YGLPU3czJW+o90Dw9ceDo8GXqgNmImZkTvuCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6RfSSGpnDpsbD9rjoUx9JmRhSfndQNz//gQwyVb2zNmvJOIExlARa4yZKomK5QbY
         tKdbT7JgSCh0NOKEp3qNTQOEIVS5hkjAK6DELWT17RwhDby7TLkY/Q+C8hCtNqCRhY
         VIsu852cBu3IZfruS75kI1ZhB1f5GhAVsrDQc1UQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.15 522/567] fuse: add inode/permission checks to fileattr_get/fileattr_set
Date:   Tue,  7 Mar 2023 18:04:18 +0100
Message-Id: <20230307165928.573825438@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>

commit 1cc4606d19e3710bfab3f6704b87ff9580493c69 upstream.

It looks like these checks were accidentally lost during the conversion to
fileattr API.

Fixes: 72227eac177d ("fuse: convert to fileattr")
Cc: <stable@vger.kernel.org> # v5.13
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -419,6 +419,12 @@ static struct fuse_file *fuse_priv_ioctl
 	struct fuse_mount *fm = get_fuse_mount(inode);
 	bool isdir = S_ISDIR(inode->i_mode);
 
+	if (!fuse_allow_current_process(fm->fc))
+		return ERR_PTR(-EACCES);
+
+	if (fuse_is_bad(inode))
+		return ERR_PTR(-EIO);
+
 	if (!S_ISREG(inode->i_mode) && !isdir)
 		return ERR_PTR(-ENOTTY);
 


