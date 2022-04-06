Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D0D4F5C8F
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 13:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbiDFLhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 07:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiDFLe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 07:34:57 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2076.outbound.protection.outlook.com [40.107.212.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87C846650E;
        Wed,  6 Apr 2022 01:26:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IxkJ2ErBJuejGE/nBRhE5/IbVU4dToO7NpXn0WmTOncE6rrIDzOfhgaqaFqJ/Z7aFwiyKlw3jrxQjyMQ9Ah44qopJa6BD8i9uUdZ56EOPeMzonJi/9pegQgtAv9Tf01NMlV8niatjGL0obiTZtIEFESbUpQedbmb+hUoYy6z4rSsyew2aB4JwJT28i3A3OnwvGMf5+7C6L+8KVD8eqzDUm81nxoU4C5Rxu2+D+uzXvPhRQbV0p6VatSKc+DWUQ/zZ/d/kNgLjikxw9PQUw3RGxXzgERNEyhlkpQpuuOWdmLGDIvZwIDaHUiVBlX0sFGzFUZ+5KOXwCc0AC0DTqdRLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AVA31r8E8LIX+FsE89RstxMRHUvxZNa4EQZA+imFAmM=;
 b=EjAdTa0paIIip/cuevmcRZXzpldzhhy5EJbXJhfeoFWQoaY9oMcArrY5JrxiumS8c1ucwiEqExRBxlNavdmcMIKiza4ZMmKRkU/McPIItvPaumbR2fCdv34KjQ8y18zSBbdqu8OrOrzrDG57Pr6sx6LAasJW3WSU7jSVTb506zsxNMKmFoAmo6GcWpeHwowCVPocE+6iOiazl4XqwmK7T4Z+/H9Of4haNtb9hAJoTTZ+JPIVI0e4VNJMcc0P5Vka9PLhnu0J8XfhDSZUmhDkYycrOLAqepFSdbUKlOXGz+jHubUjXP5aHG5Hh6AeVwcQbSo6y+syAiDzA+WyG9b73A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVA31r8E8LIX+FsE89RstxMRHUvxZNa4EQZA+imFAmM=;
 b=sWVcmb03Gjb0KlmOvVSwm3mUXitHXBtzyOQ6F971/xx9QY7MUwpXTgSCr32EOeZ8s2jJrVidWYqBZ9cAggfVZJjsP+2ugv24GTbSONKQma7gtfO6rX43R801tCBw0kFm9XKcm3KFJE09pIrG3MU4LiMk+CfYS9twB8IpGlCGGfqkyHRQSxymNQjDX7lRvXJWaagQLUPJh5oSO3XXxKFTVGGOZ7h9EOxlII6SF9sStvLxi4MkITg6K8PMtg9Z22QLSv50/Z7oBtXHMbDm9Dprt/UQPiEbYJqzK6itzu5VM22pAF2SqDBO/jzxMs5icTNqH0iOQeeqh5DudD1s3YAjPA==
Received: from DS7PR03CA0242.namprd03.prod.outlook.com (2603:10b6:5:3b3::7) by
 BL1PR12MB5160.namprd12.prod.outlook.com (2603:10b6:208:311::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Wed, 6 Apr
 2022 08:26:05 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::99) by DS7PR03CA0242.outlook.office365.com
 (2603:10b6:5:3b3::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21 via Frontend
 Transport; Wed, 6 Apr 2022 08:26:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 08:26:04 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 08:26:02 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 01:26:01 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 6 Apr 2022 01:26:01 -0700
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
Subject: Re: [PATCH 5.15 000/913] 5.15.33-rc1 review
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <407ee0d8-7fe0-49c7-a2fd-287cbeb72d8e@rnnvmail202.nvidia.com>
Date:   Wed, 6 Apr 2022 01:26:01 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 687e1cfe-ce2a-4c4e-563b-08da17a717a5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5160:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB51605414FF3FF0968EEB3673D9E79@BL1PR12MB5160.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HbreakpF1c1dXo0ktmuDadVe2ojEN5SNZOX2aATalwIMNrnA6gLECWCHse7AkGCuXI3y4CYdkQSWsgq57t7aeT7P3Td2RByrSd/ZcU/t46QYM790EwUWsEbEWAsMN/eAMzqE3gnJA7VRg3tkh4yunDozUU+KG8lFpKXnxn5M8FnNz7ixLLOsN/xKUELfiCjnANffFAlnaf5s2Hps+cxpRtIX34YxbVI48h3WajNhEXdgmPfmoJmyoupPC2NDz81Umhf9eRxkeqUzwn2N472gYGkc5GxdK0Rt/idrbVhXD9ME/OWFwl+wScnygOQObP0Qj1zCfjvlva0zesGgtTTC7AHzLROAaAf7Me1AkhxOxluvasv+aF2zh3tw6wnEs4OYD+U6bOhF/06SMQ4lMkbx8jtoEU1jYQacAuSOoRhPna5CLLIGpjCwfkGlpjNp2hWPiya3Ck4YYmcD2b3u2HzU55weJFEdRzpG+gkzlVOFrbimloYsayuO5ir0Kn/iRS84uV9j3YOosj42PHhC9M3lKuDa3uZwiDFqyc+0TIZropELLN1wMwNfwyolc5MaQL/O+P0mG9hv2MLNFSmJdisKqsXE/KCmw9Kn/Aigd74q+/iaJ5vPGv9hGS0YDp00zNeTiStZ8sWEgH+Y5bt+cx1wCk+oXQqbb3FCu5iGMiDeSXJWjmR9CMtK4BTOzPiBQ5kZBVqZhF+WdJZTJu/bH5rFGCq7k/RDGyrH+BcA87VP1dBA1Ro5QO1kk6v49AVDRrXzuEQj5ptGvVmMNpdKp6Jzwtw3cYxWE1vtaduE6sQMnyc=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(5660300002)(7416002)(8936002)(2906002)(70206006)(70586007)(6916009)(54906003)(966005)(508600001)(316002)(8676002)(82310400005)(4326008)(31686004)(426003)(336012)(186003)(26005)(36860700001)(47076005)(40460700003)(86362001)(81166007)(356005)(31696002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 08:26:04.8629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 687e1cfe-ce2a-4c4e-563b-08da17a717a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5160
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Apr 2022 09:17:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 913 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.33-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.33-rc1-g841880eaff92
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
