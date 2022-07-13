Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFEB572EEA
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 09:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiGMHRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 03:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234682AbiGMHRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 03:17:12 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B707C67CBB;
        Wed, 13 Jul 2022 00:17:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSBWPff+u8dUm1sH2eyqfxuATdAgx2ofUh2l4YCyUFPlbHced2mp67wzBm+GfadXsHYRZoclBkDgvEJ3Gx2STNZVEG24ZFrrV8oB/D1pG7eDesIKICGKwCEcUye3B4RFicWs+k66dWSlkb+LcWc2JdmcAs8m61MA9fPPiVyZMw4XiV6MwRLXTpK7SApzDASeo3aVY9I14O6DVC33GUzb+d30POQolZq2tX5H/eO0t6CCxv1Sf7LvaEso5oMebnNlTN6oT161OPTMx2yKvXb91r6uy3EDSgHUh4ipR+19TnzuJm9jxu072UxKEaEn1wGNV9kUGuiCIfAaveaOq5I71w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BcHyi4LUhzzXfXjWZIqVMdp6vHul5L2Mo56YboBUsqI=;
 b=dU1bJRIvKIEpVK2vL90pHa/MzFHqF56sn4yI980XERxcAUgz6JFsnGOttfP/aD/l7mCduJoK7h5rsj1vwXgvMYE4wohtY+psh1FqTv8zmcNdSPPgtoMGxoaii6X0uNnrhwbMphpuLgl9hq0zUIFADkS+/KODoui3wAyazP8FuuD17D56TyNjkF298k6WzSedoGew41y7G1Flkba0zFQMjryyOLE3q8MxzhFm9eI5BxLRrrgSFSXlhLwtj7gprnTwzFrCWRtLsM++xJCa2xBJQYHkfYTKG/SW6fVrORqFfkx9faZVxNIk0Bcp0EieXMmO4RdvymDECDOR79UdPVq4Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcHyi4LUhzzXfXjWZIqVMdp6vHul5L2Mo56YboBUsqI=;
 b=r3RJZ5TwNvBJQ3taOJdR73ArkINOag8XTC1R3eiAS+uhgbigbnPp48G/qrAP5rMkMjRuebH8eUHyl2+IOIXwSYNb4EXpdX5hQPsNRPYDucauRA47wPg6TH6aaFwx12Wt4k6kOE7axZXHuOSfwVoUyrHBAB92qsSeu5cK43CEYiMqOnfnDDl+Mu95nt6yWfZrb6KqBwgIP0dYi9NEWrW9eEI4ONRUv/Q44TW6+mMksTtUCuU0SLgEvA0zqSzQDKOjG6BycRpjIWhIPq5/OMxVgXisXYPjKbBrVe2j7k/fiXRo+JP+jIpaIbMEpp8WvZeDOK3eK6X4nX5PwBwlYcQi2Q==
Received: from MW2PR2101CA0027.namprd21.prod.outlook.com (2603:10b6:302:1::40)
 by MWHPR12MB1711.namprd12.prod.outlook.com (2603:10b6:300:10a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Wed, 13 Jul
 2022 07:17:10 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::31) by MW2PR2101CA0027.outlook.office365.com
 (2603:10b6:302:1::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.6 via Frontend
 Transport; Wed, 13 Jul 2022 07:17:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Wed, 13 Jul 2022 07:17:10 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Jul
 2022 07:17:09 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 13 Jul
 2022 00:17:08 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 13 Jul 2022 00:17:08 -0700
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
Subject: Re: [PATCH 5.10 000/130] 5.10.131-rc1 review
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a38f6609-308d-4508-8d28-17c41e45df29@rnnvmail205.nvidia.com>
Date:   Wed, 13 Jul 2022 00:17:08 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7406989f-5fcc-459a-c756-08da649fb395
X-MS-TrafficTypeDiagnostic: MWHPR12MB1711:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FnXV2fhOxuNkmHJ3lUayJy7i+B/u6r47+1m+eYT3y1tCcXVpVvrgcHVNIrC+GbwxgF5J9OYwAoOrEC/YXOTF+BYqQ1FycAffapHFMrJ3tR2u3MVIg+/yVWhEUjSVmjLofhXHgzC1U8l9v+qvxhHyTw2CS6SbZPTH4Fr0hrK/hWaGNEKcF7NEgZhFSB5fGKqItCXJnJhW928O+7OcwtrjzUJpo5p8+5tiM4nwnjcJXsG4QyK0G9I7XdclYVst9I4zop5N1Ez8xymRnQ14SeKA2daNElbMxUvYVm5QZNsCRr2YFdtKFjNNC4zeylR6Y8yiKRfowj+7Fm51buKnOZAFOLngAXa/B96+5dhgCuOgfZ4WglQT6eX+z9aLKWCI7G5fdRahq57nkyPPhqeYnAC8B0OHZt/SDym51TaxfxeOLyd6SFtKk9FNVkW3s8qF5mXvz9k+XGLyJDwE+OL9UC56nH6R92JdFrUfmv1dRnD10N7E05njtHp7nogVt8F3KkE5md+/eHKYQi7ZMnqWqFXd7ZZF6lLXmFgvJOpTmP9dIzMYTf3aeHzCnp7wafzsmUNavaoaAXC1QxlsbeS+3EJYTanMaENY2MltSR6er6q0JueB4Qq2HDN6qCpP73C/3dUAXseqRJ0HWAfGZa2pLKWN+CmikC1lbG2SsQDz/Kqnp2K8ZAYicmgdvvwjhN+e0C3++9S4qtFZJqyV2Q6N4Wl2SkB/ILuRwvQrAXVcPsphy2Do4ycwWS9qxWkbkmjglVXunqdhZWupB73kvkzqpoNvgy1gEWQoFdcnNlOFuPJyP+OfvoOklb+qvf75/rv2CcnPR6VpR2UYSM8UTYpCcSN1dLgOnkvNCySEmPxpjL9DTNBbzbm/7svXTdpQXMfZnk/e05bwy2AjUSfVuPN3ytL7tRY7u706lFfL3CCiRmAWLYyU3bdufv2hVnHWSiMEAgkS
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(376002)(136003)(39860400002)(40470700004)(36840700001)(46966006)(7416002)(81166007)(40480700001)(5660300002)(8936002)(40460700003)(36860700001)(82310400005)(356005)(8676002)(426003)(41300700001)(2906002)(966005)(478600001)(47076005)(336012)(82740400003)(186003)(70206006)(4326008)(54906003)(70586007)(316002)(31686004)(86362001)(31696002)(26005)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 07:17:10.1080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7406989f-5fcc-459a-c756-08da649fb395
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1711
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Jul 2022 20:37:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.131 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.131-rc1.gz
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

Linux version:	5.10.131-rc1-g53b881e19526
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
