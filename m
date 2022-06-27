Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DCC55E31C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbiF0Ooh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 10:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236155AbiF0Oog (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 10:44:36 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B19DEF4;
        Mon, 27 Jun 2022 07:44:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uy2GqNrE38gZIKHX9+lq2vht440J44ANWEHjKQ+cUwqZ/f9M0YsQWpYPjpjHtY+4eynasSWisWl+kLZ8LdsdNFamplEetXWGYHoGJwVPjmjcRzciF771Q4/Iy6uosr/DQUdtIHvoipvR0Ibpqwo6h8AY5Kct48IvgbD6xRyYuu4bW1igDnU6wDPRLGHv4PSgJtzCBLMarZyT8Sbhqey/ugayId4h/B/2R/qfO/cq4rtNZCtoNlKA1vFs/pFzB0+CTOZHKuz7L9w6b6jJM27BxRVnUaf8CLDR95sZzw3o2MSOnx6GnlzNfCPtkzQmUZ0vB8B/BFOfXAvRpTJ3ug4M5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nAhp9Fv+DvpNMwaoM39tEBm0lv1uLCU4GS+ggCi3cFw=;
 b=TqcBLPZMK6rt38pU+/q5y6Trc/OpRe0T9jbSfhfnhXoIwpHJG/fkFczbhsHkmUJeI9Ve+kHca8n1LICjtzDdx79m/Y1cWQXj9mGJSI0pOMJvomxh+ZcOmROZtBugsU13In2MrxYtnobux9oFbGU9owhWNnSvgwrAH2RQcW9IrKqo5qIaiWEjaZPtNs+ZffLf9e7AaBx8ZlPbvIc1SHEFk8vfcGqnkyxRqQF1UMr1/1cBCqsZjPyYrF4RIG8S8B4UMEfxkw0x6rvQYfbP2sNigjWtwIH42Yptt5Pq3ljQpvnDruxPLo6OO73RTnEOnWiCWTN8Px41a90ZxeQqed7xGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAhp9Fv+DvpNMwaoM39tEBm0lv1uLCU4GS+ggCi3cFw=;
 b=lb1yGb+mYrX12rF0Gf9GTEb4eq2sCEM3rWoFtU7hxQo5KXxPeiYcmJ752DNrF8Zok7O2RVKV1bRuG8jb+P3Z3DdrjtOr8UkpulD2Ni2GgcIx2UEBsyynEfTCBMXj0kEZxmds+wa0lopmtEj3UBOIGT+1BydobWCisEyZHZsMKIW52sQqX4XAuEAEYELzq0w0iRXlycWNoL5g/z/qGIiVuyxWY9DPSUu6K9l+FLtF+8fexC/KVMXYl+U+9f5HRYJm8oo2FucE1xkwKJBjIsDnwRC89fDIap5u8g15sanGJbbkKLBStbk6VIqGoe5BfMtsEFqxY5+VnqJ6teV7i/yRtA==
Received: from DS7PR06CA0007.namprd06.prod.outlook.com (2603:10b6:8:2a::25) by
 MN2PR12MB4504.namprd12.prod.outlook.com (2603:10b6:208:24f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.17; Mon, 27 Jun 2022 14:44:34 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::16) by DS7PR06CA0007.outlook.office365.com
 (2603:10b6:8:2a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Mon, 27 Jun 2022 14:44:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Mon, 27 Jun 2022 14:44:33 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 27 Jun
 2022 14:44:33 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 27 Jun
 2022 07:44:32 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Mon, 27 Jun 2022 07:44:32 -0700
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
Subject: Re: [PATCH 5.4 00/60] 5.4.202-rc1 review
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c88276ec-0a30-477b-b2ca-3a4078d6ba13@rnnvmail205.nvidia.com>
Date:   Mon, 27 Jun 2022 07:44:32 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5206a0ff-2a2c-4e9d-3903-08da584b8d0a
X-MS-TrafficTypeDiagnostic: MN2PR12MB4504:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vBMJDI7lXSNi6/8E0QqjKVHx5btQTGTfJk+BITKH+Q4OvairzJA8pWhZnzUsXXox2Pn/RGdpj5W7HmiO2d+4oXAFLg8WluWykAezP+akMZJU0++14q7oxwgsrt+cQOaUpNynXH6EeW0w0+on9mtVE8m3QKCuhI/MeagEtK6F36vIXfC3+MHgKBwiMDJ6Il8DTP2VmTNIXFUohG/U0H6d8ILtYWPaob2+kgiARxgN72NMu5mz2D+hLgooFKX9clhQJjqZT3Dw636nkHTLLB63abjvyYrbivpkh/4ezSaoe1RCe8dUf6r6H05MueID9ePeeK4A2yb9HgsYEwrLEusHuEA8acdylrDwk/3xs4dUqtExzMOyxE90otMQy18Lvct9NlPvVObrneVnbhRp6OOkmqS8z1yHNvbQFiqdoTf2l7HDoHurWtWBNjwQghuJimC7PwDa3bXVgQTvtiujb9N40r5YsIA+lizAxl+nciKztrbE6xAaSdWhWeV8qzVAZ62diM84n6IobMfhas5RZnzDNibaE4ZSiBs+w1WUB2izFs9xYPY21GlDip5GY9sTVfL6uEt/6OgZZIa2H32FhQP7vsrmWr8JT5Fq/5ejo35EJvFq25dIUwVNJ6/X4QVAGJjJvbMEMfy4AxJtnTJzFBoZ2VJxiUoHF/AS6YC/YigQ09CpY8o0SxV0plQQzDIkMks3V5HPEgH3Hxx5sag9z/PJmyGkEklBErmmbWaYFo7JUCby3e1+CfpyRLajLIFbWF8XfDeA44WoZQGjs/jTww7A1nk+uCFadgwrq34JswYAbUXaDrgx35T+mSW5cJrTQGt3S8h5walkkwQhUy6DDBQ07lz3hvQFLLt0o0UDu7OQ1h6meewDlYP9L/a5Clt3cyxX+14DqFHcfTbfHqIJsXd6exTcZs5Uv1J03cJuRLk8aXY=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(376002)(39860400002)(40470700004)(46966006)(36840700001)(26005)(8676002)(40460700003)(31696002)(70206006)(36860700001)(8936002)(70586007)(966005)(478600001)(2906002)(41300700001)(82740400003)(4326008)(82310400005)(6916009)(316002)(81166007)(356005)(186003)(54906003)(47076005)(336012)(31686004)(5660300002)(426003)(40480700001)(7416002)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 14:44:33.7145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5206a0ff-2a2c-4e9d-3903-08da584b8d0a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4504
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Jun 2022 13:21:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.202 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.202-rc1.gz
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

Linux version:	5.4.202-rc1-g1c351e730d68
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
