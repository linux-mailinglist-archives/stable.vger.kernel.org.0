Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9266649B9
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239158AbjAJSYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239246AbjAJSXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:23:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A363F11F
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:21:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A4F261874
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7AFC433D2;
        Tue, 10 Jan 2023 18:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374868;
        bh=CW/XVXv/E36Si5Kzkb1uTs8yx0CwoYx52sajY93CVsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psVTSWaIIp4mIVrZphkPsRYGpo5/G4gMjJvBFH0T6//pC4W/r/254BkueTwYWObB7
         aeQYaA+F5Z55botWpsJhxq2y+Q3OD+HLMHKwgY8iijVnVr1twrjyB9/DOIA2ROBUmY
         C3t7qPzztXJtrNlDyatjGCsH6CJIJD5br38dFOW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ronald Wahl <ronald.wahl@raritan.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 134/159] net: dsa: tag_qca: fix wrong MGMT_DATA2 size
Date:   Tue, 10 Jan 2023 19:04:42 +0100
Message-Id: <20230110180022.644146676@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Christian Marangi <ansuelsmth@gmail.com>

commit d9dba91be71f03cc75bcf39fc0d5d99ff33f1ae0 upstream.

It was discovered that MGMT_DATA2 can contain up to 28 bytes of data
instead of the 12 bytes written in the Documentation by accounting the
limit of 16 bytes declared in Documentation subtracting the first 4 byte
in the packet header.

Update the define with the real world value.

Tested-by: Ronald Wahl <ronald.wahl@raritan.com>
Fixes: c2ee8181fddb ("net: dsa: tag_qca: add define for handling mgmt Ethernet packet")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.18+
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/dsa/tag_qca.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -45,8 +45,8 @@ struct sk_buff;
 					QCA_HDR_MGMT_COMMAND_LEN + \
 					QCA_HDR_MGMT_DATA1_LEN)
 
-#define QCA_HDR_MGMT_DATA2_LEN		12 /* Other 12 byte for the mdio data */
-#define QCA_HDR_MGMT_PADDING_LEN	34 /* Padding to reach the min Ethernet packet */
+#define QCA_HDR_MGMT_DATA2_LEN		28 /* Other 28 byte for the mdio data */
+#define QCA_HDR_MGMT_PADDING_LEN	18 /* Padding to reach the min Ethernet packet */
 
 #define QCA_HDR_MGMT_PKT_LEN		(QCA_HDR_MGMT_HEADER_LEN + \
 					QCA_HDR_LEN + \


