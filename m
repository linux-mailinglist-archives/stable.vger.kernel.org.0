Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198F66C1779
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjCTPOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbjCTPN5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:13:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600FD11660
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:08:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFD7CB80EC2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2170EC433EF;
        Mon, 20 Mar 2023 15:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324928;
        bh=nyD/biSwnmE61lrtW18J5H7Y6qPC96aP9J9xqE3FVJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vpR27+k22pyXxoX3VT04UeA4ZjVJYq5cJONq5M3vwiP+84uSg0vHKZUVjJeAgcxk/
         7Ka1nGkLecOaUvEQTv8BGD3XwnIPkdl96O78pYGnzB7k5AxG4AxxZmijDaYS1fwZTb
         v8lWiZOMNtBaZjrPjpwjecci2jltWZgHPl5+6p/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/115] qed/qed_mng_tlv: correctly zero out ->min instead of ->hour
Date:   Mon, 20 Mar 2023 15:54:21 +0100
Message-Id: <20230320145451.462919500@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
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

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit 470efd68a4653d9819d391489886432cd31bcd0b ]

This fixes an issue where ->hour would erroneously get zeroed out
instead of ->min because of a bad copy paste.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: f240b6882211 ("qed: Add support for processing fcoe tlv request.")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Link: https://lore.kernel.org/r/20230315194618.579286-1-d-tatianin@yandex-team.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
index 6190adf965bca..f55eed092f25d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
@@ -422,7 +422,7 @@ qed_mfw_get_tlv_time_value(struct qed_mfw_tlv_time *p_time,
 	if (p_time->hour > 23)
 		p_time->hour = 0;
 	if (p_time->min > 59)
-		p_time->hour = 0;
+		p_time->min = 0;
 	if (p_time->msec > 999)
 		p_time->msec = 0;
 	if (p_time->usec > 999)
-- 
2.39.2



