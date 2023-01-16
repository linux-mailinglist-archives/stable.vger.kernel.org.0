Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDF566C109
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjAPOHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbjAPOGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:06:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E652203E;
        Mon, 16 Jan 2023 06:03:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C798660FD3;
        Mon, 16 Jan 2023 14:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC0DC433D2;
        Mon, 16 Jan 2023 14:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877806;
        bh=e+NWO9ODm0ZL/LjEa4Dig5LeZFMZbaYohj6S0glXTIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFHaWZ4jzQiVd7fCSCvpPqzRL4uIofYMYacAeOjaMNDX/k0L9Rg4uWGh/psZgX50a
         Oj0p0VY297RG7z3mT7ZLw5cP+onDPNkiNPUyTGm17efnzrfcMjz57hSW94gS1OmerP
         5smO3OiMXppwzkrbc9ULL7dikogjRM6KX5zFqdNqZvizMVfV0YahvI6q22+pm1iQgd
         gI6e/vDNs/LYzeMX18u5kbcGt0Ey3SPp3FWmpSgRpMoO1Ckq5FiFgHLHUA+OSRN8p2
         /YbXihVeghsJZysfhwUdHJ3hOg/rleCc95oCBQ044tL0w6M2rjJ+JlLaD58LGbfTNn
         AvQpiKxSrkYcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.1 37/53] cifs: fix potential memory leaks in session setup
Date:   Mon, 16 Jan 2023 09:01:37 -0500
Message-Id: <20230116140154.114951-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 2fe58d977ee05da5bb89ef5dc4f5bf2dc15db46f ]

Make sure to free cifs_ses::auth_key.response before allocating it as
we might end up leaking memory in reconnect or mounting.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsencrypt.c | 1 +
 fs/cifs/sess.c        | 2 ++
 fs/cifs/smb2pdu.c     | 1 +
 3 files changed, 4 insertions(+)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 5db73c0f792a..cbc18b4a9cb2 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -278,6 +278,7 @@ build_avpair_blob(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	 * ( for NTLMSSP_AV_NB_DOMAIN_NAME followed by NTLMSSP_AV_EOL ) +
 	 * unicode length of a netbios domain name
 	 */
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.len = size + 2 * dlen;
 	ses->auth_key.response = kzalloc(ses->auth_key.len, GFP_KERNEL);
 	if (!ses->auth_key.response) {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 0b842a07e157..c47b254f0d1e 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -815,6 +815,7 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 		return -EINVAL;
 	}
 	if (tilen) {
+		kfree_sensitive(ses->auth_key.response);
 		ses->auth_key.response = kmemdup(bcc_ptr + tioffset, tilen,
 						 GFP_KERNEL);
 		if (!ses->auth_key.response) {
@@ -1428,6 +1429,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
 		goto out_put_spnego_key;
 	}
 
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
 					 GFP_KERNEL);
 	if (!ses->auth_key.response) {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index a5695748a89b..d5a0eb2c0a1d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1450,6 +1450,7 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 
 	/* keep session key if binding */
 	if (!is_binding) {
+		kfree_sensitive(ses->auth_key.response);
 		ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
 						 GFP_KERNEL);
 		if (!ses->auth_key.response) {
-- 
2.35.1

