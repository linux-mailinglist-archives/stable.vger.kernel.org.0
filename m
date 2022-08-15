Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D60159471B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346931AbiHOX4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356600AbiHOXyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:54:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23212162C57;
        Mon, 15 Aug 2022 13:19:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12435B81183;
        Mon, 15 Aug 2022 20:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59175C433D7;
        Mon, 15 Aug 2022 20:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594783;
        bh=06VFarDkPU464UnbTOwMQsoTTF2JrCyJwdk9TgVmdxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0oEbPMi9iZ8DqO+Gw80GDiWFvj48VhLqcd+d3ifzen99WZ6j0HrUlBdn3jWfABz1
         NeM4YtM1RcxW8jH+2SFpX1x+QnbcyrjDrXytTeMObk7UCVH7VUJsRylbE3+sS/cdRC
         4Im1ku+OSvyYBwCWmy03nV09ug1cl1dOH3KcH/Ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0558/1157] crypto: inside-secure - Add missing MODULE_DEVICE_TABLE for of
Date:   Mon, 15 Aug 2022 19:58:34 +0200
Message-Id: <20220815180501.929627362@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

[ Upstream commit fa4d57b85786ec0e16565c75a51c208834b0c24d ]

Without MODULE_DEVICE_TABLE, crypto_safexcel.ko module is not automatically
loaded on platforms where inside-secure crypto HW is specified in device
tree (e.g. Armada 3720). So add missing MODULE_DEVICE_TABLE for of.

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 9b1a158aec29..ad0d8c4a71ac 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1831,6 +1831,8 @@ static const struct of_device_id safexcel_of_match_table[] = {
 	{},
 };
 
+MODULE_DEVICE_TABLE(of, safexcel_of_match_table);
+
 static struct platform_driver  crypto_safexcel = {
 	.probe		= safexcel_probe,
 	.remove		= safexcel_remove,
-- 
2.35.1



