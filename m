Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30CE4BE329
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345075AbiBUJQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:16:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348781AbiBUJLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:11:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA3627FF2;
        Mon, 21 Feb 2022 01:04:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3CF0ECE0E7C;
        Mon, 21 Feb 2022 09:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3B3C340E9;
        Mon, 21 Feb 2022 09:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434242;
        bh=LbpS3Y/VfwBZOHuEtHeMd4iAvaPoeairLJWLJwAYa1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/TDJc+yeIIYwI1eGE5VIuG4J8rNFw3t4zWqODF866GDWY6+5/uZUIHQVlYNBvQ60
         U0oouBb7qoVC3o3JxzC17b8fwV+xpbS0UaSXB8l2cokkEPZCdgrLjIP2luPzogHTAr
         /VPN+nRtqXP/nfFHVHd9KW8WMRvxstZBYhx9qnMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/121] selftests: openat2: Add missing dependency in Makefile
Date:   Mon, 21 Feb 2022 09:48:41 +0100
Message-Id: <20220221084922.169849260@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit ea3396725aa143dd42fe388cb67e44c90d2fb719 ]

Add a dependency on header helpers.h to the main target; while at that add
to helpers.h also a missing include for bool types.

Cc: Aleksa Sarai <cyphar@cyphar.com>
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/openat2/Makefile  | 2 +-
 tools/testing/selftests/openat2/helpers.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/openat2/Makefile b/tools/testing/selftests/openat2/Makefile
index 4b93b1417b862..843ba56d8e49e 100644
--- a/tools/testing/selftests/openat2/Makefile
+++ b/tools/testing/selftests/openat2/Makefile
@@ -5,4 +5,4 @@ TEST_GEN_PROGS := openat2_test resolve_test rename_attack_test
 
 include ../lib.mk
 
-$(TEST_GEN_PROGS): helpers.c
+$(TEST_GEN_PROGS): helpers.c helpers.h
diff --git a/tools/testing/selftests/openat2/helpers.h b/tools/testing/selftests/openat2/helpers.h
index ad5d0ba5b6ce9..7056340b9339e 100644
--- a/tools/testing/selftests/openat2/helpers.h
+++ b/tools/testing/selftests/openat2/helpers.h
@@ -9,6 +9,7 @@
 
 #define _GNU_SOURCE
 #include <stdint.h>
+#include <stdbool.h>
 #include <errno.h>
 #include <linux/types.h>
 #include "../kselftest.h"
-- 
2.34.1



