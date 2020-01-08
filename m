Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411141345B7
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 16:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgAHPHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 10:07:43 -0500
Received: from mail-vi1eur05on2108.outbound.protection.outlook.com ([40.107.21.108]:57568
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727541AbgAHPHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 10:07:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hh3kuprxgAhWF6XHwZmqELiUfbcwmz8bn0gg3NrEFi+xlWlzA7fduyOl2OEUxT5Fpp8176j9HC9PG/84KI5AYQjRjYMTHNTxCMPpOHT9bsdD3q7jFqu6YKJ+MvwKgK5P4QVLbDLgz4G20h85uiR9cD3mVUQSxkSRUTw4dx0tX3Kr3gEL7IxfXyjWpwNRevc1WpduS5oF4v9pPwxOk4gN8IZiyffBNzWj1Y+wkdWQTYrAtysXKmokT9i7pkWb/PFyHXbg/FjZVS5tqsGFXBizDYERYi/Kgm6JNufHQQW1ZseVAjbqEzi4Vgis9fiQalmeB6++nDO2WSn1X7ludQo0ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orjRyjcvhJxHCnaz3BPDGgKdjIS1OkrhehrdBUf5UaY=;
 b=KN6HcQ9wjce9lo9ZFHCgT/lr2JSk0CuzdYFaJbtrL0oXYFdZyt6yOspaCMS9aTxiXh7EatOkhjOWvp2mIcwMPJdi1dIbwe3k31PeTPj3QeNBkmJmM9xo5h15e6xDtnDRpHZR66pSQj+YLWJyU/REzxIM4d8bUIOmYXUa0foOUUg+DS8m5gwMR/dCLzG6byrfDcuq4gkqvIbtA/hPVUC7Wvd8hL3mJqOSBMLiuaO1W+HkNGUsuZjGOYamZ3cwpv4exY8J6kFPrJnloeGN1PaQJDKt+JOjr6Yl2dOOW1QLymhQHDW5mh3LirQxnkCNeDvBgd/dHKoXVhNQbBs8nLSgSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orjRyjcvhJxHCnaz3BPDGgKdjIS1OkrhehrdBUf5UaY=;
 b=OxnNkXsIooVvXkVK29wn68JqdX5DCkxSyRSBYRejFmwCYR1+NpSYHVEny3vEEREVM3dq7hWXUig5gfjKE9COvHFYDAer7sHTZpQqhFltKV9wfV2S6439jYvItgaKyCEO7lXtJUVd/0xc82SZvJSOjVxRSmkWlO3G/wQ44HDV61I=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com (20.177.203.20) by
 VI1PR07MB6013.eurprd07.prod.outlook.com (20.178.123.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.6; Wed, 8 Jan 2020 15:07:39 +0000
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::20c4:7ce8:f735:316e]) by VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::20c4:7ce8:f735:316e%2]) with mapi id 15.20.2644.006; Wed, 8 Jan 2020
 15:07:39 +0000
Subject: Re: [PATCH 2/3] genirq/irqdomain: Re-check mapping after associate in
 irq_create_mapping()
To:     Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc:     Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        "Glavinic-Pecotic, Matija (EXT - DE/Ulm)" 
        <matija.glavinic-pecotic.ext@nokia.com>,
        "Adamski, Krzysztof (Nokia - PL/Wroclaw)" 
        <krzysztof.adamski@nokia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20190912094343.5480-1-alexander.sverdlin@nokia.com>
 <20190912094343.5480-3-alexander.sverdlin@nokia.com>
 <2c02b9d5-2394-7dcb-ee89-9950c6071dd1@kernel.org>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <39bcb24e-9e30-6932-be38-b9f2962734fc@nokia.com>
Date:   Wed, 8 Jan 2020 16:07:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
In-Reply-To: <2c02b9d5-2394-7dcb-ee89-9950c6071dd1@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HE1PR05CA0247.eurprd05.prod.outlook.com
 (2603:10a6:3:fb::23) To VI1PR07MB5040.eurprd07.prod.outlook.com
 (2603:10a6:803:9c::20)
