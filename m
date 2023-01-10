Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B8D6648B9
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238811AbjAJSOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239077AbjAJSNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:13:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49758FCF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:12:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3828461871
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1C8C433F0;
        Tue, 10 Jan 2023 18:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374324;
        bh=KoA8v2Anve2Hy3NsYGykVYAmzhdRQY2RqcDs1xt48xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaa65bvhQ8ozWtzmSgn1uJ/Rh3c9jf52EYJR1OFaLjaSTqHmKTeqgg+Eb9gTPG864
         QVqOA2Q9jYROU68JiggqigvqHpPD7leE0QvM8i4dsYTvKeWNgA64qQeOAAB//ycC+M
         /JPIVcUcDSGiHWLHbDyLbM6MlUpYgyl2VdU9EGnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Kelley <mikelley@microsoft.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 130/148] block: dont allow splitting of a REQ_NOWAIT bio
Date:   Tue, 10 Jan 2023 19:03:54 +0100
Message-Id: <20230110180021.308674383@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 9cea62b2cbabff8ed46f2df17778b624ad9dd25a upstream.

If we split a bio marked with REQ_NOWAIT, then we can trigger spurious
EAGAIN if constituent parts of that split bio end up failing request
allocations. Parts will complete just fine, but just a single failure
in one of the chained bios will yield an EAGAIN final result for the
parent bio.

Return EAGAIN early if we end up needing to split such a bio, which
allows for saner recovery handling.

Cc: stable@vger.kernel.org # 5.15+
Link: https://github.com/axboe/liburing/issues/766
Reported-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-merge.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -300,6 +300,16 @@ static struct bio *bio_split_rw(struct b
 	*segs = nsegs;
 	return NULL;
 split:
+	/*
+	 * We can't sanely support splitting for a REQ_NOWAIT bio. End it
+	 * with EAGAIN if splitting is required and return an error pointer.
+	 */
+	if (bio->bi_opf & REQ_NOWAIT) {
+		bio->bi_status = BLK_STS_AGAIN;
+		bio_endio(bio);
+		return ERR_PTR(-EAGAIN);
+	}
+
 	*segs = nsegs;
 
 	/*


