Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A03955EA5C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 18:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbiF1QyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 12:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236564AbiF1Qwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 12:52:45 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE59821E18;
        Tue, 28 Jun 2022 09:51:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+8PYzusqxYvR4l29TFgunYYIiB/h+i2+brkMiSmw+p+k2+uf8YEKTgaQp4bUqacK5WXfO6P1J6ivTYdnvlf5OOhynxHRGHX665atgukWFuE0UGaUwdfgMVd7/TLYb4VLbQEfzmW6LV4vNNmLww6zi1G3B8XqsZ3UzELgeTnWPg/EAdP6QNIFsdNnq0/lkkhU0xm57P3vIHvBF+xnZbf9WXDDYHK7lsBHTexAVSLV7wxZRzXU2b2VyLbfvBVaqRsI3RWQGS2Ok6o2rI/LXD7aJqNQ5VZuja6P2xXS34ghRwpWjhPbA1pau3ruYNKWwRq3Yv83iN8FmStIjzvHMBwCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJ72MQ+1Ex+mmjjxNHxLHh+EokjldREt+Y+HQIcwi9k=;
 b=QMEKqIE+aGnlz9POr/9CElfH1LJBIdypXrZY6ivGlQuN4DYCTo63sibzvXVvlSL88RZG20XGf4+SxEYaBrPrlTSfYCGZEKgzQzN9qeoDR2UspoU04sBjNNBZGrjjDozXjGfWKPw73N34dT+f1G3JYhWVqwSqErabY4cdNXGjeswa/PBr9/NfddkUuEL9hC7ztAYjD2LESLByoWMvITCwm+UziUTrAuOuMRm1GMXxS4B9T/IF5SWZ35DpWcayQeHGogDKH9mDbIDO1buz3xainGINfF9acQtwP4krckMqSwUNIvoMLYQpsRrHexK77KYllIYpPlNaLiM+Qxx4wQosDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJ72MQ+1Ex+mmjjxNHxLHh+EokjldREt+Y+HQIcwi9k=;
 b=IV+Jj9yNinJKCcF4SWoCyynK1iOwlJQxW02139ZTxwFE9f9h+4Gc2B0AHKKnyTAfErNtB1uOGM9BN+VtLzkdjxcTIc1S+6PwYU92eQT/C9YlQVDlZQaEjzIfYsKjVk8zs/CdxHvvNNgv/uF7niififJ0J3y66pyebEI5K/xFiOo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from PH0PR05MB8703.namprd05.prod.outlook.com (2603:10b6:510:bd::5)
 by SJ0PR05MB7675.namprd05.prod.outlook.com (2603:10b6:a03:2ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.13; Tue, 28 Jun
 2022 16:51:23 +0000
Received: from PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::dc16:cc4c:985a:89ec]) by PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::dc16:cc4c:985a:89ec%9]) with mapi id 15.20.5395.014; Tue, 28 Jun 2022
 16:51:23 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     bhelgaas@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Cc:     x86@kernel.org, hpa@zytor.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        rostedt@goodmis.org, namit@vmware.com, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, anishs@vmware.com,
        vsirnapalli@vmware.com, akaher@vmware.com, er.ajay.kaher@gmail.com
