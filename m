Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65A655D3CC
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237493AbiF0Ool (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 10:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236155AbiF0Ook (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 10:44:40 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15911DEF4;
        Mon, 27 Jun 2022 07:44:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fw1vHyg2oEQn8HaaMsFw7P6aGi+eDl3DI9ZE8/um9WRC7aJAf/PmdYqiQanAOKIyJhORN4ctnMGAlflvzej+t5ibjjq5hbJlvJ96lr9aBSlfaSrR6BJRrqI76ZlTullJSQg6Tw7NsdB1rrcGEI4PAoOgbVZYGhXKDZOc30ioxkCHxup4ADkwi6S+VEiANJPbiVHmL071fbL7eNjND+EBdSwb6vYbe9QMqtw5tBG6YcAcOyVh8dlBY5lvpQvrJQevrJctzw3OPKv9B0jV5KWsKrzOxqUi51M1F44xQzHrV9DkDPV4iCxseLrE/FqgK4dHLY3J9nY87wyc6rxAQTo4YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vp8JrFZVIBkv/jhOf3qYEhBiI+ZsBxgR32ip8VN/G6E=;
 b=BogAsWwiJhwfjk8598yE+ydg2rqFDCVhywHsujiTd3LekZvI2dioORcNdgQSTylK86AKepTCKs7gnj0jXp/zTsM0aQ8NKuH2zvJd6A8VBhR2qEPHvxAYKHlW8UGlmZqMHOlwhXFQyn4nBuEHT7Ok2uJebqk9H7TP09YNB6t67ITGEJFP8zX16ahD5f+VfajPhu+WtYhwBRSjL6+s1fKBytevXAlibcxsH8g6QZzWUXAcYM6EmKWbOAqefq6sF26q5xlaMVzw8BKwsYx86n3KpH+Y+eT9MGxkxICs5c0G34+lrytW7n+L8lca+iRw2XNRhUtJzLfGtkjLGgKkoTeslA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vp8JrFZVIBkv/jhOf3qYEhBiI+ZsBxgR32ip8VN/G6E=;
 b=jrx41fELHnrZ5yYJnnvhWF01IVwSOcYETHV5xDHBa1JJUt7LQMvOkGkhWjgCWmBUNzLGrs5vvaN6mEFr+CSYb9E25pfP24cEI+sgbKNvWLzzZTTN5+lWwv2UnSgFnYcim10QLPN6JvtBpFtKDQ2LOmTvRrbYVnKFE/VDrGzxzPPhqmVfFGc9DVscEDs0WRi8762q4I+YaTHLab7UsGEpvJ5OZOCn1BXbllVJWtkDxg6lioLJgr+S9BjZlZWvGc9Qui4B9XBY2ojxav493009u5BvCokypcy5AE+liMnLlsVVPvBxHQlNuQOosnm3bDzdBRBOInjFxWpDoSVC+U8Jvg==
Received: from MWHPR22CA0069.namprd22.prod.outlook.com (2603:10b6:300:12a::31)
 by BYAPR12MB2646.namprd12.prod.outlook.com (2603:10b6:a03:65::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Mon, 27 Jun
 2022 14:44:38 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12a:cafe::6d) by MWHPR22CA0069.outlook.office365.com
 (2603:10b6:300:12a::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.21 via Frontend
 Transport; Mon, 27 Jun 2022 14:44:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Mon, 27 Jun 2022 14:44:38 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 27 Jun
 2022 14:44:37 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 27 Jun
 2022 07:44:37 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Mon, 27 Jun 2022 07:44:36 -0700
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
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0555a633-e453-4347-999d-b3c2472cb3bb@rnnvmail205.nvidia.com>
Date:   Mon, 27 Jun 2022 07:44:36 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e589983-7829-4e27-4e5f-08da584b8fc5
X-MS-TrafficTypeDiagnostic: BYAPR12MB2646:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CB32BK7mjLJANX/an1eT/UkjCq+gKFNdpIxqrMqCoTWfoaSEuYJdXenZTN7GfN/0Enrb0nU23fCfoDbrOjTklwYmB1QdRc7zhynJvXXepGA2sny1/zqXbgf142PxF/2P9zZxebQXKsSgm0KumIOt2hXRfV0TpyAUMoCPptzaW6SxS5CNEdb1iUcBI9edsGC81tQuEsaq6ecefleojzmHP9A6Y00qSdAc3ieTMwYzkwNqHdqYM7H0OEiJBAUH8cTjELkASnucCkTji0pJX9h7cP6ZCrrWNQsehZhVXjzilMXDa7r1euaLLOb6pK+D4vlGB0StkoM1jCJVxlAG8cVNDsSJBqj+1mri5WqfjpyuLlwt++JqEfonMWfq+6zsus4IgZVXfsydSW2oGS4KSPcSTjmeCUpbqV3or19o4YveTCvXYMQDCsqgHb1gB86Painwv6L//Hv6nPXYnvr+YfDvDK8HcHpMniGmjzm5e74xcmvcMesEqO/qHJpft5T5HuQN3F9HR6n69UHUzsvHPks2ApT7EZaYCzT8kuFYAiLbUJfq0wGmg8sHa297prD66sHItyoLhj4fQ7thV1EJtR3GbHAF94ebFP4TO63oTGZpYyHNMqip7HEusOoz9aqZEvMHFC6PwvBbryOv4kBzsRT3YtHwLsy3up03lMcM98xbJROVKgNJ3djZ8HV4VQEElVGRMHO6y+Z3xStxd6T4+p51O+f2yPF9we9A7H2KeUkapTZqKaKmCk2WIVSimZbQwfP8NIPChQ//ABeTgXR5B0CQuhButqaWu+svmpRFFDwwXmLiIerFiENilhk1VQiSeGJskgtkXHqxJoX6FQtN3FnFYhKBaxoQDjBu6AqZUAil+TfNJLY5FajNeJEAGqKzFHbZwsC9m6N6YmzbPPrdJ33z9g0dmly9amXW20I7gybxiH4=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(396003)(40470700004)(46966006)(36840700001)(186003)(82310400005)(6916009)(8936002)(356005)(81166007)(31686004)(316002)(40480700001)(5660300002)(47076005)(54906003)(336012)(7416002)(426003)(70206006)(26005)(478600001)(31696002)(70586007)(86362001)(36860700001)(8676002)(4326008)(82740400003)(966005)(2906002)(41300700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 14:44:38.2960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e589983-7829-4e27-4e5f-08da584b8fc5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2646
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Jun 2022 13:19:33 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.8 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.18.8-rc1-g188f58194f3c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
