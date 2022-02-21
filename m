Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E834BE539
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348731AbiBUJXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349253AbiBUJVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:21:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DBD36143;
        Mon, 21 Feb 2022 01:08:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA0CE6090A;
        Mon, 21 Feb 2022 09:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A013CC340E9;
        Mon, 21 Feb 2022 09:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434483;
        bh=Kp3T8Uq/wmdAQIvGZCoRhZ+9BMeChwVbO3ac4eqCP1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4Pk2RzHlSGeByhcg8p4hUaNjuVZWwcsd3YKbi/VJ68B/23Kzw6EIEbLr1+KjeWMb
         pEZNMZewBeUSAnxPKH23Ahi2SFTuNx3OONgLz/4cOKYr33jqAYPi5XJ1iUUUxbCet1
         QqipkPSYZPYPiBeB0h+jkLhaOUAKVJhPPNwDMOZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/196] selftests: rtc: Increase test timeout so that all tests run
Date:   Mon, 21 Feb 2022 09:47:36 +0100
Message-Id: <20220221084931.703886597@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit f034cc1301e7d83d4ec428dd6b8ffb57ca446efb ]

The timeout setting for the rtc kselftest is currently 90 seconds. This
setting is used by the kselftest runner to stop running a test if it
takes longer than the assigned value.

However, two of the test cases inside rtc set alarms. These alarms are
set to the next beginning of the minute, so each of these test cases may
take up to, in the worst case, 60 seconds.

In order to allow for all test cases in rtc to run, even in the worst
case, when using the kselftest runner, the timeout value should be
increased to at least 120. Set it to 180, so there's some additional
slack.

Correct operation can be tested by running the following command right
after the start of a minute (low second count), and checking that all
test cases run:

	./run_kselftest.sh -c rtc

Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/rtc/settings | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rtc/settings b/tools/testing/selftests/rtc/settings
index ba4d85f74cd6b..a953c96aa16e1 100644
--- a/tools/testing/selftests/rtc/settings
+++ b/tools/testing/selftests/rtc/settings
@@ -1 +1 @@
-timeout=90
+timeout=180
-- 
2.34.1



