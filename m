Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA9D59E380
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241930AbiHWMWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357882AbiHWMVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:21:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DB06147;
        Tue, 23 Aug 2022 02:43:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CF55B81C98;
        Tue, 23 Aug 2022 09:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F52C433D6;
        Tue, 23 Aug 2022 09:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247786;
        bh=pr4GpRToBJONOYmLbcX8Okfc8+U2+Ypy9bPPWkcUgBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wIODooaSuAgJhEJjBl3MUKSCQ4PyHDyHwTV1VKX/D1Huv7ENc7FngWMJjZP7bQlyT
         MMQ2TyCowOokPC0q8kYmA8qXVauZCk2IWOCPjo+xRf7XBfclvkL+YAhqfe/NhLQsIb
         uTrLLYp9PYrZthlpXOUlQkyJU5bbdWEr6zHGOJkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 147/158] smb3: check xattr value length earlier
Date:   Tue, 23 Aug 2022 10:27:59 +0200
Message-Id: <20220823080051.751648357@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b855abfaaf87..b6d72e3c5eba 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1000,9 +1000,7 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 	size_t name_len, value_len, user_name_len;
 
 	while (src_size > 0) {
-		name = &src->ea_data[0];
 		name_len = (size_t)src->ea_name_length;
-		value = &src->ea_data[src->ea_name_length + 1];
 		value_len = (size_t)le16_to_cpu(src->ea_value_length);
 
 		if (name_len == 0)
@@ -1014,6 +1012,9 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
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



