Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2D0450B9B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237744AbhKORZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:25:52 -0500
Received: from mail-dm6nam10on2084.outbound.protection.outlook.com ([40.107.93.84]:63072
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237533AbhKORXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:23:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhPD3fxPHC3bw6FSvda4FnEuyrci6lZQglSfiUgk+cWO188bB6wezBPNC1nxeE6u1khDEZ3MKpLd8MfFzGR0+c2lAawiCrg1eLCqxFmLEQgYUFcygQ+IqcgSHsDcsydRVftyRI6A9sxp5HNDgPAjrGtipBoUl0C/oT0dCMfud4QO49kaPjPY1SjblNHB+SFDP9dk4UthMvPqnZoI6ncXRrrZGs8MBOPLmKy46LsnmO4v05xNgu9l+b+OhPOw9avgi13bYRZSLNzSrBIdr8D4Tw5CeINb+zwCJGEOuCHJ8nsK4RXzMJSfUssc6Y1RQQCIfKDvm3fMSqyN5G7Nj/QF2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZjHoE0YySksPnl8DdDhwfErlU6163SOhp+ZXwGIMBvE=;
 b=UEOMWsovUhU2gDO03xBqUEcni1RK/S56TUQPq+p6VPiQcAzCXtDvykYNFZID50w//6FuCmRbOXDnEqkFRxyZldbwyokQJAhAFpeOZuoMB7GnODM3vcAT6Sq2u4ufHXdldzJmgbyc/LzVAPWp+lKVjOaCkgHN5t2uRpZLJBb3Dcdo8zlTaH7GiZuFZLB3c1HVQt2eQOWqJNIKq8H0D8uQZORQKVOxv6k8twydURk2Jp+PT6JInBKyMB92n2sRejXYwE3iw6AFP2uoYf9UdgGTNdbrVhG1QyaO1gbqnUykgCIJYc5IeOw6OTehNBLFEeP12l5syX1DlnfVTRsm4pHmXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjHoE0YySksPnl8DdDhwfErlU6163SOhp+ZXwGIMBvE=;
 b=nQtNj23+NyR164yiJhVgtZUjbSR19Erv52p9KloW8/PqHXk0pOcGODJMSn9Yn14DoGDoWykVysP2lOIxiGtizVbdztmqejaieQaDKzhIi8U3Kmu2xRlEIy0E/Z3fOt+nVPCgRJXpX3Mt0rxP5IM/bM2aoNoISgdSDzj1WTfuMQGWfvf9Lm5DuDOZm3RvMopYrg4JNZ303N7c6HQ54HWUiQwjfVtJv+hFtOdM14EdE8z+EhpGpJCEp3gDmAZJgSHg0eelb3OtlygEsLtEJy9rwQdtwgJHJx5k0TAsW/9Ap0gg/lr++0LystV1HHZyLgX1Qp+/M+mdtWD7CoJI6HMu+g==
Received: from BN8PR04CA0017.namprd04.prod.outlook.com (2603:10b6:408:70::30)
 by BL0PR12MB2404.namprd12.prod.outlook.com (2603:10b6:207:4c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Mon, 15 Nov
 2021 17:20:11 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::22) by BN8PR04CA0017.outlook.office365.com
 (2603:10b6:408:70::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.17 via Frontend
 Transport; Mon, 15 Nov 2021 17:20:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 17:20:09 +0000
Received: from [10.21.26.179] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 15 Nov
 2021 17:20:06 +0000
Subject: Re: [PATCH 5.4 043/355] reset: tegra-bpmp: Handle errors in BPMP
 response
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
References: <20211115165313.549179499@linuxfoundation.org>
 <20211115165314.943849440@linuxfoundation.org>
From:   Mikko Perttunen <mperttunen@nvidia.com>
Message-ID: <94e5add7-9e65-cbfb-46b5-b6eee6514247@nvidia.com>
Date:   Mon, 15 Nov 2021 19:19:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211115165314.943849440@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b48b30b2-1668-4770-5a9b-08d9a85c2d3a
X-MS-TrafficTypeDiagnostic: BL0PR12MB2404:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2404AC255F2A09CD70803CE1B2989@BL0PR12MB2404.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IWG4DXawQQGn2FmCEj+EFKqRoEWzX/IwOUrV2RW4G16oWvcEoxdNpfUks6I0+rBPKkHFYtbLfWyPD2hZV9R1RyqC8egTKfKuPWBkwBHz4+xl4NaqWu6FaUmBJJctakHAJlenbuizQLQLuJJYYroA5kqTJAYiKkTbJ8tDnLkTM3GWh+Mjj4MywfLxJmeJcbkkgloeZWeM6mPPuwixR5LnxvZFx3sr/Ix8PAvjBN60PBb6XpEWhBI6WXYNEy1iBBkxy8oQU64+ylHkumwaY/wGGerpdlUNk/Z+yEQtZ+OZdnLogWtfGw5DQ8aq4zSrLsMAWDmsV2O3E6kG2biU3LunVRfa0NSJX/0q9+mptwkEyuxtOmmSFjqsDByPKXMsAzZgiIHd2fUIJgEKqE9I8RVzCE4ovsU5m04uwz6gkHNHI6PWPWv/2S6huEx9IZd2fkJagFjsH/fIVi0BYRTZpnkPpoQkRcQHWmk5sVPssXhuZx8rIE2TcAW+ebVC4Ib94bfIISk8MxNdhLLQThHL0Yomz+HCuY/v9L7AuLLvwKRFY+i/hKZU7u9KIHtUqBQ7d5HehhatN3iINJQST5Shtgd2wozDEr9dQHaTHuwnkz0TfcEZEG7DfLXLD0lrJDdQFpS1vFkGLljnU/81QHxA68stteFKVAfbqjuVNnEOR9/mY8/oXRxrcJ+eBqF5g87x2jGXHVcXvWqnK3cv1rARnqp59sweMP5qPG1pemHOT46e9TeopjYDquZjlt4uEr4D5GxNDtK8TmqcMaChtTSsCruz29Py2ocbltVGydge34+5dsVK45RCfaFuMwniK+YS4BJY
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36756003)(966005)(2906002)(8676002)(6666004)(8936002)(86362001)(31686004)(54906003)(36906005)(70206006)(31696002)(5660300002)(316002)(336012)(70586007)(16576012)(356005)(47076005)(4326008)(508600001)(16526019)(186003)(82310400003)(4744005)(426003)(36860700001)(2616005)(26005)(83380400001)(110136005)(7636003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 17:20:09.7223
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b48b30b2-1668-4770-5a9b-08d9a85c2d3a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2404
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.11.2021 18.59, Greg Kroah-Hartman wrote:
> From: Mikko Perttunen <mperttunen@nvidia.com>
> 
> [ Upstream commit c045ceb5a145d2a9a4bf33cbc55185ddf99f60ab ]
> 
> The return value from tegra_bpmp_transfer indicates the success or
> failure of the IPC transaction with BPMP. If the transaction
> succeeded, we also need to check the actual command's result code.
> Add code to do this.
> 
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> Link: https://lore.kernel.org/r/20210915085517.1669675-2-mperttunen@nvidia.com
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> ...
Can we drop this patch from all stable trees. A revert has been 
submitted by Jon Hunter -- the reason is that the tegra-hda driver has a 
(harmless) bug that was previously masked, but with this patch causes 
the driver to fail to probe.

Thanks,
Mikko
