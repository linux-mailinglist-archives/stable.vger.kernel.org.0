Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC989541A1A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378862AbiFGV3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378778AbiFGV1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:27:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8125152BB2;
        Tue,  7 Jun 2022 12:02:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E484617C8;
        Tue,  7 Jun 2022 19:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1383FC385A2;
        Tue,  7 Jun 2022 19:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628523;
        bh=4en+cC/nYj++7MgCIJDMIe5jSsByg+LEvsp7KKofpjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZM0B7O5lsSKl1Mcwn/E2qm5Qu+Wg5iss56J/AxYUW/FKdYBvEYlny1j3Za7iMXei
         BTOipycdg0dXK4vIcvvh5h/FsjZWM5PTWxXRk8G3bHddjL5Nf9B8/HLB7RRwHn+GMq
         6ZONYFgYftQNeXfzYAVEEwI6YnGzShavkcvjSTgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 359/879] selftests/resctrl: Fix null pointer dereference on open failed
Date:   Tue,  7 Jun 2022 18:57:57 +0200
Message-Id: <20220607165013.284404152@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit c7b607fa9325ccc94982774c505176677117689c ]

Currently if opening /dev/null fails to open then file pointer fp
is null and further access to fp via fprintf will cause a null
pointer dereference. Fix this by returning a negative error value
when a null fp is detected.

Detected using cppcheck static analysis:
tools/testing/selftests/resctrl/fill_buf.c:124:6: note: Assuming
that condition '!fp' is not redundant
 if (!fp)
     ^
tools/testing/selftests/resctrl/fill_buf.c:126:10: note: Null
pointer dereference
 fprintf(fp, "Sum: %d ", ret);

Fixes: a2561b12fe39 ("selftests/resctrl: Add built in benchmark")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/fill_buf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/resctrl/fill_buf.c b/tools/testing/selftests/resctrl/fill_buf.c
index 51e5cf22632f..56ccbeae0638 100644
--- a/tools/testing/selftests/resctrl/fill_buf.c
+++ b/tools/testing/selftests/resctrl/fill_buf.c
@@ -121,8 +121,10 @@ static int fill_cache_read(unsigned char *start_ptr, unsigned char *end_ptr,
 
 	/* Consume read result so that reading memory is not optimized out. */
 	fp = fopen("/dev/null", "w");
-	if (!fp)
+	if (!fp) {
 		perror("Unable to write to /dev/null");
+		return -1;
+	}
 	fprintf(fp, "Sum: %d ", ret);
 	fclose(fp);
 
-- 
2.35.1



