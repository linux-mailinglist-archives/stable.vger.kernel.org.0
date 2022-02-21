Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AE24BE8B9
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238501AbiBUJ7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:59:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352944AbiBUJ45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:56:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112B345502;
        Mon, 21 Feb 2022 01:24:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CC816104F;
        Mon, 21 Feb 2022 09:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81776C340F3;
        Mon, 21 Feb 2022 09:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435486;
        bh=K6IXxwfYf+2EogGduwm0n8GcWNbITrkY/OPsF0vp9b0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZI4peuLW5EgrmZWFMCdC4hV14+rHO4euZJoSbQ1PCwxPfD/HSfrj4F2odU8k+N4Vy
         X7GUjPHRCwRfYWpsTxyUHD2SLLmJgoqQJ2EYqMFitvnIt5bfr0k339tJumSMJWLPBE
         0a48a96kX9ooKr2VT0kJQMPP+P1rI38yXcbq6nGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Scarborough <kim@scarborough.kim>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.16 148/227] cifs: fix confusing unneeded warning message on smb2.1 and earlier
Date:   Mon, 21 Feb 2022 09:49:27 +0100
Message-Id: <20220221084939.755611375@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Steve French <stfrench@microsoft.com>

commit 53923e0fe2098f90f339510aeaa0e1413ae99a16 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/sess.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -76,11 +76,6 @@ int cifs_try_adding_channels(struct cifs
 	struct cifs_server_iface *ifaces = NULL;
 	size_t iface_count;
 
-	if (ses->server->dialect < SMB30_PROT_ID) {
-		cifs_dbg(VFS, "multichannel is not supported on this protocol version, use 3.0 or above\n");
-		return 0;
-	}
-
 	spin_lock(&ses->chan_lock);
 
 	new_chan_count = old_chan_count = ses->chan_count;
@@ -94,6 +89,12 @@ int cifs_try_adding_channels(struct cifs
 		return 0;
 	}
 
+	if (ses->server->dialect < SMB30_PROT_ID) {
+		spin_unlock(&ses->chan_lock);
+		cifs_dbg(VFS, "multichannel is not supported on this protocol version, use 3.0 or above\n");
+		return 0;
+	}
+
 	if (!(ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
 		ses->chan_max = 1;
 		spin_unlock(&ses->chan_lock);


