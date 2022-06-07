Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB832540850
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348833AbiFGR5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348852AbiFGR4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:56:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DAC1483CE;
        Tue,  7 Jun 2022 10:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 650F26146F;
        Tue,  7 Jun 2022 17:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75227C385A5;
        Tue,  7 Jun 2022 17:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623612;
        bh=Ug2iDgnAtpoUE8P9c9MZInvHRwl5cstezlbysnMVdkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElTsZCbXRPS5/uGF2glaEQg0nlYWAc1+5frJCDmr7IbPXpRg0AVewOXJRZ9iheNve
         T9UuVmEr6foFBSkR/bgl9bIThPmMHuBFWMaWplBqkZ9bc3HcIzNK+FOh2JlkT/f1e4
         iEZ57kDtWZS8+lXU0KcITLlANE87AjC3HGdRpbfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Bergantinos <rbergant@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 028/667] cifs: fix potential double free during failed mount
Date:   Tue,  7 Jun 2022 18:54:53 +0200
Message-Id: <20220607164935.640274400@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
@@ -826,7 +826,7 @@ cifs_smb3_do_mount(struct file_system_ty
 	      int flags, struct smb3_fs_context *old_ctx)
 {
 	int rc;
-	struct super_block *sb;
+	struct super_block *sb = NULL;
 	struct cifs_sb_info *cifs_sb = NULL;
 	struct cifs_mnt_data mnt_data;
 	struct dentry *root;
@@ -922,9 +922,11 @@ out_super:
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


