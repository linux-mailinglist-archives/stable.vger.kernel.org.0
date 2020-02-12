Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C7B15A8D4
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 13:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgBLMJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 07:09:50 -0500
Received: from foss.arm.com ([217.140.110.172]:60372 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgBLMJu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Feb 2020 07:09:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 271F930E;
        Wed, 12 Feb 2020 04:09:50 -0800 (PST)
Received: from [192.168.1.123] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44B4C3F6CF;
        Wed, 12 Feb 2020 04:09:48 -0800 (PST)
Subject: Re: [PATCH] ata: ahci_platform: add 32-bit quirk for dwc-ahci
To:     David Laight <David.Laight@ACULAB.COM>,
        Hans de Goede <hdegoede@redhat.com>,
        Roger Quadros <rogerq@ti.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "vigneshr@ti.com" <vigneshr@ti.com>,
        "nsekhar@ti.com" <nsekhar@ti.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?Q?P=c3=a9ter_Ujfalusi?= <peter.ujfalusi@ti.com>
References: <20200206111728.6703-1-rogerq@ti.com>
 <d3a80407-a40a-c9e4-830f-138cfe9b163c@redhat.com>
 <1c3ec10c-8505-a067-d51d-667f47d8d55b@ti.com>
 <37c3ca6a-dc64-9ce9-e43b-03b12da6325e@redhat.com>
 <7e5f503f-03df-29d0-baae-af12d0af6f61@arm.com>
 <2a527d21087b4f959c7f95895d70b669@AcuMS.aculab.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <2f82cd89-a1c2-cf47-97df-3acac0798c85@arm.com>
Date:   Wed, 12 Feb 2020 12:09:49 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <2a527d21087b4f959c7f95895d70b669@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-02-12 11:56 am, David Laight wrote:
> From: Robin Murphy
>> Sent: 12 February 2020 11:43
> ...
>> If the device *is* inherently 64-bit capable, then setting 64-bit masks
>> in the driver is correct - if a 64-bit IP block happens to have been
>> integrated with only 32 address bits wired up, but the system has memory
>> above the 32-bit boundary, then that should be described via
>> "dma-ranges", which should then end up being used to further constrain
>> the device masks internally to the DMA API.
> 
> Given how often this happens (please can I shoot some more
> hardware engineers - he says while compiling some VHDL)
> is it possible to allocate some memory pages that are
> aliases if the address bits over 31 are ignored?
> 
> Then (at least some) drivers could to a run-time probe
> reading to the high address and checking the data didn't
> appear in the low address.
> 
> Only one such set of pages is needed - access can be locked.
> But they'd need to be reserved early on.

(Oh, for that much control over page allocation!)

It's a fun idea, but there's no guarantee that the platform memory map 
is actually suitable (AMD Seattle is the go-to counterexample), and 
having an opt-in test that every driver has to implement individually 
sounds like a maintenance nightmare. I think it's far better all round 
to just expect the firmware-provided machine description - be it 
devicetree, ACPI, or whatever - to correctly describe the integration.

Robin.
