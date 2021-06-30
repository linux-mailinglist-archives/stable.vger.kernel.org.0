Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D534D3B826B
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 14:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbhF3MwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 08:52:04 -0400
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:16247
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234455AbhF3MwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 08:52:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaZ/BRwChI57IUVD5no6mr3g1HT44JzmBjdA+CYPj63vq3m6BDeXitFzH2Biahu1hBHoRrdfycnNIJQFY51vVey7RVzE61FmSgfYok9B9088QwYuN9gMTr9ltTovxfSuuvsYeZ5SHGzL0fioDMZvyUNH6KrNl7s6zioy6RrBERPapFSKoTqeOB5Xdho3lZXtvyH8Te933zDBaFtK7DT3wBb49xXDdHuL4knIsvc/dsl9d9nwWIQnly9lOq0suCO0z+vapSxESVvxQi9Ue7dsGXufD7nIxx4j+Q9/zyj7odTlG3y0pwH3fkw27DeZOW1lBwN6cF4lvRsj6UDKhrhOPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDnEO4pDQeSu3wQEAp+gwYDa9wRTXQ4hBnCzDCuErDY=;
 b=O80dEzM1AHbE1J6y4cZg7SRafB72lqsW85Iggx/vGmlj/FBvb656ed47zNNuOXYxUcK9n9nZKu8kAAiZiCPmgk32mUs4ZSQpmOPDtWfwrNMF6VCnroj/BEsiaGNY/oWHfWLxbBi/fuoYuLbACKMaVpeCeJAmccOi2P9s+x2vMU9Dx+Qbi5ZaVcThCxNysS9jqL0KNXdcqK4yvRbII/65kCelMzaGHaVQZwaDBcqfqd1XW4d3cCBGXR0YFUCUrPfV2L2LKYQve6IX1aG9/a6qQHGXWiPWFFf7ImWjAm53QzOXTPZUCbXza5JE5tUZSU/Dgs7EZFJcpozI2rR64FXogA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDnEO4pDQeSu3wQEAp+gwYDa9wRTXQ4hBnCzDCuErDY=;
 b=c9AhB3eou4k4UzO1DyASaAXTP0nQygTWh4lZAQFQxDg3EXtjxoPTtFFVoYQEluSrJJwDusznf536FPty8piD4SJ2y854mTgfVHUMFN8A0o0tP37s5AYZPNGDRGTKxSk+ZCM5nXKEVR2YUrbI5JXZXvMpWNsh/aRuOGIP6X9Tctz2YAw8tWOP2A/8z6SqJtChfPcnVpXg9JxclnDMFrccRL16qYmb92/dDplCoqXP6YjLWCzF0WwjMxnssBYbuylUFqdG7yuQdXgN+Tzm1xC0hI7mOFucOelLrVg7s32HhEPekF+/11wIkiV6o1tbf/fWlaxFixRmTOlZDN3y9vavRQ==
