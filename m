Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F6F3C20E2
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 10:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhGIIgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 04:36:51 -0400
Received: from mail-mw2nam12on2067.outbound.protection.outlook.com ([40.107.244.67]:22113
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231382AbhGIIgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 04:36:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZyYrtRWhMK/YkEnY9eVZGeQoYdu/SJ+ZdtMIqokStEIru/aiblXYQLcqeLZ1XE6v+eNo5ovM0+1Fa3vwZod/uhOPhpDHvYp78cZEa6Gifl/A09HSdr3BlyFWRTYf/mgnchKyij5gv86t+VrPQTtFMPZ0yWwHvWFb9Jnp0+aI/I7NE/qSBec9RoNzY9UwXVwrCPK+A1k6jkXdF5OGg5tRoa33O4Msd/W9+77G+TiGS8sW1/HRvEHqZ78Zmv6Y5zK19d3qG3xoeUurBLtrMbHEL5apRPJyoxjJpQHEV5MILVZB2RLMzEU1n5SkZQI8irloGelakpB8JpyXQYxEZv4lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkjvjaBHugt2zg3+w/dZfGO1RyA1pc5GcXl255bR5pY=;
 b=EXyMtS3C+PVxFjbcL/CGebF2iwpVzH78Nzb8QrTQt24XVYDBDr66G6bKuI3fO91gwGZ8lUJCDP840B9B27/0KWKEmbDqh5V32uGqYyGtoocRmHDCiQBGNPVhJlbkCPDxiCFg/Sk5P0f76Y9FXyO3gTUg1xql0m3QInbojDnYrnyRsGuIJ4D5faTPkANgBfYjauND4P4pAqShdPuaoxdI+so/uRaovmiPFN84NyFGgXqIOPg2sVvCBZ0LolW2uHxdRlUPCPqBuA+AnI2XcqAXfgfK2WUR4pkkKbL4JUwhV7jj1mjSQGOd0LeB0HTot+z0NwYJ9YiPkW2Di3tBccXz9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkjvjaBHugt2zg3+w/dZfGO1RyA1pc5GcXl255bR5pY=;
 b=cEfMHr6DtZzOSEvUFz8uswfCYkTZ8ZkmxgyOTIG9pS9NsPgj/nzip87j7SG1kHbiKBUvu9c8VqEWNwaIeiSlIDwf0iHkg9/C7AuPLmxqDbNToTy3cPSK5EvI63E8NIYpTcQ7+lwsJxhfhYDZ3GhMFZb9DLXG/zpQ4yVuswXqG+fE497jr42TY8dMTcJnscTwBf1Dj25qp07roVgoDziD1ZFc4JwK2bLp+HQ+lfrViMlborqz1C1NiyqHEpFLJz3mWf5rkyg+OjWrzoM1b2HCWAjabn/QuaXRHrjjMViNv3ynpsopDoSl+MgV/CyMcctMtth8EyBqBtqiV+TD/Pt76A==
Received: from DM5PR07CA0104.namprd07.prod.outlook.com (2603:10b6:4:ae::33) by
 SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4308.21; Fri, 9 Jul 2021 08:34:06 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::eb) by DM5PR07CA0104.outlook.office365.com
 (2603:10b6:4:ae::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23 via Frontend
 Transport; Fri, 9 Jul 2021 08:34:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 08:34:05 +0000
Received: from [10.26.49.10] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Jul
 2021 08:34:03 +0000
Subject: Re: [PATCH V2] serial: tegra: Only print FIFO error message when an
 error occurs
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
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <aad402e7-a2b7-1faf-bc22-eb90bee39d3b@nvidia.com>
Date:   Fri, 9 Jul 2021 09:34:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOd7ZTJf0WoQ8oKo@qmqm.qmqm.pl>
Content-Type: text/plain; charset="iso-8859-2"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 806dc0ae-22fd-45ff-661f-08d942b4506a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4574DC0C590899B0EA5FD793D9189@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7hEf8U0LmpA/+BfUlfnRVagExV4/J9gKTCaHVSWVHpF61Hs6gN7Toatm2M9pbBt+sWoGWmGmlbZ6kbOXbugfFySYGVxOJR+WVDRTzuYmfXiuGpKVziMStCRF84dVIMBZEv7jaqhjd6zDZ5KOTdct74oDe51YcSd83kTdCvzhdgYiUOwbb61Y38VodxMiq46PQk+z9WwYGsvUsvd++MTK4g2fylMLwIfezUQzymSctuUI6e/gKlLU14wSsahqhUhKkUpW/k6RX4NId/ZEhsxcsey3/ReR+C7e+RC73tBWANsCt8VR25s/VKbUH/DIWB066jfsJ4U1JXVKuqdDdLKQx5o7uU1U9usgdOUWOCGaB71FtNZG7qIq3E8VqcKQtXmaKPqqgl5KpzHF9SOUTyw7bdD3YRZ0BAAjsuipRxDVj0fnwlwN+YRWTWr1samJE2cbe3PTs0gKQNedCUHNb52GOIJ4/RrdL0vBjZzbNNtSkakW5f4c5mmUtWbau+WYdsi+wAcEPQZJY0T96Zax7OLCF28HdGb4Eb7kqbZ6XEq3gEceKL7oY5lbSkv8Zk+WjZyTV+zSgcaGDKvzBuVzLGRQnTa7NwPVUzwE6gGcGc14BvhSA+z7y8jCmXtOo682GX9by6APkIBr4blapD3ObHtcWqQnM2LpIkn8bMkWZbqi4ul4awjsvqRpeAHeqSFGSO7TgpP7O4T7t2JQMiZdAUqsty/TiPfZzn6NgzhQSDhUIO460WyrPTuuCIiPFS227vSsMDdE0KUDCgDA09sEKp7Vmw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39850400004)(136003)(36840700001)(46966006)(86362001)(54906003)(83380400001)(16576012)(4326008)(82310400003)(2616005)(15650500001)(36860700001)(82740400003)(7636003)(31696002)(336012)(316002)(426003)(36906005)(6916009)(66574015)(31686004)(47076005)(356005)(4744005)(2906002)(5660300002)(70586007)(8936002)(53546011)(186003)(36756003)(70206006)(34070700002)(16526019)(26005)(8676002)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 08:34:05.9283
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 806dc0ae-22fd-45ff-661f-08d942b4506a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 08/07/2021 23:25, Micha³ Miros³aw wrote:
> On Wed, Jun 30, 2021 at 01:56:43PM +0100, Jon Hunter wrote:
>> The Tegra serial driver always prints an error message when enabling the
>> FIFO for devices that have support for checking the FIFO enable status.
>> Fix this by displaying the error message, only when an error occurs.
>>
>> Finally, update the error message to make it clear that enabling the
>> FIFO failed and display the error code.
> [...]
>> @@ -1045,9 +1045,11 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
>>  
>>  	if (tup->cdata->fifo_mode_enable_status) {
>>  		ret = tegra_uart_wait_fifo_mode_enabled(tup);
>> -		dev_err(tup->uport.dev, "FIFO mode not enabled\n");
>> -		if (ret < 0)
>> +		if (ret < 0) {
>> +			dev_err(tup->uport.dev,
>> +				"Failed to enable FIFO mode: %d\n", ret);
> 
> Could you change this to use %pe and ERR_PTR(ret)?

Sorry, but it is not clear to me why this would be necessary in this case.

Jon

-- 
nvpublic
