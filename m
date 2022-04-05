Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667074F30E8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236758AbiDEJDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237158AbiDEIRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E335694B7;
        Tue,  5 Apr 2022 01:05:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B7DAB81B7F;
        Tue,  5 Apr 2022 08:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF44BC385A2;
        Tue,  5 Apr 2022 08:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145928;
        bh=6+9kOnTAntUOhvfGm7xQGXJ5NZ8bUKFJ/hdZcBWcIkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLM6pyrxOmosHCQd7OzHK38rfZjSWcqZN1V9z/1JipGG8R7UOhErDzfxLmg0MRaa0
         qRpw8i0yOYLUiyE2kxRh++DnD81JopUbT0afYxbW7TXJrN77tie6PTrSnqGcmLj7Rj
         jEagGAm1eAX2cXwFlC+Wuf4QnVXB2RZJZLJ/UjoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aashish Sharma <shraash@google.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0579/1126] dm crypt: fix get_key_size compiler warning if !CONFIG_KEYS
Date:   Tue,  5 Apr 2022 09:22:06 +0200
Message-Id: <20220405070424.627167206@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Aashish Sharma <shraash@google.com>

[ Upstream commit 6fc51504388c1a1a53db8faafe9fff78fccc7c87 ]

Explicitly convert unsigned int in the right of the conditional
expression to int to match the left side operand and the return type,
fixing the following compiler warning:

drivers/md/dm-crypt.c:2593:43: warning: signed and unsigned
type in conditional expression [-Wsign-compare]

Fixes: c538f6ec9f56 ("dm crypt: add ability to use keys from the kernel key retention service")
Signed-off-by: Aashish Sharma <shraash@google.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d4ae31558826..f51aea71cb03 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2590,7 +2590,7 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 
 static int get_key_size(char **key_string)
 {
-	return (*key_string[0] == ':') ? -EINVAL : strlen(*key_string) >> 1;
+	return (*key_string[0] == ':') ? -EINVAL : (int)(strlen(*key_string) >> 1);
 }
 
 #endif /* CONFIG_KEYS */
-- 
2.34.1