Received: from DS7PR03CA0041.namprd03.prod.outlook.com (2603:10b6:5:3b5::16)
 by MWHPR12MB1424.namprd12.prod.outlook.com (2603:10b6:300:13::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Wed, 30 Jun
 2021 12:49:32 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::ff) by DS7PR03CA0041.outlook.office365.com
 (2603:10b6:5:3b5::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend
 Transport; Wed, 30 Jun 2021 12:49:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4287.22 via Frontend Transport; Wed, 30 Jun 2021 12:49:31 +0000
Received: from [10.26.49.10] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Jun
 2021 12:49:28 +0000
Subject: Re: [PATCH] serial: tegra: Only print FIFO error message when an
 error occurs
To:     Thierry Reding <thierry.reding@gmail.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "Krishna Yarlagadda" <kyarlagadda@nvidia.com>,
        <linux-serial@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20210630094601.136280-1-jonathanh@nvidia.com>
 <YNxfaEDFIW7d7rYi@orome.fritz.box>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f93a11ad-e6cc-7a5a-173a-d2087f6dda12@nvidia.com>
Date:   Wed, 30 Jun 2021 13:49:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YNxfaEDFIW7d7rYi@orome.fritz.box>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d219a22d-8a0a-4031-a99a-08d93bc58165
X-MS-TrafficTypeDiagnostic: MWHPR12MB1424:
X-Microsoft-Antispam-PRVS: <MWHPR12MB142452325E5ABE20835F4FAFD9019@MWHPR12MB1424.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jg18m4nz7UZCGsRMrq6QSesIIhtYV6BLVU+w2xAtKJMnaMDnmOEV5rlbRFG1b0d7QYWP3Km9NBwCak4hiUUXsHn85bSyQlU7zZA1OxxJ82mGgggsTEBRebb8CemJ6IzI+58VMYl3IhWTgvxyxg/8nkbLnFt1ZikrW7oaoYjGB0BTnVQUcjkMT/MkkaAXp6dLP880SiqZjH9bbR6PpsAojpYg3w8JCo5N5jVNPKL59LWcjhALwec682iefX1h1emD8I6E5ZowGJsvS8dqrPPGxePIweHS7KeIKW9+96w7FA6ly67MVeSfHWpZcLZTtH6f2yT6dzPyBVIRPQRsT6DOxYsS2fbhbZJO7SGBGBaV4F8M2Ep1z3WTOiJ2xxnPVvaK++EAbyDz1fmifcV/tPPO2cOkQ5EuTvjaoSUC08McYMXYVMb374hiWxRoBSmKfghe46/az9Ep8LCvm5LDqJ1bBrOqz42QyxIycWOmSN475fmH5UwYrDdaOHMYsoILK77281+vU6DphJfSFiiadcAhioIWm/yKLq10DZt4WX8T2F4qSEISTjIvZ43FJyXBOCpOrepRbsT+aZztZekjFb5pTQ97ghPj3FTwj+72ADH8jLzqlVJo6grs24c0t8N6mCXdjzaFGCupGXCEf6WQS/Wl3XTK3sS+LqauqBo+nH8enJoZvkwuLhmaiDoSTe0UeJ5UxD80WQHRvsSaRxIJGx54RDEirOsHEgUwvnioH/FCSWE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(46966006)(36840700001)(336012)(36756003)(31696002)(70206006)(26005)(316002)(53546011)(47076005)(478600001)(5660300002)(16576012)(2906002)(7636003)(83380400001)(4326008)(86362001)(54906003)(186003)(36860700001)(16526019)(70586007)(2616005)(426003)(6916009)(31686004)(82740400003)(8676002)(356005)(15650500001)(82310400003)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2021 12:49:31.4065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d219a22d-8a0a-4031-a99a-08d93bc58165
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1424
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/06/2021 13:11, Thierry Reding wrote:
> On Wed, Jun 30, 2021 at 10:46:01AM +0100, Jon Hunter wrote:
>> The Tegra serial driver always prints an error message when enabling the
>> FIFO for devices that have support for checking the FIFO enable status.
>> Fix this by only display the error message, when an error occurs.
>>
>> Fixes: 222dcdff3405 ("serial: tegra: check for FIFO mode enabled status")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
>> ---
>>  drivers/tty/serial/serial-tegra.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
>> index 222032792d6c..cd481f7ba8eb 100644
>> --- a/drivers/tty/serial/serial-tegra.c
>> +++ b/drivers/tty/serial/serial-tegra.c
>> @@ -1045,9 +1045,10 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
>>  
>>  	if (tup->cdata->fifo_mode_enable_status) {
>>  		ret = tegra_uart_wait_fifo_mode_enabled(tup);
>> -		dev_err(tup->uport.dev, "FIFO mode not enabled\n");
>> -		if (ret < 0)
>> +		if (ret < 0) {
>> +			dev_err(tup->uport.dev, "FIFO mode not enabled\n");
> 
> The error message seems a bit confusing. I read this as meaning "FIFO
> mode was expected to be enabled but wasn't" whereas this really seems to
> mean that for some reason the FIFO enable timed out.
> 
> In the former case it sounds like a some configuration mismatch, while
> it's really something that went wrong during the process of enabling the
> FIFO mode.
> 
> So I wonder if this should perhaps be something like:
> 
> 	dev_err(tup->uport.dev, "FIFO mode enable timed out\n");
> 
> or something along those lines.

Yes good point. Maybe I should just ...

	dev_err(tup->uport.dev,
		"Failed to enable FIFO mode: %d\n", ret);

Then if it is updated to ever return anything other that -ETIMEDOUT we
are covered. I will send a V2.

Jon

-- 
nvpublic
