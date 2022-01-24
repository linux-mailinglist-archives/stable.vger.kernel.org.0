Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD8749A352
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387604AbiAXX5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846025AbiAXXOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:14:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CBFC067A7D;
        Mon, 24 Jan 2022 13:22:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A357B81188;
        Mon, 24 Jan 2022 21:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE63C340E4;
        Mon, 24 Jan 2022 21:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059343;
        bh=/EAeO4xUnZVlE4J3vuK3DNqUta/S6QmR1xXciBHU+t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KaKw1anUg42BQFWn47k6WcIxzJi+pTM0JetW//CMyPMcOsqZ0h3rz4Lqie6Mc8TNq
         kJPLZ8DRmmh7h4HfqRX+PQANvSc7j1ZbnDZC1I/3TQtL7lOpIkfs0QGfplB+bH72PW
         gxuXJAdG/g6La8BLEoVRWN1jfI0zQqA+JPHFj25w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0551/1039] selftests/bpf: Destroy XDP link correctly
Date:   Mon, 24 Jan 2022 19:39:00 +0100
Message-Id: <20220124184143.806005676@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit f91231eeeed752119f49eb6620cae44ec745a007 ]

bpf_link__detach() was confused with bpf_link__destroy() and leaves
leaked FD in the process. Fix the problem.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Hengqi Chen <hengqi.chen@gmail.com>
Link: https://lore.kernel.org/bpf/20211107165521.9240-9-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
index 7589c03fd26be..eb2feaac81fe2 100644
--- a/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
@@ -204,8 +204,8 @@ static int pass_ack(struct migrate_reuseport_test_case *test_case)
 {
 	int err;
 
-	err = bpf_link__detach(test_case->link);
-	if (!ASSERT_OK(err, "bpf_link__detach"))
+	err = bpf_link__destroy(test_case->link);
+	if (!ASSERT_OK(err, "bpf_link__destroy"))
 		return -1;
 
 	test_case->link = NULL;
-- 
2.34.1



