Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68BE56FC97
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbiGKJp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbiGKJoo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:44:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9245D2BB0E;
        Mon, 11 Jul 2022 02:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7115061283;
        Mon, 11 Jul 2022 09:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F51FC34115;
        Mon, 11 Jul 2022 09:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531335;
        bh=WvrECEWfwpgZ3U7b0mnKDdps2mWNuLBNzbWv509ML6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqAmbPl1fgeFtiy/uzdkEZL0qCvb/wjGlunZ/wyuS3z4QM0R+iMgt5pHYgSWX8slV
         6Krd940nqNc7Dmk6fiSigTRxrJ162t7asTrMcLvmDCUM7o5SdoQjDidliL2oAwOzrY
         NbhMgA1eJPj0HFdwV5S4wwZZ+CdzxkASrJ9UrHfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/230] block: only mark bio as tracked if it really is tracked
Date:   Mon, 11 Jul 2022 11:05:24 +0200
Message-Id: <20220711090606.006275650@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 90b8faa0e8de1b02b619fb33f6c6e1e13e7d1d70 ]

We set BIO_TRACKED unconditionally when rq_qos_throttle() is called, even
though we may not even have an rq_qos handler. Only mark it as TRACKED if
it really is potentially tracked.

This saves considerable time for the case where the bio isn't tracked:

     2.64%     -1.65%  [kernel.vmlinux]  [k] bio_endio

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-rq-qos.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index f000f83e0621..3cfbc8668cba 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -189,9 +189,10 @@ static inline void rq_qos_throttle(struct request_queue *q, struct bio *bio)
 	 * BIO_TRACKED lets controllers know that a bio went through the
 	 * normal rq_qos path.
 	 */
-	bio_set_flag(bio, BIO_TRACKED);
-	if (q->rq_qos)
+	if (q->rq_qos) {
+		bio_set_flag(bio, BIO_TRACKED);
 		__rq_qos_throttle(q->rq_qos, bio);
+	}
 }
 
 static inline void rq_qos_track(struct request_queue *q, struct request *rq,
-- 
2.35.1



