Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6C04B5329
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 15:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355121AbiBNOWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 09:22:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbiBNOWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 09:22:18 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089EC49FB9;
        Mon, 14 Feb 2022 06:22:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCzMo4MbUHwwh3spaFyRY72TYtQHCHs/0oyqvH/UqD/fKSrWuL6/NyXQmHVPTRYG51drRhy5Zee3CW4UQkzDlHK8GaNOkstuoWs7bIjHlX1eu4RWFF27FvWioqRWadHA32y4GaI4dkPPMbbqQgD6nY5Kd4rzH5TEanapTgP6C+uLxUspVMWCQP7lpOTEG5Esj2MPvbKFgMNC36VciS8TUSJR5dd7x0v8JiAqg+8dRWqU2CXKr6UOgR5Aii1DJw+qnY0HD9Nrj9ORMMrSWKjPifcGDwrnHHmYE+eLaWK6a1vo3LcIej1buZ2c+3WYvLY4cIbyWQRMOdAD08jF7Po9qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0r1jLdak3mcRuw9ENGGBPogt1JDnsMBoCgOdY6rZYAU=;
 b=KH/NxIncma9TOu65zKR2V3CFOjlcddMXT6PXmfmZXefDzpffcRU213W6JltTuYu3agko0VN1Ckd0Y1zqAGlNVDLFvZSvOTySx/L4Cmr4V3z/zgX7vb9CX4kNVy6YzMxySDcbv7i/uTMk/PQ1PLFk+IiKCwi8wQKL38Ai38jxszuAoMPqlbdrxIEdSLWc2zFlXDLHCNFayeyVN58Tw9UD1ISq7fSmpBuHCu0Un5pntZxn/3UsPC/1J09W1nx3cOyvuLw0qx+IBaBMiYsshNVlu2CgvZR36w18Ju1YSrGrs/DWfOgTEnn8wvWn9cqzQj5A9DRSrIPh/czC4rsKubSbnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0r1jLdak3mcRuw9ENGGBPogt1JDnsMBoCgOdY6rZYAU=;
 b=RofrtuKf7GGIe5tBMyQiBLWJHWiWVoqUasAnRtQUMaMBksIPMAcifOpc7a3fdQb4kTxLt8gPMgAj+tZuuiqpTiCRcoaWaRfRenCCt0tno5IYx+dkc+u08lB0gfpueRano142l0UyNhQCfnSits6rKXeRXZssZJRr89ABVCs42kDwav3xn28vQjGxgnivVzuqHmwvAEdHNVA1VXyLol8IQbPDBkyUg58mp2GN5GzB6N0Gtu+s2dr+CD8PBNMgtEve+2bOW002OExqWajQDknderjgI2oqObDCHfp8b3p/3JEnzvmV77mOx/xECFqDVPwAU9MM3dialJIzglWip24/2Q==
Received: from MWHPR18CA0028.namprd18.prod.outlook.com (2603:10b6:320:31::14)
 by DM4PR12MB5309.namprd12.prod.outlook.com (2603:10b6:5:390::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 14:22:09 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::3d) by MWHPR18CA0028.outlook.office365.com
 (2603:10b6:320:31::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15 via Frontend
 Transport; Mon, 14 Feb 2022 14:22:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 14:22:08 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 14:22:08 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 06:22:07 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Mon, 14 Feb 2022 06:22:07 -0800
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
Subject: Re: [PATCH 5.10 000/116] 5.10.101-rc1 review
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6dc4a2eb-c15a-46f6-9650-1beba79b4029@rnnvmail203.nvidia.com>
Date:   Mon, 14 Feb 2022 06:22:07 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c4c0401-381f-4e21-7e2f-08d9efc56272
X-MS-TrafficTypeDiagnostic: DM4PR12MB5309:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB53099D38E89B66996D6F7482D9339@DM4PR12MB5309.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l5wh9SKgu6qgLgjJIve3JctSm+chFIEAcimxqmTfS/dKhkTh4vhRpiJ7LtKNdjp2IPxzAsy8vUYLGOTKKTm72CHS1q0YXrcjPUqorWn9sj0g+dB+krH88QjQ2JxyF3GQKGY+KmLy2yFD2byCcDEWOkPuuxxp7t+jHOcKiTa7VQmaw1QSI4BX6K7QyHgFFxwidx4uhwmM1SDSAr6MAE3hcwra+lRnfLvn3P8aISkx1opTW4ueHZUDsHneyXlPcGzuxH7uQ4O2NBDBaPFIMLK6aIpIMGtndPnGPaRXd+rbSIoynh1e5EABQKHLQ8ME+V5Vh7iwouAB4zk/orLNG97Y+5EKTurSI1nQ+v7IteJHbFZrTbmYAc5xnOrdEkkHV3sn22GK5hqpD01/ReBI5KK9BQNpfaWg6ELesVuu2ObcD5/H8ijhbe0baHWsBSZTVEOMV9x5p/Fc6MhsYVUPzutEbjIHI39k4C50wxsUTHWSEbHaQD4eYNi0jntDm47+JE4uHlwJgI/anRzYbgkLaXzVkgQ/DcR5PW2Whl2W7UZiqONhoRB38UqK+1QqHI0orNRVBkVDeeHn0hQ1bY+/wrXa3tTmozsG77DOCEf1c3TJw4b+ybIA/Wx+Z3xujWpwjOfxkLErBR6nLsxXp/1E45RAnyXlo5N3XSvQ2kBiqlE7LNVqM47IH2PQ6qa1DxK3GkLYsgSxIXG5VZFXQEjQPnCXheIW/wEm3p3VUgyDtIzzFmTQ7aMGtuOciA20I80nzfe1nrf54wPJN2Fd61M1YYJ9oiLGkQ0CbvYJMMEYoP0W2p0=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(6916009)(508600001)(36860700001)(966005)(54906003)(8936002)(316002)(8676002)(81166007)(82310400004)(2906002)(26005)(186003)(31686004)(336012)(7416002)(31696002)(426003)(70206006)(47076005)(5660300002)(70586007)(40460700003)(4326008)(86362001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 14:22:08.7808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c4c0401-381f-4e21-7e2f-08d9efc56272
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5309
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 10:24:59 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.101 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.101-rc1.gz
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

Linux version:	5.10.101-rc1-g8d15f8eda4b3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
