Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA084F281A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbiDEIKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiDEICa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:02:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF12254FA9;
        Tue,  5 Apr 2022 01:00:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55D446177F;
        Tue,  5 Apr 2022 08:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E087C34110;
        Tue,  5 Apr 2022 08:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145631;
        bh=5ViWBbsLPxdn3zqyYlQXpfb56RiI3TzY2TRM9WAalvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXMn3DghpYyPV/BB/aGRtvB/iul++SpI/BGgowFWnmHSSEIOmN8qASfHljD6HBNOH
         4fJM7dIzwhSsD7wG2vKXAxKZ6lXbJ2Gd477K2BZoCeIRzuHc18/SHOnd5ip2WkwQ/I
         um9eRkRZiw9PQrybWuL1mFCJFs5RxW4a9BpVeydU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0474/1126] selftests/net: timestamping: Fix bind_phc check
Date:   Tue,  5 Apr 2022 09:20:21 +0200
Message-Id: <20220405070421.539916834@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



