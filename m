Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE83A548FEC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378983AbiFMNqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379549AbiFMNo1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:44:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B36D9D;
        Mon, 13 Jun 2022 04:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9075B80EA8;
        Mon, 13 Jun 2022 11:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2527DC3411C;
        Mon, 13 Jun 2022 11:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119942;
        bh=gHar6usD+Ov4HeHkYWCEF6ZCkOmCyCmYj6jZWl6X/+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJDlhTbyQQbw5nw0+rcAMye5x3gegHMPygUwn4Dp71qgKFCkfhoUTfDylqDIAJ/T1
         2jx8dSwZZ6x0aV6VwHBI6zviGTHn+AY0GuugGRVD/qstT9ZsX/RlurMdF9/f3rKmVj
         OWQc0jxvY3dokQXSufMxFlzapbU2QS9A3r/m7BTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 193/339] amt: fix wrong type string definition
Date:   Mon, 13 Jun 2022 12:10:18 +0200
Message-Id: <20220613094932.523723111@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit d7970039d87c926bb648982e920cb9851c19f3e1 ]

amt message type definition starts from 1, not 0.
But type_str[] starts from 0.
So, it prints wrong type information.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 2815db7ee2a3..14fe03dbd9b1 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -51,6 +51,7 @@ static char *status_str[] = {
 };
 
 static char *type_str[] = {
+	"", /* Type 0 is not defined */
 	"AMT_MSG_DISCOVERY",
 	"AMT_MSG_ADVERTISEMENT",
 	"AMT_MSG_REQUEST",
-- 
2.35.1



