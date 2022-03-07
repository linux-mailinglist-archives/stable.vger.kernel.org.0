Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C9C4CF6C3
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbiCGJm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239513AbiCGJjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:39:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D75471EE4;
        Mon,  7 Mar 2022 01:35:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60850B80E70;
        Mon,  7 Mar 2022 09:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E3FC340E9;
        Mon,  7 Mar 2022 09:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645724;
        bh=kS8D6bkfgqqgmMhggKntZnsLULvt63AbdUvRgellOS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhvs7o3dW8BRkgWjn3AgKnFQt/2L1AizQoC62Hb/8lZyCek3Rao59C3Lpdx3P7f4K
         yCy76/7z91VfDPpWW5AmC8qPJIQLumLgj2MXEosfPOeTZAm4RnuNsXAvSiprAcefYE
         zc5olZbjQUr8RiKThAmx3Y8iClY7sdxpzA1FHeuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/262] cifs: modefromsids must add an ACE for authenticated users
Date:   Mon,  7 Mar 2022 10:16:01 +0100
Message-Id: <20220307091702.861572644@linuxfoundation.org>
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



