Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FCA55840A
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbiFWRj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbiFWRiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:38:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC8C51E61;
        Thu, 23 Jun 2022 10:07:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A786F60B2C;
        Thu, 23 Jun 2022 17:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C6BC3411B;
        Thu, 23 Jun 2022 17:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004053;
        bh=wvyHoClL7ERvP595o/9+eYZSIUBBJhySOGYGJJR06BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8aTq9yiuHc7ZLQBSW+/3734a4imfVW3EtPFIdJ1rwIpitKuId4DJwnodkYgtw7wY
         0pUgCKmEVxRi6/1NmcP3Q+2o2ydKvu2pUOChe5/WcHfAcLs60mqexh2Ucb6GqQs2tT
         bQSAhfhJLE5BDLEGcGT74TAdy3qXEDOf9dmpraJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 172/237] random: use proper jiffies comparison macro
Date:   Thu, 23 Jun 2022 18:43:26 +0200
Message-Id: <20220623164348.101232996@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 8a5b8a4a4ceb353b4dd5bafd09e2b15751bcdb51 upstream.

This expands to exactly the same code that it replaces, but makes things
consistent by using the same macro for jiffy comparisons throughout.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -324,7 +324,7 @@ static bool crng_has_old_seed(void)
 			interval = max_t(unsigned int, CRNG_RESEED_START_INTERVAL,
 					 (unsigned int)uptime / 2 * HZ);
 	}
-	return time_after(jiffies, READ_ONCE(base_crng.birth) + interval);
+	return time_is_before_jiffies(READ_ONCE(base_crng.birth) + interval);
 }
 
 /*


