Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8AD5F2FA8
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 13:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiJCLbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 07:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiJCLbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 07:31:20 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AC23ECFC;
        Mon,  3 Oct 2022 04:31:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXqv2JcB3bvO3WmwX9nKswlK6PVZUkG/F+ukNQ0LAnnXhIhdbBD44rl5BAZJeLwUivJQ+YSUeRTIye3xVLtKIw2Wv0O4ri+202qCxqCnz793IrnUMd3bfAMx/e1Qbm04IvKdvnTU01++KWlcBJAHyc6CB8l2CyXKqgmuUdmK4JoJf1dPw6KK4WUJ1P8aG/IWB/XjeLMaxUBYzA0adub6XStVwQxdPWbUGzth0k1xPtvwsHIIYHW1NLm1DwCSqFJB1oM1Mxu7pLwVBAspZQSNbN0xDxNfHwfrv0ISBbupXoMWQWrYY5VoMMHR1jywerB6vbNeeWucg4Wa8wXHYFtXFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NszAGbvQ5L2yC8msJPX66Ao3Y9GBEvCqKSrejmEpRUE=;
 b=a1gha6VAilvhZqgiJZOSzvqtIOJ5uPnKuCGsxws993c0rd4ACwFTzK4NCnFDFEOYH6ocmxPMdCCyiRcqteZ2rl4MAsb8etdluukZUfvD1cwNGuwEdhgnqa1hTGpyVkjVtdBdQFk1wVDQMiYMQVH+sfxt7ib17MG9mAx+1zCKiEGmD1oANX9eWBH5xzVcdPnIwfnnBRWBPTjkxOCFqCDidT7yDehmNBAkrzq/J2E/QhOxGjgag8EEm/Ey/6lUlf+rHBQ3Qi9AkU02F69odcjRSV1n+FhNomoF5PK/9JenISNAB1GVcbumOYGO5IS5B1Nw/SnWAuL7QKXP/+YGjVNywg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NszAGbvQ5L2yC8msJPX66Ao3Y9GBEvCqKSrejmEpRUE=;
 b=R54cd9JKDt6n6DPqK8lQ5/yKWw+4xlNcq4/lzJN7lTP+dCf4nBekDROX4WpWehhIGM4Gk9w7kLxyBx9kxcsGR0DmWsJrD3e4kbCuX0GehtWEbM9vmSdrZ3IWhaUNZ4ViO3TwgCo1acLcOYavXqEqBDwpsEKLEy3rJZOYCDLdgxYvV4183MiLgwlvPqJKWbjwxhAZYmDLLNKiLJJSDDyjh0gMzFUkbfhKHAPVgShBW2XRMoAmZvaR839mTclz03R0ZY5m+nImFmSiM4zm0q+z4qJmCCoc6oJPbJ205n7XBbOqQRXUUZK6i0vVQ06oZcn/7NAQfLua7aenop8RgrE1fg==
Received: from DM5PR08CA0050.namprd08.prod.outlook.com (2603:10b6:4:60::39) by
 MW5PR12MB5651.namprd12.prod.outlook.com (2603:10b6:303:19f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Mon, 3 Oct
 2022 11:31:14 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::a4) by DM5PR08CA0050.outlook.office365.com
 (2603:10b6:4:60::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26 via Frontend
 Transport; Mon, 3 Oct 2022 11:31:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Mon, 3 Oct 2022 11:31:14 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 3 Oct 2022
 04:31:02 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 3 Oct 2022
 04:31:01 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Mon, 3 Oct 2022 04:31:01 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/30] 5.4.216-rc1 review
In-Reply-To: <20221003070716.269502440@linuxfoundation.org>
References: <20221003070716.269502440@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b49c69f7-651e-42ea-ae4f-07010f451a1b@rnnvmail203.nvidia.com>
Date:   Mon, 3 Oct 2022 04:31:01 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT008:EE_|MW5PR12MB5651:EE_
X-MS-Office365-Filtering-Correlation-Id: 37455b9a-f58b-4cc9-59d5-08daa532c7c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BFzS9TobTAZhB8aQXiAWqEh3cuhN+ambbIjEA3ZBQ/+H4klJXULjQAdV6UIGCoiV9UosxLKiAK9CA7CjtyoiaRDa6aCtPTb5E+agKmhc6Cpr0+DciUCmw4h2SYFbqBEEw4ycM43M36afU9ArUqpC5h7WVHZvg4imlz81qShYnsOyzPhjQuBY+siYHfHSEcSNDjRqqDmGKSE2vyMOq3qyBR9VIVl0+d4zry5tWX2+m+U8v1zi+tGQjhCBop7rpuEpAq7fn2gBWiq/k6sP+TFdsCpnRUU/I28X67ERylD2aqAD7HHJoFxTu8s9F/0UnZqoNgdEYcd5QgvgbJVQpUyK61tiUsrT/9kvVfzaPo0XdR0q7Jo63jZT2gAF00YahG/TUF1MM2HeTaNLK5NQpViWVIMB1v29E+ab6cVwHtMZ6rH5pCza8BpDXniilPPXHkBRm1xLM+Vs0Xg7X8aa4y3Uv7hcDIQpVDYp4SIHEe3AqzwLLneJR0CCeueSTsFcgl87Xk/sT9Oijc0T89CQ1s5TONMfakQwDQ/FMl9OSMfwWvTC2CjN5wLerRrgg6sLjlboWWuAGYiqI2mtpdIfWFFj8jTU/cvNMqYQWOl7zjrMHXMyNvt7DH1C8hlRwdMarT/Z1TIJ5ojjIVFh5MlOAvLkg47UTJ4rXyPfGCfQuMPMpB0pSw+ChZFB+sgWr1UY3ZHT8W1jTmKoZkrenFfr1xj5kwuMLrXLBEMAi43yS+KfqiVmMCuRWevJ2OgFCNXp9afjnJcLv4Q5icoZTMvLA+jTphBhbED4g2Q8WQVer8f7gfUuUndwEOPLpKhm4O0eFD11RFpIe3TkjmLNXHsZrgpVZ1/KnjO+bITKLJYj1LtkDMQ=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199015)(36840700001)(46966006)(40470700004)(316002)(2906002)(31686004)(6916009)(966005)(478600001)(26005)(40460700003)(82740400003)(5660300002)(356005)(47076005)(186003)(336012)(41300700001)(86362001)(7636003)(426003)(31696002)(36860700001)(82310400005)(54906003)(8936002)(4326008)(7416002)(70586007)(40480700001)(70206006)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 11:31:14.3422
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37455b9a-f58b-4cc9-59d5-08daa532c7c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5651
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 03 Oct 2022 09:11:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.216 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.216-rc1.gz
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

Linux version:	5.4.216-rc1-gd69f2dcfc489
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
