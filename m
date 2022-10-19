Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F97603EF1
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbiJSJZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbiJSJXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:23:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100F432ECA;
        Wed, 19 Oct 2022 02:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADC2D6187E;
        Wed, 19 Oct 2022 09:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC12C433D6;
        Wed, 19 Oct 2022 09:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170486;
        bh=MKoBh82UrCikpRPp+3I9KxQVcYkaIfYhH8SFNWI3dfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ow8nXXCFdEwNB4Zu29z7v/szyNj7MZi6YzdrBU8yRNS/h1Xv6HDX6vo7Ea02S5D2y
         wQxp9bmkLXJH/YI5INT4q5DaEYfNiJBzegSfCuFqF9GIZK5JXT/GXZmBT0lIMaYyEj
         5GnpgxRnqZkTexN9soqmPxfGV9EoS+S1TGm0cUXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 641/862] cifs: return correct error in ->calc_signature()
Date:   Wed, 19 Oct 2022 10:32:08 +0200
Message-Id: <20221019083318.246791597@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 09a1f9a168ae1f69f701689429871793174417d2 ]

If an error happens while getting the key or session in the
->calc_signature implementations, 0 (success) is returned. Fix it by
returning a proper error code.

Since it seems to be highly unlikely to happen wrap the rc check in
unlikely() too.

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Fixes: 32811d242ff6 ("cifs: Start using per session key for smb2/3 for signature generation")
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2transport.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 1a5fc3314dbf..4640fc4a8b13 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -225,9 +225,9 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	struct smb_rqst drqst;
 
 	ses = smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
-	if (!ses) {
+	if (unlikely(!ses)) {
 		cifs_server_dbg(VFS, "%s: Could not find session\n", __func__);
-		return 0;
+		return -ENOENT;
 	}
 
 	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
@@ -557,8 +557,10 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	u8 key[SMB3_SIGN_KEY_SIZE];
 
 	rc = smb2_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
-	if (rc)
-		return 0;
+	if (unlikely(rc)) {
+		cifs_server_dbg(VFS, "%s: Could not get signing key\n", __func__);
+		return rc;
+	}
 
 	if (allocate_crypto) {
 		rc = cifs_alloc_hash("cmac(aes)", &hash, &sdesc);
-- 
2.35.1



