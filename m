Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2BF6648C0
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238945AbjAJSOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbjAJSNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:13:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8293E0E4
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:12:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F38161866
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3906C433D2;
        Tue, 10 Jan 2023 18:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374322;
        bh=PmgdSdYQSI2Mwtt6WZ0RgPDMDdHRbpjhytYVNPRN2aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVEMJnCP9piHCKosCR5O1KhJPE/nPfV2d2nV9LuWNvO64uOiYeAuyFM50jQvAaK4j
         U34+ryzhm+kQHJ/dyilhtuWoD1P8y5kqiHx/lgEWkPxAvMlmy8AiCRDvE+lcHNDG1l
         UylPDH+vFIJZkTf0ma0VGJeJFZiEnyp2bBQy4dSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ronald Wahl <ronald.wahl@raritan.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.0 129/148] net: dsa: tag_qca: fix wrong MGMT_DATA2 size
Date:   Tue, 10 Jan 2023 19:03:53 +0100
Message-Id: <20230110180021.277307517@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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
 include/linux/dsa/tag_qca.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index b1b5720d89a5..ee657452f122 100644
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
-- 
2.39.0



