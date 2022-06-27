Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582D455D2B0
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbiF0Lqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236843AbiF0LpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:45:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79830DF3A;
        Mon, 27 Jun 2022 04:39:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4912B81123;
        Mon, 27 Jun 2022 11:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FA6C341C7;
        Mon, 27 Jun 2022 11:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329940;
        bh=LZEf909pHSiLWpkGshipQ2LNgivgihDRui4xRJSPfOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ho0ez39Md34FM1SbFzcYyaYFEpeawdlAWh2NeIo5wlQjr7KV3csfDA4rGHUVdgtTj
         SdkC0wb47rBMZGnHPx0HiVy8qpBG6J7e+QKKaRPY1WHiw9bQGrisQG10waYHAdpyPF
         47OlfLbUn+eaMDh1S9hPxMfTcdBCsjy5/hkyC5yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.18 030/181] dm: do not return early from dm_io_complete if BLK_STS_AGAIN without polling
Date:   Mon, 27 Jun 2022 13:20:03 +0200
Message-Id: <20220627111945.438082323@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

From: Mike Snitzer <snitzer@kernel.org>

commit 78ccef91234ba331c04d71f3ecb1377451d21056 upstream.

Commit 5291984004edf ("dm: fix bio polling to handle possibile
BLK_STS_AGAIN") inadvertently introduced an early return from
dm_io_complete() without first queueing the bio to DM if BLK_STS_AGAIN
occurs and bio-polling is _not_ being used.

Fix this by only returning early from dm_io_complete() if the bio has
first been properly queued to DM. Otherwise, the bio will never finish
via bio_endio.

Fixes: 5291984004edf ("dm: fix bio polling to handle possibile BLK_STS_AGAIN")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -899,9 +899,11 @@ static void dm_io_complete(struct dm_io
 			if (io_error == BLK_STS_AGAIN) {
 				/* io_uring doesn't handle BLK_STS_AGAIN (yet) */
 				queue_io(md, bio);
+				return;
 			}
 		}
-		return;
+		if (io_error == BLK_STS_DM_REQUEUE)
+			return;
 	}
 
 	if (bio_is_flush_with_data(bio)) {


