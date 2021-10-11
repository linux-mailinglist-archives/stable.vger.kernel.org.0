Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17FA42859B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 05:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhJKDeh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 10 Oct 2021 23:34:37 -0400
Received: from comms.puri.sm ([159.203.221.185]:32822 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233264AbhJKDeh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Oct 2021 23:34:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 4426CE01C9;
        Sun, 10 Oct 2021 20:32:37 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0Vpvc_Y5b0Jg; Sun, 10 Oct 2021 20:32:36 -0700 (PDT)
From:   Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
To:     Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>, kernel@puri.sm,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] power: supply: max17042_battery: Clear status bits in interrupt handler
Date:   Mon, 11 Oct 2021 05:32:30 +0200
Message-ID: <11303414.9r73sBlGM0@pliszka>
In-Reply-To: <20210914121806.1301131-1-sebastian.krzyszkowiak@puri.sm>
References: <20210914121806.1301131-1-sebastian.krzyszkowiak@puri.sm>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On wtorek, 14 września 2021 14:18:05 CEST Sebastian Krzyszkowiak wrote:
> The gauge requires us to clear the status bits manually for some alerts
> to be properly dismissed. Previously the IRQ was configured to react only
> on falling edge, which wasn't technically correct (the ALRT line is active
> low), but it had a happy side-effect of preventing interrupt storms
> on uncleared alerts from happening.
> 
> Fixes: 7fbf6b731bca ("power: supply: max17042: Do not enforce (incorrect)
> interrupt trigger type") Cc: <stable@vger.kernel.org>
> Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> ---
> v2: added a comment on why it clears all alert bits
> ---
>  drivers/power/supply/max17042_battery.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/power/supply/max17042_battery.c
> b/drivers/power/supply/max17042_battery.c index 8dffae76b6a3..da78ffe6a3ec
> 100644
> --- a/drivers/power/supply/max17042_battery.c
> +++ b/drivers/power/supply/max17042_battery.c
> @@ -876,6 +876,10 @@ static irqreturn_t max17042_thread_handler(int id, void
> *dev) max17042_set_soc_threshold(chip, 1);
>  	}
> 
> +	/* we implicitly handle all alerts via power_supply_changed */
> +	regmap_clear_bits(chip->regmap, MAX17042_STATUS,
> +			  0xFFFF & ~(STATUS_POR_BIT | 
STATUS_BST_BIT));
> +
>  	power_supply_changed(chip->battery);
>  	return IRQ_HANDLED;
>  }

Ping? Seems this didn't get applied yet.

S.


