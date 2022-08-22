Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDF259BB1F
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbiHVIJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbiHVIHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:07:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580D42B1A3
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:07:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27D4561006
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A453C433D6;
        Mon, 22 Aug 2022 08:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661155630;
        bh=iLSJs2aDSDvBleR44M5BJNztChmLU+0vbxa6CmloE1U=;
        h=Subject:To:Cc:From:Date:From;
        b=WTqSgCnPz+6cY8ztsCJHiJrtasL8e1ta3rjz/WaKudryxJYUkQ9F5tUllPeD58RIe
         53FbP1vWyIhlG5tS1XOVKPN8EvAyQ13Wu2OTucpzo78H1GYzFDNxiAfaFF1gZHu0CR
         X/2i2ciimulmBNmyftzdh1JlRwKQG8219KDHfT/E=
Subject: FAILED: patch "[PATCH] apparmor: fix setting unconfined mode on a loaded profile" failed to apply to 5.4-stable tree
To:     john.johansen@canonical.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:07:07 +0200
Message-ID: <16611556274158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3bbb7b2e9bbcd22e539e23034da753898fe3b4dc Mon Sep 17 00:00:00 2001
From: John Johansen <john.johansen@canonical.com>
Date: Sat, 26 Mar 2022 01:52:06 -0700
Subject: [PATCH] apparmor: fix setting unconfined mode on a loaded profile

When loading a profile that is set to unconfined mode, that label
flag is not set when it should be. Ensure it is set so that when
used in a label the unconfined check will be applied correctly.

Fixes: 038165070aa5 ("apparmor: allow setting any profile into the unconfined state")
Signed-off-by: John Johansen <john.johansen@canonical.com>

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index df4033db0e0f..302fecf9b197 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -750,16 +750,18 @@ static struct aa_profile *unpack_profile(struct aa_ext *e, char **ns_name)
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

