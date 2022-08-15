Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7263459487A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355334AbiHOXz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354536AbiHOXub (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:50:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684724D825;
        Mon, 15 Aug 2022 13:16:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EACF960F9F;
        Mon, 15 Aug 2022 20:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1490C433D6;
        Mon, 15 Aug 2022 20:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594563;
        bh=5w7u11WAsIHQgPorsHch8FybS1tdF79re+HYY2FLuss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBX3QCtKZwL3QyYaTYEw5gMYf4ExPHP2MxmW/DtOhIUy2/V+nyCEMfCVK7/inB+ev
         y812rBtoi3GgtY/uEZUAO+/48lqTnTqnJqCkBqHma1A6Ed7Gr1sgdWTzA5IPppVKFe
         vBszDnqXrmwD7alA+aP934lI8/02JH/tZ6C1p/9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0488/1157] mediatek: mt76: eeprom: fix missing of_node_put() in mt76_find_power_limits_node()
Date:   Mon, 15 Aug 2022 19:57:24 +0200
Message-Id: <20220815180459.142334805@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 3bd53ea02d77917c2314ec7be9e2d05be22f87d3 ]

We should use of_node_put() for the reference 'np' returned by
of_get_child_by_name() which will increase the refcount.

Fixes: 22b980badc0f ("mt76: add functions for parsing rate power limits from DT")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
index a499861918fa..9bc8758573fc 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -162,10 +162,13 @@ mt76_find_power_limits_node(struct mt76_dev *dev)
 		}
 
 		if (mt76_string_prop_find(country, dev->alpha2) ||
-		    mt76_string_prop_find(regd, region_name))
+		    mt76_string_prop_find(regd, region_name)) {
+			of_node_put(np);
 			return cur;
+		}
 	}
 
+	of_node_put(np);
 	return fallback;
 }
 
-- 
2.35.1



