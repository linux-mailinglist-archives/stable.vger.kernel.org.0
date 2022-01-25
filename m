Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5332E49BCCB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 21:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiAYUOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 15:14:48 -0500
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:2656
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231566AbiAYUOf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 15:14:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1HsP0ncwC4HRVzvA/sDZOBuc2jK40j/FY0gLDYqBrr3g/Q2qvW2m/wvYtAsvrz2EtpOod3CCLiuvhclBaLspFlTXU6Nj4Qcmr65SCw1BrGqXxBzD8LtlgEGpfTK+LpkoMYhTqGtoNsq2j4CCsh8raSWYUhafb0FteEPhLledtCKXw89wEWAYJP6Yg+/mpNFbaAiyRIUahFcAx8OkCzms/LpRGqwZeome3vqvyvdoLE30lv64otn7UhqxaYj4zcKLlC0m28K57p/dhW5Tu35AphlfV9UA4r0FHehnq8oI/xoDTL1s2c1FmXyaw7umdxlcnnurApLzQ/j967UO98nXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8s/Wb21nDewbyrPgi9TFPSczi3wEbDMXcYJ3jHHHymc=;
 b=kC2qsOroCOIeVAppXglivM8iPwfTxLCCFd4frFrZU565gPiioZNuOvVoQHLm0huwbj/uUi4xqKIdHQazLWPogpfg/9byEA7Yn9H13ho6TOGqYnxB/LUshUR9wGuv7JgwrEkRrp+epQmkapdIXuhMVJgv02ucuLRkOx/rLsRwXeFnFnwJvi2pe2oGoJscQv1Xtt5Pe5Y8WF95N1offKaljYF3Mr4+SGhhRJ568lHEqgNNq+Y9+XEkhwpDHZ/F8ZwMS81AX0A44kw2MoTIbNfhqV7HycQCMOHOPHSAzjz3B6WvcpYFdUK2SvQGzp1dr2w4fMTKYDatusRpYHVaI8PQcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8s/Wb21nDewbyrPgi9TFPSczi3wEbDMXcYJ3jHHHymc=;
 b=TSzSIuPUmqAKH+aMQDZ8zVac1VmrfG46ENFSKLtHugswifwfMZyYhx+aMPH3cthK2IE4GpRCX4C4yX/Vg854+e9ztU6AJ+IVorux25uvGGHweehrhhmX1vH9jBp3d4uaaIfUhLPTgIwgeVFZdoelN2JDNp4HMN4WdSVaJAIbnzOvlKHRgeJ2Hx6FHrDXFvib2heyx14Q1UZSQ1G6A8MdALbth5wmlI68J5vkHkP6mxg29rg2iAhTEOWs+0qKE9fQyQS7gqKMdILw5BiGROIySsx5fY4Wy+NsCudOWiKGXZ4dQpyMFaNmCRysS3n3BO2UseELAk5wXRLm45jU3k5ZIg==
Received: from DS7PR03CA0270.namprd03.prod.outlook.com (2603:10b6:5:3b3::35)
 by MWHPR1201MB0032.namprd12.prod.outlook.com (2603:10b6:301:4f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Tue, 25 Jan
 2022 20:14:29 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::fd) by DS7PR03CA0270.outlook.office365.com
 (2603:10b6:5:3b3::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12 via Frontend
 Transport; Tue, 25 Jan 2022 20:14:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 20:14:29 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 25 Jan 2022 20:14:28 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 25 Jan 2022 12:14:27 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 25 Jan 2022 12:14:27 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/841] 5.15.17-rc2 review
In-Reply-To: <20220125155423.959812122@linuxfoundation.org>
References: <20220125155423.959812122@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d73457f8-4c73-4f32-b37a-800731e21c27@drhqmail201.nvidia.com>
Date:   Tue, 25 Jan 2022 12:14:27 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37b5fa3a-25b9-43f4-f9e4-08d9e03f4acc
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0032:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0032A732979F051665F8FF8FD95F9@MWHPR1201MB0032.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fdx3OA8rUWz6n7wbQ3y990dH/xO4HM4RQStimJMubTJlgepWaGNp0f+eTSRbqyn3ooTjcrm+BZF271ZvxJ1Wf4ReV/bp8axVUJLCR1Rp1+wNQo5onylM+cJBl2fymjUYAARQjbrBiI0AMOn9J7E5YBqcJKaT8KclRy8tV4E7nfeZg8GV9N0R+MO5Jo2dI3t29rLSZxza2o+/dKEDz7aYcWIxDIDnTs0zR+3vZJLjly9q/qYugq90w/eDZ448rYnjZ+xEAIqhzkzfKd/nklcL8Ks6OiblrcwHP7UVNGFEEYIJYejA/bOEaWssMBDOuDygFg211hm3XgC9svmroRji1+uA7aWFFo0/9FjvvORs2q1DrD7Z88nixuzQPUJ3/JILoBlH0fdLscvxfgSJf/UXj/kiBeUv2fX/6s0yYvAQaH3PNaza/all6JrDmk3j43isuSfg4KciosT6PM7HqrhXjlnzLr+RrzMf8+llJSWl1POAVUbtuzCstROAGL0YCOzZl4gd1xVMXG+ufc0b66OkF2B+o+dXTvWLr0XmQjr9+Y1Tsk2+6pCBE7I2iRzFi8/wT20bipzqaCtKk9tump4CkLO0ccNa7NEsPr4mAPsS4G7etNnDAn2tqBYyAjjwrhzPRFZdFTErA8iawTBIo3SlZZUFcqQimpDsojV+7mMMBMuAJm9yq6l8QGrB5kf12t1LpbXMQgnqE6IRrT8Pp/neQ6SYLDQhj8nCu+xGiBcENS6um+Q3joc6DnBnNgGUpDA4c8P9bQVzHB0dh/p5HTmyPcYgA5cbSw1s3PZ+H+RJF046+9/frFJ3kXIMXyyCBId07b1wQxQhjJHQYYPZWTBIwv/ikMJz1cc3Gmw7ucu0WqgPA/DmgPcwnfmxmazNY6do
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700004)(36840700001)(46966006)(54906003)(47076005)(70206006)(316002)(356005)(82310400004)(6916009)(2906002)(70586007)(40460700003)(8676002)(31686004)(81166007)(336012)(5660300002)(186003)(966005)(508600001)(31696002)(86362001)(26005)(426003)(7416002)(36860700001)(8936002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 20:14:29.1050
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b5fa3a-25b9-43f4-f9e4-08d9e03f4acc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0032
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 17:32:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.17 release.
> There are 841 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.17-rc2.gz
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

Linux version:	5.15.17-rc2-g384933ffef76
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
