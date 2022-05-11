Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7149522F2D
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 11:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbiEKJT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 05:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiEKJTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 05:19:24 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23EA95DE4;
        Wed, 11 May 2022 02:19:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlJ1k0H+pDkvmLhujNWjlPkQr2ILBzywE/7nvNtqQytXNWTg3NZcSOFW/buN6Shra6ajyAsT0NlV6+NPGtswpRBKOYw3hpTrZidUqJ/men8L827kEGEK7B5rnLOpkrzbWsHUFIEepqYLqV7i4QSPUtiBLqygrGJb0dVWX11FYULtDfSZP93bju+J14i4mNBe4y3U+UU3qfCgxq1yewgIsDCQ1xhj9dtmIi1H5Fv5DTllCpj2w3VNGN4NBUuiynerHDHMs9YTRhsx2/AAvH+cIwrA97Tokz0fXtLKgwUR0Ln3nxQntpWVSiKMlpK9qNyC+U2x0EAtQPU9hudA4qfnYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EL0JaXORrxbOUUJOy8RFKRsKnJqeA4W8b9LZhmyXM+M=;
 b=YJWtj3t8JfUlobB0ONn/mjzh6FtWCAhW0fFVb/VCLy1GL3LY1yWNurxT2E+OmkYvO+GoAqB8jrz+ZtCcSnqLrKcgNPc5S/ETKD9hCq5ZV6VaKThydg04ekRl9++WH2UgSzDO3ymF6aKYiP+DDyD+OBd2PcuvaS4RajFf4EESVY/o9QuIoIjRpPjy7Z6eRh/7UruFBB5OybIzqKemxL/NiUCQ4vt/wPfq/ioUtXkR3wrdEe6FR67AVbvWyV7u84atAh6vZdBljZwrrI8eEBJp7r+P+nlnMZiuUASRb4DfhuG4xAoyJVDHXVkqAkbJYH+xkEUYIrfB+ClvQaykF0pTow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EL0JaXORrxbOUUJOy8RFKRsKnJqeA4W8b9LZhmyXM+M=;
 b=gvaQGxYwkKxyxRpAl3/NCnHfyfRZlziCZZY58aIT+lmxeXNQCy3UR7Rg5wc7ApHmNspkbTEUMWyXvTjfpea1Ng5qYaDF6Hw8153QMkqyTapctxlhMOArzmjjd6xCRdtqTILVS+V+gCjszRuR53HBQWA0eB9VbCsv+OLCyDtjday/NmuPQoALo1CnFu6c0dLKEuiaJ333g0/bGwH9zk6NEkp1JBZlmt2jTf+ZuAN5eytTOkTaU7KMJJz3F3lskm9sM2/bROX6a9y1m/z5lXEzRj3Bo6NFmxCoHek9Ah72ufEDgH0f/vaPCBrOA4GkAk1gCLyT+/3Xk6x5eVtGZ89S0Q==
Received: from BN9P222CA0004.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::9)
 by BYAPR12MB3302.namprd12.prod.outlook.com (2603:10b6:a03:12f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Wed, 11 May
 2022 09:19:20 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::bb) by BN9P222CA0004.outlook.office365.com
 (2603:10b6:408:10c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Wed, 11 May 2022 09:19:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Wed, 11 May 2022 09:19:20 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 11 May
 2022 09:19:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 11 May
 2022 02:19:18 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 11 May 2022 02:19:18 -0700
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
Subject: Re: [PATCH 4.19 00/88] 4.19.242-rc1 review
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4cf5bc6c-6f84-43e4-a7b7-a33dcf840eef@rnnvmail201.nvidia.com>
Date:   Wed, 11 May 2022 02:19:18 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bb5f877-e56a-4f9b-8817-08da332f54a3
X-MS-TrafficTypeDiagnostic: BYAPR12MB3302:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3302FCA7F091619E479DAC7BD9C89@BYAPR12MB3302.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jw8sUS6MguGmch2UWBVRPxv8SdfoMaqKcKl5sVtGqaZxOjc1nR57caCPS3NbZXMplSZmiZ+DjSrG7Bq5gTqN+IJg30oyY5lkoF/mv2ORSwwdL7/SNfhJ77h8DqnbYONsuwx3mShypLQ0NSNMITRBFFlZGJFeWzhjEstCCBksntt1iDDXe9SHVKAn2X6NH4fKc60UPu9gFlUkMH5LXW4kzXnoWgQqxza9XmK+onImw0UYvNQLd4SvW2e/RET/KYGFYh4duA6ctyl882muxPBQmtfy2LQWzr0aJP0cVs9nAXBhnl6mu6UnbPrPdifOWfNdc6to1Ama+wr41S8PTQAVRVBTxWQwPeqThh7o0szeq5TIL3pb7EEBCYWfqvKyxJMcMqZ0nkPVl1lI1fTuwV7sdMtKquZpkJRNhm8Qadjb52cDm7CI1c7sLHjZBTFenNoVHDOaTyDaEq7RsmCfcthChGBkO7afvpcdZ3ORK2jyaw0e2BzU/LbK8A0X/hvBLEaO93jBKFbA/0WF84mXnLkH8EMjG6cf6r6Da/TaoYoL0zxNLCFxpytqziGJQ3SJREAvAZ/i7U8pS///MGQXoifVxQYu7/W6LFMmBYn/+YFJtL+XvLpGs5sZDTx3dts47cFq+/exHdboyEpCfO3nrLO8EjLoyQU13F1CFPIBk7CTnNiGiXHv7VBrzL3newCgvWolzfbUbN9e1tMNpxFLqaJJlpdWHRymgP6MdmdZUTryzqUADbIPf06DiER8AnHCphB+H5S3Sc3HZ2K02gytCd4uiTjT9xi7uKS2/+oYDuRomuo=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(82310400005)(8936002)(2906002)(36860700001)(7416002)(31686004)(5660300002)(8676002)(70206006)(4326008)(70586007)(186003)(86362001)(31696002)(40460700003)(6916009)(54906003)(966005)(336012)(26005)(81166007)(47076005)(316002)(426003)(508600001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:19:20.1266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb5f877-e56a-4f9b-8817-08da332f54a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3302
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 May 2022 15:06:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.242 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.242-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.242-rc1-g71a9ee8b0cfd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
