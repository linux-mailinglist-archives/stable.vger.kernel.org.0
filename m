Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD13558102
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbiFWQzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbiFWQu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:50:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CBB4EA12;
        Thu, 23 Jun 2022 09:48:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEAF2B82490;
        Thu, 23 Jun 2022 16:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF6BC3411B;
        Thu, 23 Jun 2022 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002897;
        bh=Ddg1gfGWpnvl1shfneyA+XSeB3QnW3yp84eQDhHFI0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CskNbn/RmE5rW880uFaEExnis0OWSM5qrETF219v/TTdC2lyWay86wNN1fANEaCwd
         XDUFL0S4AkK2BvVdSDEqnGI4Fk01uim/J5jdLxt4uHx2S5GqsLOhDdumGmCspuSS8A
         /4lYmx3Z1+/qAD/kiEOsfeUJlRvu/xMUtFpKzDmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 062/264] random: remove unnecessary unlikely()
Date:   Thu, 23 Jun 2022 18:40:55 +0200
Message-Id: <20220623164345.826929831@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

commit 870e05b1b18814911cb2703a977f447cb974f0f9 upstream.

WARN_ON() already contains an unlikely(), so it's not necessary to use
unlikely.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Link: https://lore.kernel.org/r/20190607182517.28266-1-tiny.windzz@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -739,10 +739,9 @@ retry:
 		} while (unlikely(entropy_count < pool_size-2 && pnfrac));
 	}
 
-	if (unlikely(entropy_count < 0)) {
+	if (WARN_ON(entropy_count < 0)) {
 		pr_warn("random: negative entropy/overflow: pool %s count %d\n",
 			r->name, entropy_count);
-		WARN_ON(1);
 		entropy_count = 0;
 	} else if (entropy_count > pool_size)
 		entropy_count = pool_size;
@@ -1432,10 +1431,9 @@ retry:
 	if (ibytes < min)
 		ibytes = 0;
 
-	if (unlikely(entropy_count < 0)) {
+	if (WARN_ON(entropy_count < 0)) {
 		pr_warn("random: negative entropy count: pool %s count %d\n",
 			r->name, entropy_count);
-		WARN_ON(1);
 		entropy_count = 0;
 	}
 	nfrac = ibytes << (ENTROPY_SHIFT + 3);


