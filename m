Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9645417A0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357948AbiFGVEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378457AbiFGVDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:03:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A469313A2D9;
        Tue,  7 Jun 2022 11:48:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A889B8220B;
        Tue,  7 Jun 2022 18:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F68C385A5;
        Tue,  7 Jun 2022 18:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627707;
        bh=7R34usxBQu7eJg2cIGwm/1IcqRrI7YppV2uXmYDwZpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnh5h3wsRZOkJbJHT/EtFV239ViG9pvAI6CHZB+sBTwZDHKODWGDNhO/DtPo/ZLoG
         sMc50ov3eF3R0IKyHfUIV+baAgbFOhlYogSfL9y0Wz8qZ+et91AsItjQDiuQJyxVTx
         VWdZQ+gSKZdNzlyqO0elbRaMsAdVrrC/XksPwWH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 062/879] selftests/bpf: Fix file descriptor leak in load_kallsyms()
Date:   Tue,  7 Jun 2022 18:53:00 +0200
Message-Id: <20220607165004.492035042@linuxfoundation.org>
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

From: Yuntao Wang <ytcoode@gmail.com>

[ Upstream commit 2d0df01974ce2b59b6f7d5bd3ea58d74f12ddf85 ]

Currently, if sym_cnt > 0, it just returns and does not close file, fix it.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220405145711.49543-1-ytcoode@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/trace_helpers.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index 3d6217e3aff7..9c4be2cdb21a 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -25,15 +25,12 @@ static int ksym_cmp(const void *p1, const void *p2)
 
 int load_kallsyms(void)
 {
-	FILE *f = fopen("/proc/kallsyms", "r");
+	FILE *f;
 	char func[256], buf[256];
 	char symbol;
 	void *addr;
 	int i = 0;
 
-	if (!f)
-		return -ENOENT;
-
 	/*
 	 * This is called/used from multiplace places,
 	 * load symbols just once.
@@ -41,6 +38,10 @@ int load_kallsyms(void)
 	if (sym_cnt)
 		return 0;
 
+	f = fopen("/proc/kallsyms", "r");
+	if (!f)
+		return -ENOENT;
+
 	while (fgets(buf, sizeof(buf), f)) {
 		if (sscanf(buf, "%p %c %s", &addr, &symbol, func) != 3)
 			break;
-- 
2.35.1



