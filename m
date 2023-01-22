Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8F9676F66
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjAVPVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjAVPVE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:21:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEDD2278C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:21:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09B43B80B1D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6B3C433D2;
        Sun, 22 Jan 2023 15:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400859;
        bh=CC6zOMidGEEk6EIhOLGPBw0/X6Ca/ilRjIAoTNkXIDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmiCEl8EOGZW9Ckjq8SwN61z/Xlc84977YW/BfJG+hYknUPluFm2nsKdED1INCAb/
         S13yS03leyl69p9xfSMijXfoLBzsq/xJ8OKh++bPTvgt0sk0FYcy5GItkp7dtBLs3k
         m1T0Drv+egMwSn/qE5edZIcUMWiKARIp0S4f1e1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Po-Hsu Lin <po-hsu.lin@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/193] selftests: net: fix cmsg_so_mark.sh test hang
Date:   Sun, 22 Jan 2023 16:02:28 +0100
Message-Id: <20230122150247.224804194@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 1573c6882018f69991aead951d09423ce978adac ]

This cmsg_so_mark.sh test will hang on non-amd64 systems because of the
infinity loop for argument parsing in cmsg_sender.

Variable "o" in cs_parse_args() for taking getopt() should be an int,
otherwise it will be 255 when getopt() returns -1 on non-amd64 system
and thus causing infinity loop.

Link: https://lore.kernel.org/lkml/CA+G9fYsM2k7mrF7W4V_TrZ-qDauWM394=8yEJ=-t1oUg8_40YA@mail.gmail.com/t/
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/cmsg_sender.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index 75dd83e39207..24b21b15ed3f 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -110,7 +110,7 @@ static void __attribute__((noreturn)) cs_usage(const char *bin)
 
 static void cs_parse_args(int argc, char *argv[])
 {
-	char o;
+	int o;
 
 	while ((o = getopt(argc, argv, "46sS:p:m:M:d:tf:F:c:C:l:L:H:")) != -1) {
 		switch (o) {
-- 
2.35.1



