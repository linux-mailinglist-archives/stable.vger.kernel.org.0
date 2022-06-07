Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618255410C7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355132AbiFGT3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356868AbiFGT2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6F51A196C;
        Tue,  7 Jun 2022 11:11:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 46537CE2442;
        Tue,  7 Jun 2022 18:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CC2C385A2;
        Tue,  7 Jun 2022 18:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625474;
        bh=InTEJxokk0gSldDDmnuCDCLtUbImqooZSkroi+Xe/fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HrmqVVRe+eUcDv5JwXhL8jLC+NS9nEEZtQNkYk4xbE94k8G8T9ciD/qRKLhNcjdIv
         Gb/GQ9UMKqZO0eR6TrhcEgy8J4eaf/puwsUcWgWc3gFHYZZikwe2bU8ALEditKLzcZ
         pSA8l1Pf/ke10LHc1kMhWoeWj1/58e0DHPf8Pf7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Bergantinos <rbergant@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.17 030/772] cifs: fix potential double free during failed mount
Date:   Tue,  7 Jun 2022 18:53:42 +0200
Message-Id: <20220607164949.907204065@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 8378a51e3f8140f60901fb27208cc7a6e47047b5 upstream.

RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=2088799

Cc: stable@vger.kernel.org
Signed-off-by: Roberto Bergantinos <rbergant@redhat.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -836,7 +836,7 @@ cifs_smb3_do_mount(struct file_system_ty
 	      int flags, struct smb3_fs_context *old_ctx)
 {
 	int rc;
-	struct super_block *sb;
+	struct super_block *sb = NULL;
 	struct cifs_sb_info *cifs_sb = NULL;
 	struct cifs_mnt_data mnt_data;
 	struct dentry *root;
@@ -932,9 +932,11 @@ out_super:
 	return root;
 out:
 	if (cifs_sb) {
-		kfree(cifs_sb->prepath);
-		smb3_cleanup_fs_context(cifs_sb->ctx);
-		kfree(cifs_sb);
+		if (!sb || IS_ERR(sb)) {  /* otherwise kill_sb will handle */
+			kfree(cifs_sb->prepath);
+			smb3_cleanup_fs_context(cifs_sb->ctx);
+			kfree(cifs_sb);
+		}
 	}
 	return root;
 }


