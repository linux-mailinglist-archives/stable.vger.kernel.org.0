Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D055283322
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 11:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgJEJ0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 05:26:06 -0400
Received: from mailout12.rmx.de ([94.199.88.78]:56290 "EHLO mailout12.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJEJ0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 05:26:06 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout12.rmx.de (Postfix) with ESMTPS id 4C4Zw961JPzRp7N;
        Mon,  5 Oct 2020 11:26:01 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4C4Zvn14HCz2TTL1;
        Mon,  5 Oct 2020 11:25:41 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.143) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 5 Oct
 2020 11:25:13 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Krzysztof Kozlowski <krzk@kernel.org>
CC:     Oleksij Rempel <linux@rempel-privat.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] i2c: imx: Check for I2SR_IAL after every byte
Date:   Mon, 5 Oct 2020 11:25:13 +0200
Message-ID: <3765943.G7FBkpUTMe@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201005080725.GB7135@kozik-lap>
References: <20201002152305.4963-1-ceggers@arri.de> <20201002152305.4963-3-ceggers@arri.de> <20201005080725.GB7135@kozik-lap>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.143]
X-RMX-ID: 20201005-112545-4C4Zvn14HCz2TTL1-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday, 5 October 2020, 10:07:25 CEST, Krzysztof Kozlowski wrote:
> The I2C on Vybrid VF500 still works fine. I did not test this actual
> condition (arbitration) but only a regular I2C driver (BQ27xxx fuel
> gauge). Obviously this only proves that regular operation is not
> broken...
thank you very much for testing on Vybrid.

> Alternatively if you have a specific testing procedure (reproduction of
> a problem), please share.

The IAL errors happen due to noise on our I2C bus. We have our power supply 
connected via I2C. The hardware designers wanted to make sure that no
high currents flow through the ground pins of the I2C interface. So they added 
a series resistor (30 Ohm) in the GND line between the power supply and the 
i.MX board.

If you have an I2C device on an external PCB, adding some small series 
resistance in the GND line may cause IAL errors. On the other hand, if 
everything else works fine, also handling if IAL should work on Vybrid.

> Best regards,
> Krzysztof
Best regards
Christian



