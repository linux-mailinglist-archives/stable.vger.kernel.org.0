Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844AB4F30ED
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347409AbiDEJ0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245062AbiDEIxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:53:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AE0108F;
        Tue,  5 Apr 2022 01:51:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E993B81B92;
        Tue,  5 Apr 2022 08:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE187C385A1;
        Tue,  5 Apr 2022 08:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148662;
        bh=5ViWBbsLPxdn3zqyYlQXpfb56RiI3TzY2TRM9WAalvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZX4BnRnxQNDXaP5qeat+8mNc49TakOcBJVR4Mui8+ZrbtF4Q0wAISAR+DKAH8s02
         Eqps3PmHn6NmSrMY7nvuNdEMgJbqH9S3Px1erqas9HvD7pEI24Ssyiv4kWl7egAd9/
         gOjAW0Lm9l6wfXsci212NzgHB6amqA1Yl4EgC/6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0437/1017] selftests/net: timestamping: Fix bind_phc check
Date:   Tue,  5 Apr 2022 09:22:30 +0200
Message-Id: <20220405070407.265556676@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit 678dfd5280341d877ca646499bfdc82a3d8b4356 ]

timestamping checks socket options during initialisation. For the field
bind_phc of the socket option SO_TIMESTAMPING it expects the value -1 if
PHC is not bound. Actually the value of bind_phc is 0 if PHC is not
bound. This results in the following output:

SIOCSHWTSTAMP: tx_type 0 requested, got 0; rx_filter 0 requested, got 0
SO_TIMESTAMP 0
SO_TIMESTAMPNS 0
SO_TIMESTAMPING flags 0, bind phc 0
   not expected, flags 0, bind phc -1

This is fixed by setting default value and expected value of bind_phc to
0.

Fixes: 2214d7032479 ("selftests/net: timestamping: support binding PHC")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/timestamping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/timestamping.c b/tools/testing/selftests/net/timestamping.c
index aee631c5284e..044bc0e9ed81 100644
--- a/tools/testing/selftests/net/timestamping.c
+++ b/tools/testing/selftests/net/timestamping.c
@@ -325,8 +325,8 @@ int main(int argc, char **argv)
 	struct ifreq device;
 	struct ifreq hwtstamp;
 	struct hwtstamp_config hwconfig, hwconfig_requested;
-	struct so_timestamping so_timestamping_get = { 0, -1 };
-	struct so_timestamping so_timestamping = { 0, -1 };
+	struct so_timestamping so_timestamping_get = { 0, 0 };
+	struct so_timestamping so_timestamping = { 0, 0 };
 	struct sockaddr_in addr;
 	struct ip_mreq imr;
 	struct in_addr iaddr;
-- 
2.34.1



