Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FD765D8FD
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbjADQUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239689AbjADQUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E58D41D5B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D6EDB81733
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F95FC433D2;
        Wed,  4 Jan 2023 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849216;
        bh=4r5S2G9TNj2o2zkuitumm9+llmmLGUaSHxvKX1YW4Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSZnzFQ/tO0L/px1qZmW8pNNBFTC2OQwQY7jAy/0VUU5ERtmwGCbIgm+sv1knChDT
         3vGQiM1PUO5M3m1rMlrWZ7UD1p/5UKR7/ObpzszbtJ7OGkeyaz47lmjP8r6jZ1x/5M
         TufNPWb8jVRSEjeGTWgnoy5twoEFIBStVoIWXeH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 084/177] cifs: set correct status of tcon ipc when reconnecting
Date:   Wed,  4 Jan 2023 17:06:15 +0100
Message-Id: <20230104160510.190957955@linuxfoundation.org>
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

commit 25cf01b7c9200d6ace5a59125d8166435dd9dea7 upstream.

The status of tcon ipcs were not being set to TID_NEED_RECO when
marking sessions and tcons to be reconnected, therefore not sending
tree connect to those ipcs in cifs_tree_connect() and leaving them
disconnected.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -279,8 +279,10 @@ cifs_mark_tcp_ses_conns_for_reconnect(st
 			tcon->need_reconnect = true;
 			tcon->status = TID_NEED_RECON;
 		}
-		if (ses->tcon_ipc)
+		if (ses->tcon_ipc) {
 			ses->tcon_ipc->need_reconnect = true;
+			ses->tcon_ipc->status = TID_NEED_RECON;
+		}
 
 next_session:
 		spin_unlock(&ses->chan_lock);


