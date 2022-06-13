Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651385498E8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381576AbiFMOIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382262AbiFMOFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:05:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7866394180;
        Mon, 13 Jun 2022 04:40:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B66AC61306;
        Mon, 13 Jun 2022 11:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE7BC34114;
        Mon, 13 Jun 2022 11:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120432;
        bh=cJI/Ff5eCY4YKk09fUdLQV5mFqySbVgI0sF7RBQJTzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WivYVYtufpViLfzy4i1GAMQfokPqWHrOv2xT+n3V1FCv5f9y5sSw8N+pui7QotER1
         pp1O9aLEtkHjWyHJci9E+cCS6HIyilD2PirH0nPwm3phUwc5p733bZ+vzRfiJb2udL
         gKCaLNBI+pFvwvWDlnH6EoWM6BUTuQG7X8cX9jWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 030/298] iio: adc: stmpe-adc: Fix wait_for_completion_timeout return value check
Date:   Mon, 13 Jun 2022 12:08:44 +0200
Message-Id: <20220613094925.845754621@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit d345b23200bcdbd2bd3582213d738c258b77718f ]

wait_for_completion_timeout() returns unsigned long not long.
it returns 0 if timed out, and positive if completed.
The check for <= 0 is ambiguous and should be == 0 here
indicating timeout which is the only error case

Fixes: e813dde6f833 ("iio: stmpe-adc: Use wait_for_completion_timeout")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Philippe Schenker <philippe.schenker@toradex.com>
Link: https://lore.kernel.org/r/20220412065150.14486-1-linmq006@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stmpe-adc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/stmpe-adc.c b/drivers/iio/adc/stmpe-adc.c
index d2d405388499..83e0ac4467ca 100644
--- a/drivers/iio/adc/stmpe-adc.c
+++ b/drivers/iio/adc/stmpe-adc.c
@@ -61,7 +61,7 @@ struct stmpe_adc {
 static int stmpe_read_voltage(struct stmpe_adc *info,
 		struct iio_chan_spec const *chan, int *val)
 {
-	long ret;
+	unsigned long ret;
 
 	mutex_lock(&info->lock);
 
@@ -79,7 +79,7 @@ static int stmpe_read_voltage(struct stmpe_adc *info,
 
 	ret = wait_for_completion_timeout(&info->completion, STMPE_ADC_TIMEOUT);
 
-	if (ret <= 0) {
+	if (ret == 0) {
 		stmpe_reg_write(info->stmpe, STMPE_REG_ADC_INT_STA,
 				STMPE_ADC_CH(info->channel));
 		mutex_unlock(&info->lock);
@@ -96,7 +96,7 @@ static int stmpe_read_voltage(struct stmpe_adc *info,
 static int stmpe_read_temp(struct stmpe_adc *info,
 		struct iio_chan_spec const *chan, int *val)
 {
-	long ret;
+	unsigned long ret;
 
 	mutex_lock(&info->lock);
 
@@ -114,7 +114,7 @@ static int stmpe_read_temp(struct stmpe_adc *info,
 
 	ret = wait_for_completion_timeout(&info->completion, STMPE_ADC_TIMEOUT);
 
-	if (ret <= 0) {
+	if (ret == 0) {
 		mutex_unlock(&info->lock);
 		return -ETIMEDOUT;
 	}
-- 
2.35.1



