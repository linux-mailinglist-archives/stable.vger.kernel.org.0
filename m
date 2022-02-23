Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321024C0868
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237132AbiBWCcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbiBWCb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:31:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE85496B4;
        Tue, 22 Feb 2022 18:30:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51CBB6151D;
        Wed, 23 Feb 2022 02:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E1BC340F4;
        Wed, 23 Feb 2022 02:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583403;
        bh=kS8D6bkfgqqgmMhggKntZnsLULvt63AbdUvRgellOS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7Di3KQZQi6EpYGoTnwjpbioqUiBiG4Rh45ZnPA0F+EX+uakhqXXNeAUmUOsPsQ12
         vH7dzXr7KQg5jvML8Xj6N4VJs3Ga6IygiTW7669xrKoMVARqe79xDGujjn3GwWCtng
         pqBNC9jkqUxP2UToYIXeqLT4zGDEaRLII31JoLoj8wKXq0J/xNLa3x+1fy2d8gEPch
         NmUAF7ckzAdVJlDIFTEW0oJqmQJZWSbfAUeQTMurGWJjd0BieAS9ZzB71aZLTDbvnU
         pECoKIYZ0Tyfe3jMEGC4QwUIfOmSLtXYT4rrbJl4f+6reB/fRReaAVcVJbSrcWP7SU
         bLfE2Z7W0tkOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.15 18/28] cifs: modefromsids must add an ACE for authenticated users
Date:   Tue, 22 Feb 2022 21:29:19 -0500
Message-Id: <20220223022929.241127-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022929.241127-1-sashal@kernel.org>
References: <20220223022929.241127-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 0c6f4ebf8835d01866eb686d47578cde80097981 ]

When we create a file with modefromsids we set an ACL that
has one ACE for the magic modefromsid as well as a second ACE that
grants full access to all authenticated users.

When later we chante the mode on the file we strip away this, and other,
ACE for authenticated users in set_chmod_dacl() and then just add back/update
the modefromsid ACE.
Thus leaving the file with a single ACE that is for the mode and no ACE
to grant any user any rights to access the file.
Fix this by always adding back also the modefromsid ACE so that we do not
drop the rights to access the file.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsacl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 5df21d63dd04e..bf861fef2f0c3 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -949,6 +949,9 @@ static void populate_new_aces(char *nacl_base,
 		pnntace = (struct cifs_ace *) (nacl_base + nsize);
 		nsize += setup_special_mode_ACE(pnntace, nmode);
 		num_aces++;
+		pnntace = (struct cifs_ace *) (nacl_base + nsize);
+		nsize += setup_authusers_ACE(pnntace);
+		num_aces++;
 		goto set_size;
 	}
 
@@ -1613,7 +1616,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	nsecdesclen = secdesclen;
 	if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
 		if (mode_from_sid)
-			nsecdesclen += sizeof(struct cifs_ace);
+			nsecdesclen += 2 * sizeof(struct cifs_ace);
 		else /* cifsacl */
 			nsecdesclen += 5 * sizeof(struct cifs_ace);
 	} else { /* chown */
-- 
2.34.1

