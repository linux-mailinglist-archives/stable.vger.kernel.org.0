Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3284CF832
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiCGJwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239308AbiCGJta (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:49:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CEC1DA73;
        Mon,  7 Mar 2022 01:42:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B9CCB810C3;
        Mon,  7 Mar 2022 09:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66EFC340E9;
        Mon,  7 Mar 2022 09:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646174;
        bh=lpTIfqFfuxNnkZVoWmvjaup59vtQTcg03a28fDRHsfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kR4BpZJeEKYoamKW+hmTbSir5vJc7fxqiWP22M3mDcN8IWbd8Z7MuYqJGRPjhwqg2
         v3OvhbZ9sck1XYbgwXiLPiE8WVHYbTVv5+QelQf5JGSPcrUEM7PnmN1tRCdxgGPQr8
         DB9BAYAihGRSd6w6y3UOoum5RjhMFmsuual0d+Mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Scarborough <kim@scarborough.kim>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/262] cifs: fix confusing unneeded warning message on smb2.1 and earlier
Date:   Mon,  7 Mar 2022 10:17:54 +0100
Message-Id: <20220307091706.127954885@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 53923e0fe2098f90f339510aeaa0e1413ae99a16 ]

When mounting with SMB2.1 or earlier, even with nomultichannel, we
log the confusing warning message:
  "CIFS: VFS: multichannel is not supported on this protocol version, use 3.0 or above"

Fix this so that we don't log this unless they really are trying
to mount with multichannel.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215608
Reported-by: Kim Scarborough <kim@scarborough.kim>
Cc: stable@vger.kernel.org # 5.11+
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/sess.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index a1e688113645f..5500ea7837845 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -76,11 +76,6 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 	struct cifs_server_iface *ifaces = NULL;
 	size_t iface_count;
 
-	if (ses->server->dialect < SMB30_PROT_ID) {
-		cifs_dbg(VFS, "multichannel is not supported on this protocol version, use 3.0 or above\n");
-		return 0;
-	}
-
 	spin_lock(&ses->chan_lock);
 
 	new_chan_count = old_chan_count = ses->chan_count;
@@ -94,6 +89,12 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 		return 0;
 	}
 
+	if (ses->server->dialect < SMB30_PROT_ID) {
+		spin_unlock(&ses->chan_lock);
+		cifs_dbg(VFS, "multichannel is not supported on this protocol version, use 3.0 or above\n");
+		return 0;
+	}
+
 	if (!(ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
 		cifs_dbg(VFS, "server %s does not support multichannel\n", ses->server->hostname);
 		ses->chan_max = 1;
-- 
2.34.1



