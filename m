Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB069558078
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiFWQqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbiFWQqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:46:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD2349241;
        Thu, 23 Jun 2022 09:46:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 324AAB82486;
        Thu, 23 Jun 2022 16:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C90C3411B;
        Thu, 23 Jun 2022 16:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002769;
        bh=TrzbbqsCtrXJjCT0Qc2UXZVSDOTNsRyLQf4EYboMBUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Doz0k7zzCS38aNrlHRWujsyHrndUWieUJA97BvPk0YiKeFoaaG0rUkV6zkf6dZMa5
         dekePoYX5FgdVD9TbOrJDRyzjDBwHyaTQEwafJA3DMZuVPCqTVWj+e8zWnTTKEOAu/
         BTlaTj7y1AYi4lWGz3De/oVflPEmrUsVEj70VAMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Mueller <smueller@chronox.de>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 002/264] random: remove stale maybe_reseed_primary_crng
Date:   Thu, 23 Jun 2022 18:39:55 +0200
Message-Id: <20220623164344.127505498@linuxfoundation.org>
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

From: Stephan Mueller <stephan.mueller@atsec.com>

commit 3d071d8da1f586c24863a57349586a1611b9aa67 upstream.

The function maybe_reseed_primary_crng is not used anywhere and thus can
be removed.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -931,13 +931,6 @@ static void crng_reseed(struct crng_stat
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
-static inline void maybe_reseed_primary_crng(void)
-{
-	if (crng_init > 2 &&
-	    time_after(jiffies, primary_crng.init_time + CRNG_RESEED_INTERVAL))
-		crng_reseed(&primary_crng, &input_pool);
-}
-
 static inline void crng_wait_ready(void)
 {
 	wait_event_interruptible(crng_init_wait, crng_ready());


