Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9BAF59DBC1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359183AbiHWMDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359568AbiHWMB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:01:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D4497D7A;
        Tue, 23 Aug 2022 02:36:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 357AC60F50;
        Tue, 23 Aug 2022 09:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A995C433D6;
        Tue, 23 Aug 2022 09:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247376;
        bh=BynSNA2pLc0++aOd/nVe1u0EbpDodCq+xxgBLeUp6rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWBwAPKzQUB+s+5vbxqkdoOPP4A6GBkHUmT2sZy067fYGjrE2xvuCHRzGNPjQdr9k
         ZkvY8RZocakcmOe+Aq4xmJ0URSq+v1DvwlFK55kTabHOZptosMIA4pOBdVMGV/ohMU
         WknSPjnIyoyAa+0svmmW1LFjv+shR7d/qtb9OfzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.10 017/158] apparmor: fix setting unconfined mode on a loaded profile
Date:   Tue, 23 Aug 2022 10:25:49 +0200
Message-Id: <20220823080046.769431105@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

commit 3bbb7b2e9bbcd22e539e23034da753898fe3b4dc upstream.

When loading a profile that is set to unconfined mode, that label
flag is not set when it should be. Ensure it is set so that when
used in a label the unconfined check will be applied correctly.

Fixes: 038165070aa5 ("apparmor: allow setting any profile into the unconfined state")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy_unpack.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -746,16 +746,18 @@ static struct aa_profile *unpack_profile
 		profile->label.flags |= FLAG_HAT;
 	if (!unpack_u32(e, &tmp, NULL))
 		goto fail;
-	if (tmp == PACKED_MODE_COMPLAIN || (e->version & FORCE_COMPLAIN_FLAG))
+	if (tmp == PACKED_MODE_COMPLAIN || (e->version & FORCE_COMPLAIN_FLAG)) {
 		profile->mode = APPARMOR_COMPLAIN;
-	else if (tmp == PACKED_MODE_ENFORCE)
+	} else if (tmp == PACKED_MODE_ENFORCE) {
 		profile->mode = APPARMOR_ENFORCE;
-	else if (tmp == PACKED_MODE_KILL)
+	} else if (tmp == PACKED_MODE_KILL) {
 		profile->mode = APPARMOR_KILL;
-	else if (tmp == PACKED_MODE_UNCONFINED)
+	} else if (tmp == PACKED_MODE_UNCONFINED) {
 		profile->mode = APPARMOR_UNCONFINED;
-	else
+		profile->label.flags |= FLAG_UNCONFINED;
+	} else {
 		goto fail;
+	}
 	if (!unpack_u32(e, &tmp, NULL))
 		goto fail;
 	if (tmp)


