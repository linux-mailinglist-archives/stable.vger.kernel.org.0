Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3012741D5F7
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 11:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349161AbhI3JHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 05:07:10 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:53820 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349146AbhI3JHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 05:07:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1632992726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P2SV8i4zOKKKMJrzp1Jbf97C0U75RRAm1lh6MTcopZI=;
        b=ZpQ+Up4LloJyy2Aqw1WVTFwhKCbHwbG+AFzLqVuVYj1hfAuGFJafE5QCcv6Bz1YlLfRMOK
        i3Po4369qINa2QZ7W59VH6SxXJNmqZ3Z9ZiITx64FsqjuPBkOWBuRbC66Lz3PwNj9dtl4W
        TwJA9lOrueyOC39SWLNZdmz9TaIXRlA=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2059.outbound.protection.outlook.com [104.47.2.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-38-FIS3G5RoP9OFaIdVXcZa_A-2; Thu, 30 Sep 2021 11:05:25 +0200
X-MC-Unique: FIS3G5RoP9OFaIdVXcZa_A-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQhgcyTuXHKO6qyJlAtM0JSKpDNYWnFe9qvH1UdwJXHsud2NiTMm943z4V3YJskkoNtmTcMcVbWmehxEfQOu0IHhsahIeC3zatraxVulT44omVj/6Rlocud8BJ/J0hZkraHDay4bY+IPWoUKTPHxOKtB6WzFGpfORDXSi7708qFk9h3ZbXRloATl75bTJj//YF88sYiNkkNc6eYaVNczoNKDMXB/7DMl3L8rpap9XOPm8UmLVIiYqyAXkqu2Nhgq2i2KnfZXhsH2+lTKp9646E4zqcc8nBVVn1viO0HPRUrXsjvDfDTDp5r2a2eSZAmsU3j0v2eTOkKOhseHy9FQ6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=P2SV8i4zOKKKMJrzp1Jbf97C0U75RRAm1lh6MTcopZI=;
 b=GdSRhdDRlVb1ukSEM+Ks3F3GZOEvsnop2VSTn9Rb8BAYSx4ySKTl8wdM4rnpLIYrWhkBVV6Zo1Y2aNdMuOxii/Viakx8JRgC694Kr0U//ulBUeHe+UBgF9OAx5mTXJFoYRDz6d9E6Rn14mRjNpmLprE//DsJQoDmTDwA6sNQ4CAYBr94s8WfamsYoqt1isCEGjg2V2stgkNa0ALXjDxvv/y+yVsQGMJC4r9gW95awHAMzyPTuqura6+E22swM2ScmU27i9vXkZuktg9HSFRGjBjutvg+nG3oBBgZ/bxKHbYfN7lCBTIleL/JnjS+1kGpf0tJ2RaeeHX12it3EsZ2dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB6PR04MB3143.eurprd04.prod.outlook.com (2603:10a6:6:11::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Thu, 30 Sep
 2021 09:05:23 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4566.014; Thu, 30 Sep 2021
 09:05:23 +0000
Subject: Re: [PATCH 2/2] USB: cdc-acm: fix break reporting
To:     Johan Hovold <johan@kernel.org>, Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210929090937.7410-1-johan@kernel.org>
 <20210929090937.7410-3-johan@kernel.org>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <b4d332bf-de58-f0a5-c403-429b1c67af1b@suse.com>
Date:   Thu, 30 Sep 2021 11:05:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210929090937.7410-3-johan@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM6PR02CA0010.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::23) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from linux.fritz.box (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by AM6PR02CA0010.eurprd02.prod.outlook.com (2603:10a6:20b:6e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 09:05:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1393d938-8398-4d74-66e3-08d983f16f7f
X-MS-TrafficTypeDiagnostic: DB6PR04MB3143:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB3143CF2D5D50E83EE5DFE971C7AA9@DB6PR04MB3143.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wCNFtzDTyPK0Vyb9FvlpfqzPWVd+xLpSOTgAAtEMtGHvKf6la+LzviJtPqRk+gGOUvwpNeqQkgmzdh5X3bMDEw5aAGKhcnsdUiJ0Qw9KeZGX1GyfilRA6f6iC7kh0lpMgN3/Qj1Ey4qAU1MqIe4sKRygQClzqFDm1FYDgc4RNVyFbCH3i1hyb9WoPSN7Ce2wqNEcdhNMwn9nf5SXyLPyXHP0fhmV/9vPL6HdBIUF2iVGMWp/DJ9PP3Ov+PF8JOvZ68WU3NB0yUbA8FklEXdsBv141QgLL0Q/JVDQEQon7tWtinm8Xw9qdOLh1AklMMNu2yzYN/LwCwzuLl7jO6ydqMRvadVpd6lWKTeLzYpSVQm2pR+TzlimEicurL6qs7f1OdDCGVZt3gD6MTvFqutVRI3wTIUGSQywNh2+Oegr5C/hpPlt9NLLxAj0TIGzIFX+ajKO+w4PU4OLKbxd6fXKfgMtEw1wzl/EJ75KKiZHmrVTLVPMxqTx7EwIXPHZJSmw23q9qIYvdu4mp/EMBTewKuVKKrPxLsCS+qYVNESciWwG6mzp+Dt60h+FmwkDytUSDmDwaZQ1xseuSXJsitzbiyUL5mzTQG723eI8JS/Wbe0/On9WannlaEoNxIb7O10rliihltrDtChHFgt7/gZSNM0cKmzUwTkMqv2XJfbqgRq/Z7b5EYi+YbepEpqWil1W+qNUlx3lprktLdlLU2W9OQwCePstDKaa8xXkhFsNUhg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(110136005)(5660300002)(4744005)(186003)(53546011)(8676002)(316002)(6512007)(4326008)(2906002)(6486002)(86362001)(31696002)(36756003)(2616005)(66946007)(66556008)(66476007)(38100700002)(6506007)(508600001)(8936002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzQ3Y1BVQndKaFpJa2hzY1BJaGcwZU5oZEc1WGpGbmxHV2ZwUFBYSVBIQ0hX?=
 =?utf-8?B?UlJqMHA1WU4zUGdkeDhRNCtibCtFd2JnQ0lYVzArZlYvaGwwTHYzaVVsZFFo?=
 =?utf-8?B?eEg3RVptdnpKRkJNQnkvaHo2ZW1lTElhSjdsM3RVVzljRm4vMTZSWm82SGNu?=
 =?utf-8?B?TVY4ZGlSbnRTQUduelRUUmN1RVVUZCtaczF4V2xrQ3Y5UldzY1EzYWl3UzU1?=
 =?utf-8?B?blQ2TzJLeElOQ2hVSXNXZGpMb0c4WnlSTTY1ZVRHbGdFZ2d4WmdrOWF1eElm?=
 =?utf-8?B?SnB3N3l5d09mM04yLzV3M0g2Uk9vTmsrQVFLMURpUTc2SXliR0tqN0NQWDVW?=
 =?utf-8?B?OFlTcTJFNXltUGFLd1lYb3dYYXVoRjlYUVhDMDZtUEFLTWJ3VkQ5R0VhdjBC?=
 =?utf-8?B?ZlYrSEpLbXAzNk0rdHZwcTIrSHFsQThLRVR0S0wyMkhOWVdmRTJVeFJXTk1t?=
 =?utf-8?B?anlORVRBczVic2gvUmZJTWMvYTZGNStSbFJqVmJ2bjhKc1l2QUkvRi9pN0Vy?=
 =?utf-8?B?MVhFUGJ4WkZ2bFg0MHI3eFlQa2Y0d2FtR0dZbHhMaW04QklvbmlqV0ZsN0F0?=
 =?utf-8?B?cmkvQWFTVnNmZjgwRjJvVm9vTmtRNXFON1NER3ZXOGRUMHBWZXFNMldEd3dK?=
 =?utf-8?B?L05pRGJpN0dwL2lrVURlVnROMkl2eTdWYmxWMzY2a2xYai9STEpzNUljN2pC?=
 =?utf-8?B?TkNESlNBOWovN0h3d1RlYURnWVJ0YWFSRFhUdnZiZHhQekh2T3dCVHpDTmYv?=
 =?utf-8?B?clFTV0ttVG42SEkxQ2NiVGNSRjdUU1hsQmlMU0NkVzgwOFBSVGxYZHFFd1NI?=
 =?utf-8?B?Y2YrWk85WWp6K01nS08wQStyKzNreExaWm0ya2ZlUmN0eE1tQ3A0M3lyTHJB?=
 =?utf-8?B?bmszWHQzMjE2UzhKSjRmTFk2akl4dUNuL3VDYXhUS1lGc0VNeGZ3ZG1xODZj?=
 =?utf-8?B?SitWMHBUTml5ZDI2RWNIVEloTWJVU1dzMWpJalYvdzd5dzRFaFY5WU1qVE5j?=
 =?utf-8?B?RW01c240Y3IwQVFGQ05QRE5xL2ZWWnljZVJvVGw4OGdXVmZ5V0E4cUhLRVo5?=
 =?utf-8?B?SnQxczBWdmI4MVNlbVJjS1BFU1JwUGxUMWx6MGEyN012MmhRVVJ0NmpCcFZS?=
 =?utf-8?B?aGcxK1habklyV3JHbXh4T2RTN20xYXVpSVhKZXhOcTUvakRFNURUTDBuSmhK?=
 =?utf-8?B?SU5rNWNZSHJnY1FZd1BodkJrSVhycG5SR01NeWovc1FKckxyVkk1MDVGa1RK?=
 =?utf-8?B?KzZ3aUg5cW55YzdpMVZRMlZ3ZkNyNlZDbUgxSFJEOTZjc3VOR0xGbUpEMlZG?=
 =?utf-8?B?bnI4QlorUU1SMVhvWldubkJBVXNxbUF0cTBrbTNRMlNPSE5jZFdtZUJ5YzQ4?=
 =?utf-8?B?ZEVuaWhyTUJwbUNDUjBzTGVFamIvTElVWkRHZXVVOXEyODQ0SlRaN1VwQWtj?=
 =?utf-8?B?TzdjK3BwY1psMFQ5NTU2UWlyNlZ5MUdwRGs1OWNlbXJPZk9VdWZ0eDUyZGNp?=
 =?utf-8?B?UU5uWUNwMWwrU3hKSHJkYnpYZUg0Y0RiNHAwblhSSmVxWklSMjBtK043cy9i?=
 =?utf-8?B?dUt1bzhITVZmOTdoY01kZGxSUlRRUUtxZE05LzhJL2VmTi9uVkk0cXh2NGNn?=
 =?utf-8?B?R3lUSWI2djlvUlQwT2MwZk9GV2RMemZIb0svWk1DbnFRTFdQR09FeGhCbkFI?=
 =?utf-8?B?NjVSdjFucEQ5YjRlWm5PVEV1dnFZWW1JOTE2emtaSndrUWdyTS8zLzFPN29k?=
 =?utf-8?B?MlM3WGdtU3kzOHlXZ0l2MEV2NEZPY085dHZ5NGNrSWhhRHdlcUNtbFQzdHhS?=
 =?utf-8?B?SDhVK0dJTWVGQ2hWcVNaVisvajlqMExWb1RvM2dsQXN3SCtmUTN2blZaV2ZJ?=
 =?utf-8?Q?rCjj1D6QjI0Hr?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1393d938-8398-4d74-66e3-08d983f16f7f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 09:05:23.1722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Id9fH3zn5ATuKf0PDFVvQCaReSXjh8XLNQA4XpUgnpBFlzw7Dtt3f2ByPm/reUTeAKhTe1l1ck6SrTAyTB7+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3143
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29.09.21 11:09, Johan Hovold wrote:
> A recent change that started reporting break events forgot to push the
> event to the line discipline, which meant that a detected break would
> not be reported until further characters had been receive (the port
> could even have been closed and reopened in between).
>
> Fixes: 08dff274edda ("cdc-acm: fix BREAK rx code path adding necessary calls")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>

