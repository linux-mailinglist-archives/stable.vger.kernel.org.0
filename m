Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B70E55C1CD
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbiF0Lxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbiF0Lv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:51:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AB765D8;
        Mon, 27 Jun 2022 04:44:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6925BB80DFB;
        Mon, 27 Jun 2022 11:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB77CC3411D;
        Mon, 27 Jun 2022 11:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330274;
        bh=Ohcf7nGk8n9vCs4Z+7cqN7DCW8MDM/AmhWQ9xORVs54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHx+BQDLykS/x83wz7TbgE9OQ9zloUAj73aFM8PUKgulwF6tyxDfqi6jwX0pfFuNP
         MQXG2N/uRImTObkKEVVZcnQ33xVr5SkpR829n2qd2Qe0aO55h9VnEvCzcpFuImRw2L
         aAHN0DNCA1LoeXx333pF/ZctgF96ELNp6RaO1fRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.18 143/181] iio: adc: aspeed: Fix refcount leak in aspeed_adc_set_trim_data
Date:   Mon, 27 Jun 2022 13:21:56 +0200
Message-Id: <20220627111948.832841064@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit 8a2b6b5687984a010ed094b4f436a2f091987758 upstream.

of_find_node_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: d0a4c17b4073 ("iio: adc: aspeed: Get and set trimming data.")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220516075206.34580-1-linmq006@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/aspeed_adc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -186,6 +186,7 @@ static int aspeed_adc_set_trim_data(stru
 		return -EOPNOTSUPP;
 	}
 	scu = syscon_node_to_regmap(syscon);
+	of_node_put(syscon);
 	if (IS_ERR(scu)) {
 		dev_warn(data->dev, "Failed to get syscon regmap\n");
 		return -EOPNOTSUPP;


