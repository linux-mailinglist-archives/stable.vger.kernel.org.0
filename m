Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3A46674E1
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbjALOPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235345AbjALOOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:14:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90985C908
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:06:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 785A362014
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E2AC433D2;
        Thu, 12 Jan 2023 14:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532408;
        bh=YiyV8zWoNEHoS6O2/wYwT2h5G7m0Wj9gvhJbJaeFG2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1fMM/i+MNeNXr5+8WmSlxikbQ004WMrQAk+Js2eRWlqxu1hzF5e9O0ot/ODf019zP
         dRXSJ0QPIIU5Hr3HLn4e6qOEyWcFEhh75Ygo6ON1uHFYR7v7Y2Mm61MLoYVslw7nMu
         oQnhD/WSGBrH7oHkGdRuDhW23WXWLXxnkv8AUVTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, GUO Zihua <guozihua@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/783] integrity: Fix memory leakage in keyring allocation error path
Date:   Thu, 12 Jan 2023 14:47:49 +0100
Message-Id: <20230112135531.442734600@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: GUO Zihua <guozihua@huawei.com>

[ Upstream commit 39419ef7af0916cc3620ecf1ed42d29659109bf3 ]

Key restriction is allocated in integrity_init_keyring(). However, if
keyring allocation failed, it is not freed, causing memory leaks.

Fixes: 2b6aa412ff23 ("KEYS: Use structure to capture key restriction function and data")
Signed-off-by: GUO Zihua <guozihua@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/digsig.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 0f518dcfde05..de442af7b336 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -120,6 +120,7 @@ int __init integrity_init_keyring(const unsigned int id)
 {
 	struct key_restriction *restriction;
 	key_perm_t perm;
+	int ret;
 
 	perm = (KEY_POS_ALL & ~KEY_POS_SETATTR) | KEY_USR_VIEW
 		| KEY_USR_READ | KEY_USR_SEARCH;
@@ -140,7 +141,10 @@ int __init integrity_init_keyring(const unsigned int id)
 	perm |= KEY_USR_WRITE;
 
 out:
-	return __integrity_init_keyring(id, perm, restriction);
+	ret = __integrity_init_keyring(id, perm, restriction);
+	if (ret)
+		kfree(restriction);
+	return ret;
 }
 
 int __init integrity_add_key(const unsigned int id, const void *data,
-- 
2.35.1



