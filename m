Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2397C4AD36D
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349061AbiBHIbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345508AbiBHIa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:30:59 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA30C0401F6;
        Tue,  8 Feb 2022 00:30:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOL83U65uGX6wprBw3Azgo4cxPU3ahWx169grhBDgCQgWw2i03an96NBHaDUGaW/M+mqQda1EY/Z18+DRlKB5irM6J67M3kEG1sx5h4DFVEnFUwlilcpI+4ZZu1pjwB7HbVBij4bmxWKUocBrloy0O8VPRggEdHBUJXLtUeR9FDGk0BadOOm3jJ0FI+LSEwDUGz6AvoHL/q8QMyib37Di+Q+aIO+7aWS8sDZfjxPuRaz8WsGmxr5JGZBAy4d50sCIOeiIuShei/Lxtic+jvBEZLtZ0nkexAfMGiko6vIlrSBuI91a20ZN443wwwM1CJ12RtoTE4l/dVvGJHNJ7PDOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mBLa0Qa6lMbWL3ebhrzdRd/ZgLnmvVmN95qcGE5Amqk=;
 b=AoHecqXmM5cAjNb28Hl9J7GeAAjQi4BbMNliEO2MLz+GlFtFraOaU/ant9PC+LqSxwwy+QX5eUmiz8ma20BXcdGHlZz/932a1SmLLCjSR1GszRRXtJK/hm+1ypx+q8Ntu8wCxcE/UsnwiDpBZhGVjvej5Q0RjFAo2lNx4X+yb4YIzsB8crIVYsXtxb0cezPnfGWiI0Me7y/6PdzDcdqDXX+dwRx3XDiQV6MmFvmf4QHpNnBG4HdB6idx1wO6ovCEC1JquD4AtceVNIkLA8XNqY8MKgrVvprpd7wK5EXaZGASp/5UUbxQEA1Uu6rRr72B4S5WlbEgrt8/0vxsHYyDcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBLa0Qa6lMbWL3ebhrzdRd/ZgLnmvVmN95qcGE5Amqk=;
 b=LPJfN3OXXoRZzFYKSHxvs0O0mSdpVyKH776oqquJk+HQIUimU8LvrH9u7c4h1Ik4mYxfjealRyWQVhOKYjjvDBz01Aa3PMJi+f58b8sb9mk2TXD4gQOV/fA3h3W3SXWQ+ol1byj3VTM4XrRY0DSNciDfvBY02Do+Dg8OHJyVj+30lx/l90GiZ/z9RIbdt0cyM88LkpMNfF/qHgHLTfRcMfw8C08GEVuu8D5M1o7xdNJvKV9Kmu7w+YjXSy7efJdKOaleaHYXUebUu3G3xYikltty4uqjTSOdnU02l984Q1Co2tAuJC2PIzxBxsB4Flp5hQTmSCDTSQPv0UYlA3NXtQ==
Received: from DM6PR02CA0045.namprd02.prod.outlook.com (2603:10b6:5:177::22)
 by MW3PR12MB4364.namprd12.prod.outlook.com (2603:10b6:303:5c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Tue, 8 Feb
 2022 08:30:57 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::4b) by DM6PR02CA0045.outlook.office365.com
 (2603:10b6:5:177::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Tue, 8 Feb 2022 08:30:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 08:30:57 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 08:30:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 00:30:55 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Feb 2022 00:30:55 -0800
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
Subject: Re: [PATCH 5.4 00/44] 5.4.178-rc1 review
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
References: <20220207103753.155627314@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8aaed727-6a77-4980-aa25-c1fd3e419943@rnnvmail201.nvidia.com>
Date:   Tue, 8 Feb 2022 00:30:55 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba589171-befc-4a6f-ca79-08d9eadd5477
X-MS-TrafficTypeDiagnostic: MW3PR12MB4364:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4364ECDCB20B88E28A531807D92D9@MW3PR12MB4364.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 06vvI1gZhp7oYX19eagqSqx6ARIYQW19xb+saKn65UJC2+bZzw76l5548vbjOemtwW71ZmP6eynpOaXG5S5XUPtCs7BxJTB2FQGDiZTvBHP4mi/jgG+yhXpKgVCzDVxsVfwHCkrGoGXKeGOHm66pQGfVYp3MUxZPp1VnkS9+1dLlUIy8qgrhX/QNaAldadua3e6ROm3rLTVAQuFMw5t7NlxEDMWLrc6/D+nVSD7Olh2yYItzh+vyHD/m1So6aioQJ0nPW62CGZOZSzeCxN3f4j2fA6lWX+NXrFcwlzZ33Df9qqu4SLR0jPDggqjLjvth1qKfHyw6mdTJ/0A/I2TfvB++AN0ZEEHZihgdPiLqRLmTGA3zHgOJlb/ther8NVWPvtXtkqzxDCZWkOs5BtpZQYp3KRyCv6Ih6/rxSzNBGSYGhqhebHFl1FBmIXYX/6xcQPGXQ4tiB9M0axcxV7hZaF03O0v1sTo29oJoOUFeUU0EBi0hRN/T501oQ+/dy8ClCmFnkV9uGKfTAD/AwQyL5hGNxb8SYE0SswN23uQvOJjUhDxt5oGqMIHUDZYSGUttoh2Ue4MQycKZfGxfQnfgEfEpTXiRAizmrLcCMMvVPrgkBkjl2QZoTfMucuOY5CVmZ7+VQdvpoGg9v8QPZB09YW6yJf1W8klmYR1Z1QvTudcW0CtJhtorFdZK0Y8akCHpwkfzgN0tSi3x2AB16iQyVRopBbGW3rG5HOakbRFmMJUrJstROFyfsLT26HqCBgy7JwJTVxd9QZfq/qnEHRWmt30HSgcKH5i5587ZCGxeJso=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(316002)(6916009)(426003)(81166007)(356005)(336012)(54906003)(86362001)(36860700001)(40460700003)(508600001)(5660300002)(31686004)(2906002)(26005)(186003)(8936002)(31696002)(8676002)(4326008)(70586007)(70206006)(966005)(82310400004)(47076005)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 08:30:57.4194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba589171-befc-4a6f-ca79-08d9eadd5477
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4364
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Feb 2022 12:06:16 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.178 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.178-rc1.gz
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

Linux version:	5.4.178-rc1-g3836147e31ee
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
