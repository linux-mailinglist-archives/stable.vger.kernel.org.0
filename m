Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7396358DDC8
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343514AbiHISF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344675AbiHISFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:05:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AEC27B1A;
        Tue,  9 Aug 2022 11:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1608B8171A;
        Tue,  9 Aug 2022 18:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50008C433D6;
        Tue,  9 Aug 2022 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068147;
        bh=p57W8xdgWJ4rBg4QKkF/0C1QRV+CcyrZojmXs1ej7Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baUyoisuFVB7MLPLu9/12yEZeao2kC7QYD5fQw4Q7OiwA6SKzvpzxtqoYKqKD09zp
         eX7uJayWjACmEPLso3dfiT5F7riv69mCyIIV93BKkWk2RKYLw04O5hQJwIYsvgUtZz
         2J2hIRe6azyX7mTTmvWKDdABSg+fS9h7+T1dSARE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/32] Documentation: fix sctp_wmem in ip-sysctl.rst
Date:   Tue,  9 Aug 2022 20:00:09 +0200
Message-Id: <20220809175513.662269725@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit aa709da0e032cee7c202047ecd75f437bb0126ed ]

Since commit 1033990ac5b2 ("sctp: implement memory accounting on tx path"),
SCTP has supported memory accounting on tx path where 'sctp_wmem' is used
by sk_wmem_schedule(). So we should fix the description for this option in
ip-sysctl.rst accordingly.

v1->v2:
  - Improve the description as Marcelo suggested.

Fixes: 1033990ac5b2 ("sctp: implement memory accounting on tx path")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.txt | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index e315e6052b9f..eb24b8137226 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -2170,7 +2170,14 @@ sctp_rmem - vector of 3 INTEGERs: min, default, max
 	Default: 4K
 
 sctp_wmem  - vector of 3 INTEGERs: min, default, max
-	Currently this tunable has no effect.
+	Only the first value ("min") is used, "default" and "max" are
+	ignored.
+
+	min: Minimum size of send buffer that can be used by SCTP sockets.
+	It is guaranteed to each SCTP socket (but not association) even
+	under moderate memory pressure.
+
+	Default: 4K
 
 addr_scope_policy - INTEGER
 	Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00
-- 
2.35.1



