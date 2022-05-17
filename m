Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4ED529B19
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 09:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242119AbiEQHkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 03:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242051AbiEQHkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 03:40:03 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FF94B1EB;
        Tue, 17 May 2022 00:38:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ItP9DdawQ5f0vYdjz1jzyol4nMe3pie8Exsbu3Nj1eQp44XphYJiZ0XV5ZQPKSWhXe9nuJUN5CIBMxVMwoLBkRpnGE84WDG8zR1nk/1wazJpLI8Ie/7NTqaFcHtLv/wHKESqhXz9TL1NnOTT/QRfkGVl2OsOZp7hOmyEOLU+4a/ogG2DC5D85yN1skUOBX3lG1xTyPrhfLAY1f4p294hqNGsJWH8WI6YfzhulPjaG+7IkETqyatIF2XHGsJAL/3kwF8MeJzLTIsdQTlLfmyCkCAf+wUnK6juEWS9dNqRp60NpneokI0pxCnuL9YcMl2pUddmpSvJ/ukYbGnYBrN1bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KMHp1UH83Os3mX0XdlzePfovfVB68EGmj9h+Fb/S8dk=;
 b=JT4koVcffAfNLtX/1xfiR7WVuebjF94Q97wIc6NuX7id5KHYsRiZTJAoaZbqiuaFa+EEpad2aEeCpni/8swFE/zW2h8ZiC6fUDWCjWXGkvnpT0kQyzMYlSGOYmkElPJnJaxx0v3zvdxF/+GnbmyCoglqGFi7gTv94Q+vk7+CvuIfz3WtbYdVFPNCF+EYyg8fJjqE45lVZ8/0XI9PQUHthW6AqW+RBac/DVHSe/40IalCNiJNGzh2q2PTUmVadTlhNgyS4niEK6xz609fjXep8FUXIZuNYatuzOvnam7tXr6Fmdk3C5GrTunNFDJ9He0DCb3NqUsy6TcU18WH+6fGAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMHp1UH83Os3mX0XdlzePfovfVB68EGmj9h+Fb/S8dk=;
 b=MunsM3yFMfbTij3kOWfvStJgZRZwYPrEuolpfy4MUsF1VBLVqZik/SpPq04lbZ4gBtrcGitnBEmLQM1AP0r9pfQU9WpUjZ8Ma0E21e7kTvUWjYExafp4euLsJ5jr9I2S0Ta7ZuKhnGtVk1fx/KfIvMxmnnIHtlVDeW3rUm2Xq5hHMuQg31k/rMvRRuAB0cTU3rRZtB7tBphe8+YnWSQO0/Rs7rq6al2V981nLwoSLXqP8qvtlLkAwQF2sGFUknHA4Xnz8hbntlQBFPqrQZryTCNTV12+4Uh1riM/3yRq3q42C4QGZ6tyfjqDcxmri6BPpTxG3juEC0z6k5HXm3RxWw==
Received: from DM6PR03CA0089.namprd03.prod.outlook.com (2603:10b6:5:333::22)
 by BL1PR12MB5207.namprd12.prod.outlook.com (2603:10b6:208:318::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Tue, 17 May
 2022 07:38:40 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::4d) by DM6PR03CA0089.outlook.office365.com
 (2603:10b6:5:333::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17 via Frontend
 Transport; Tue, 17 May 2022 07:38:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 07:38:40 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 17 May
 2022 07:38:39 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 17 May
 2022 00:38:39 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 17 May 2022 00:38:39 -0700
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
Subject: Re: [PATCH 5.4 00/43] 5.4.195-rc1 review
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
References: <20220516193614.714657361@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6b8513d6-9789-4d1c-96b6-88e0a1d58744@rnnvmail205.nvidia.com>
Date:   Tue, 17 May 2022 00:38:39 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9ae2dbf-3aa2-44d6-469f-08da37d8432c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5207:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB520749679717BAD4E3A8A58BD9CE9@BL1PR12MB5207.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qzqa6Jz1HtZcZE8KBbzbZZoJZE8yu0yaQQRHonCrvyaJrsyX/p2SGXFYGVNzlilGplHZIMzkKbvIDaC8tmH51osvsscOiSCg7O90giVo+1dgQgpsajlEj2QnhcqHpz17x1IRfZ5uSnzJqMdGCUjRDj7uEuKyojt0vFku4nJMnZFtYkdo7t05HpolrY9GkGezu4loro+sN+Gcl5csKlXx51FT/FRfeiR3fsKiItatG8NiE0jtuV5v7vFfdHScgVTeyaoIRkzBzCmEbt1YAJAbbtCeGCknM03S576awZNtyj4wMKgLghQCh+FC7JieUjYVHxeyTDFz3D+K0i3n3il8MG34R81CNs5t4rsO8dSS8QKQn00JxBW4sPQvS1Jc6nyTVlr/ApM4hvjiAM5m/qpsIFcTJNGVF6Bo2ragTWsnMVf+rT8lCk3yRTge8KFEh6wS4bA0T4rQWivbRSp+w8s7OyGBadRM6bgrMNNa7iveLXKWyAuzOFj5On2pjGsj083eehPtQu0ngqTKQnKNO0hcpl8hQD8N7qVoC300aO1B5xqq9Rge/Jh4gCoXXv4gwqQsJ7rAtA3d0PmRDM54GwDGzmGkx7YLZ/izvB5Bsc6fupeXV5fW4rK6VoAfDyYOSk30XjYxV+p7/Avrk4KPhwRb8O3TgZEcRj7ATs42dIEAcasHcnvHA2If2yUXJndTUElg1mjJXzmIKBfkZmLDTgKZqO9Pr7GPDqMdhThrTBtNcjl/tJt00tK2xOfPLPIuS9rPOjziopyoZdFNsibK9cmF4ycNyIUo3AB3lASoH6pxagk=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36860700001)(54906003)(2906002)(26005)(81166007)(31696002)(8936002)(966005)(82310400005)(40460700003)(4326008)(7416002)(70586007)(5660300002)(508600001)(6916009)(8676002)(86362001)(186003)(356005)(336012)(31686004)(426003)(47076005)(316002)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 07:38:40.4535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ae2dbf-3aa2-44d6-469f-08da37d8432c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5207
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 16 May 2022 21:36:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.195 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.195-rc1.gz
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

Linux version:	5.4.195-rc1-g25f2e99af01b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
