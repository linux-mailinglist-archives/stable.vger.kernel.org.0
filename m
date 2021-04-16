Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A02B361A1C
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 08:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237775AbhDPG4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 02:56:00 -0400
Received: from mail-eopbgr750053.outbound.protection.outlook.com ([40.107.75.53]:18626
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231193AbhDPG4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 02:56:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCcON2nkJbJyBIj/XlTBzPeUpzda/uGso5CrxMjq471AI6gC2+eeJXDEKDVRr5/9/EC9J+Ohvj57X998KANW7Mk7fksH917R3V1G/hyKzDCFA6td9ZtAZYAPDmb+AFnMh2+pJ7LLSu8htm1bMpX7cT4vhUlNyj0SQaLyw4ZsqYqOfj3r0m2X/RTY7+sHOnipiLzN49RBTIEXnpCZeuwwxXb/GIUXmeEhku/JFc116XQvn93IXrXPfrpfBIawRXLDb4qHsSa8vhBcWpDuG3B8ipm7t+4KsNNQk9swcPhxoUiQSr7VqtPxL9SOHt0br/iTZ6ORPow9ff6xo4fnYCvmmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9u/R+9fCwV6UYMJ2Q6MN/RpoFkfMaKjxceHzfGu6xaU=;
 b=NO9QgpSe40oJCGSa6sp9VJRClq5q9wBYM7yQqQ5EZFpQbBoj4ZU2K2YNEwZlpO/iSFOXcQ94POfFZDwpqCGuT1jMKO5LKX1rXYDcqiAqbkNk8jPqhkrpgv3W5Adq27T/IvSXUP08/0ZqlaSbzFeksNYkmopNhVEndE0/s/5jj5DlAK5bgu1oaR9jO6GWUFnaQIiDDuVVC5hLtsfdHo/3HWKqd1Aj9mqsHXy8ZkOq3mAvvQFwPOzlarWOnDgqZASLGk/kTOM9T0OrCX6KF4ic43MXvFlVcgDKOnzHi8Jmmc67CNodsxDtbo7P0qCtftPXw1sAyxhS6fXRa37VyMv88A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9u/R+9fCwV6UYMJ2Q6MN/RpoFkfMaKjxceHzfGu6xaU=;
 b=gWVaAu7OrvzjCwh5ISSZ1FUmnS6vx4QANSXDwxQDxsDN/IFzGDAZOYnBK/6nKN8vWwVxtgrV3XisPQZKp5rIBjeFQF6lR5+2VBolyWaTTensS2lzWVVV0pWeH5OBZ+DeIrQ2n0RmVf2aK/ExCG2Sjy65ePTGwCI2aNqgiKMWQKM=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB3141.namprd12.prod.outlook.com (2603:10b6:a03:da::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Fri, 16 Apr
 2021 06:55:34 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 06:55:33 +0000
From:   Prike Liang <Prike.Liang@amd.com>
To:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        hch@infradead.org, Chaitanya.Kulkarni@wdc.com,
        gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Alexander.Deucher@amd.com,
        Shyam-sundar.S-k@amd.com, Prike Liang <Prike.Liang@amd.com>
Subject: [PATCH v5 0/2] nvme-pci: add AMD PCIe quirk for NVMe simple suspend/resume
Date:   Fri, 16 Apr 2021 14:54:33 +0800
Message-Id: <1618556075-24589-1-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HKAPR03CA0012.apcprd03.prod.outlook.com
 (2603:1096:203:c8::17) To BYAPR12MB3238.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prike.amd.com (180.167.199.189) by HKAPR03CA0012.apcprd03.prod.outlook.com (2603:1096:203:c8::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4065.7 via Frontend Transport; Fri, 16 Apr 2021 06:55:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fe78470-6ef3-432c-02ea-08d900a4a1a0
X-MS-TrafficTypeDiagnostic: BYAPR12MB3141:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB31414380ABC9D27A95986890FB4C9@BYAPR12MB3141.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kmHaVaALv2uhItrecYDzUHA+Fgxf1FhV5weDQIVT9lWeXt2UZE3XkPgpvalvCkKYNhcpZL5UvyT7ZL0qEzfydvuJBYFJRKsXBGG1rjLbWbk9Jx78vEBTFedY7HyAamvSZasnD8PkRzB/7kMWPKRIvtj95z2fFltPBwah3Q0H9PheDi7slnuERqicTjg3+MVuANv5/PqWvktbIW3AsRJmUFHHccJs1CUOJK1KR524pgok++nYUZlmf97LViULXJfSJpOYX+jOcleJhxINWUEervT0tL2F3Y9DbSCf0APxsICgf74gR+mEOaugWHvVll0BfA1rkvqLDctLUKxfIt08nc5YgrGlXjpRSyK0BIi93P0RFW5ARhnETSS2vpIehn+aQzxVBJHhpLOYpgwhHVU9x/UR/7yxHaSmNWd+ecLY6Azlpp4tQicl9JOdzfepRvwsEcTE/detZKtO6ZnXjtJ2V84YUixo+xoPfL2o2FWYLdQZS/v/zhhXLzMb1NN/Yv4Ko9rWsCG7RvMlnB8NkU7+u4tXwdR1YJ1lhHuaPrugvYEye4PLCK9F34pnnyPEcB4BYoZmraRrkBybXTAfXQ5z1wwliozQDzOO4FVvcJsc1pJZYDWTsG6KFODgrgAsFMN7IFaulfHV7UQVuzZ2NoFeEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(16526019)(8676002)(15650500001)(186003)(83380400001)(2906002)(86362001)(38100700002)(66556008)(4326008)(26005)(5660300002)(8936002)(956004)(36756003)(52116002)(478600001)(316002)(2616005)(6486002)(4744005)(38350700002)(66476007)(66946007)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1RdErhSUtAS3VTuu5UlwiClzF4dOTxk2pG0xzqa5ryEDi98DCt7iEhuSw39c?=
 =?us-ascii?Q?ppmtIa5Ms0zaIi4ND1piHh1Jx2OatAicVokJ5jtpblB7VKN0+hXxinuRYY4l?=
 =?us-ascii?Q?a3ldC1J0dQKLyBTBC9u3CqSGIduzkcr5f6Tv4i20evbVd8eW1MiERlXmD4jU?=
 =?us-ascii?Q?OPNdTdUoRpWbOPEmc+0ZNgfB8jLtVmT9LEvwvS+Es/7eiJ982fTz++un3K8N?=
 =?us-ascii?Q?j/7mKmE0sdzqBjB7N+JkmkQynsBYHYUtBd1hHiTaavoRDWEDXnC/otvcwv7R?=
 =?us-ascii?Q?7j0f/y95eaH6cKIkUbkFbfcBnsZaNqMZSn2GtOQ/ZtgtD9SsxJ9JqdGYaZys?=
 =?us-ascii?Q?2znoFi3RgTD9fy8OVqFiZJtn5R/6ZDrHwJhMoYPFs2t2ZwS7HsppbV6Wo4wm?=
 =?us-ascii?Q?RveerYqm0F4/UqrTu3oMmtjgU9Vhvt6z7xDgozvFcgbq8yFOZ/IacB8Pgu/6?=
 =?us-ascii?Q?gy30pJFoCAF9uGYL/clCGCscRamhDYtkjhnayOeCkqbEeBOXMhrkMGHsBvPD?=
 =?us-ascii?Q?QNv6OhqxbSxLx+POQo2MA4MkwmqfxSqPIc2e3YwPw4XezwpN+Dj282CcyU1r?=
 =?us-ascii?Q?NtZIl+8GWwNGdLus/NR9Wn225HWhPo4xh0iMQyE4m6k+nMwv1z7wwYmyB26n?=
 =?us-ascii?Q?RcpRIkvUz6bhx3Hou5hTTWYmTJ9YFuupAxWP08b5rhKbmOGuuxG38+svpn2D?=
 =?us-ascii?Q?k3WCNp89/neEMue4WJz8rJTuGrmccK3pU6N8s7iOylmJBx39Rm//EykI+CHn?=
 =?us-ascii?Q?t+X1WQyHVbXEuEnuO6hMe8qVNucX4Sevb2AGgGtkVx2o5224SsYpsk3V3kHU?=
 =?us-ascii?Q?igRU4MvkS19ZfPV6BA/tKhDKtgo+oQqGM0FXuwNugAS5M9gBIp1HopKc6aNL?=
 =?us-ascii?Q?g6da47QTLGDvEZW4RH/8KuWAKOJItlp3oxlxZm8at7PCdHjcifR+YsOgfRVg?=
 =?us-ascii?Q?SQhfY0a70Q988qvDdFmL+y3UAZoXiFyBiJEOWPkMSC6TyI+KvJp1+ZZ5Ys42?=
 =?us-ascii?Q?3Migm0t7EWPdJ+10JMe+HRfsu2kjVI6XTPshL/447x4MvGeFd9w/GgiroZ1p?=
 =?us-ascii?Q?BuxeNkPokMJUFfV7p6MQmPvyRkT4M3GVIFXj8CY63R86Ys5B9FCoCsMbuTpp?=
 =?us-ascii?Q?KcinEJ9xxBeeCBI54G7TU0lMvtbJW9W4rc/U/d546CkAl2FEzsJiRG2Tet4d?=
 =?us-ascii?Q?Zyakxz5lsqiet27ikYlafK95GMcx1GyOn3bRcEAqmNyy2t/ehzrPQzd6Iwjs?=
 =?us-ascii?Q?ep19Aul8f04gJw7Cw6XQEbtoIX7gYA9ActSRuQqfJdiKtsx4AyStWK071PB8?=
 =?us-ascii?Q?kDQ+NGoaBe/Hz6pooIs+aZWk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe78470-6ef3-432c-02ea-08d900a4a1a0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 06:55:33.9208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9zEHySzUaqnfCYnp9aXva4PzLScVo9yx3So16bUprOWKrt9NWxTubMao6wV0GEjR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3141
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