MIME-Version: 1.0
Received: from [0.0.0.0] (131.228.32.166) by HE1PR05CA0247.eurprd05.prod.outlook.com (2603:10a6:3:fb::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend Transport; Wed, 8 Jan 2020 15:07:38 +0000
X-Originating-IP: [131.228.32.166]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dcf61354-bc75-4e52-1a4a-08d7944c809b
X-MS-TrafficTypeDiagnostic: VI1PR07MB6013:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR07MB6013BADA3AD0E56A9E8EBF1A883E0@VI1PR07MB6013.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 02760F0D1C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(376002)(366004)(39860400002)(199004)(189003)(2906002)(52116002)(26005)(53546011)(186003)(478600001)(16526019)(6666004)(4326008)(44832011)(31686004)(5660300002)(956004)(54906003)(86362001)(6706004)(110136005)(81166006)(81156014)(8936002)(16576012)(316002)(31696002)(36756003)(66946007)(66476007)(8676002)(2616005)(66556008)(6486002)(78286006);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB6013;H:VI1PR07MB5040.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nYrLITztDlGEZ9oGH8/nitIzUIYzGdbj0ha6MswgWNdW7QM6NHtVEtBAlWKzzBXLVj/XfvYAiSYd4yJ0NVSOS/ZNTl+nmb+FDqje7M8fjlGmKMYhebgN5VgxyfyYxXJVbXvhjW+V454ssUGp/PAgzcupDi0cUV52YtfnAEhc8hi8aQhzyH+aYn9O6RxhE6nIIEtcq9GVu6dPVI6kZD0JA3olu7QfkLqkEdVeZD1eMl2r8Mxn3Af/Q6J9HGQUdXtlafadmnoku09fTpqFiT/6gFYyjlqSxKrjdC1P0k0+MzjIvO963qSCKtXXJomHPl4NFrKLlDfGsaAqQFeLQdhmxUvcy5aF+huU3co7jRudRePM9bR4Omq+Ga4N2hjgmjchTkrhcKq31nK5XC7778jo2tdA845G7sLwelOipLcoBjXhX6BdMi+EUiCmq9/gf+IJkVWIqjbWBDm9tNTvP6X4aJVPmPHl7qEyAMMf10cnOFW8AEMQyTYZO5rhumlg/im4
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf61354-bc75-4e52-1a4a-08d7944c809b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2020 15:07:39.4047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bOHhTTGpienlHID+XJBYnRRs/H/2141E2gfbzCosn23zub3T2ENAiXj1nwsPH+oxU6js5Fk4VY7wCvQrxVBWYJr6Dxk6Yrif/5SmTbjrM/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB6013
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Marc,

On 20/09/2019 17:52, Marc Zyngier wrote:
> On 12/09/2019 10:44, Sverdlin, Alexander (Nokia - DE/Ulm) wrote:
>> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>>
>> If two irq_create_mapping() calls perform a mapping of the same hwirq on
>> two CPU cores in parallel they both will get 0 from irq_find_mapping(),
>> both will allocate unique virq using irq_domain_alloc_descs() and both
>> will finally irq_domain_associate() it. Giving different virq numbers
>> to their callers.
>>
>> In practice the first caller is usually an interrupt controller driver and
>> the seconds is some device requesting the interrupt providede by the above
>> interrupt controller.
> I disagree with this "In practice". An irqchip controller should *very
> rarely* call irq_create_mapping on its own. It usually indicates some
> level of brokenness, unless the mapped interrupt is exposed by the
> irqchip itself (the GIC maintenance interrupt, for example).
> 
>> In this case either the interrupt controller driver configures virq which
>> is not the one being "associated" with hwirq, or the "slave" device
>> requests the virq which is never being triggered.
> Why should the interrupt controller configure that interrupt? On any
> sane platform, the mapping should be created by the user of the
> interrupt, and not by the provider.
> 
> This doesn't mean we shouldn't fix the irqdomain races, but I tend to
> disagree with the analysis here.

would you have time to review v2 of this series?

-- 
Best regards,
Alexander Sverdlin.
