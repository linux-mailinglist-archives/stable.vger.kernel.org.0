Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7C163592F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbiKWKI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236778AbiKWKIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:08:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28CF54B1B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:58:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFE0B61B5F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2142C433C1;
        Wed, 23 Nov 2022 09:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197482;
        bh=8c+6djlqgElR9yErWZlCKtrSSvUjTzJ5YFeukv8w3Wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrTnJL6NIbz6x5FsmcHjhNmBPMWT7dHML6hlqQTI5CmHcyV8+9yfYFPonMiutzD2a
         o8F5dhPTSZuFAI0efxM0op9kDtxCUqTR8SDL+YVVIKky4Sq2H0RnkGvtsXPFhqbDof
         Dm9gu6Cu26fehMs+7/RlVNxYVp/jz2rWGjRysH1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Mason <clm@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Jens Axboe <axboe@kernel.dk>, Rik van Riel <riel@surriel.com>
Subject: [PATCH 6.0 276/314] blk-cgroup: properly pin the parent in blkcg_css_online
Date:   Wed, 23 Nov 2022 09:52:01 +0100
Message-Id: <20221123084638.040660384@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Chris Mason <clm@fb.com>

commit d7dbd43f4a828fa1d9a8614d5b0ac40aee6375fe upstream.

blkcg_css_online is supposed to pin the blkcg of the parent, but
397c9f46ee4d refactored things and along the way, changed it to pin the
css instead.  This results in extra pins, and we end up leaking blkcgs
and cgroups.

Fixes: 397c9f46ee4d ("blk-cgroup: move blkcg_{pin,unpin}_online out of line")
Signed-off-by: Chris Mason <clm@fb.com>
Spotted-by: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org> # v5.19+
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://lore.kernel.org/r/20221114181930.2093706-1-clm@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1251,7 +1251,7 @@ static int blkcg_css_online(struct cgrou
 	 * parent so that offline always happens towards the root.
 	 */
 	if (parent)
-		blkcg_pin_online(css);
+		blkcg_pin_online(&parent->css);
 	return 0;
 }
 


