Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DD638AE46
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 14:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhETMdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 08:33:53 -0400
Received: from mail-dm6nam10on2068.outbound.protection.outlook.com ([40.107.93.68]:34657
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233104AbhETMdm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 08:33:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUUZ+rMe8oszFO2o6SnLwanAxtgswI4oFRuc6k3pWlocc4WvJH7wCvTlHkWNKVwMovEz3nyU+3XVIHhFk4o44P72wTmncSFVoSJjFarZOtg+KMzbvRbTOLnOKzOv2NgzGLE/7lyw8lyXN0/RtorrKj7d5d6d6ZoDQub3y0SiNqAc36aAW6cx1Eq6uTPSLNCl4ikTeTIWPn31OPeSDBGjZntPwPun0kdbyhn4hQiC5TBOfYT+aEO/t+Xn2M4atSdR78N+lapUpbNpr+iA5aiL2tJ4pkRNrV2SQI39KC9/tR9Z/gfGywZoY9tLqypfo6E7OTQRds5io7lAIao3HeO0kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7Y23aM4JASZ3P0lQo3UnV1Vsacl6/8BeJ96+fDQpxc=;
 b=QeQ8Li7r+y8yvgToX8as5foggFZbdvdNLVK007sHpUPwRDYe0TKnlROgW8q1BHhJu0rKOZp2abwD9OJIFyfltDyB45w3n/kDef2D/kdhbHMtRmYUIgnM83JRXNrtMEIzUZZtZn1vq2Bm1LakHJ3YzT2LPT5CyCLV0pyshMceX/OS0fIW5QT12ov5CDR5zk5xnpHJ9oqOYE0D+oJAIE+yQ5UXrTIUh2MusO5gcCeW2CJOH4ZZ/+Mln7NKL6i9AE6DqCDtP6QsR0qqXI3XVo2qFcHoQ40ZtS91OhjOXL9NlWXuZ4qXiNlE3LGq9unJFOBco3UR2nCMzNnbkdl0Ju+2Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7Y23aM4JASZ3P0lQo3UnV1Vsacl6/8BeJ96+fDQpxc=;
 b=QeobQmhlogyfo2WR0D7GpM5R2u9m0EckXtGU0A1I4MaUTNOrv44latyDny4J4u3IqOHj2TPEEsisbpgqhyhFoQ0QLgRd6ACpiioCk1qQlcS/FUsVQziLTBBL2l7WMzfb7DNZ+yQyZJfhhoI0/0pizs5VqENVesctsrwpZ3ynmIU8bGVZ5h4vI4mR85QID6dIopPN/6F6UKKQTp+lHql9yqLn1PBILigFcGaBTFouWs0Zh6Mmw7E8OyQRKLBTrelIpdbROSIRET1Z8I2lBg4ab+anPNSpgCygAuWSKBKf1IC2ylhpLn7woyV92VPdWK5PFHjuJ6Lk7yDkBg6C0mWn/g==
Received: from MWHPR21CA0042.namprd21.prod.outlook.com (2603:10b6:300:129::28)
 by BN8PR12MB3124.namprd12.prod.outlook.com (2603:10b6:408:41::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 20 May
 2021 12:32:19 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:129:cafe::7e) by MWHPR21CA0042.outlook.office365.com
 (2603:10b6:300:129::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.3 via Frontend
 Transport; Thu, 20 May 2021 12:32:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linux-foundation.org; dkim=none (message not
 signed) header.d=none;linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 20 May 2021 12:32:19 +0000
Received: from [10.26.49.10] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 May
 2021 12:32:16 +0000
Subject: Re: [PATCH 5.10 00/47] 5.10.39-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <f.fainelli@gmail.com>, <stable@vger.kernel.org>,
        Vidya Sagar <vidyas@nvidia.com>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20210520092053.559923764@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <447d562a-248f-7e92-42de-4239a2c18fc0@nvidia.com>
Date:   Thu, 20 May 2021 13:32:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c305fe0c-5d64-4777-ac0a-08d91b8b4f44
X-MS-TrafficTypeDiagnostic: BN8PR12MB3124:
X-Microsoft-Antispam-PRVS: <BN8PR12MB312470C2CEA2D24ED1FE7B64D92A9@BN8PR12MB3124.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wyl2vNfBZgybNpy606wDDxwDLY1tK7ePlF5SVvX97OvvCi6NOLMOpVfY4yvgqoEA4ccsm+8G6cu4ks20eejH/wgAtsf4ESEsIABFPLofYyFSso4FHm2IRLJB02Dk/CT+2j0xyMRQoK9sC/1eCkY/F9OkR9deZps32CmV2M5I+IVsgZPnZb3MRqYbzbLWwi+51uaTk3PUPvj7Jrxh7x0hxJ/XMD5wnNOjBK1eF5k43dydtSQMvbGVfMxEwx6TC9OVwWme3C1CYTHBXnLol2+k+5TOLPw356KSi7tsv6btfVgEv4oSovZXZapm9SmJpQWgerASHZKhszeBuwNzH5nTnJR8efFmgdeBKDsYlQcrNixtRTNUhAtTnWAsh/XhSYn9fZGn5u2LgDlo+CaK3Pi0d4+KzdneCJEoMXeDp9JrMVCUCfQWT0MjE7ErUoZrWQvrGpf4C7wy0Kdo8GLE3GeH0tKm0bH8wlftGiDDm9rDRZpVAL/F5Fx2xmS91ZB46PQe/ti2QTQiSWkDuxKuCsOLFfwfpAt7volxmKCzE1mf/5400Ic9CuHH0YBA0+bcr/QsaV/H2T7x57n+I5ADWBPwAbRFbygsQradgnLi7iPZsq0Gb0R/oewcbmt0/6obypzx2sWkX/JCHhObhOzgwbO7N7UC/RWRwdWep8UERmEjQrEO1a7pcX2KbCDrs6eqJCrmBxIVSziMkhaA+M1A+iPImxpH7w4LMI2VI776ZXrMlQzLtfY8Dv5uYOEOJWq6IqHq9Yb180C7kX2nV8B9SqhjH/DmAVB/R2dfWnYx8wRAZRI0iNXq0UjGZYUD4hQVAMjN
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(36840700001)(46966006)(53546011)(70586007)(70206006)(31696002)(966005)(7636003)(2616005)(426003)(336012)(47076005)(8936002)(8676002)(82310400003)(36756003)(26005)(36860700001)(186003)(4326008)(356005)(16576012)(31686004)(110136005)(316002)(54906003)(82740400003)(7416002)(86362001)(16526019)(36906005)(5660300002)(2906002)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 12:32:19.2821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c305fe0c-5d64-4777-ac0a-08d91b8b4f44
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3124
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 20/05/2021 10:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.39 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.39-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

...

> Vidya Sagar <vidyas@nvidia.com>
>     PCI: tegra: Add Tegra194 MCFG quirks for ECAM errata


The above is causing some tests regressions for Tegra. We have a fix
that is under review but not merged yet [0]. Please can you drop this
for v5.10 and v5.12? Sorry about that.

Thanks!
Jon	

[0]
https://patchwork.ozlabs.org/project/linux-tegra/patch/20210520090123.11814-1-jonathanh@nvidia.com/
-- 
nvpublic
