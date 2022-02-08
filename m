Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61014AD36A
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349009AbiBHIa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345508AbiBHIa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:30:57 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E99C0401F6;
        Tue,  8 Feb 2022 00:30:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tvc0A8yA9Fv0+pRfd0IOphGfS2V0VdkbTtVVlHk/3vZcOe+X28VDGR/v4jyawFtb0FTgv3jX+KuIkcrvr0pRCODGPRMmViWnaduQZprK8ntdtIY9K67gKHhNe3lVzl4zKkmi3DXz5ghprADJs6zFqZRR75/imgPM4d7/udvsKNlDKFlTTxtwnC0FGgaiUvG0LZGqxuZXwnMC6gf442lTdMY3rQdPdwXAhrnpwipRlHwXkhQMeuK5/hZebW7iwRJxT7tvcIzVH3Q+KuahgZABxujGrbDOm7eMoMdfuViIfIKPawSPz0X+skJe5dOH6ZyIaqxZvKF2McnrkVYLi4SHsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UHnrhDm1kCus5HBdlXH9CBFWd9XyM5DkOxYcqQu/ePw=;
 b=gTi1ILVfWXLvGjsLSj37Mg6etzpnNNYZZZj/Yb5HL982Xaoj4BYfZcwMcFhEXVWaQ2I9l263Omw+GoQgzz23+Qc13u4wW+gcLkMu7zJmWiew+Pc2qS/H6O/bSJyTFpPKOlKf/g8gC4IPeFPgdwi/E2J31P+uPoyE6ZtfHzG8KEoocHzqtVqvmy16WTjSQTEyphr1ggaAPx0CF1MK/SGXBqaZnYWZXrJis9s7mCxFsu55KDO0RE2GvWUCv6VBTVzmA3EyXrajw/sZtO+I9/NzL9qgcoHSkbXJ23ZTjl9nKfS+qZ10WZu3s5aGmqT7Y+ZRcels7GeBapd8wazZuIpMlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UHnrhDm1kCus5HBdlXH9CBFWd9XyM5DkOxYcqQu/ePw=;
 b=K2kmuAbkF6efB9oDeWrvHtjVR/0s0e12WkWkshz3FjI8K1+Q/CrFhV4y8gt4z1Ll19zdgf5FYN2H0cCchnMMK3oEgkMUq/GCy+CHFbhUKKmLSzxMJJryNZw0yN+2sx6yklSfkSp5i5aIhKiJeiRz5MlQGt0mbcCWxggxcef9OYvImrVvbzgk8w6/C1/yq3nzTrheNQUq2tKbLEsIVW0UgERxc0K/PivXEqG1LhlL1mHmedEhjR3OseWfGf+8xRdlaFsJYhJO4uJNcCaRMF9O3nskWI5dUYlOYYiR7wePLWK4nW5Wy2WDAe0tbiwItwqDDVAC27dhCFiSEHEu11c0Yw==
Received: from BN0PR04CA0138.namprd04.prod.outlook.com (2603:10b6:408:ed::23)
 by DM6PR12MB3516.namprd12.prod.outlook.com (2603:10b6:5:18b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Tue, 8 Feb
 2022 08:30:56 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::66) by BN0PR04CA0138.outlook.office365.com
 (2603:10b6:408:ed::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Tue, 8 Feb 2022 08:30:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 08:30:55 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 08:30:54 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 00:30:54 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Feb 2022 00:30:53 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <slade@sladewatkins.com>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/86] 4.19.228-rc1 review
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <90c4b8d9-c92c-47e8-b247-059dc4f2c9c7@rnnvmail202.nvidia.com>
Date:   Tue, 8 Feb 2022 00:30:53 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 404597b0-fab2-4346-1b37-08d9eadd536d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3516:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3516B34AA39CD55C7313829CD92D9@DM6PR12MB3516.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8pAkH6AF31Hsejh4SuG3UaZ8Kx8alCuy2MVWZxSIsz8f1zyvRAMoQ42qaRwHwR0PKcIBfREluzF55TYlTovI71Zm18ux8LpvcVMOnmAiHjd3HYcBTQpUEa6d2yb4hLPjdisDbRCV+T4ByHOa8opzllv09hb1BtfI47BJr1dXc7rf5xQgFeyQLGxKgvbAIrNk+XZbV0gAc6NXWYOeL/nKkRNLLVWM6zwNpjGKSFotue20MduoyaF8TTi3d4rFkeeM8EYBmEkzMoBZKCcNPklLZGg7iKUx9MuJKGmkXfPribUk8UWyaqBV4APl6yaiFkMiZv1GhvST5g5tDtGOAvsIPZ70qyKXgNCqKsJTNHNF3ZURqdh9ZXzemUjaPj1lk4MylAgizHVJOvCZNgSRkqHCqr/Kvk9NAEWijonriBwW+0ROl2lDq2KMHU3dGpn7U9KzOqIEEx2Ve9FHR1e81s2rKMFxhIUD8SIpnwvXXlYmoKMSYwJ1FmO527Gt+rJRtwGnqhV50B20LuQkMz5jiP+1FbdQX9LI1gS7RNLO8Gd3rkUNSkNU0mKMbNehlJo+foVrm0mg1UMQ9IRpCqXl3W+HAwTgRSpd3pVOs/SaRDEsDuPQmnAiY90/RuJBmjxLNPiE+niRKl5kqMac9q24k70kyD/MaBxKP97vbLLev9Eu7SIjjJnilQ5gji7UB4CquyHd3kEqMWTm8ObD2+ACIzr7iGknkWr0L8Z1CuueGCb1xWXvoVJFRaUbRIXpIInGrDmCKiU7RcQV3UInH9/RWZpRXgRDsr6NlJEs8aDgGr3Wje4=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(316002)(6916009)(356005)(2906002)(81166007)(82310400004)(86362001)(508600001)(31696002)(70586007)(40460700003)(47076005)(966005)(54906003)(26005)(336012)(426003)(186003)(5660300002)(7416002)(31686004)(4326008)(8936002)(8676002)(36860700001)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 08:30:55.6248
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 404597b0-fab2-4346-1b37-08d9eadd536d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3516
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Feb 2022 12:05:23 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.228 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.228-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.228-rc1-gb06b07466af8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
