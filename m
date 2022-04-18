Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8777A505130
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238975AbiDRMd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239161AbiDRMcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:32:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818FF25C7F;
        Mon, 18 Apr 2022 05:24:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8B7260FB0;
        Mon, 18 Apr 2022 12:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11F4C385AB;
        Mon, 18 Apr 2022 12:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284658;
        bh=m9viVS1D+NUit2asz3mAmwwfeEnNpj04FNw9SDwXsWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMluKMGrhUKe4zD6KVHac4WFhX/K6nXW6lTvFAW/Vn9K2Kqa7mELZhFAdoFCDMl/U
         6DXGXVFcR7ZPpnGTm3nd8IryjhbsD0UR238EmCYdwUcKyq61sy60hkGCxsNVh8bM7n
         vW7MEX/oelJhEWdTmMWomW0QW6iaezCCjABMzwhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Xiaoli Feng <xifeng@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.17 187/219] cifs: verify that tcon is valid before dereference in cifs_kill_sb
Date:   Mon, 18 Apr 2022 14:12:36 +0200
Message-Id: <20220418121212.112167732@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 8b6c58458ee3206dde345fce327a4cb83e69caf9 upstream.

On umount, cifs_sb->tlink_tree might contain entries that do not represent
a valid tcon.
Check the tcon for error before we dereference it.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -266,10 +266,11 @@ static void cifs_kill_sb(struct super_bl
 	 * before we kill the sb.
 	 */
 	if (cifs_sb->root) {
-		node = rb_first(root);
-		while (node != NULL) {
+		for (node = rb_first(root); node; node = rb_next(node)) {
 			tlink = rb_entry(node, struct tcon_link, tl_rbnode);
 			tcon = tlink_tcon(tlink);
+			if (IS_ERR(tcon))
+				continue;
 			cfid = &tcon->crfid;
 			mutex_lock(&cfid->fid_mutex);
 			if (cfid->dentry) {
@@ -277,7 +278,6 @@ static void cifs_kill_sb(struct super_bl
 				cfid->dentry = NULL;
 			}
 			mutex_unlock(&cfid->fid_mutex);
-			node = rb_next(node);
 		}
 
 		/* finally release root dentry */


