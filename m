Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DBC6E9484
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 14:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjDTMfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 08:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjDTMfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 08:35:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573D261A8;
        Thu, 20 Apr 2023 05:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37DDF647D2;
        Thu, 20 Apr 2023 12:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B923BC433EF;
        Thu, 20 Apr 2023 12:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681994095;
        bh=ZVPl9soHfS/xgIlOXOG9k3GM/fGYYRXOIzddm4WJhjM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=b8ljy5P3Z3nJqO65Pk3yCCziiE+r1s7kCSUhWku/dGfgSnTHtIbBV33ey0MUo9rs0
         Y2VZV33LarMGQy0O5XgDSE+rFH7jmB5Tq1dDghjAYhgjbGcogK+G6M7lrSjMcB4hdx
         78tBnXhneaARVVwTEXplra0jZIwCpLTIHiGV6Vy092lCTgyK20gub24iZVw6YtkeuG
         Y5jwVPiWV4EjclCp9YwR66vtoeYnS/JVxCEYtPSaf2qszvWAs7Z9ndopB6xjYfQ36J
         uCeWD37p9Ffu3hfi7bV7RM9gFfvjyQq1cVD302LJ/1zjqke0KytjrzjqoG0vSYpMLG
         IV6VUFbjGfcnw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/4] wifi: rtw88: usb: fix priority queue to endpoint
 mapping
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230417140358.2240429-2-s.hauer@pengutronix.de>
References: <20230417140358.2240429-2-s.hauer@pengutronix.de>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Tim K <tpkuester@gmail.com>,
        "Alex G ." <mr.nuke.me@gmail.com>,
        Nick Morrow <morrownr@gmail.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Andreas Henriksson <andreas@fatal.se>,
        ValdikSS <iam@valdikss.org.ru>, kernel@pengutronix.de,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168199409054.31131.13943288409295170406.kvalo@kernel.org>
Date:   Thu, 20 Apr 2023 12:34:52 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sascha Hauer <s.hauer@pengutronix.de> wrote:

> The RTW88 chipsets have four different priority queues in hardware. For
> the USB type chipsets the packets destined for a specific priority queue
> must be sent through the endpoint corresponding to the queue. This was
> not fully understood when porting from the RTW88 USB out of tree driver
> and thus violated.
> 
> This patch implements the qsel to endpoint mapping as in
> get_usb_bulkout_id_88xx() in the downstream driver.
> 
> Without this the driver often issues "timed out to flush queue 3"
> warnings and often TX stalls completely.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Tested-by: ValdikSS <iam@valdikss.org.ru>
> Tested-by: Alexandru gagniuc <mr.nuke.me@gmail.com>
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: stable@vger.kernel.org
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

4 patches applied to wireless-next.git, thanks.

a6f187f92bcc wifi: rtw88: usb: fix priority queue to endpoint mapping
14705f969d98 wifi: rtw88: rtw8821c: Fix rfe_option field width
97c75e1adeda wifi: rtw88: set pkg_type correctly for specific rtw8821c variants
172591baa2cc wifi: rtw88: call rtw8821c_switch_rf_set() according to chip variant

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230417140358.2240429-2-s.hauer@pengutronix.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

