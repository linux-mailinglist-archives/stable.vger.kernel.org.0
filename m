Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08ADD26939C
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgINRhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:37:25 -0400
Received: from mailout07.rmx.de ([94.199.90.95]:34600 "EHLO mailout07.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgINRhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 13:37:13 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout07.rmx.de (Postfix) with ESMTPS id 4BqtpR3xK9zBtwp;
        Mon, 14 Sep 2020 19:37:03 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4Bqtp267Chz2TRjk;
        Mon, 14 Sep 2020 19:36:42 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.15) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 14 Sep
 2020 19:36:20 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Jonathan Cameron <jic23@kernel.org>
CC:     kernel test robot <lkp@intel.com>, <kbuild-all@lists.01.org>,
        "Hartmut Knaack" <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "Peter Meerwald-Stadler" <pmeerw@pmeerw.net>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] iio: trigger: Don't use RT priority
Date:   Mon, 14 Sep 2020 19:36:19 +0200
Message-ID: <2593270.IIsAztQlyu@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20200913104240.5c1b98ae@archlinux>
References: <20200909162216.13765-1-ceggers@arri.de> <202009100951.s9xJuuod%lkp@intel.com> <20200913104240.5c1b98ae@archlinux>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.15]
X-RMX-ID: 20200914-193644-4Bqtp267Chz2TRjk-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jonathan,

On Sunday, 13 September 2020, 11:43:05 CEST, Jonathan Cameron wrote:
> Looks like we can't do this unless we have a precusor patch to export that
> function for module use.

This patch compiles fine on my development kernel (5.4-rt). I guess that it 
doesn't link on latest due to https://lwn.net/Articles/818388/

This raises the important question, which priority to use for the iio trigger. 
According to the above link, this should better be chosen by user space than 
by the kernel. Some systems may require a medium/high priority thread for data 
acquisition, on other systems (like mine) this exposed a number of bugs in the 
i2c bus driver which blocked the whole system.

Use space can change the priority of the iio trigger thread using the chrt 
command. The question is, which priority should be used by default (RT / non 
RT). If desired, I'll port the patch to latest.

What happened on my system (only if interested):
A normal priority user space process was using the i2c bus. Due to noise on 
the bus and several bugs in the (noise related) error handling in i2c-imx, the 
driver code was caught in a busy wait loop with a 500 ms timeout. This was bad 
enough but after the iio trigger irq thread with a RT priority equal to 
interrupt threads wanted to access the same i2c bus, the prio of the user 
space process was boosted and busy waiting was done with IRQ priority. For the 
rest of the 500 ms timeout, no further IRQ threads were serviced.

Best regards
Christian



