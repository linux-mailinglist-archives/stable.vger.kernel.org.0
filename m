Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3BE85581D1
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiFWRGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiFWRFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:05:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AF0517EE;
        Thu, 23 Jun 2022 09:55:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0918360AD7;
        Thu, 23 Jun 2022 16:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2651C3411B;
        Thu, 23 Jun 2022 16:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003333;
        bh=wKMkV5rfQc+zDw2NvKbWHa6wP6CeVEtieC64LbcrhLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N95q3NTJIl9zKcS/PDu/ubKBPm5F/OM0dr1rEa33Cz6U4HhFcresUm6kuO7R7Ng3D
         7bzKPgH1HEwi3cnoHegNnMHnNo3Nek8omVPbDBM6F1slpkVCCgFTBtwWXHJuAiRU4E
         xN0yO90ufWIxaIWquNeQIX6fxLpPJiY86F2f1/8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 203/264] random: use proper jiffies comparison macro
Date:   Thu, 23 Jun 2022 18:43:16 +0200
Message-Id: <20220623164349.814560964@linuxfoundation.org>
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
@@ -325,7 +325,7 @@ static bool crng_has_old_seed(void)
 			interval = max_t(unsigned int, CRNG_RESEED_START_INTERVAL,
 					 (unsigned int)uptime / 2 * HZ);
 	}
-	return time_after(jiffies, READ_ONCE(base_crng.birth) + interval);
+	return time_is_before_jiffies(READ_ONCE(base_crng.birth) + interval);
 }
 
 /*


