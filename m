Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C63359D38D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241717AbiHWIMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241984AbiHWIKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F95E0F5;
        Tue, 23 Aug 2022 01:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC207B81C18;
        Tue, 23 Aug 2022 08:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D88C43470;
        Tue, 23 Aug 2022 08:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242009;
        bh=BynSNA2pLc0++aOd/nVe1u0EbpDodCq+xxgBLeUp6rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pP86Il+04/myRUji9LglaWvEqDY0jlK7pfHGUFMIyeEcgc807pxf/Ehfg06ofHoQq
         Cl7OEMfwoSN1moJon9fvA1WPl3I4WumPSveda/nwTC9alzh6Bakq0HZh8YWFxyro14
         i5IBwuIPJDCenehJorXRLj2h3sRC5iz25PSAzvSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.19 045/365] apparmor: fix setting unconfined mode on a loaded profile
Date:   Tue, 23 Aug 2022 09:59:06 +0200
Message-Id: <20220823080120.059478611@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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


