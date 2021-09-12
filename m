Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0170C407D3A
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 14:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbhILMUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 08:20:09 -0400
Received: from mail-mw2nam12on2059.outbound.protection.outlook.com ([40.107.244.59]:4224
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235202AbhILMTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Sep 2021 08:19:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXXjhWH07PDVSCLa6tqrAADRJEdwW2K4PUvm9lgWBAXLxWxuvQ5/2+4LTk7yMU7cg1+wbPYIiiEJ2QVR9T3o5hAOMJN/R8su5f+FDr3JjJbCV9C2nfdoePsMViOuQBaoGo73BqIT2pcV7+HieT7pxWXRLn/7CQmyOmUXD7JHSh4KyHJXE0JOGyAF/tpLUybTS8FP7uGb5sce+5tC7v8Y7W/B0MZSrib0e/FwlWOipA/+qRdKzrwAQpjwKVMd3lFNusjGHa3ubxdA2hqU3idRJVPPLSpMb1Yl45IAn9UsN4vWtU6xIJlvZOXMe0YxYJkhGKEsqHQJi+rZGwU+mPrBOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=DHd78LQ+kg45bV+8pmssRW5TjPyh0CFhWdhP9Gb8YAg=;
 b=h/E+55+5fJRmj2WgFYvuQeyuuY2bMCHRNIAvQN72V4v5dITTHYc8lLFQuVn5+P2gB/HLj9ff5xpNCWxEZ1zJxjEGahb66AP9iXE6TmXnqqy7/4Eqnfs1zykiju5Y+LOc/p5KrP3V5LYft/PI7dqs9pXqEonWI9Ln2cf/5el6i+7PEx9yrmalKxeqKIqahj2Qm5WLXQfGjvIbfX3Y9mjecTi6Etb7X80A0JpKE9wt+T1Z9J2N8ZhOR2U+Pq/aL2uKoAE5njJZ9b7KP+X0ytbxeZdb1z+mq3tSMr2n5ahxnXl5pale0QAsNXz73btc0rWGTSlteIKBDyYSEjlktYY0gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHd78LQ+kg45bV+8pmssRW5TjPyh0CFhWdhP9Gb8YAg=;
 b=pEGRARJR3masrpz0mYSb5jN+rc5PfcnQMDXt9wbAPQ3/gCWTaCAqZbotiH+ZcA06DWnUZnsbLggtfqmpTdIXxGYGWR5UPAPXKnA/vUWVOagITx7JisPNc3pmRaYmzT/Bzp0mfBPGiONSenln2PctZj0oE9LnW7V6HUnMUCqNQAWe654b/0/dlHVex+HitPKPkxzGIfTj/NDHXaoPGXHX5i1wAmQsT2v1HdOI0RKqDsEB37JSCE5axzV0pFK40api/Th86XgcTm9boxxKu6WJziplcORkzGDTbiTc4BmYburnqIgIsjEFtOrA9GI09L21c2eqyikCw2nyckjq4WYQYQ==
Received: from MWHPR02CA0018.namprd02.prod.outlook.com (2603:10b6:300:4b::28)
 by DM6PR12MB3994.namprd12.prod.outlook.com (2603:10b6:5:1cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Sun, 12 Sep
 2021 12:18:02 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:4b:cafe::a3) by MWHPR02CA0018.outlook.office365.com
 (2603:10b6:300:4b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Sun, 12 Sep 2021 12:18:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Sun, 12 Sep 2021 12:18:02 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 12 Sep
 2021 05:18:01 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Sun, 12 Sep 2021 12:18:01 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/37] 5.4.145-rc1 review
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
References: <20210910122917.149278545@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ef8ef151c185490fbb2456d09335041e@HQMAIL105.nvidia.com>
Date:   Sun, 12 Sep 2021 12:18:01 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7266980-8b26-4f8f-15ce-08d975e75df4
X-MS-TrafficTypeDiagnostic: DM6PR12MB3994:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3994D1DC6986DA95319E18A9D9D89@DM6PR12MB3994.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ++QlcIIUaHqO6JC54wN9OP408AkXyZZ4cZxssEPaYqIbJLUUPhObJLV6MqEISxPaW/vYixz0sDDv0SXjIXeoIXpKljB++Q1qwmHYtsgKkjh1CeW/PXTdbqrHD5OY7Wukiupj5ODNIae3SVRIAwU4FWiQPx64jxTsQRhQPrIvwc4CtvHvrOzfoMkXeKwKjy5WF3H0ql/ibYYoGTC04uVo6DGEgNOsLPqxXFeSXVRUQ3OYw+XuJX5hO0FNOzxxSzedx3gyGBrsY1TglzTS2jADwVUWn37NdrBs9UL3aAeg35c08sQRZX8SPiEvftvkIhToX3cAHnlxuAnWUqPXZbi6VVvneRm78XXVd7Jc3KTDr80wCMyIvnxrSoygMDyxzwPd6FqF6CDZz7CPBHPgsg7IsbxmhOfBkBHQwyG7p6abFLDGMX5YODC80C8uAYYonOQ0sO0TFGQjrjKPa56RmhEjl+6p0Q+igE61Y4TTyZIqgjL89vEG4bJGqlsW76tMVZ2kqusG3U1Zy/DKIP8Y0YJjzyqijcT6j4JnIsPTp03Um9dmd5OVR2OlHCkJv5HSM1IJYM+g3xdzViVU1jDzw4tDJIJgewyxWs9C5+q6CSaFPBcAcBJJsNY1h7xT3VemRl4ZyqBUH6uY0v54a9XC9cjkpbcvQHzgIKNTYnPWNDBvxzNKiu/rNyhVbb7UNXISZ/iskJAdcPn+J5zMhwor51T0/QS1Wj2hcg3/bjIlNCm5G4rNUP/x67HNLqUF6NxFm+fSbWLIqzR6OboytroSg0FP7umcu8xvHkMWp1AjAw8v27Q=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(36840700001)(46966006)(47076005)(7416002)(356005)(2906002)(316002)(4326008)(54906003)(70586007)(70206006)(7636003)(82740400003)(6916009)(8676002)(966005)(86362001)(186003)(426003)(336012)(82310400003)(26005)(8936002)(5660300002)(24736004)(108616005)(36860700001)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2021 12:18:02.2659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7266980-8b26-4f8f-15ce-08d975e75df4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3994
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Sep 2021 14:30:03 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.145 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.145-rc1.gz
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

Linux version:	5.4.145-rc1-gc7a4f9e9970a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
