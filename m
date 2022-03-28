Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5334E9961
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 16:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243792AbiC1O0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 10:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243787AbiC1O0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 10:26:32 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7AA1EECF;
        Mon, 28 Mar 2022 07:24:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZetaGviFvL+L8bKTIzeDy18ZWYfboyuFd7qoDJ6SDRVTKIytXH/TpQ4bKHH/pXN9mjzjensV4O+0ZRhexPrM/Fdru9157+reQlfnAiVBcmfwTYZlkWxd21xtSjJrdEBwwquO7uXZZ72kBNcRqAyOjhQQ5in0ILNqIZzdb7NFOZJryQ9C9/yrGCQxxiWDqF+V+3Bga2/wZrbxuwGva7K98WCH8zGoXluSQ7nQGJ3zFCQvdDeYjJ3FG8haOV8qacnCQPsVV6h13NfRsVx8Gt7M8/CFe7EQmSuNddoCABcWGGlY06tDwg1qHgIIe1i7XsuMGf0o8UyWhML36BDdHwWgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuxkPAVblhZdrKhPKIlX6FRP8KsT7Lc/pdtnIgOv4t0=;
 b=RWpmJFXKYUgDUTob2PfT+xAKmC7xKEGI+j3jA/9/8E+BH89O721dwbDxJT6PCIDJi6LwHtlN5mkLp1OsRB7CD0qUUf6n4CLwgsaZLgCWA7F9XBLUuUOBE5UTSq9BImpPSABBeRkyV1pR5mwi9rbpbDUxAv4aNqt2GyWHexwrteeLW7tqsucwwtQ5Tiu4SqTlHpWDY5hVkkAgoGgFZ82XG3a1bHJCMa31v+zL8vh7lVA++QLPFEcOUcoTl5qGeAfCIfE4ICh8p8g5mnTzAqfieCtgEoW6WKRhEly7FlweohyuuWU5r4E8MPu5HldEWWC+T+n1sHD1LTdUzqEyCWMxXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuxkPAVblhZdrKhPKIlX6FRP8KsT7Lc/pdtnIgOv4t0=;
 b=lufRNz9elJsoXds5VfcQIwwX/FEqYzETEc7j3uD1zXcHmVxmw3qbVIdMblUttToIpHtYGwatgbCO7PZUr2mPITIGKk2H/9xGgMusXWGmzvCwravqUKyxmoZWKLnPo9xeY3BCLP4+7EDRS4jobmlAgk1XjnwFqMDFrGILKm7mJKZU+Fm+r221EsOXZOZVR+ksT1nCHiYP1yu8+F4yg2qUsqnX6mB9HLSwgTRWMuqYkVTzmDF+u76QXpMWNTWeBJI9JLRF5Z0Lm3nCJVGBIXj8yM0wZuXUJlk+3mchdeEqwIlcwcOrGLFPWdc3wfpS+78wEmXPwMnJR8wbm4oYG3+ymw==
Received: from DM5PR12CA0008.namprd12.prod.outlook.com (2603:10b6:4:1::18) by
 MN2PR12MB3166.namprd12.prod.outlook.com (2603:10b6:208:106::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Mon, 28 Mar
 2022 14:24:50 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:1:cafe::c5) by DM5PR12CA0008.outlook.office365.com
 (2603:10b6:4:1::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18 via Frontend
 Transport; Mon, 28 Mar 2022 14:24:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5102.17 via Frontend Transport; Mon, 28 Mar 2022 14:24:50 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 28 Mar
 2022 14:24:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 28 Mar
 2022 07:24:49 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 28 Mar 2022 07:24:48 -0700
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
Subject: Re: [PATCH 5.4 00/29] 5.4.188-rc1 review
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
References: <20220325150418.585286754@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5a188321-3a32-4f7f-b64c-6678da1510ee@rnnvmail201.nvidia.com>
Date:   Mon, 28 Mar 2022 07:24:48 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff7238c5-f196-4dd2-670c-08da10c6b828
X-MS-TrafficTypeDiagnostic: MN2PR12MB3166:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3166E30F425AE1167ACBC058D91D9@MN2PR12MB3166.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mTHdo6cjLbzgguUmb8rrnM6E91swUWv+YoeVnZ3vtYoPMLEd5dZMviiQjoTrMRSLKM6Ur7LKgl1qhjLFmgr5rRLUKtqS1clQKPkporexUY3B8Iit3kTvI0U2YNwlwFHckwgvmgwg2RfJA9nxL0j1ijeURUAW83IUb/AFnxxIyfAhrJqcDRusDaXbndMg62diRM6otWrOOFrRve0g8vu+zB0P7JmBLPNeVe9gtSMdYpOXC4aer7ejgvjYeq8Cx3vZhGtZhkFP08+4yxp2cYz99IpWhNQMDCWHHB5ZGVPFeN5UvGSM8shjRahe3E8PdPl8lPFxnwGE7SElZDnm/FcAjC3/BZBWTgy9bDpdsYTmqP0IkR6WksiGm14gPet+f6ckI3XjN0FJaSZ9ywpiUMMeqcLGYUMUxB2WY4ko0skL0cKatmQo8lNTNaNSzjuZ2HyL9CVIgvkDyqCwSl5ubYKBYUol0lO5o3YtCW1Kjb1REYCVLWjLdmgLnI1DhFX2o21mf8p/nSc6+qtPNDY/SK9jsDE6Z59dwfjz1EsyP/hmLaUpe9sjeMA9JbolB7wiAn7ZVaFg6DEyosU4KJBvwQBydsmozLZDedqbz0QpiRRlMENnzBHZwMQ1b+rKjnZTjMvh7Rj4eVFfgwZq7F93Wozfsi7SvbAacOA6yMBppd3it4crjv4nJFAmxdxXd8eAloNRD1JHTksgmjIZ5cPUF516wMuyKgyc10xOI/uN0NKtwPDG2bGdvIDUb6k8G0zzMIlyC3i0zahVx0IzAbQ/dVO4ukd2If4NPyaGYbUpi5d1FTk=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(54906003)(36860700001)(6916009)(82310400004)(5660300002)(7416002)(47076005)(8936002)(508600001)(40460700003)(70206006)(8676002)(70586007)(4326008)(966005)(31696002)(86362001)(316002)(81166007)(356005)(2906002)(31686004)(336012)(426003)(186003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 14:24:50.4321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff7238c5-f196-4dd2-670c-08da10c6b828
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3166
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Mar 2022 16:04:40 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.188 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.188-rc1.gz
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

Linux version:	5.4.188-rc1-gf7f6eb6ea69d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
