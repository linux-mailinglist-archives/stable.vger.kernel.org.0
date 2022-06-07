Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B4E5425F8
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbiFHBaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242760AbiFHBX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 21:23:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF99B26F366;
        Tue,  7 Jun 2022 12:22:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B4DD60B01;
        Tue,  7 Jun 2022 19:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3479BC3411C;
        Tue,  7 Jun 2022 19:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629777;
        bh=FfadC9C66rH2lacYrTMtOrPQ5n/QT/RHFNMsY8y2TuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMgvY5NcS8eAmpjOgOJDh0coi7s5FLSWqaEFe/n/i1TIaT9qS4uW6QSTdqQRBombf
         FRzbn6xsSYu97/Lw4IJGTROv6TxHKgOz7w+mMb99d4HY4yceQL8rQOKm5+1AASxRi1
         XdM4qPu4tcrFy9neec49FiXSHXed3P0sT/ykHvhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dimitri John Ledkov <dimitri.ledkov@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.18 814/879] cfg80211: declare MODULE_FIRMWARE for regulatory.db
Date:   Tue,  7 Jun 2022 19:05:32 +0200
Message-Id: <20220607165026.485151127@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
@@ -807,6 +807,8 @@ static int __init load_builtin_regdb_key
 	return 0;
 }
 
+MODULE_FIRMWARE("regulatory.db.p7s");
+
 static bool regdb_has_valid_signature(const u8 *data, unsigned int size)
 {
 	const struct firmware *sig;
@@ -1078,6 +1080,8 @@ static void regdb_fw_cb(const struct fir
 	release_firmware(fw);
 }
 
+MODULE_FIRMWARE("regulatory.db");
+
 static int query_regdb_file(const char *alpha2)
 {
 	ASSERT_RTNL();


