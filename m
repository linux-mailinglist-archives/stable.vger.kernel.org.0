Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B249239FB6
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 08:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHCGpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 02:45:04 -0400
Received: from mailout05.rmx.de ([94.199.90.90]:45032 "EHLO mailout05.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbgHCGpE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 02:45:04 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout05.rmx.de (Postfix) with ESMTPS id 4BKpKS1Xslz9xjp;
        Mon,  3 Aug 2020 08:45:00 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4BKpK73msMz2TSDj;
        Mon,  3 Aug 2020 08:44:43 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.50) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 3 Aug
 2020 08:44:30 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Lars-Peter Clausen <lars@metafoo.de>
CC:     Jonathan Cameron <jic23@kernel.org>, <stable@vger.kernel.org>,
        "Hartmut Knaack" <knaack.h@gmx.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iio: trigger: sysfs: Disable irqs before calling iio_trigger_poll()
Date:   Mon, 3 Aug 2020 08:44:29 +0200
Message-ID: <4871626.01MspNxQH7@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <2443aad4-b631-bfe7-e79c-2cb585685a1e@metafoo.de>
References: <20200727145714.4377-1-ceggers@arri.de> <2272098.D4WoNcAbr4@n95hx1g2> <2443aad4-b631-bfe7-e79c-2cb585685a1e@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.50]
X-RMX-ID: 20200803-084449-4BKpK73msMz2TSDj-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lars,

On Monday, 3 August 2020, 08:37:43 CEST, Lars-Peter Clausen wrote:
> The sysfs IIO trigger uses irq_work to schedule the iio_trigger_poll()
> and the promise of irq_work is that the callback will run in hard IRQ
> context. That's the whole point of it.
> 
> irq_work_run_list(), which shows up in your callgraph, has as
> BUG_ON(!irqs_disabled())[1], so we should never even get to calling
> iio_trigger_poll() if IRQs where not disabled at this point. That's the
> same condition that triggers the WARN_ON() in __handle_irq_event_percpu.
is my patch sufficient, or would you prefer a different solution?

> Are you using a non-upstream kernel? Maybe a RT kernel?
I use v5.4.<almost-latest>-rt

regards
Christian



