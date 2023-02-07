Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E148068D7A5
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjBGNB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjBGNBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:01:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901E439CFC
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:01:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70D35613DC
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71841C4339B;
        Tue,  7 Feb 2023 13:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774877;
        bh=w5JQsmd+idHfWEj3+FjUusmRJWIvJcB20o2WkD4QGys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+/kxqbAqmHqb5ZLCGGD1+pnlmUEkbvL+TaXXvwBOnCrwqprYCgKcBNRO8DdAJvIW
         As8N4/I2fctKQf7jlBT9JdcQVVGK3Je1APEhyxrAUzeRYnVvDiUqRefeh0JqzpgpUM
         xVkPgZesXxQ7vhB563aI5Aap4+nkjE1hcPFkL014=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/208] net/tls: tls_is_tx_ready() checked list_entry
Date:   Tue,  7 Feb 2023 13:55:18 +0100
Message-Id: <20230207125637.203075920@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit ffe2a22562444720b05bdfeb999c03e810d84cbb ]

tls_is_tx_ready() checks that list_first_entry() does not return NULL.
This condition can never happen. For empty lists, list_first_entry()
returns the list_entry() of the head, which is a type confusion.
Use list_first_entry_or_null() which returns NULL in case of empty
lists.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Link: https://lore.kernel.org/r/20230128-list-entry-null-check-tls-v1-1-525bbfe6f0d0@diag.uniroma1.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 9ed978634125..a83d2b4275fa 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2427,7 +2427,7 @@ static bool tls_is_tx_ready(struct tls_sw_context_tx *ctx)
 {
 	struct tls_rec *rec;
 
-	rec = list_first_entry(&ctx->tx_list, struct tls_rec, list);
+	rec = list_first_entry_or_null(&ctx->tx_list, struct tls_rec, list);
 	if (!rec)
 		return false;
 
-- 
2.39.0



