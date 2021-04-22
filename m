Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B21F3676B8
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 03:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbhDVBT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 21:19:57 -0400
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:19360
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234970AbhDVBT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 21:19:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOzfasYmEpuxk/kfvKAY6kC+hMiojRdM7svNrfOwMTiZuVLiRKqWHM1q9TtaaoPNLjLP5WjuZlSh+t27QCBeyBh5pf+53Ynod/4TX04KQZ9Okq7kdU7p0BUO1CblpkJnuB/t96+e37cr3SzPKu6cypsvW9I2BjiQ7iVAFWqFqY6XyywmxOUrA27mdF7O34Xhf1P49RNk5z8YMeUEtnhiHp4FgsZSz0njna5VvCwGtd4F5VEGHpmDXAT7OXSBs2qe3Bqzk0+di86Fx5ShkBc92MBuQHPF3YcaGqc6KPHXecFftg7NTR4WJ2D7ecoImikYRU+PLYWf4+wysMRd43vhZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9u/R+9fCwV6UYMJ2Q6MN/RpoFkfMaKjxceHzfGu6xaU=;
 b=QMmiMIMTUaIQuFgox+5NUKzc/H5J5b6lZn+Jqj58xVZsI102stCuXs9aphKQN7Scnfo5VU2Pk5rh3hYvlGljjYpKO98C+5i9TPawBTEd8ZEchABR9ED86mH/c3wv9J157q2EqP8Y+atiIkylJmXcuFkxxwenokcbmhlKck68kimS2zNF2Giws/bTBXjpg9i6XP1ocJUF612BZgjyxVf2E235+1cvtAipzr+23yvfvgeoSFtuztZGZi9+8706PRpauMQb+PlxnxFRkt7zRdLgrvWbLD6YMHlMdn4PMB20MRnCdQTdLqm2oFU29aFjY4f4UxA/X2i2eTDYPTLjW0JL+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9u/R+9fCwV6UYMJ2Q6MN/RpoFkfMaKjxceHzfGu6xaU=;
 b=F+VLf2YNLYLrU5p/GnGS3dc5PMWkdblFES98iT4s5SakkHDgtTPVS9OlJOnOlhhz1QcvZXBl3fJ4OGV/Lt77njOEDsA08C5k0HPw7To3PN3HK4K3flzfv0IM4/nIHmkJeUDPwQ9lU8sUwfJW2qX/kEcxqk4wKCgXzw32Zu/w4ZM=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BY5PR12MB3713.namprd12.prod.outlook.com (2603:10b6:a03:1a6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 01:19:21 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 01:19:21 +0000
From:   Prike Liang <Prike.Liang@amd.com>
To:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        hch@infradead.org, Chaitanya.Kulkarni@wdc.com,
        gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Alexander.Deucher@amd.com,
        Shyam-sundar.S-k@amd.com, Prike Liang <Prike.Liang@amd.com>
Subject: [PATCH v5 0/2] nvme-pci: add AMD PCIe quirk for NVMe simple suspend/resume
Date:   Thu, 22 Apr 2021 09:19:04 +0800
Message-Id: <1619054346-4566-1-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HKAPR03CA0020.apcprd03.prod.outlook.com
 (2603:1096:203:c9::7) To BYAPR12MB3238.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prike.amd.com (180.167.199.189) by HKAPR03CA0020.apcprd03.prod.outlook.com (2603:1096:203:c9::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4087.16 via Frontend Transport; Thu, 22 Apr 2021 01:19:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b97c963c-fcfa-40bf-7dc0-08d9052ca82e
X-MS-TrafficTypeDiagnostic: BY5PR12MB3713:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB37136C2FF35428696A927500FB469@BY5PR12MB3713.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YFAJLVEl9cgNbmR+IyLjpmqfDStWJP8eGXmJkqmdUus8HMVYuLw38q7wGTSW1BjQeKOiOXK299pKj10Q0o3wLG6wAK6HNJc7JSCv76Pp3CUbIkVID5Sh71+mh88RiGxfzPhXDsHk9tVtWIsMQD9HvSsyQdekI6ZeJSVyZlhLgfyS31RMCM/eRkVQQw4b7RroZkgR9/I3KpEYvOGb0fvpN67TpIopX8ZIs0M/3W+XA1uII4X9N4gCTWjOTaV/osoYq3KpBJz3P1Mz8kFLbE1kiJTfzYIj4JX4o/L+NraeSEWblP80jyPT/affvvZ13q4Kna/fAVxU4o5LsgWN6m6YTFaP4vvRiRD6aoKj+/0ia7AHXYU4qOvOtr99+4AxUwJUK8E6ij5D4wWjcLym+mmL9GBv/kNJ6ZIuJHsGNZVBJfNcrF/6AlJwbtEE4BjKDXee3IBTpBexEdXXlmeNgML4iyPHL5qyvOWGf38UbShn/N6+hRQCAGxBqKdXYqwt/XOMqKanyLVOVQ/kCPreZF383/bUWINh4hJc6gcJQOoCZ/E8EiER5bbWEX9daBWsX09yLcZc4rhY6IXzQ9bbkjfcPoQ7ZWHZU2sck79QGxeKOQ5RxLvc4B/8NPPFnDjc28wkW4FH7m+aJ/8PRYSNAAmoXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(83380400001)(4326008)(8676002)(478600001)(316002)(66946007)(4744005)(8936002)(2906002)(36756003)(86362001)(38100700002)(16526019)(15650500001)(186003)(2616005)(5660300002)(956004)(38350700002)(26005)(6486002)(52116002)(7696005)(6666004)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NMO+O4ARpZ51AW1HDCuPVRyrB3+pF2/apF2/J+eoCDYtyLJGHpLtY/BxOYOx?=
 =?us-ascii?Q?uyHY9uZQXA7Flwj63DDxj2K/7CFEO3wfWX3P1yxij6s6y+naU30o4k23faHP?=
 =?us-ascii?Q?5dTJNMvxLwSosQ2mSwqn7cqlI3Xk0wSOyOneu1jfM/mJV99rIGAjYLv3XbLa?=
 =?us-ascii?Q?5FsBnBKbzws4kdVZZ2NKKTLTdLcvglq64TrYnnCK4ZTD2NhC+rQu1PvmpfR+?=
 =?us-ascii?Q?qZ+DhEDfUvvBVSLM8bxTbXPAnFvPqe21qkdeaDD6oP/yTKoP4q/ZRzGMs5/4?=
 =?us-ascii?Q?CLfyprqQBN4xMsPGIzstxM89kfT6x5Ldj46VY0zY5h17C/YVxw9jsDWmy6Sg?=
 =?us-ascii?Q?NM+HQnReqDkyp/aNPfFi4iZsVDLCM57fg1Sgdm32GU/1X676ggVqyfu5S/8D?=
 =?us-ascii?Q?9xe7xtnoWM/n/hvasV4yp4gWXNcTDQi9vHYfK3FKE3bwH4SR0bGVFLVs7lVh?=
 =?us-ascii?Q?s2bok+9aP0GrQzxUO5vRcLQmbjJ/JXjqMblxHYUTimissjrqUMRnQOmfmzhH?=
 =?us-ascii?Q?jlm2TT4z1DEo4fjiF6+Bjz67KvS6y6ocLYWhsDzuBtXJKwL+WFttB4tDUc+M?=
 =?us-ascii?Q?SI3o+jE31Sp+3q2Y1CJpsVJjo5mpf2AY//4QwLw70JxFGGN+8VcdylwJ054J?=
 =?us-ascii?Q?PFZcY7CN30wibqWQjQaxUs8rDccJkPjuAWPzofsM5xKTO4/Qg2w9W8kmUrSh?=
 =?us-ascii?Q?l2GdfJsAzx9XbrhxwbrSZi3EQS1wbAMb8AZgtN9YJXE3IGZ8EGt8MinrszER?=
 =?us-ascii?Q?oYLi/DrHgoqls3gYEL3zINJRtASaeFZ7Z0aOyN8vew9D7r6HKwvKtJVJfLDp?=
 =?us-ascii?Q?aG9FRlcBJxqxh+fQRYtG4/Puu/0XGKGcQ5qmGypg2B3Z1BPzkLNEbI8gbsie?=
 =?us-ascii?Q?8Ji7rzMbDZblmyi32rCz8T2fsrl/IqkbWlBIFQY966bqapcF8zlOaekp86TJ?=
 =?us-ascii?Q?elA0BqVF7vmVx8Ba0ftf5SPybOrpWnAdDveg6zZe2UHw6uUIJYikNl6eQsoN?=
 =?us-ascii?Q?YnwzAupsOANjP4mG+mPmsbT5M3YZLtHQS3Ecd6y8x/mS5XKxAD7ErMZnTebR?=
 =?us-ascii?Q?8HxL3ZbKGXo+3SYJuWldwJvQx+dgAd+tkc3L6M2dEoJGAXfQ8o4Y2zkTCUHU?=
 =?us-ascii?Q?Rs1dhDwBBc28wSbOxIE/0g70tVPWeqARVZZxMoYDPZdQmLTYCCswgWLEjPzG?=
 =?us-ascii?Q?QjgIlmS+5cOmEcRvbsHUOtRShCHRYLbbJBOT25qybRF4oGN+5ygn4OVMkVL9?=
 =?us-ascii?Q?NCzmzAscs4fvNnERfw7szLOHgAbPMjDGu2nSFwGKktuzncuPmtfpFv2S/w7G?=
 =?us-ascii?Q?YLqL0SgIYWjsLDWrQA2PUiqc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b97c963c-fcfa-40bf-7dc0-08d9052ca82e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 01:19:21.1792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w5b5dWn0LGYVv7KedGAGErqSpWpSp3Y3nqfAGK/FZq1AL0SUa4soCMjL4dfO2WzU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3713
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Those patch series can handle NVMe can't suspend to D3 during s2idle
entry on some AMD platform. In this case, can be settld by assigning and
passing a PCIe bus flag to the armed device which need NVMe shutdown opt
in s2idle suspend and then use PCIe power setting to put the NVMe device
to D3.

Prike Liang (2):
  PCI: add AMD PCIe quirk for nvme shutdown opt
  nvme-pci: add AMD PCIe quirk for simple suspend/resume

 drivers/nvme/host/pci.c | 2 ++
 drivers/pci/probe.c     | 5 ++++-
 drivers/pci/quirks.c    | 7 +++++++
 include/linux/pci.h     | 2 ++
 4 files changed, 15 insertions(+), 1 deletion(-)

-- 
2.7.4

