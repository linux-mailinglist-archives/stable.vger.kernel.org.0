Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069544C75AB
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239325AbiB1Rz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240705AbiB1Ryb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140F02980F;
        Mon, 28 Feb 2022 09:42:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B6AD615B4;
        Mon, 28 Feb 2022 17:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45A4C340E7;
        Mon, 28 Feb 2022 17:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070165;
        bh=oYdLpNFMJoWpUsGNteMjbuQJIBxw4NVt3rpKOLt7l1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmA66K7YEdZ9Y48g2ATfA85hzd1XEBiCVZWKsKf71XbzRgf7dUhZx0voMzK+lDVPS
         bflwEOhbkdBJtd4R3/BI9qJiD1Q9u5N9FjakW8ZHilTBm9WqUDGACS9gkhxmeK6hX9
         dnlUBh2Q9GF3jDJ2PeSAB0JL5lIZqZucH0XL+fag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.16 010/164] selinux: fix misuse of mutex_is_locked()
Date:   Mon, 28 Feb 2022 18:22:52 +0100
Message-Id: <20220228172400.731941088@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
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

From: Ondrej Mosnacek <omosnace@redhat.com>

commit ce2fc710c9d2b25afc710f49bb2065b4439a62bc upstream.

mutex_is_locked() tests whether the mutex is locked *by any task*, while
here we want to test if it is held *by the current task*. To avoid
false/missed WARNINGs, use lockdep_assert_is_held() and
lockdep_assert_is_not_held() instead, which do the right thing (though
they are a no-op if CONFIG_LOCKDEP=n).

Cc: stable@vger.kernel.org
Fixes: 2554a48f4437 ("selinux: measure state and policy capabilities")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ima.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/security/selinux/ima.c
+++ b/security/selinux/ima.c
@@ -77,7 +77,7 @@ void selinux_ima_measure_state_locked(st
 	size_t policy_len;
 	int rc = 0;
 
-	WARN_ON(!mutex_is_locked(&state->policy_mutex));
+	lockdep_assert_held(&state->policy_mutex);
 
 	state_str = selinux_ima_collect_state(state);
 	if (!state_str) {
@@ -117,7 +117,7 @@ void selinux_ima_measure_state_locked(st
  */
 void selinux_ima_measure_state(struct selinux_state *state)
 {
-	WARN_ON(mutex_is_locked(&state->policy_mutex));
+	lockdep_assert_not_held(&state->policy_mutex);
 
 	mutex_lock(&state->policy_mutex);
 	selinux_ima_measure_state_locked(state);


