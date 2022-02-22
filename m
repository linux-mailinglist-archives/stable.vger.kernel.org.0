Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735A74BF7E0
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 13:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbiBVMJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 07:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiBVMJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 07:09:36 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F031CB3E7C;
        Tue, 22 Feb 2022 04:09:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCD0RbuGUKhjGT9An/gUez+7T6RJgYg1sRXuMAhM/2CISifXk6O6BPuVt1Em3xB/NV5AboHNVE5nGO7RMyrO6FhtMhyuCe7erwLs4lLPCtdpJ4dr5sPT0l0nXNccqj6o/fWnI1CbayQaA/L4cnkYsvtxKEGVeW3ix2XmhGfb5uCUX4RHXDybarAZuWIpduP2tPBiFsQNMfpDwXas8OCcrRb+2aSseWafO5DV6wZqCyB7livcnMErX0rKN/e+icAG0v1xKcMFuPsaEMXtabWAASIfLytB9S8APweR7/b57j8tCFs1eCRIj/MNYp3ZfoE643xyjLiwm/Do4IABIQXgFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gw0LyOytf3ilc8PeAbjT5LfVWOr7Y9hgAgMBwHy9sRQ=;
 b=TKAPRDhBNGe9DMZ85C2BSbHhTc8eGWXk6h114mexhqnYec7xOVElAAQDThnm8rqU0Uyzc1gZB0v/drpCQYJ2FHYfMOghEieRo92uXeCqCv4C6KyTP+7QvrcQPpr2mLrS3TAb2cUveAkCA/j5f9XnucSKlpvCk2PE/Ow/GVMdRT8K0uY2voc8Vl0nTxK7yLvZiyU/4CEGnj6hzNubO361DbyHksWy8N7nO6k3K2MuMaxW9OYA3qQq+UsqjIE1azMOTK1coE9ofrQLdFDA7c01jN/lSHHc0kd0jibTKVKBHvak138KH87+f3qTsDLsOdsUyKG0IT06JYtY7bL02Fk3ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gw0LyOytf3ilc8PeAbjT5LfVWOr7Y9hgAgMBwHy9sRQ=;
 b=GDTEtcXZW8CWnrTcN3TcZCcMUQaguDWdeK1b/grTMS1dirICFth7kbLFdaOWYwPyVQYDLSEzdRPyYm/H1dmOePiLJfsJPdAZYHee33jGB7PSoZHqXLFHqvQw5nnbwt/Nlko9HJQKYILS3xLD87uANSzEcPoBi/RPBO1F8io2wQnkNnoOoW+NTu9YnOkDyoc5A3yTjxWNkUnWm9GQPVf9Bf2MojVJJQQRtZ+5LGcy7rkqAmJTyCdLmoH2FoL8bVzSUQtlpHIwMIL5mHxtFRq45c8XXuQgA/vep+uwREr8Ivw46LN7w7e151WLbdu/5jqFpd5o9JO8g3lUFPRa+dCbFg==
Received: from CO1PR15CA0077.namprd15.prod.outlook.com (2603:10b6:101:20::21)
 by DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Tue, 22 Feb
 2022 12:09:10 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::dd) by CO1PR15CA0077.outlook.office365.com
 (2603:10b6:101:20::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18 via Frontend
 Transport; Tue, 22 Feb 2022 12:09:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 12:09:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 12:09:08 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 04:09:07 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 22 Feb 2022 04:09:07 -0800
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
Subject: Re: [PATCH 5.10 000/121] 5.10.102-rc1 review
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <57a7b2f9-9459-40e1-9c10-de3cda7fb605@rnnvmail203.nvidia.com>
Date:   Tue, 22 Feb 2022 04:09:07 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26320fed-21fb-45d9-fb42-08d9f5fc21ba
X-MS-TrafficTypeDiagnostic: DM5PR12MB1449:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1449E91604EFD35B2C8FDA86D93B9@DM5PR12MB1449.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pBIT1EZONQaPkJWKZ4w86Wxbs9AzdlH0FmFYnprWuxciFNfRwJOzt9CadhMbdnsD3xzzEDcda5XBoxvpfT68LjbkH5NBHQu3IjtksyzZVAaLt+46MJsPjYeVw27m/cUsSClztV1jx4jDFTv+oEFYGYKokhANOsM2WQxsAkkP2hiSpxHdFCkW9MLHXQfdFsKtw9K+fNoh2fNQPiUpjU5jLD+1HsY0ItJc1b7dF+fSQIymNFbQfpOZANJ6uUDH8SCHMOtOy+3/4IW52Um+Yc3yAKE44OxGbhkPPpmpcq2CbLt5dliPu9dzKjMuMvbN47VIsSfDPqk+gsmCtVa2FeEFcNOACZwDOs/FbXvqUPY8rm1O/CibD76dw9KsuHIstoTMl7CM53aYdG+9dCuK11pDqqr/tLe2UNvVhlx4EA+KVaEcs1ewqHuW5tHEk258Ax6kXxa7aPU2igqTb7MsFJpu3BopIaFd7odcJaTICVH8PR6sHebpPC+z/HhXwsIuEDrcYmTdm4lIEYuCFijXz6Zvfd25RHcte8CMUH2IygqOoZDJcvTnOrcmlxt2tOly6ANE2ijNKgX6E5q9EDewVuSnD8DvI/mKEjYc76eqTrNLq0VzGBvbA6R2CEWuBWBN5+J34v//euiPpM6z8s2ixaUdFdopW5/jJShiBNCR/I4Ns3TG9tZ6skYAmMyzKvcPXpgFUqOKenQs6v4ifG6lYNVhhvT0SIPwrLVLMwFJ7dc4Z504hVVolTQazeg8IyjeUWNXR1BTlIsl8SMOVc+iXuqBXQ+hb0NKBWXtOHFxK6dv3/U=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(186003)(26005)(70206006)(70586007)(966005)(31696002)(86362001)(508600001)(8676002)(54906003)(82310400004)(36860700001)(316002)(6916009)(81166007)(356005)(426003)(7416002)(336012)(4326008)(47076005)(40460700003)(5660300002)(2906002)(8936002)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 12:09:09.5164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26320fed-21fb-45d9-fb42-08d9f5fc21ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1449
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Feb 2022 09:48:12 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.102 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.102-rc1.gz
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

Linux version:	5.10.102-rc1-g6c935cea31db
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
