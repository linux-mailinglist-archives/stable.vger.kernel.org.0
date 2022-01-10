Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547C84897EE
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 12:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245065AbiAJLud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 06:50:33 -0500
Received: from mail-dm3nam07on2087.outbound.protection.outlook.com ([40.107.95.87]:21856
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245030AbiAJLt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jan 2022 06:49:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhRYEXBUUYNcHXKNR4k4JaasWy+bQjfzG9jWuNT7732pbgUxFU8N8fUY62YxkYTJ8RZFkhhblydMWlMyr8+qonqdeU3xAOWf/cBq49ZzzQWxo1wA3AiDu1E5T0W3oifpAtAkTnH8PiiYyLnVLNfaZPgMUkUkldf96To99f8sogDXggulChAXtc7loQm9+eA0TfjX04kjfqUMt7qZINmyQmNBP8N/8drcu9LGAvsn8sf8lC59SDOLlGXt2gskcCz4JQoir3ykDuNL8dCfo6oQaEDHnqi1akbK9PXxASh5ypo8DyYugn8EHNBRs8deXfZSZ4RlguR4ELatL1Lbib0TCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xX/ZidgWe/bg0YOJzlImGWTchQWx9zpapenhU0YoZsw=;
 b=iGMt07bkepT9sIYAebIBDEEWTNTTBQue2zNaFHURtCQMiDjBIdEOv4TZPtD/1fdQoq/xNrrnkk2zKfbbsl5DLa13s0gPbCjMhf2+V3cFr8ii6loAsEqlGjCvoSN9lKk1bkQkhFt51GiHSgrJEhB+FZaTpijkH9bgLuCp7wVrkeOk3dnuMO5e4Pockz0VAbHHC/qaGiuAf2dK75ULsgCQrbHOIj4W1U4B05j5UVPPSQ/GEuPgADCRTtJrEaWZpfdBP/604RJuaN00Qa1D9mmVLAfc00NK7US+L0KqZMj7sDc/9q1FX0hfuK1GCBORIZJUtwg/TSKWokQIxyoZ4Iz4LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xX/ZidgWe/bg0YOJzlImGWTchQWx9zpapenhU0YoZsw=;
 b=kx1K1Fxgba+qvXcswJRvRx1fl12XNTycgWIbww41RktowBG/lBaBNOWO9TbhXx2KP/Vpu1Ai4x/32Jzb7BE/xL1IqR7rprWIXSpnuDuSC/nH9rBd9ruGyPMvB+Zl+lx7O/b7r7VTR8GY+sasRDS/pdEnQdoOtEX5EuH96EOXDCC73Z+T5vRragGxZICPJyq5aUOZfxk/7ivbeCqECzJfHJKQm9Fq+LdQzaxIOUODkVKujjDECt9+LFN/hexrLIqUKAtg4uukNwIyE5TQPbL5UGL9ulm7xy2pcGsr0ydEoZ98EyGMDu6shBHl37GcU+NW3qTSjD8ChUnhQWSSy+dF+w==
Received: from MW4PR04CA0066.namprd04.prod.outlook.com (2603:10b6:303:6b::11)
 by CH0PR12MB5370.namprd12.prod.outlook.com (2603:10b6:610:d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 11:49:24 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::ea) by MW4PR04CA0066.outlook.office365.com
 (2603:10b6:303:6b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9 via Frontend
 Transport; Mon, 10 Jan 2022 11:49:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.7 via Frontend Transport; Mon, 10 Jan 2022 11:49:24 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 11:49:22 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 11:49:22 +0000
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 10 Jan 2022 11:49:22 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/34] 5.4.171-rc1 review
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d747dea81c524eaebbaae2b6b85a805c@HQMAIL111.nvidia.com>
Date:   Mon, 10 Jan 2022 11:49:22 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f95e695-367c-45a9-9571-08d9d42f3f83
X-MS-TrafficTypeDiagnostic: CH0PR12MB5370:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5370C5027104411C2BA57909D9509@CH0PR12MB5370.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kdEPJwn3ysoe47sbY1M+cDgsU4mwmZpZfysgLtks9jlXq3TxTGa+b1F+HSxQsH6x3PSSairTlqAw1bV19ff6tdn6f+zGUIAU5qu6gZJFSqiEBVGuR9cuaLhRTTc2uh8HJMYvJrJ7Z5W37NW3s/7dPscqHe6g8bymsfjqP/xQ3IEHSHZjlbTRfk1G0YKc3Ag1MS8Q7hITMIQoDFIKdq3hQsu18Lp3fLsD9QbEShD8alfdu0BdL8fDI4gQ61N8MUV36YERC8sTzBFaPiQCHg5r/6DcKVXvNQYsZwfOZRpfHYjA4zoSQyoc2fsK1in5hycgi6ThZ8dmJQ9viyPg4X1nzU1lAN+T2aCixLQ2WDiNOuOJVXyUE+Qvd2HCF5QjiQK4KqhLVRv9hc8+ioMQzIhHKCeagAB36R4GTBhxCmug7OmGIhLY0fJ/Ejn3YP9OQTQCeYhjyEfUQBOB7/ZcEICDEZejx7Nozm7icDwo9TbNhS+p/HEgv7oK+wubsOeW/popWx6YdcPjyatWPqh3pQCIzt1yUaOvnSKRvG9eso12Or50BPqfMVLfnE1/2hQOYYAYoHguHnP16tUKvL68/0g9+MTM9YeccMlsf3zqquM5EpLUrbZ96kHkv3uvapT7yp00GWX0WRvFrW6oEoJACp30ZNI+SY9qYFiGnG6kAXZN2OBbU++Ytyb3tu0NEU9GjtNG6YETGoLvYBKiBeCwhY8addeD3T3pqP14l0W8Q52/dXYr7+sggLJERG3OEDtGz6LujQ2ZBhJLgnmmfFG1muI9FTzDhdzuE/IGU2vR243/RVjkH/tIkG/+QXfuMY0ntvqSaC06BCPe7YJuf5D6oXTjQNUTcKkoB4pogRkKJdOKuuKBdg1UULwa4CiCOviiIGtN
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(356005)(36860700001)(316002)(40460700001)(8936002)(81166007)(86362001)(6916009)(336012)(47076005)(54906003)(108616005)(24736004)(70586007)(966005)(186003)(4326008)(70206006)(508600001)(7416002)(8676002)(2906002)(5660300002)(426003)(82310400004)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 11:49:24.2681
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f95e695-367c-45a9-9571-08d9d42f3f83
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5370
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 08:22:55 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.171 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.171-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.171-rc1-g681e37e4e026
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
