Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B713C22F5
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 13:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhGILk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 07:40:57 -0400
Received: from mail-mw2nam12on2058.outbound.protection.outlook.com ([40.107.244.58]:22304
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230024AbhGILk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 07:40:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZpmUd1D/xXvNBLS5XrRI5G3NY42QhT8/VbuMgpDEqttdTYLn3sNEBY0IesdUtzjhNAgwihu5JTU35wvu6AeZBCE9LafPKZHsqHbExf+UbI/fP7O3sOB1DBCYUgINQ2WCg7nrUTphDkzDw5VgN+PZpSGtWpsrO4x3EeL5wr4UxvJXuf1Pkr69pOa2ml6ny3nvtPgJpk0nJtOxlfJCr8rOE9Ry8U1TzVnVTtAv3+suaHD9VxC5ptpBZOmEoh6s19GCYIuhAWmzm34lE26ljlj9vbJ16GFMX3k+T5Jo+VciOjY381L5dZSZxD0DxvX5f1gNaXdpFo1mVGDJtZrGk+4wcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mz4QUJNWYJYVAeaK8HiF3+qno/BpzPeapxhxrzE6MA=;
 b=KJwFDdGiyGmxoRFikYypqos2n8kRJcxtDnK5G6tLy7BjDNeNXNlSvk/epDtK8iZWBITBjRZ2HVnc0KqbawSoRKcChpYB58VAMgM5810Z8WXANUR4ufV9kuhOr15Wrzjvm3OGulBVj795fsTPT5nNlLTsRdMto6jpmpwVk+GcgrmQFFGOEGml+8CcmB9y08wzVQtJeERwiQo3J/AOBTRc4yY9n3uAE4prMBQIndx/+NgUNPIRYUFMttyuEBYqRWlEak26k3bXnoJUvvDvwhvE4qzbBo6HHO1CBoWUeJJqNgdWBs6Q1OLBaJI3HuySPeIgmbxf5YEAUozvSFAZLGNNPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mz4QUJNWYJYVAeaK8HiF3+qno/BpzPeapxhxrzE6MA=;
 b=JWUzpS11T8eAdFBmWICULagf25maWlOvr4mhQHWFxRqFI6LMhXklXbr5yJT1WHKqmEitsqpMzz+h+zDxE0aaEPaAk0chWVaOpwPXwBLz17giEpLWweJ4VG8BSwkzG62U17rOWCuc4MoRpTtJvdPaGErDTYYMGbl2BoBUDimRhTg1Tecq53cV61dZIkaqiD1SVzc6UcdTL7rlB7jCZL5/QTi2TMQFSZmpTr8D5QkeFY4n1c/Uw72WQU5GnbmDqFMum4qrA/C1YLfG/JgUC1qEVGzxSOr/QJKs+U7T4g6IJGi1lwZDGRx8hozhe6H8y/+y8I5RkwMHsVOBphvW4cTAiA==
Received: from DS7PR05CA0002.namprd05.prod.outlook.com (2603:10b6:5:3b9::7) by
 MN2PR12MB3615.namprd12.prod.outlook.com (2603:10b6:208:c9::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4308.23; Fri, 9 Jul 2021 11:38:12 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::9c) by DS7PR05CA0002.outlook.office365.com
 (2603:10b6:5:3b9::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.12 via Frontend
 Transport; Fri, 9 Jul 2021 11:38:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 11:38:12 +0000
Received: from [10.26.49.10] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Jul
 2021 11:38:09 +0000
Subject: Re: [PATCH V2] serial: tegra: Only print FIFO error message when an
 error occurs
From:   Jon Hunter <jonathanh@nvidia.com>
To:     =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Laxman Dewangan" <ldewangan@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        <linux-serial@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20210630125643.264264-1-jonathanh@nvidia.com>
 <YOd7ZTJf0WoQ8oKo@qmqm.qmqm.pl>
 <aad402e7-a2b7-1faf-bc22-eb90bee39d3b@nvidia.com>
Message-ID: <30057ea5-5699-9335-f4dd-a9e8ed847ee4@nvidia.com>
Date:   Fri, 9 Jul 2021 12:38:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <aad402e7-a2b7-1faf-bc22-eb90bee39d3b@nvidia.com>
Content-Type: text/plain; charset="iso-8859-2"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 738774ff-3a19-4ff3-36a8-08d942ce0868
X-MS-TrafficTypeDiagnostic: MN2PR12MB3615:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3615571DC2BA155AF7586240D9189@MN2PR12MB3615.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: khNE8m2v2aRjlez8ulankrvbZRXvdM0UTTvMWd26OOmPn5zOdIzqq5eS+1t+4qk8hc/9Cn0FZVutTZQ31ZBKBZr5K/03EbmgpqZ0OURf6+kHY02d2tBytngVewN5efAOmY96PS0S2BEF5ME4Tjfy0vA+DYblRdBnT6a8B7MQkBY4+xbrVifKohy9SxUxLgCnoaQybRslxJl/QYDgD1dO1WplAdsb8i/SFDDHnO8smo+uyTdIKvP3sBsMEg5Fkcni+n16ij4DTJgoVHWNfcEVk4YwH5ro+qNHeP/Scs9xNROCQvVVlycFSDUTHMxhuSaxaYUVPCiT4AZA4RDvgn0mDQMwaH9ACuIcAm5oNK99UOuvicJZv+1gqT0pJQnFL3FTmeNFBCJFJDKm1oKTvgfzHfMhQ2xM3UJje/PUwUjw6f+1n2zBH+gL32NKw6l9KM9zN1Hmsqh1jQSkPE1mYsTHv6FLI48APH/Xk3Rwv28Rfgvd7DNwq3e4MKLe1azh29HC9n2OUAPlHtbz8lD2AkhFdXdR5+8fxpYQn1ThsPZrlu4Tq6cwYNgtYQaLiAMHd0SmZK2jw0WfPE/tNZMYgHaEOFXtnlQj8gMKikRVU+TCBT9OQADWBFoxEGs1spDBIVe8Mz1qX4vOrpvAyAHZzMINjtWCgZu1EPEIeDtcxi6kf5nkZ7/WnorhJ5ZNditfCuK30rKobpXxHbE1xIFGbBAzGnK42KCR6+hSbV6B+iQMX9FEdMJwNMOMmK0WuaLqMDFEWdvJHTcWRbCWwntNp0ghQg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(46966006)(36840700001)(6916009)(5660300002)(36906005)(82740400003)(8676002)(47076005)(8936002)(15650500001)(36756003)(4326008)(54906003)(34070700002)(16576012)(316002)(31696002)(7636003)(356005)(82310400003)(26005)(2906002)(70586007)(70206006)(16526019)(186003)(66574015)(31686004)(426003)(83380400001)(53546011)(86362001)(36860700001)(478600001)(2616005)(336012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 11:38:12.0370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 738774ff-3a19-4ff3-36a8-08d942ce0868
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3615
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 09/07/2021 09:34, Jon Hunter wrote:
> 
> 
> On 08/07/2021 23:25, Micha³ Miros³aw wrote:
>> On Wed, Jun 30, 2021 at 01:56:43PM +0100, Jon Hunter wrote:
>>> The Tegra serial driver always prints an error message when enabling the
>>> FIFO for devices that have support for checking the FIFO enable status.
>>> Fix this by displaying the error message, only when an error occurs.
>>>
>>> Finally, update the error message to make it clear that enabling the
>>> FIFO failed and display the error code.
>> [...]
>>> @@ -1045,9 +1045,11 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
>>>  
>>>  	if (tup->cdata->fifo_mode_enable_status) {
>>>  		ret = tegra_uart_wait_fifo_mode_enabled(tup);
>>> -		dev_err(tup->uport.dev, "FIFO mode not enabled\n");
>>> -		if (ret < 0)
>>> +		if (ret < 0) {
>>> +			dev_err(tup->uport.dev,
>>> +				"Failed to enable FIFO mode: %d\n", ret);
>>
>> Could you change this to use %pe and ERR_PTR(ret)?
> 
> Sorry, but it is not clear to me why this would be necessary in this case.

I see so '%pe' prints the symbolic name of the error code. While that is
nice, it also looks a bit odd. Given that we simply print the error code
values in this driver, from looking at other prints, I prefer to keep it
as is for consistency.

Jon

-- 
nvpublic
