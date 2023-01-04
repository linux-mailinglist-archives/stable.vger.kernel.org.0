Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A4765D891
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239815AbjADQQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239882AbjADQPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:15:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0833D9DA
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:15:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68D59B8171C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B65C433F1;
        Wed,  4 Jan 2023 16:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848933;
        bh=+K7NqQ8ruQddz2eXqd/yUqVXYkEvC4WHEVyi3KhOHE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmgVC0zG+WAEJvYBAklJqey08M1Z64/oYemhBgxb0za3RGgVI6uh3O2C4/Hj9eWYH
         zbmUREt0cSfhlc/7bjKoH23aZZZ669mMpFU0UmD8ecOy87+x6f5wFMTgA/2fCHBYhK
         1XIy4Apd5huePUKkXzzqgFq2+pdF1HOOacbqIfTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 106/207] cifs: set correct ipc status after initial tree connect
Date:   Wed,  4 Jan 2023 17:06:04 +0100
Message-Id: <20230104160515.269504648@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit 86fe0fa8747fb1bc4cc44fc1966e0959fe752f38 upstream.

cifs_tcon::status wasn't correctly updated to TID_GOOD after
establishing initial IPC connection thus staying at TID_NEW as long as
it wasn't reconnected.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1871,6 +1871,9 @@ cifs_setup_ipc(struct cifs_ses *ses, str
 
 	cifs_dbg(FYI, "IPC tcon rc=%d ipc tid=0x%x\n", rc, tcon->tid);
 
+	spin_lock(&tcon->tc_lock);
+	tcon->status = TID_GOOD;
+	spin_unlock(&tcon->tc_lock);
 	ses->tcon_ipc = tcon;
 out:
 	return rc;
@@ -2280,10 +2283,10 @@ cifs_get_smb_ses(struct TCP_Server_Info
 	list_add(&ses->smb_ses_list, &server->smb_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	free_xid(xid);
-
 	cifs_setup_ipc(ses, ctx);
 
+	free_xid(xid);
+
 	return ses;
 
 get_ses_fail:


