Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A04657D6C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbiL1PnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiL1PnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:43:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B9F17068
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:43:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6BF9B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36597C433EF;
        Wed, 28 Dec 2022 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242180;
        bh=XnTi9FcTf0AmtoOMr2gqYVbtxiOYs+MFc/cV4YioQHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3EihMNeK6XArlwbfACO4RJHLZRkg2Apu+Atkq4weORmrh2EOOvT3neB1i7lsed9u
         jWwtKhGJzWGTT9rPH2siHZD090+btlNpt7W2LIgPIl8BVyYu9ktiwKsOMhOCHb2lXd
         47VP2kkfGELXtgsas9jdE90eH3Lk+/QT9IDPNMjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, GUO Zihua <guozihua@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0338/1146] integrity: Fix memory leakage in keyring allocation error path
Date:   Wed, 28 Dec 2022 15:31:17 +0100
Message-Id: <20221228144339.339251038@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 8a82a6c7f48a..f2193c531f4a 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -126,6 +126,7 @@ int __init integrity_init_keyring(const unsigned int id)
 {
 	struct key_restriction *restriction;
 	key_perm_t perm;
+	int ret;
 
 	perm = (KEY_POS_ALL & ~KEY_POS_SETATTR) | KEY_USR_VIEW
 		| KEY_USR_READ | KEY_USR_SEARCH;
@@ -154,7 +155,10 @@ int __init integrity_init_keyring(const unsigned int id)
 		perm |= KEY_USR_WRITE;
 
 out:
-	return __integrity_init_keyring(id, perm, restriction);
+	ret = __integrity_init_keyring(id, perm, restriction);
+	if (ret)
+		kfree(restriction);
+	return ret;
 }
 
 static int __init integrity_add_key(const unsigned int id, const void *data,
-- 
2.35.1



