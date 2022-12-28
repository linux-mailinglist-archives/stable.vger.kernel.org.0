Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAC4657ACD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbiL1PPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbiL1PPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:15:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0476B13F58
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:15:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ECB261560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7372FC433D2;
        Wed, 28 Dec 2022 15:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240499;
        bh=9F4L16uHh0vWhoOkDpjGof02gmsSKtQ+bK8TqTv5yTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnDX0z3QXyBSep8D+udMB/PKPxjVdenk4b2bBNqKvCRoecP8AmFA8YGPzWGUgPhS3
         8vFFUjbUzTHINrF7l1VXheQMlR8ZWYBtT0x3fyUdOFPOest2ctC/Bu8r9WssouALKg
         JfLr+lJQ3+cmAPu4cFuDI/oG0NucOJGZ9Xr4OMcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 360/731] apparmor: Fix abi check to include v8 abi
Date:   Wed, 28 Dec 2022 15:37:47 +0100
Message-Id: <20221228144306.996722268@linuxfoundation.org>
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

[ Upstream commit 1b5a6198f5a9d0aa5497da0dc4bcd4fc166ee516 ]

The v8 abi is supported by the kernel but the userspace supported
version check does not allow for it. This was missed when v8 was added
due to a bug in the userspace compiler which was setting an older abi
version for v8 encoding (which is forward compatible except on the
network encoding). However it is possible to detect the network
encoding by checking the policydb network support which the code
does. The end result was that missing the abi flag worked until
userspace was fixed and began correctly checking for the v8 abi
version.

Fixes: 56974a6fcfef ("apparmor: add base infastructure for socket mediation")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 03c9609ca407..d5b3a062d1d1 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -964,7 +964,7 @@ static int verify_header(struct aa_ext *e, int required, const char **ns)
 	 * if not specified use previous version
 	 * Mask off everything that is not kernel abi version
 	 */
-	if (VERSION_LT(e->version, v5) || VERSION_GT(e->version, v7)) {
+	if (VERSION_LT(e->version, v5) || VERSION_GT(e->version, v8)) {
 		audit_iface(NULL, NULL, NULL, "unsupported interface version",
 			    e, error);
 		return error;
-- 
2.35.1



