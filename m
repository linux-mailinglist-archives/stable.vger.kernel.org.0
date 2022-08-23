Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D48F59D742
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243084AbiHWJmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352083AbiHWJkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:40:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725F7402FA;
        Tue, 23 Aug 2022 01:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06255B81C5A;
        Tue, 23 Aug 2022 08:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348B1C433D6;
        Tue, 23 Aug 2022 08:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244077;
        bh=sZHTj6NlHV1gKfCIF3Oh0sM2abCOlzPAapitMOgNRbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q90JOrQjI8UnHtAuofmA7pUS2lPDoiZUwYDqzW/nQa+1hWul4F99opK1wzePonrMq
         +6leH7VJfRGzumAOply8RBwXUkpEDejtYzwsAURd1ZkEYnMzUUznhvS+nP2S1dOmYN
         v7r8Vjmud67TVGvMOiPMDQ5IetaInfNHvlFmM5MQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.15 033/244] apparmor: fix overlapping attachment computation
Date:   Tue, 23 Aug 2022 10:23:12 +0200
Message-Id: <20220823080100.171767098@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

commit 2504db207146543736e877241f3b3de005cbe056 upstream.

When finding the profile via patterned attachments, the longest left
match is being set to the static compile time value and not using the
runtime computed value.

Fix this by setting the candidate value to the greater of the
precomputed value or runtime computed value.

Fixes: 21f606610502 ("apparmor: improve overlapping domain attachment resolution")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/domain.c         |    2 +-
 security/apparmor/include/policy.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -467,7 +467,7 @@ restart:
 				 * xattrs, or a longer match
 				 */
 				candidate = profile;
-				candidate_len = profile->xmatch_len;
+				candidate_len = max(count, profile->xmatch_len);
 				candidate_xattrs = ret;
 				conflict = false;
 			}
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -135,7 +135,7 @@ struct aa_profile {
 
 	const char *attach;
 	struct aa_dfa *xmatch;
-	int xmatch_len;
+	unsigned int xmatch_len;
 	enum audit_mode audit;
 	long mode;
 	u32 path_flags;


