Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41C859DDE3
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356078AbiHWKtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356346AbiHWKrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:47:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B573586B59;
        Tue, 23 Aug 2022 02:11:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40EEF60F50;
        Tue, 23 Aug 2022 09:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D115C433D6;
        Tue, 23 Aug 2022 09:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245906;
        bh=J1OQH30u8/si5yEbyQ4z0MiHnttBlN//30HHIi/nk44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDbeEpxLkeWmCqIgXdsTp2QH7sDiFmRyumSPTU0vyOhwl2Bs90u3Eqz4RH5Pb/vI4
         T1ozImuRKw5XFmiFeQFzjLioWY8QMdalgbpUA/vhgiTP6sdKu14F1oSHMGHfPigjz6
         E6rHqPnfBefVAYau43wwL7QYkPlCA7dtFSHm1aXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 4.19 227/287] apparmor: fix overlapping attachment computation
Date:   Tue, 23 Aug 2022 10:26:36 +0200
Message-Id: <20220823080108.649059844@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
@@ -464,7 +464,7 @@ restart:
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
@@ -139,7 +139,7 @@ struct aa_profile {
 
 	const char *attach;
 	struct aa_dfa *xmatch;
-	int xmatch_len;
+	unsigned int xmatch_len;
 	enum audit_mode audit;
 	long mode;
 	u32 path_flags;


