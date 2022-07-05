Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DA456713A
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 16:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiGEOf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 10:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbiGEOf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 10:35:56 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC7155BF;
        Tue,  5 Jul 2022 07:35:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQW8FYmnOqjE02CKdWblSKV6zkpfAZseRrhuY1Sr679cdcDddbj4NilhVOnP4GgK4EisKMoqAY45u64IroRXLst80mlcgCu2wBJ3WzuucBp39A5YQ/sHz45kM1yinVL514wYzcQJKemUH0zdetWiDIMr8gAUhfWlJjWikwKZ1RAafOsYBWNSJAgwyly0yAm0VXdaUQnKUCR328cIWbqfwfU0UsIeplWWVxrCkVZpGTwYUvp9SZj1/pS0jB3rzNeDOrX187hI1htk8Ml+lBUODeuBMnS/8fUKiwnYGKgYq19/crZ0B3kvr/e1mxyfjYS4P2lQZSWYyfI+Bt+mAapZ6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sGdZvYEcNMFCn/1eOIEr45MCy7W61LPB4QafYbqFduY=;
 b=BZLw+Dq4mP84B28iGjKDzcx/vAoSmxaygdYdVXo/WFdswHH5Ubutq0hCIIhQTIgaDQ4Fe2sC7+JnAwFcgluLvmFvcpK4IpkNksGTjU6POz11fMB8EdskH7a41G8ucNwkI0cM4VSrFwAXYfUWC58J87Ja0Z8WWejf1XhWVMbbJV8HPmOLZG5oIgIy7Y8e9GdteNjePVR+h98lR+p3JJL2o4RqcYyQb2BCCP5vZRFo5IrVrE8M/X9BW1yc0eCUOXJtE4XliCkvOfnTfsIcSdptPygGPZuRgv1TQddv6LWNPNdHoS1MdgdF9DSSidvEXfCyzeu95AlublRhhGlDEwSKjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sGdZvYEcNMFCn/1eOIEr45MCy7W61LPB4QafYbqFduY=;
 b=oBvahyJKYFPSz9Aeh4f8o+nxUP7xmZllV8yUDc0mo7fqn7otpTOrkuOknrS23mtfTmLuOI7u1atFs0hV2uiJ4TK0gEgoWt+BQPLIdhOBCaydeGSPX4oSLmhGzrkniETzwHQM0uwT28PHW8jP06C2OYGNj3zYTW1lEAbF04nGotZA+4pFLwW8fDtIDmPm42s2aBDz9+0G6qYmeWodfuA+oDA0/6EydX4V4dmGm40eCkUqlpvqyPLZFPa+DynUqbra2VmEM2bTjh+DuzjdOInFvBkvxuyZ9np6i6/GfNVw71NOZI02vY5LavW6K4CIzoMtGemPCHFiKYmN/Tat8gPpCA==
Received: from MWHPR1701CA0022.namprd17.prod.outlook.com
 (2603:10b6:301:14::32) by BY5PR12MB3940.namprd12.prod.outlook.com
 (2603:10b6:a03:1a8::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 14:35:53 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:14:cafe::50) by MWHPR1701CA0022.outlook.office365.com
 (2603:10b6:301:14::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.22 via Frontend
 Transport; Tue, 5 Jul 2022 14:35:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.17 via Frontend Transport; Tue, 5 Jul 2022 14:35:53 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 14:35:52 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 07:35:52 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 07:35:52 -0700
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
Subject: Re: [PATCH 5.15 00/98] 5.15.53-rc1 review
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c224afaf-ee04-4c59-b5d2-f06020a231cc@drhqmail202.nvidia.com>
Date:   Tue, 5 Jul 2022 07:35:52 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e888c781-3b0d-4223-af21-08da5e93aa0b
X-MS-TrafficTypeDiagnostic: BY5PR12MB3940:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: feqdIkxLtIkRPNgLOjqnLEPkbxVb2w117H2lDMuIy7vd/n/6xwir7VDytXzshPT9MUQIoRHdKqG8ZMR0nfqfQEM0rt+0WMxwKRFWlpfGgBLQIcOSLpJEwjiQ8jRd+Hrd2qkJ3EZvcEGEmn7+2Chb+kgXFDo1y5YAWc0OL7BvO1PMtaI+ChRjXit0BCTTb+q0C/kPeAnQdpxuIojc6f4LUrX1ScACjOAOEtiW85FjOQL0tWUWgRYP+YJjDZ9/lti1D1eJjp6bGAkuSHWANt3cc6bIJCtmm8eoi5OjREHi8OjUrqroVYaTMWbWdut5fAvn6aKgbGKWcjrKhlBqFvhQFrnr793m1GLRlTZKUVr/auz57QaGhIH3X+1KUte9rPE1CPJhQYRM6uoSKH0yDh2anOjLt+QG7T51dLL4pZN9aGrGxChpX0OVxcQE99tr4DwtjAhfQOhiZC+5SuC25ikpm4q05/ZS1vNjPRLNNlT/+cigdI5D+G7PpoIEU1BhWOrdp+3sO6DoWJkFmJGQ1uApRxeO4HQ2suX2jXAzVaEcvXl74uv59U/bO+PGpFuk7cpjJGywgj9q0OlWNxvHtFkXrL7kKxWhpOBM/VpELvjTgmn5IMwaXzEGAM/Y8WZs+50jTQPcK9544jDgfKtBXaCDkh4yg51JuYcoMK0HiwF1Cn3WrXYjRfFVAH1YeH9TNRjO+3vw3y3BfqYWvKztwWGxsaJvOU5lN2TkppTYdb9dMCyymrH9lRxr6b0dDFlzMZMwY8fXjjKl4xzr6IM5ZZwG/Ba8l5HEmBw8js99QAzYvdjOlThZo5f6ecVfb1i5sBMiiWy7r3gJtX6T9EsjwAO+r5csBYVpBK5T/b7rbgTYtobpcZRus0yMDS1kDinJxKWFyuL83mJ0P/u7v07OCwNuG+vkcv0e/CynCEiP8oUtBTgHbImkE30Z6fpI0zz0sMOx
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(376002)(136003)(40470700004)(46966006)(36840700001)(478600001)(966005)(186003)(31686004)(41300700001)(2906002)(316002)(54906003)(8936002)(7416002)(5660300002)(31696002)(86362001)(47076005)(82310400005)(81166007)(336012)(426003)(6916009)(82740400003)(356005)(40460700003)(26005)(36860700001)(40480700001)(70586007)(70206006)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 14:35:53.1192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e888c781-3b0d-4223-af21-08da5e93aa0b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3940
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Jul 2022 13:57:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.53 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.53-rc1.gz
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

Linux version:	5.15.53-rc1-gbcb9695d82c0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
