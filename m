Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFFF541CF2
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382712AbiFGWHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382792AbiFGWEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:04:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C688250694;
        Tue,  7 Jun 2022 12:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AF63B8233E;
        Tue,  7 Jun 2022 19:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60256C385A2;
        Tue,  7 Jun 2022 19:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629342;
        bh=h7iFGRANW2OaT8ExBuyx2KGOZq68ixyMEhTw8ubdLHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzKV6qqPdXAZMIc2zU8F+v/U4MBew0o3VG69P3b1uRnycSUwXKtMuKC1p9rBrSpZx
         MtoAVbbfG//hnUsBnvhhgEBE3FOg6nZZRXlxBl2FoQ7mnVRqxwRWHP6qhMOX16fCsM
         osI45tiuCIoqZ5ZMKC7sATq09vOzCU+G1KW39Nm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 657/879] OPP: call of_node_put() on error path in _bandwidth_supported()
Date:   Tue,  7 Jun 2022 19:02:55 +0200
Message-Id: <20220607165021.915516608@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 907ed123b9d096c73e9361f6cd4097f0691497f2 ]

This code does not call of_node_put(opp_np) if of_get_next_available_child()
returns NULL.  But it should.

Fixes: 45679f9b508f ("opp: Don't parse icc paths unnecessarily")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 440ab5a03df9..95b184fc3372 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -437,11 +437,11 @@ static int _bandwidth_supported(struct device *dev, struct opp_table *opp_table)
 
 	/* Checking only first OPP is sufficient */
 	np = of_get_next_available_child(opp_np, NULL);
+	of_node_put(opp_np);
 	if (!np) {
 		dev_err(dev, "OPP table empty\n");
 		return -EINVAL;
 	}
-	of_node_put(opp_np);
 
 	prop = of_find_property(np, "opp-peak-kBps", NULL);
 	of_node_put(np);
-- 
2.35.1



