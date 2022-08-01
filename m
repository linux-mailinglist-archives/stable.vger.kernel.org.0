Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7619586A4F
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiHAMOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbiHAMOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:14:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC57481DA;
        Mon,  1 Aug 2022 04:57:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01B45B80EAC;
        Mon,  1 Aug 2022 11:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AD5C4314C;
        Mon,  1 Aug 2022 11:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355069;
        bh=/5CZygGq4BwDZcE4D5t5rnKAa8XQjuxhRvcakUpGfME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3V2gLahlIb0C5gioBYOIWbPSpyGiFLe11W8pcZPv8wtNAT4YUvjaJgeawHKnsCRw
         3Ts+wfP0mjcbPc3KJoOrzITnfBuFRmXvuFmfwstVOt7rPQFdnHaM0CHvn1bay8vnfI
         i72oZyluXs2LTNS1UnG9Qkz+AyuVqJrCwKiRLza8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 51/88] Documentation: fix sctp_wmem in ip-sysctl.rst
Date:   Mon,  1 Aug 2022 13:47:05 +0200
Message-Id: <20220801114140.357178617@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 Documentation/networking/ip-sysctl.rst | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 8899b474edbf..e29017d4d7a2 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2848,7 +2848,14 @@ sctp_rmem - vector of 3 INTEGERs: min, default, max
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



