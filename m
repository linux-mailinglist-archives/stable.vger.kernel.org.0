Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A77549FCE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 22:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240931AbiFMUpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 16:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345842AbiFMUpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 16:45:06 -0400
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669F25FDC;
        Mon, 13 Jun 2022 12:52:40 -0700 (PDT)
Received: from [192.168.1.103] (178.176.74.127) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.14; Mon, 13 Jun
 2022 22:52:32 +0300
Subject: Re: [PATCH 4.9 160/167] ata: libata-transport: fix
 {dma|pio|xfer}_mode sysfs files
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <20220613094840.720778945@linuxfoundation.org>
 <20220613094918.497423809@linuxfoundation.org>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <cd1ff8c8-bb25-8e58-a4ed-af74c450d03f@omp.ru>
Date:   Mon, 13 Jun 2022 22:52:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220613094918.497423809@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [178.176.74.127]
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/13/2022 19:36:35
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 171077 [Jun 13 2022]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 489 489 b67d2e276d358fa514f5991440453e6a402e3a26
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 178.176.74.127 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: {Found in DNSBL: 178.176.74.127 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info: omp.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;178.176.74.127:7.1.2
X-KSE-AntiSpam-Info: ApMailHostAddress: 178.176.74.127
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/13/2022 19:40:00
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 6/13/2022 4:53:00 PM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/22 1:10 PM, Greg Kroah-Hartman wrote:

> From: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> commit 72aad489f992871e908ff6d9055b26c6366fb864 upstream.
> 
> The {dma|pio}_mode sysfs files are incorrectly documented as having a
> list of the supported DMA/PIO transfer modes, while the corresponding
> fields of the *struct* ata_device hold the transfer mode IDs, not masks.
> 
> To match these docs, the {dma|pio}_mode (and even xfer_mode!) sysfs
> files are handled by the ata_bitfield_name_match() macro which leads to
> reading such kind of nonsense from them:
> 
> $ cat /sys/class/ata_device/dev3.0/pio_mode
> XFER_UDMA_7, XFER_UDMA_6, XFER_UDMA_5, XFER_UDMA_4, XFER_MW_DMA_4,
> XFER_PIO_6, XFER_PIO_5, XFER_PIO_4, XFER_PIO_3, XFER_PIO_2, XFER_PIO_1,
> XFER_PIO_0
> 
> Using the correct ata_bitfield_name_search() macro fixes that:
> 
> $ cat /sys/class/ata_device/dev3.0/pio_mode
> XFER_PIO_4
> 
> While fixing the file documentation, somewhat reword the {dma|pio}_mode
> file doc and add a note about being mostly useful for PATA devices to
> the xfer_mode file doc...
> 
> Fixes: d9027470b886 ("[libata] Add ATA transport class")
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  Documentation/ABI/testing/sysfs-ata |    5 +++--
>  drivers/ata/libata-transport.c      |    2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> --- a/Documentation/ABI/testing/sysfs-ata
> +++ b/Documentation/ABI/testing/sysfs-ata
> @@ -59,17 +59,18 @@ class
>  
>  dma_mode
>  
> -	Transfer modes supported by the device when in DMA mode.
> +	DMA transfer mode used by the device.
>  	Mostly used by PATA device.
>  
>  pio_mode
>  
> -	Transfer modes supported by the device when in PIO mode.
> +	PIO transfer mode used by the device.
>  	Mostly used by PATA device.
>  
>  xfer_mode
>  
>  	Current transfer mode.
> +	Mostly used by PATA device.
>  

   Again, needs s/device/devices/ as reported already...

MBR, Sergey
