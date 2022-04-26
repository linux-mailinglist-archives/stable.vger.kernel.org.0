Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D8B50F4FF
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345354AbiDZIk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345814AbiDZIje (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:39:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D9A76293;
        Tue, 26 Apr 2022 01:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76BA4B81CF3;
        Tue, 26 Apr 2022 08:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAADC385A0;
        Tue, 26 Apr 2022 08:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961894;
        bh=5T3eTfQO08G5FmqikWHLKnbCUxqKl/QAJjfaLnqdXfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lor8HovSYpCupsAKpoNvLwgEjct/lfADAIBhqEG18IinOIqKe4mmMY7wtxGeco/zH
         JJ7Yw31t6dKPky4MAvSjBqwSDNEG6fQqnU1O45FZ5XZnOtCx+gZWuRRHlqPyCBospy
         DQQAuXpK38xHgS/nfXVCRu+mKnAbUlDUmIxH32X0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James Hutchinson <jahutchinson99@googlemail.com>,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 49/62] e1000e: Fix possible overflow in LTR decoding
Date:   Tue, 26 Apr 2022 10:21:29 +0200
Message-Id: <20220426081738.628092897@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

commit 04ebaa1cfddae5f240cc7404f009133bb0389a47 upstream.

When we decode the latency and the max_latency, u16 value may not fit
the required size and could lead to the wrong LTR representation.

Scaling is represented as:
scale 0 - 1         (2^(5*0)) = 2^0
scale 1 - 32        (2^(5 *1))= 2^5
scale 2 - 1024      (2^(5 *2)) =2^10
scale 3 - 32768     (2^(5 *3)) =2^15
scale 4 - 1048576   (2^(5 *4)) = 2^20
scale 5 - 33554432  (2^(5 *4)) = 2^25
scale 4 and scale 5 required 20 and 25 bits respectively.
scale 6 reserved.

Replace the u16 type with the u32 type and allow corrected LTR
representation.

Cc: stable@vger.kernel.org
Fixes: 44a13a5d99c7 ("e1000e: Fix the max snoop/no-snoop latency for 10M")
Reported-by: James Hutchinson <jahutchinson99@googlemail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215689
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Tested-by: James Hutchinson <jahutchinson99@googlemail.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -995,8 +995,8 @@ static s32 e1000_platform_pm_pch_lpt(str
 {
 	u32 reg = link << (E1000_LTRV_REQ_SHIFT + E1000_LTRV_NOSNOOP_SHIFT) |
 	    link << E1000_LTRV_REQ_SHIFT | E1000_LTRV_SEND;
-	u16 max_ltr_enc_d = 0;	/* maximum LTR decoded by platform */
-	u16 lat_enc_d = 0;	/* latency decoded */
+	u32 max_ltr_enc_d = 0;	/* maximum LTR decoded by platform */
+	u32 lat_enc_d = 0;	/* latency decoded */
 	u16 lat_enc = 0;	/* latency encoded */
 
 	if (link) {