Subject: [PATCH] MMIO should have more priority then IO 
Date:   Tue, 28 Jun 2022 21:59:21 +0530
Message-Id: <1656433761-9163-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:a03:180::27) To PH0PR05MB8703.namprd05.prod.outlook.com
 (2603:10b6:510:bd::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0dd696f-0059-4f86-956d-08da59266ee8
X-MS-TrafficTypeDiagnostic: SJ0PR05MB7675:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cUx4N0SH5CyOsbvvz3MR4Fuxk2yUVwsy2mBIsJcRjA9f+n7ceNhRNsMY54tSv5jVzv8Gwk24oS/HIxr8BJe081GEjJ73VHm92/f+OMSqL1sidIT0mJadHJJ1Bp0pkxr7Q30lVUJ0+jvE6dwF4I4TNVIM0zJ3pFV5P1XwrJfDuxit7WIKYJ2f2rYt7JeZRp+2WMaH8T7VoXjMewaemcHOY9AlfF2yGCsqp/3deGkw0LK077E4Ks+XfIWgEVZaUbc4fxB1ymwEaaKCzM3ABa++vdi4KqHVYNRRiB/xzcXGqMRuqVZ0mr5rZg6753xsa0/T6O7avPPl6ETRC7Q20YJFz+IPlKIQGPWeZW8rFSAgkoVijNVuLKHeZhIh3dL8pCTld7NCdhUBFgzPDgRuPq0ib5P/rTpC6ulpHetd++CibnoOM+/Jo3BBXE8XsStycUEivf6lWnmoRR8gbOt+LyVuVeZCiawYEtzJjL5NdQWkf08IpJQc0I4zGetG1LLhKERZwO3B6MWV9LZ/jU36kuL5BrvzT0cfKeCPoUY/Ss6SWX9u19Td1v1phQDwHise5WLsGIcJbr/HvcnXyn0En1AZmCHx8evuFpgIOXupBQYdqDRzTThZqQ7Jbumu7yWQCQzUiA4m/gVS5Kwda4fNT2nRxRKal4/NvDd4Lnwt/9HkXYzdBXrF6r8AnJaObOBHnGh/n8jBD3mFE81JG4fOsloqk8GeJKwxkxsPU+6mm0x7SSyk7iwH4lOmJW5VNLctbBjSE57IQwcA9kz1FTLe+3YJxCmkai9YN/AninRBW9kslNE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR05MB8703.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(7416002)(6506007)(2906002)(66946007)(8676002)(66476007)(52116002)(4326008)(41300700001)(8936002)(26005)(478600001)(66556008)(38100700002)(38350700002)(86362001)(2616005)(5660300002)(6512007)(4743002)(186003)(36756003)(6486002)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cTZgb+36/LVmqUmGQpt4heDtxZm4u7XPJNiHoGt8Wa+jTLAnsoWyq0r7Gmer?=
 =?us-ascii?Q?kTyBqO/mzTzAvmlKRuylGuMwPnZyeFJ19Nklwpq4CI9TvLsrQUVb5tS5hFs5?=
 =?us-ascii?Q?pjR+BUxG6nKaiw8tg4rQ1kWdbLyYr6VoR4fpCU15PqDabfxVKKomMfjwBBnC?=
 =?us-ascii?Q?zP/hgVAdGEQcWb5B0YmzAZBH3gDZ6nzbkJuzP/GzV+MHLVBpr7b6k9A5OadV?=
 =?us-ascii?Q?gzQsubkuvvykydsqOpodM8sDGVafsDoegErolTvMYgFeRcaGfCJWvHogQ3Kw?=
 =?us-ascii?Q?RTo3DvGxnV7g59z46Nn7XaAuzseKQSMjfWxyv1+k7KTTSpLVFtXxuOE3U3Wm?=
 =?us-ascii?Q?wlthN7fcbrkW+e5zF5mr7oCfkHwuyrOmpFA3D9O9aQWXU8PTXKGyYkfPdckR?=
 =?us-ascii?Q?vqsFw4KNKJ5YGF9x2VNZsQyg0NYvD9Qj/O0bKkgUXo/dZEuffjt9vIWTA9D+?=
 =?us-ascii?Q?QWmyi/Ly7lmELmPAiJAZG57AZjylkRf55v3WvLCAr7dSof66EFRemSb9LCEK?=
 =?us-ascii?Q?9UhMtv3jR6zR7ev3D2l3t+g39+VUhAkei3NEMhEbg2a4pVJfO/Tn4lvD/put?=
 =?us-ascii?Q?Jxc5+qN5g1t2nkkhCHZaxube5ScU0/Wto7yGNCeSqQJM/oXh2TqqsJ0aJ2Om?=
 =?us-ascii?Q?jwZfeA4xsloWBH8i7Fhhly033Dc85qco67KTotX+3CsQAszCWKVL1GCLZeG5?=
 =?us-ascii?Q?kJisPiTNgalpJ4XYrse5u0fBJVSpsCZFY+hVQtP1H0eCuBWXRLKhOUaFey2m?=
 =?us-ascii?Q?yuGfDfF4Lx7se3mwXDDaFV8+BRSJf0t6dTKE16/fOPujo1mHdu2CtjLdNToI?=
 =?us-ascii?Q?PhJlu0LrOyzZ6IydHCBShMeIyq5+ID6o6FivV8n+YgVaCIKBMEAmoDhpxxia?=
 =?us-ascii?Q?iCsaQPnkRmGz8Mp8UJJUDnXGW8Z/hv2Mqpdo1nZZt0PUNynfsRzHjQrrlFD9?=
 =?us-ascii?Q?0Nsn0SdRoJdMcAKILPnmJMpOQO7r1rFN0VhjEbyKRueWhg0FSPsCJxfeokeQ?=
 =?us-ascii?Q?GdKAHBA1yq9T4021QC5TqSbkpSBDg7t0h9rk9OzWiEUkHKHizk3Ksjs49z4w?=
 =?us-ascii?Q?cNbD8s70QCrtg8bMD9dYC1/qP/cJWEVdy1JOw0US41Vp7UnSWH/pGEsfUcoj?=
 =?us-ascii?Q?6LSr6tIwZbFRe8P0Ba1YmD3V2fGq/VgAe/NbqOk6Qx/VZzhjQlL2nBtRnheI?=
 =?us-ascii?Q?FSiYhSQnL9dTdcwnxpLn0QC5Np6Oge3BcJmlDxhmva4OkwzQaSCxMDXvaHMS?=
 =?us-ascii?Q?aR0PpT7gIg3F2XBCMVusy2ywkyn/yvbO0IJSbPuKix2WvctCOLKGo4ffup+K?=
 =?us-ascii?Q?Km4QvR/Ougyrz3HagQeh7wwzW4oeuQxc8/dWsV+u/4fSahVuOytD+F1duunZ?=
 =?us-ascii?Q?9nvyN8Uad5Zc33pxYtCh86CXuFgpvTGpBFUC6JpDhLgBQIhJExns/eVx+6le?=
 =?us-ascii?Q?7X5KXdqaCmEGYRZ/S6DVwRIyj1vwX/+HLaZYCbs7NGlNdFiRO0TWB7UZ4/G8?=
 =?us-ascii?Q?FmLR7H+3zYl6IEtNfivtDxVvdTSTjDbxeaY2mcymAZgNmy3C1/I8CTqIjO2r?=
 =?us-ascii?Q?E/AQSXC8OuPS8g8WU7v9Y7T+NL7bIB6fsbJivEdR?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0dd696f-0059-4f86-956d-08da59266ee8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR05MB8703.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 16:51:23.2274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RxEHav1X3wJHjgFkfaK5V5CXAFBzgWiwags7j5CMvXd1AgEMZJf4CuIqdzceMQdyFmbStOpDs2jj2zjIV3h25g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7675
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Port IO instructions (PIO) are less efficient than MMIO (memory
mapped I/O). They require twice as many PCI accesses and PIO
instructions are serializing. As a result, MMIO should be preferred
when possible over PIO.

Bare metal test result
1 million reads using raw_pci_read() took:
PIO: 0.433153 Sec.
MMIO: 0.268792 Sec.

Virtual Machine test result
1 hundred thousand reads using raw_pci_read() took:
PIO: 12.809 Sec.
MMIO: took 8.517 Sec.

Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 arch/x86/pci/common.c          |  8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 3507f456f..0b3383d9c 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -40,20 +40,20 @@ const struct pci_raw_ops *__read_mostly raw_pci_ext_ops;
 int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 *val)
 {
+	if (raw_pci_ext_ops)
+		return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
 	if (domain == 0 && reg < 256 && raw_pci_ops)
 		return raw_pci_ops->read(domain, bus, devfn, reg, len, val);
-	if (raw_pci_ext_ops)
-		return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
 	return -EINVAL;
 }
 
 int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 val)
 {
+	if (raw_pci_ext_ops)
+		return raw_pci_ext_ops->write(domain, bus, devfn, reg, len, val);
 	if (domain == 0 && reg < 256 && raw_pci_ops)
 		return raw_pci_ops->write(domain, bus, devfn, reg, len, val);
-	if (raw_pci_ext_ops)
-		return raw_pci_ext_ops->write(domain, bus, devfn, reg, len, val);
 	return -EINVAL;
 }
 
-- 
2.30.0

