Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AD8540E06
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353484AbiFGSv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353343AbiFGSrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC786A889E;
        Tue,  7 Jun 2022 11:02:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2590DB82340;
        Tue,  7 Jun 2022 18:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB82C36B00;
        Tue,  7 Jun 2022 18:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624971;
        bh=wsDuzAc9NqsM7BkZpBqt7GwC66dvPJnn9XcP8LB5P/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4npYdLF2RSqU7tJN+jmDyGHAFonAAbPwjuDmNjQWfAqLWmI+JfChGz3onlDukbfy
         vitQ3vr0FnFi5DwBhPOU4zRefQd9VCZ7KV4/gtI8/+eQSrU7tenFYX8IG/wjXRzlLi
         PW9f0f+w06IVxW8bzEJIztyMh7UAI1Q7HJP9bTiQrLTMs0JEwzWbARY4La7xSYIEXA
         Ca3WrPp5pGClFu6zdlQXD9QB1/SBdbZK9KZwobf1HuCXgKkbmXjHekwSSvl4/tvfkD
         xhwPUF5ePc/jcppDuhHcg67nrv29Cs5LnvUrKXr3I/yOzOSqMmTLcE+UEk4P01D/3j
         erRpqpOh2l9cg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lee.jones@linaro.org
Subject: [PATCH AUTOSEL 4.14 11/25] misc: rtsx: set NULL intfdata when probe fails
Date:   Tue,  7 Jun 2022 14:02:12 -0400
Message-Id: <20220607180229.482040-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180229.482040-1-sashal@kernel.org>
References: <20220607180229.482040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit f861d36e021e1ac4a0a2a1f6411d623809975d63 ]

rtsx_usb_probe() doesn't call usb_set_intfdata() to null out the
interface pointer when probe fails. This leaves a stale pointer.
Noticed the missing usb_set_intfdata() while debugging an unrelated
invalid DMA mapping problem.

Fix it with a call to usb_set_intfdata(..., NULL).

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20220429210913.46804-1-skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/rtsx_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
index 691dab791f7a..e94f855eac15 100644
--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -678,6 +678,7 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 	return 0;
 
 out_init_fail:
+	usb_set_intfdata(ucr->pusb_intf, NULL);
 	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
 			ucr->iobuf_dma);
 	return ret;
-- 
2.35.1

