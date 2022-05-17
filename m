Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707D5529B1B
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 09:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbiEQHkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 03:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242174AbiEQHkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 03:40:12 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2089.outbound.protection.outlook.com [40.107.212.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F0E4B416;
        Tue, 17 May 2022 00:38:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNP3sN1UM8XnW+6d0ICGNnKJ46Yv1GwuV1vvP80X6DPnP1C1o8+ShDQDYT9CVQd6Y6ked+blSXYTwJRWhEsOu5i3A+bRJ4lXAgIF1tkCFo1b52cPjzy0j0/csUV2m2NKnfxN/YIixvBQo8R3srwkFdyiIVkpT4qMfW0jR7Clgszh6ekxFb7twVeOE1jNeOoNUDOqW4Ml4O4duESrC2FesY10j4pMxKuIhJzLGLv7mWdC+8cMBLmPz4sDZ0SKX3xS4pywU9giiRZRCPdMHID6jRHezfzaeedpTqUX57Eiy+5cC1gG2mCQknnFsFzRvGdvA9JFvpJ4AulTfWCXJi2HHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVUS8IQ8I/qVZX6+7XWy01PAH/HyPOU0uQUwepPBNg4=;
 b=OmCIkk93LjqjpqHtgVptaiOyge6Hu2i/sIsyLjWrSA2tCCu+3ymVbYvnE35bqmlru64qraeR2U/tZ9ndga+2ozkGzl7DgKvKLBR1QqnDfSiR6vEBVMqJCSn7gAJNDRxlZes2dHiphXvKnKw0Z4SdvDGoi81Q+zibkICOxIkPjUcxih6Z7CWzfK52N4Vuvao/Z9S7cLEcbR3Y69r+aXUXtJyXAV08eW2oa5XbxvgTNFdcocEyM5d11JZuX42ubKMjsk/JmV7EBZ3NjMh9oFcTns7dgFB/qGRrHo7PW8d2urqOp8Pwblx8uBAnm7FBupW0c6Dbv1hjEYJSqx6AI0aafg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVUS8IQ8I/qVZX6+7XWy01PAH/HyPOU0uQUwepPBNg4=;
 b=L82MYiEufU1B9btGxMLYEiVWV23LBuFxfMOP+TfViTolckvq03bB/h/CmON6IiHVV0JxuwDAD9pIsv8y01qTN6zsAvQRvzBr6OfAHIk44OVMFBe7e9teunVBvG1WJjTz7PS7BJisidvxj7Zp/Ji/pSx1Anv6YqgGEhbdpq+fqQzpowpe96yjf8lx3Wy8ASPZ3RRhVsBh+25GrrgWaOUj5unjG3zPVtllM1fYhWX4rJUHdisrIw2vT3/bKYMBYJZb3X0ksL4VKiGTYdoWorY6dIGxIaBKBT0b9oRahzYHiBYeL6bSwIj2Ylh0qT0Nb+De36YsrCD2uvPn8eUQo5YjLg==
Received: from BN1PR13CA0025.namprd13.prod.outlook.com (2603:10b6:408:e2::30)
 by BYAPR12MB3318.namprd12.prod.outlook.com (2603:10b6:a03:df::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 07:38:54 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::2) by BN1PR13CA0025.outlook.office365.com
 (2603:10b6:408:e2::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13 via Frontend
 Transport; Tue, 17 May 2022 07:38:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 07:38:54 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 17 May 2022 07:38:53 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 17 May 2022 00:38:53 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 17 May 2022 00:38:53 -0700
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
Subject: Re: [PATCH 5.10 00/66] 5.10.117-rc1 review
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <eec58bef-24a8-4d29-98f7-7af50fbedfd2@drhqmail201.nvidia.com>
Date:   Tue, 17 May 2022 00:38:53 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b34c487-6399-4654-ceda-08da37d84b79
X-MS-TrafficTypeDiagnostic: BYAPR12MB3318:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB33187FCEE22BFBDB7419168ED9CE9@BYAPR12MB3318.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0S86zOLssiWwc4+MCnQAEEkA0y+EjQvhXCIQkHVjtBS0H4OWgn8WHuiogLd7zNpUP5a1IqK1fTpXyoVj9xMz9VpVhyBqKuUKmBB1I28U4XzmhPNRAYlfnCNXzP3DmtcmecUR+Of1LD8IlLIyM9WKTXftoOcwaAzZxV27SuadOMcy65CJTCPgO/Tbo/ku0xygdRn2mbq0cwGTgqcaSvtWYMwCS8Qy1ImsWnPD2ypXo2Kc27zn1QjwMnGZcyIeCWxlYJiHfCELBdoIecgUMZ2qvGqZogur/nL4AQC4mAiivpw5+bJyiodvmowOAs8l22zZ6DX7yao1cq78zXFqFDC//fw429BTCog2EmVzsJd0GStVYVZsonLSnZSBYeupSTphTotbHL9QBMyvT8tsw1gAFVTOy14rCOZjie0UTqiTmdAXE8n9MuV6J5yIGcepPSdEOzsaZrlEV3VuQTem6UpuyFtH18r70PTJ0rlALqv7BvGZUa8vXUIT+f39tnTb3MMGpHpw/LTz8iEDu53PqBkKktXJG/XhDgwtQ7K8z0t2ysPZmzS1fbVeO3hRgRphHE3ssSx1yRYBW6pYgaJZgMkjtA1YS1mPFTwiz01+XI6XbOkFrfk81Jw303lIXBDOGxrnTEWpJ0VqTEMG1CspPDShoJoZTzBAves6Xhomo30HszKAltyujCrqXIBEm1hxPi6Q+M+xq2ShXjV9S1gKFbtwEch5QHgXKLKbUEr8qP5vrEk6UFjeF2W5QhX1NH3gqdz7sZm01Pstx7iplktbfYNzXps8Ctp6hB/5vco+0uyCzR0=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(966005)(508600001)(40460700003)(26005)(31696002)(6916009)(8936002)(7416002)(356005)(316002)(86362001)(47076005)(54906003)(36860700001)(81166007)(4326008)(8676002)(70206006)(70586007)(2906002)(31686004)(5660300002)(336012)(186003)(82310400005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 07:38:54.3365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b34c487-6399-4654-ceda-08da37d84b79
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3318
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 16 May 2022 21:36:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.117 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.117-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.117-rc1-gf18e1f39e30c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
