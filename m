Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6A25924BF
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242824AbiHNQfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242705AbiHNQeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:34:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8361E2C66C;
        Sun, 14 Aug 2022 09:27:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B73DB80B37;
        Sun, 14 Aug 2022 16:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0D1C433C1;
        Sun, 14 Aug 2022 16:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494446;
        bh=AR7Ip3kl2XlY0ZQseaklUDElSuk4HH4NTMx0bp4+/TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4eMz87UatfMZYPuc9HAWoC+/J/2hqN7/U8Rrd98h69UPKMoy0XGP669WVFkmuweL
         vly4ajMtMkdZ3WnVfBbY3c83LM+0APdrMypWAFsFijOL6q154mmGY07H5KZRDU1388
         tnO+CnqyPHCaNUGm6gFfLSxy+80Yw9P2u/QvlTyucukHLp3Nntx7caFfwpoPHHnQTq
         jv2omNirJc4v35NUTYGDsSuwTNj71Q4gPXCKYInfr4g0ot28X9EFEwG2jrxbRpPwjt
         drJlpwmp4C80wpUjqxzZTkWgjUpIaeRyGSl5+6IISnsNz0K6frjA61Xim/5Tx9Dv3F
         usC1Jwb3zwsOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.15 24/28] smb3: check xattr value length earlier
Date:   Sun, 14 Aug 2022 12:26:04 -0400
Message-Id: <20220814162610.2397644-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162610.2397644-1-sashal@kernel.org>
References: <20220814162610.2397644-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 5fa2cffba0b82336a2244d941322eb1627ff787b ]

Coverity complains about assigning a pointer based on
value length before checking that value length goes
beyond the end of the SMB.  Although this is even more
unlikely as value length is a single byte, and the
pointer is not dereferenced until laterm, it is clearer
to check the lengths first.

Addresses-Coverity: 1467704 ("Speculative execution data leak")
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 735aafee63be..07895e9d537c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1105,9 +1105,7 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 	size_t name_len, value_len, user_name_len;
 
 	while (src_size > 0) {
-		name = &src->ea_data[0];
 		name_len = (size_t)src->ea_name_length;
-		value = &src->ea_data[src->ea_name_length + 1];
 		value_len = (size_t)le16_to_cpu(src->ea_value_length);
 
 		if (name_len == 0)
@@ -1119,6 +1117,9 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 			goto out;
 		}
 
+		name = &src->ea_data[0];
+		value = &src->ea_data[src->ea_name_length + 1];
+
 		if (ea_name) {
 			if (ea_name_len == name_len &&
 			    memcmp(ea_name, name, name_len) == 0) {
-- 
2.35.1

