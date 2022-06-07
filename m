Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9C4540FC2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353953AbiFGTM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354830AbiFGTLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:11:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25384194262;
        Tue,  7 Jun 2022 11:07:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72BE86171C;
        Tue,  7 Jun 2022 18:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E51AC34115;
        Tue,  7 Jun 2022 18:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625227;
        bh=nXntMZVpla3NklUfK6+iMj4hlV8xeBF+Xq/mDF1C6kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yy2/r4yIWfzzK5bpX0VCoHWBxbmUZkDxXMDhNZIZFzVVeLEkhDyo7FEIZal0Mju2d
         ebPNfZp6ntBZUd1AaOYlEL2bU2nVE+e1Tj4QpoJXZR44VpyMLNpykqWD4h2kgsYIP5
         sobd9Hq9t5oMDUtNGVKziACVRFZZjTl2KXljwzJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dimitri John Ledkov <dimitri.ledkov@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 609/667] cfg80211: declare MODULE_FIRMWARE for regulatory.db
Date:   Tue,  7 Jun 2022 19:04:34 +0200
Message-Id: <20220607164952.940551650@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dimitri John Ledkov <dimitri.ledkov@canonical.com>

commit 7bc7981eeebe1b8e603ad2ffc5e84f4df76920dd upstream.

Add MODULE_FIRMWARE declarations for regulatory.db and
regulatory.db.p7s such that userspace tooling can discover and include
these files.

Cc: stable@vger.kernel.org
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Link: https://lore.kernel.org/r/20220414125004.267819-1-dimitri.ledkov@canonical.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/reg.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -806,6 +806,8 @@ static int __init load_builtin_regdb_key
 	return 0;
 }
 
+MODULE_FIRMWARE("regulatory.db.p7s");
+
 static bool regdb_has_valid_signature(const u8 *data, unsigned int size)
 {
 	const struct firmware *sig;
@@ -1077,6 +1079,8 @@ static void regdb_fw_cb(const struct fir
 	release_firmware(fw);
 }
 
+MODULE_FIRMWARE("regulatory.db");
+
 static int query_regdb_file(const char *alpha2)
 {
 	ASSERT_RTNL();


