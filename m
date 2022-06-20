Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F7E551CC6
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346437AbiFTNet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347074AbiFTNd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:33:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6B72717C;
        Mon, 20 Jun 2022 06:13:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A07FB811BF;
        Mon, 20 Jun 2022 13:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312CEC3411B;
        Mon, 20 Jun 2022 13:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730746;
        bh=/34Tt39GUWSoy+Q3pQqNRnI1EB/UlCXitZI7zQwu2Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/VTwAIrXJfGD59rvaVhCDeiazoZUTZ4pWxsWNIq9EkRoBRwCZkRIjvY+bAl41Mmp
         qamsyd0NlUlnehf4n/W8CGauCFFh4hII3NH5t8XDP08ovmOJKVfVEHM/MM7p9NTwNU
         UCO0W071b9KUZcO7VkvZioTHCc4V59yo0MNPmViI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 043/240] random: harmonize "crng init done" messages
Date:   Mon, 20 Jun 2022 14:49:04 +0200
Message-Id: <20220620124739.257001778@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit 161212c7fd1d9069b232785c75492e50941e2ea8 upstream.

We print out "crng init done" for !TRUST_CPU, so we should also print
out the same for TRUST_CPU.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -832,7 +832,7 @@ static void __init crng_initialize_prima
 		invalidate_batched_entropy();
 		numa_crng_init();
 		crng_init = 2;
-		pr_notice("crng done (trusting CPU's manufacturer)\n");
+		pr_notice("crng init done (trusting CPU's manufacturer)\n");
 	}
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }


