Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1F56356FB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237910AbiKWJhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237607AbiKWJgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:36:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B12F105ABA
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:34:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EF72B81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63564C433D7;
        Wed, 23 Nov 2022 09:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196046;
        bh=26dPqmVMcre4ytCuwSsTGLEgFwUH0WSOQZihYVuXXSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjdHXjye2KQi5/sS/VF5K4PBUmEgS1StiwWTa5K6xVWyNmig88eB4y7Em6cvuOwFd
         Ufp77uO8Y/poolYNLnLQ0h2fTUt+qOCK7HYKPolSx4XoQRxzdi691HCSXly2HCe4bb
         Ancr4ptivrzK3PGRRS9FYwuGWap10gLPlH5l9Hwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anastasia Belova <abelova@astralinux.ru>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/181] cifs: add check for returning value of SMB2_set_info_init
Date:   Wed, 23 Nov 2022 09:51:08 +0100
Message-Id: <20221123084606.864935716@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Anastasia Belova <abelova@astralinux.ru>

[ Upstream commit a51e5d293dd1c2e7bf6f7be788466cd9b5d280fb ]

If the returning value of SMB2_set_info_init is an error-value,
exit the function.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0967e5457954 ("cifs: use a compound for setting an xattr")

Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 30b2efafa2de..53e87466e3b2 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1361,6 +1361,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 				COMPOUND_FID, current->tgid,
 				FILE_FULL_EA_INFORMATION,
 				SMB2_O_INFO_FILE, 0, data, size);
+	if (rc)
+		goto sea_exit;
 	smb2_set_next_command(tcon, &rqst[1]);
 	smb2_set_related(&rqst[1]);
 
-- 
2.35.1



