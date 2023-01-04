Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E9065D8F8
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239711AbjADQUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240022AbjADQUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:20:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5893EC74A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10709B81714
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6630BC433D2;
        Wed,  4 Jan 2023 16:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849210;
        bh=gbueyn30KPFSslQhbfJLCwpeIQPsQuHQBcdCpyP6FU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R24pempimE+SnGpVdVbgCxrwqy3GmdX/S6uXFDTxQddNyUsjrlN/SeT4U0aW8yT/O
         zPGunsesdM1L+IgMWiuZMnsY/ta+OOKzWR8S2JpN6k+3fujdWIgk713iwDGkZpxjFc
         aRhc7Q0yyyad+RR/znFqK+nafQyP27RYifuHQVyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 083/177] cifs: set correct ipc status after initial tree connect
Date:   Wed,  4 Jan 2023 17:06:14 +0100
Message-Id: <20230104160510.162714907@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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
@@ -1870,6 +1870,9 @@ cifs_setup_ipc(struct cifs_ses *ses, str
 
 	cifs_dbg(FYI, "IPC tcon rc=%d ipc tid=0x%x\n", rc, tcon->tid);
 
+	spin_lock(&tcon->tc_lock);
+	tcon->status = TID_GOOD;
+	spin_unlock(&tcon->tc_lock);
 	ses->tcon_ipc = tcon;
 out:
 	return rc;
@@ -2278,10 +2281,10 @@ cifs_get_smb_ses(struct TCP_Server_Info
 	list_add(&ses->smb_ses_list, &server->smb_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	free_xid(xid);
-
 	cifs_setup_ipc(ses, ctx);
 
+	free_xid(xid);
+
 	return ses;
 
 get_ses_fail:


