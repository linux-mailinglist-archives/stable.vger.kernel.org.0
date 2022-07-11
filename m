Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0547D55DAE0
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbiF0L3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbiF0L3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:29:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85CC131;
        Mon, 27 Jun 2022 04:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 756D061456;
        Mon, 27 Jun 2022 11:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3219DC3411D;
        Mon, 27 Jun 2022 11:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329293;
        bh=A2migJAf3lhueRVP05DdDRYtA3dnSY0+3MDuPOjx5+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAmAoMrlsvb2u5BBuRiwM8uhJF2lfGDY3c2Lt6sqKnIn1uioYN4eCrk7BHkpCZ2ah
         Kqkmp2PrtXofyWCiNKWl/9nyPpLme21UtopVYtIjDPsKkstMpCfJ7j2tu1zRSu+OD3
         xADEP9DHJ504ES2nVlOh+AJ1dtT/1tTO7MUY1xRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Marzinski <bmarzins@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 12/60] dm mirror log: clear log bits up to BITS_PER_LONG boundary
Date:   Mon, 27 Jun 2022 13:21:23 +0200
Message-Id: <20220627111928.015873235@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 90736eb3232d208ee048493f371075e4272e0944 upstream.

Commit 85e123c27d5c ("dm mirror log: round up region bitmap size to
BITS_PER_LONG") introduced a regression on 64-bit architectures in the
lvm testsuite tests: lvcreate-mirror, mirror-names and vgsplit-operation.

If the device is shrunk, we need to clear log bits beyond the end of the
device. The code clears bits up to a 32-bit boundary and then calculates
lc->sync_count by summing set bits up to a 64-bit boundary (the commit
changed that; previously, this boundary was 32-bit too). So, it was using
some non-zeroed bits in the calculation and this caused misbehavior.

Fix this regression by clearing bits up to BITS_PER_LONG boundary.

Fixes: 85e123c27d5c ("dm mirror log: round up region bitmap size to BITS_PER_LONG")
Cc: stable@vger.kernel.org
Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -615,7 +615,7 @@ static int disk_resume(struct dm_dirty_l
 			log_clear_bit(lc, lc->clean_bits, i);
 
 	/* clear any old bits -- device has shrunk */
-	for (i = lc->region_count; i % (sizeof(*lc->clean_bits) << BYTE_SHIFT); i++)
+	for (i = lc->region_count; i % BITS_PER_LONG; i++)
 		log_clear_bit(lc, lc->clean_bits, i);
 
 	/* copy clean across to sync */


