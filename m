Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485EB4AD368
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244731AbiBHIa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiBHIa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:30:57 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C779C0401F6;
        Tue,  8 Feb 2022 00:30:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpkXbekYg8Vyyn/l7i1BoHXcSWycUqZT4DeB6lbGNCy0g8I9wS+BSDqd7QI3tV2eTKrC2m4/CwA2hY4221qKFnmV3Nb0i+JUQM72IfGNahfS6Beqw5zfutBRdJhlc3XfhF7gRTasqVvA4ates0LjEBuln6kEzfuG2vgNjB+voiNkS9KpNbsmkCkhxZcyIcklZEs+2ywBVsaP/Jnnng1dnYsmghOr5MjBMSaMIDOCl8tBUEMN2/XyrCxGwJqV0XrsHRG3VXI2n5xMa/r0ylx7eLXcJYoAw4vaxXWwi+Jzs+YBsfAKO7vqguA3b3g4gmLTijnotf6FrngajmUX9N7A4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KscgSzTB10lwddLE7TE4OQ4aJVbeARmEl8M1qbSFO9Y=;
 b=Z4fosyD0bzptc1MgqKkl934MKot3YdWFuy6mJRRE0/XFJfmPZ5m4Vg/wdenqIcRwqNmSEuYSaT7gJjneykzb1qyumppd4A4367IVNB2YSGS660pvuSGau7cLj8rqgup9DCsTKUwoJenV//3riEzUTrZxRJTItYhUPryLfPIpj4QqqU5oYY0WkJIL2ps8ugHkLAnoCJnyKjd2dLjezC8KXyu/W8gRUs45CIxEr8ckwk5QtGxWVfVFT4tC3+1Oi0QsSZCX8CQLsjPw90f/4Igv6D3AuMDlL4ueL60IEFSkd098A4Cuplp4I4Wwusryd7ol27QC9VIGpjtMQSW7uhmq7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KscgSzTB10lwddLE7TE4OQ4aJVbeARmEl8M1qbSFO9Y=;
 b=or0qUbx4d473JpJwRt8zyiVnPHEBmiA14DwrImJrSvRyJfKHjPjP8yPL8XkY6F+rmJTZlnwJqHt5iTJD5mkcnq4gwcv0j4b1/KKesgVF3jhSXeQ+Q43jeg960zn+qCxBizoPlK5PDy2H304FgCW86Tv4S1kFYKuCP7wl8InIIdjYQ+Ax0YPaOMhegxhUKAmlMKX1UQHkFmgFJu7HdigVTt+YBO3EHP2oDmPtpvK2qGs/pCml52cgBuNRiuEbPwHUPrwDZAQeIB7iGc9c3LZg2cuzNa0HB1ZzKalOP6BonDxVt3rwFCs99lnwmCCcGXTeTIMqsww9Ctft2uyzDeGEgQ==
Received: from DM6PR06CA0049.namprd06.prod.outlook.com (2603:10b6:5:54::26) by
 BY5PR12MB4148.namprd12.prod.outlook.com (2603:10b6:a03:208::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 08:30:54 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::38) by DM6PR06CA0049.outlook.office365.com
 (2603:10b6:5:54::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Tue, 8 Feb 2022 08:30:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 08:30:53 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 08:30:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 00:30:52 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Feb 2022 00:30:52 -0800
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
Subject: Re: [PATCH 4.9 00/48] 4.9.300-rc1 review
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7c1d5531-d756-4cff-986f-02b57fd45ede@rnnvmail203.nvidia.com>
Date:   Tue, 8 Feb 2022 00:30:52 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b628416-7e11-4046-15da-08d9eadd5240
X-MS-TrafficTypeDiagnostic: BY5PR12MB4148:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4148820315E211F4EC315953D92D9@BY5PR12MB4148.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v9yyjUAxaF/vzzDbENkW6MmqydirEEpnAd64qc4m+q/KW2zhCnLW7CDSvnr36U39Ua9bLWb9kEslIMKGnmikz9IW8JVxA+Y12NmEYYMDZTeWpzeR/HLjDbRMJM5lqPA+vpUZq+LatLzZizVmtANqdvUWbwO/ckIoFcFzv226zyX4rcIGJ5YICbmDToDbXoGg0yv3kmwyCkPiHP2u4bJFhiQHLVnhRu+BFIoRiW/IQrWZ60zRbk/ZnXTTsTAbg19MkhUSwGwquriYPboHfesMUz9i69rqPWhv4lCSTEJ2VDztX4tOCwtwifuxHhVvDzhF9W0JeGh+cS86t3zAZc/yM1npwQ0+Az1prEY1IeLP9VeMlZpN5kUVUGe8HRHafi8iaBizQDRt5kestoFe9JritI6CwjckJVUqb3QerTKleI1nHJtw1xWaf1sGKX15sTAsbUMQZhQGz0ULU+42vSmPCv/TJ/flWW9t8jzfHNbFvqgwiYgu+eJe2CUALMB8KXsmyAHshOut/duMxcZTAEVWTqFob/pLxl06Zn9R7EUGH3qPghjMeUtzv/n51qWHAN4kspieK6k8w29lSM4vV7Q5a0I54fXHIrrWqZh1eq284COZOfPihqHk/LufAgKPOMYvvvGe4XBvsuTCy0J8wYgLaoGVONy4XV7SuInFZPcsEiif3UC1JlAoRuVA/+RY1o0VVnUMfmahHOxIj0COakASzrhOhKe3Sn1oIxmrlXBH6Ml2gw2vs11v9atdZpoWUo1zMRL1AJjad6t6ovl5EaiTuiNjWUKM8PplOc/GvHfv22g=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(316002)(47076005)(336012)(8676002)(70586007)(31686004)(8936002)(70206006)(7416002)(4326008)(5660300002)(54906003)(2906002)(6916009)(508600001)(40460700003)(186003)(26005)(31696002)(356005)(36860700001)(966005)(81166007)(86362001)(82310400004)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 08:30:53.7145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b628416-7e11-4046-15da-08d9eadd5240
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4148
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Feb 2022 12:05:33 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.300 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.300-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.300-rc1-gfa39f098578a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
