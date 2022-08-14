Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D23E592524
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243128AbiHNQiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242957AbiHNQh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:37:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF01D1C11E;
        Sun, 14 Aug 2022 09:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CE08B80B37;
        Sun, 14 Aug 2022 16:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65309C43470;
        Sun, 14 Aug 2022 16:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494550;
        bh=9SfeYFIkUxV4kzA0oTEj7SB4EtELhFUNxGS1fzUs1Ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=am8jsWNHsXZGimAkMpH6DHCjuIDZe59QEk9yFryekNJFwdynwZZQbg8Q1B+DidpL0
         7BtPjXTBTSinkyiX5TR88dsHBlqEHcH00E+snK2ZG3bgBhn/DrvJw6ZGAOO2LQcYKT
         ua9wiMkH9nkXBUjiWTskUXoQbj16a4b6fgXDY+IJlSp2WPk0r51Xiz2v4BwFVF56OZ
         UqPBlVNPJyxZcOtRFxLWSMg/fbYO5DPZu893g1AzDutWiFVu8rNgLh7nDeQ0IpUwVF
         q/JP5uLeK4mPKP6+F0Ud4NCyg+sGe3kWdEr2eC6AbjUG3KA4SEnibm5M4rAzn8E1N0
         EMIyJcjhv8QfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 13/16] smb3: check xattr value length earlier
Date:   Sun, 14 Aug 2022 12:28:28 -0400
Message-Id: <20220814162833.2398478-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162833.2398478-1-sashal@kernel.org>
References: <20220814162833.2398478-1-sashal@kernel.org>
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
index 57164563eec6..6ae281cff0d5 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -960,9 +960,7 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 	size_t name_len, value_len, user_name_len;
 
 	while (src_size > 0) {
-		name = &src->ea_data[0];
 		name_len = (size_t)src->ea_name_length;
-		value = &src->ea_data[src->ea_name_length + 1];
 		value_len = (size_t)le16_to_cpu(src->ea_value_length);
 
 		if (name_len == 0)
@@ -974,6 +972,9 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
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

