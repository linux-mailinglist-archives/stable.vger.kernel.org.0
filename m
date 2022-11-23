Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7EB63580D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236986AbiKWJuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238240AbiKWJtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:49:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F8110AD26
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:46:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5517B81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297B4C433C1;
        Wed, 23 Nov 2022 09:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196791;
        bh=RBHfiV6ctG5H4E9QhEOBnjB8iFT88OSDBL+qt/D9V2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gv1Q1H92xL6DQ5Xx6Gwy4C4AX/c8yicMn/AGjge87HUxLAu9z9dJB8yPf/jpjLrEN
         M7PWsOvKDQSryKFNs/x5ZFCl70dg+1uvQppO43ry04sMFYQ+ivOjmrQ7NzNUtdcpEF
         Umgv0pfPHN4Jb3nxYcOop32sLbDpYIm+SGNq7hP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Jihong <yangjihong1@huawei.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 125/314] selftests/bpf: Fix test_progs compilation failure in 32-bit arch
Date:   Wed, 23 Nov 2022 09:49:30 +0100
Message-Id: <20221123084631.189914289@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit 5704bc7e8991164b14efb748b5afa0715c25fac3 ]

test_progs fails to be compiled in the 32-bit arch, log is as follows:

  test_progs.c:1013:52: error: format '%ld' expects argument of type 'long int', but argument 3 has type 'size_t' {aka 'unsigned int'} [-Werror=format=]
   1013 |                 sprintf(buf, "MSG_TEST_LOG (cnt: %ld, last: %d)",
        |                                                  ~~^
        |                                                    |
        |                                                    long int
        |                                                  %d
   1014 |                         strlen(msg->test_log.log_buf),
        |                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        |                         |
        |                         size_t {aka unsigned int}

Fix it.

Fixes: 91b2c0afd00c ("selftests/bpf: Add parallelism to test_progs")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20221108015857.132457-1-yangjihong1@huawei.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 3561c97701f2..a07b8ae64bf8 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -993,7 +993,7 @@ static inline const char *str_msg(const struct msg *msg, char *buf)
 			msg->subtest_done.have_log);
 		break;
 	case MSG_TEST_LOG:
-		sprintf(buf, "MSG_TEST_LOG (cnt: %ld, last: %d)",
+		sprintf(buf, "MSG_TEST_LOG (cnt: %zu, last: %d)",
 			strlen(msg->test_log.log_buf),
 			msg->test_log.is_last);
 		break;
-- 
2.35.1



