Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A36359BAFF
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbiHVIGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiHVIGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:06:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9D12B249
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:05:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF61060C71
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B94C433D6;
        Mon, 22 Aug 2022 08:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661155552;
        bh=sUucZbdfspLt3rbIcFSPZm8f3qzo8nPmuD/uQclnjCQ=;
        h=Subject:To:Cc:From:Date:From;
        b=Q81ESKC4nrMtuXRmj06MCJRDgYZgPM3T5gL9j8LwC66NBtfUWgdgH7hIJ0rIixdbM
         RAFGjUY6YCepjexZzeAaOnMA1VBjd2mBOogrVmB6AYZAuPDFCjtkBAN4glgkkGuEFO
         wEBGZIPI7fR8H6cMsC1yTb7eh/XxW24N9rAFQ110=
Subject: FAILED: patch "[PATCH] apparmor: fix quiet_denied for file rules" failed to apply to 4.9-stable tree
To:     john.johansen@canonical.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:05:49 +0200
Message-ID: <166115554923435@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 68ff8540cc9e4ab557065b3f635c1ff4c96e1f1c Mon Sep 17 00:00:00 2001
From: John Johansen <john.johansen@canonical.com>
Date: Thu, 29 Apr 2021 01:48:28 -0700
Subject: [PATCH] apparmor: fix quiet_denied for file rules

Global quieting of denied AppArmor generated file events is not
handled correctly. Unfortunately the is checking if quieting of all
audit events is set instead of just denied events.

Fixes: 67012e8209df ("AppArmor: basic auditing infrastructure.")
Signed-off-by: John Johansen <john.johansen@canonical.com>

diff --git a/security/apparmor/audit.c b/security/apparmor/audit.c
index f7e97c7e80f3..704b0c895605 100644
--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -137,7 +137,7 @@ int aa_audit(int type, struct aa_profile *profile, struct common_audit_data *sa,
 	}
 	if (AUDIT_MODE(profile) == AUDIT_QUIET ||
 	    (type == AUDIT_APPARMOR_DENIED &&
-	     AUDIT_MODE(profile) == AUDIT_QUIET))
+	     AUDIT_MODE(profile) == AUDIT_QUIET_DENIED))
 		return aad(sa)->error;
 
 	if (KILL_MODE(profile) && type == AUDIT_APPARMOR_DENIED)

