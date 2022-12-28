Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F9A657AC9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbiL1PPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiL1POv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:14:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1D413EAF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:14:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF4346155F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AE1C433D2;
        Wed, 28 Dec 2022 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240489;
        bh=E4lei+1C8TJdzdU6L6ZhYCyB0ufrywpb31IgqBawctE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqPi43NsknMAj6UJSLi6lj15qREpwsVLm7NlKDSLJso78I5rkhMuuISfu9O8FjI4H
         TePoZNxfEzB10CCbfyS6ulv3cWlDvz+M9pxAxpJpci2X+CcUMyorWIu6OF0d2L+0Pi
         bVB68EAA/3RzhZz1w3EpSXAMKN4EPec2brqgBUnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/731] apparmor: fix lockdep warning when removing a namespace
Date:   Wed, 28 Dec 2022 15:37:46 +0100
Message-Id: <20221228144306.967967423@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 9c4557efc558a68e4cd973490fd936d6e3414db8 ]

Fix the following lockdep warning

[ 1119.158984] ============================================
[ 1119.158988] WARNING: possible recursive locking detected
[ 1119.158996] 6.0.0-rc1+ #257 Tainted: G            E    N
[ 1119.158999] --------------------------------------------
[ 1119.159001] bash/80100 is trying to acquire lock:
[ 1119.159007] ffff88803e79b4a0 (&ns->lock/1){+.+.}-{4:4}, at: destroy_ns.part.0+0x43/0x140
[ 1119.159028]
               but task is already holding lock:
[ 1119.159030] ffff8881009764a0 (&ns->lock/1){+.+.}-{4:4}, at: aa_remove_profiles+0x3f0/0x640
[ 1119.159040]
               other info that might help us debug this:
[ 1119.159042]  Possible unsafe locking scenario:

[ 1119.159043]        CPU0
[ 1119.159045]        ----
[ 1119.159047]   lock(&ns->lock/1);
[ 1119.159051]   lock(&ns->lock/1);
[ 1119.159055]
                *** DEADLOCK ***

Which is caused by an incorrect lockdep nesting notation

Fixes: feb3c766a3ab ("apparmor: fix possible recursive lock warning in __aa_create_ns")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 4c010c9a6af1..fcf22577f606 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1125,7 +1125,7 @@ ssize_t aa_remove_profiles(struct aa_ns *policy_ns, struct aa_label *subj,
 
 	if (!name) {
 		/* remove namespace - can only happen if fqname[0] == ':' */
-		mutex_lock_nested(&ns->parent->lock, ns->level);
+		mutex_lock_nested(&ns->parent->lock, ns->parent->level);
 		__aa_bump_ns_revision(ns);
 		__aa_remove_ns(ns);
 		mutex_unlock(&ns->parent->lock);
-- 
2.35.1



