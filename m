Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA5C5A4861
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiH2LJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbiH2LIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:08:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C182369F49;
        Mon, 29 Aug 2022 04:05:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 839DE611B8;
        Mon, 29 Aug 2022 11:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4E3C433C1;
        Mon, 29 Aug 2022 11:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771040;
        bh=Sz3Q4UxT7dqoQblVzdJOQZ/hjUT/fosBNY6GHX19QdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GltdBoUx3fawPjtgI4M5CABTEqizbtZ3uahTkgKXpBftVSjt/9O2mvH88hyVF2OZW
         wJn8KaN/0m4L6MbGaCX10Lyw2kMCnrCb+3ytPMIXSuXNV3zK7wXYA4Jvoesi+wg4vA
         qSv9mznEGEeEM1Y94en6DZOuq1YliClUQ0+bmcio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mahesh Bandewar <maheshb@google.com>,
        Sainath Grandhi <sainath.grandhi@intel.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/136] net: ipvtap - add __init/__exit annotations to module init/exit funcs
Date:   Mon, 29 Aug 2022 12:58:39 +0200
Message-Id: <20220829105806.771724796@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit 4b2e3a17e9f279325712b79fb01d1493f9e3e005 ]

Looks to have been left out in an oversight.

Cc: Mahesh Bandewar <maheshb@google.com>
Cc: Sainath Grandhi <sainath.grandhi@intel.com>
Fixes: 235a9d89da97 ('ipvtap: IP-VLAN based tap driver')
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Link: https://lore.kernel.org/r/20220821130808.12143-1-zenczykowski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvtap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipvlan/ipvtap.c b/drivers/net/ipvlan/ipvtap.c
index 1cedb634f4f7b..f01078b2581ce 100644
--- a/drivers/net/ipvlan/ipvtap.c
+++ b/drivers/net/ipvlan/ipvtap.c
@@ -194,7 +194,7 @@ static struct notifier_block ipvtap_notifier_block __read_mostly = {
 	.notifier_call	= ipvtap_device_event,
 };
 
-static int ipvtap_init(void)
+static int __init ipvtap_init(void)
 {
 	int err;
 
@@ -228,7 +228,7 @@ static int ipvtap_init(void)
 }
 module_init(ipvtap_init);
 
-static void ipvtap_exit(void)
+static void __exit ipvtap_exit(void)
 {
 	rtnl_link_unregister(&ipvtap_link_ops);
 	unregister_netdevice_notifier(&ipvtap_notifier_block);
-- 
2.35.1



