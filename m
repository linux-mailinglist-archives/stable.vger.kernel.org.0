Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0455E9BD6
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 10:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbiIZIUH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 26 Sep 2022 04:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbiIZIT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 04:19:58 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BAF12098
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 01:19:49 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-405-Qb3Og9akNIqbdq-vx1UKdQ-1; Mon, 26 Sep 2022 09:19:46 +0100
X-MC-Unique: Qb3Og9akNIqbdq-vx1UKdQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 26 Sep
 2022 09:19:40 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Mon, 26 Sep 2022 09:19:40 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'K Prateek Nayak' <kprateek.nayak@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "rafael@kernel.org" <rafael@kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "andi@lisas.de" <andi@lisas.de>, "puwen@hygon.cn" <puwen@hygon.cn>,
        "mario.limonciello@amd.com" <mario.limonciello@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "gpiccoli@igalia.com" <gpiccoli@igalia.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "ananth.narayan@amd.com" <ananth.narayan@amd.com>,
        "gautham.shenoy@amd.com" <gautham.shenoy@amd.com>,
        Calvin Ong <calvin.ong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] x86,acpi: Limit "Dummy wait" workaround to older AMD
 and Intel processors
Thread-Topic: [PATCH v2] x86,acpi: Limit "Dummy wait" workaround to older AMD
 and Intel processors
Thread-Index: AQHYz2KQHQ0Aty345ECS39s1ZZ3yPa3xXk7w
Date:   Mon, 26 Sep 2022 08:19:40 +0000
Message-ID: <93705b7dab2f4d6db7f4631648daf16f@AcuMS.aculab.com>
References: <20220923153801.9167-1-kprateek.nayak@amd.com>
In-Reply-To: <20220923153801.9167-1-kprateek.nayak@amd.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: K Prateek Nayak
> Sent: 23 September 2022 16:38
....
> 
> This workaround is very painful on modern systems with a large number of
> cores. The "inl()" can take thousands of cycles. Sampling certain
> workloads with IBS on AMD Zen3 system shows that a significant amount of
> time is spent in the dummy op, which incorrectly gets accounted as
> C-State residency. A large C-State residency value can prime the cpuidle
> governor to recommend a deeper C-State during the subsequent idle
> instances, starting a vicious cycle, leading to performance degradation
> on workloads that rapidly switch between busy and idle phases.
> (For the extent of the performance degradation refer link [2])

Isn't that a horrid bug itself?
Sounds like it affects any code that is doing pio reads of hardware buffers.
While they are slow they are necessary.
IIRC any PCIe read into an Altera fpga takes about 128 cycles of the 125MHz
clock. The Intel cpu I've checked will only execute one concurrent PCIe read
for each cpu core - so the cpu soon stalls for thousands of clocks.

> The dummy wait is unnecessary on processors based on the Zen
> microarchitecture (AMD family 17h+ and HYGON). Skip it to prevent
> polluting the C-state residency information. Among the pre-family 17h
> AMD processors, there has been at least one report of an AMD Athlon on a
> VIA chipset (circa 2006) where this this problem was seen (see [3] for
> report by Andreas Mohr).
> 
> Modern Intel processors use MWAIT based C-States in the intel_idle driver
> and are not impacted by this code path. For older Intel processors that
> use the acpi_idle driver, a workaround was suggested by Dave Hansen and
> Rafael J. Wysocki to regard all Intel chipsets using the IOPORT based
> C-state management as being affected by this problem (see [4] for
> workaround proposed).

Can you use a surrogate (maybe AVX support?) to exclude large groups
on modern cpu?

Another possibility is that is the io address doesn't really matter
are there any locations that have moved on-die and are now executed
much faster than the ISA bus speed of older systems?
Or do all the 'originally ISA' peripherals still run at ISA speeds?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

