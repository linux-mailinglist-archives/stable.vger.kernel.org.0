Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0852F5F2B2B
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiJCHus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbiJCHuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:50:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83805AC72;
        Mon,  3 Oct 2022 00:28:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 706C960FB3;
        Mon,  3 Oct 2022 07:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DFCC43142;
        Mon,  3 Oct 2022 07:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781418;
        bh=iiHvL8xuvSgYPTGIvbygeHeLLXH/8zJ7cHYbq0fxa4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1vsldhahH/KUy1Z3fwnvfRvvPobR4XSoy+RbQcCaLKdiWnrlkjQ4Pz776TNDYIJw
         pZVNz59k5MO7ipcdOH6MWyTexPZtA4IWr/k+aUnuviQkfGXfFMZu187AS7kTJwau93
         f/vvw/eIEl/7XzOZpiiRrWcZl+eki2LY43MnwX/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 13/83] Input: snvs_pwrkey - fix SNVS_HPVIDR1 register address
Date:   Mon,  3 Oct 2022 09:10:38 +0200
Message-Id: <20221003070722.316560040@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

commit e62563db857f81d75c5726a35bc0180bed6d1540 upstream.

Both i.MX6 and i.MX8 reference manuals list 0xBF8 as SNVS_HPVIDR1
(chapters 57.9 and 6.4.5 respectively).

Without this, trying to read the revision number results in 0 on
all revisions, causing the i.MX6 quirk to apply on all platforms,
which in turn causes the driver to synthesise power button release
events instead of passing the real one as they happen even on
platforms like i.MX8 where that's not wanted.

Fixes: 1a26c920717a ("Input: snvs_pwrkey - send key events for i.MX6 S, DL and Q")
Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/4599101.ElGaqSPkdT@pliszka
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/snvs_pwrkey.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/keyboard/snvs_pwrkey.c
+++ b/drivers/input/keyboard/snvs_pwrkey.c
@@ -20,7 +20,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 
-#define SNVS_HPVIDR1_REG	0xF8
+#define SNVS_HPVIDR1_REG	0xBF8
 #define SNVS_LPSR_REG		0x4C	/* LP Status Register */
 #define SNVS_LPCR_REG		0x38	/* LP Control Register */
 #define SNVS_HPSR_REG		0x14


