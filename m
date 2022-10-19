Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A868060429B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbiJSLHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234008AbiJSLHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:07:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05A22408C;
        Wed, 19 Oct 2022 03:36:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2C96CE218C;
        Wed, 19 Oct 2022 09:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A739C433D7;
        Wed, 19 Oct 2022 09:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170569;
        bh=7+9iLh8rQ4HHyOSIN1Pqo+gNYTzhMkFpZiwMptBxaMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwgSrylHOCjnvrOQyAz1pPLxeG38w2vNao7DZFkvyjCzotsyt+AbfXRFq5HTgl4FE
         9VdOY9NsR1xEYRkTSn6kqnd6H00crRA8pRpjPsIK6+bdw2b4KYRWC+FoAjFGcbvwSe
         E31jyBc7FOu+D7Hmjjgd61LszShUjbMlFuFQ3kQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Patrick Rudolph <patrick.rudolph@9elements.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 703/862] regulator: core: Prevent integer underflow
Date:   Wed, 19 Oct 2022 10:33:10 +0200
Message-Id: <20221019083321.051979568@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Rudolph <patrick.rudolph@9elements.com>

[ Upstream commit 8d8e16592022c9650df8aedfe6552ed478d7135b ]

By using a ratio of delay to poll_enabled_time that is not integer
time_remaining underflows and does not exit the loop as expected.
As delay could be derived from DT and poll_enabled_time is defined
in the driver this can easily happen.

Use a signed iterator to make sure that the loop exits once
the remaining time is negative.

Signed-off-by: Patrick Rudolph <patrick.rudolph@9elements.com>
Link: https://lore.kernel.org/r/20220909125954.577669-1-patrick.rudolph@9elements.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d3e8dc32832d..c3871565fd7d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2681,7 +2681,7 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 	 * return -ETIMEDOUT.
 	 */
 	if (rdev->desc->poll_enabled_time) {
-		unsigned int time_remaining = delay;
+		int time_remaining = delay;
 
 		while (time_remaining > 0) {
 			_regulator_delay_helper(rdev->desc->poll_enabled_time);
-- 
2.35.1



