Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43ACE47B367
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 20:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhLTTFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 14:05:45 -0500
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com ([104.47.66.43]:16596
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231630AbhLTTFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 14:05:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/IrUR9lX2TNgT7tCvFQi+u8wgzKHjESJw4q4o7cZ80pjsgigjf+9CSY9ccMkZcR420UQ3Muz2Rzdf+Xeh/tAyTgAavmzkhGpCes7Ye89xA8CGuK2D5C1esRS2PygjrueSIRua9arGL+zyorm902qiuaSMB6/ESOG6ahrKAuc0OoMkcuwuFSA1rAINzWs8/4tqGdqBwjFIVaI6E8uJBuIYh0roVjc/5Z7Ks4gzQQZZNcaL6dwedTH+MgMUqF4uFIKDS7kowBGd0eVqBH6NX393rUUOo2zL0Nbc+2zdx5GtWQOFLoccxItFzr240jtaigYQ85rpLdj5sUQDccrCXAJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+9WZjy5F7PusrEVl4Su0FdKXHVLnHdK7HoqebY51as=;
 b=AaPWPGg3VfY7Z89oJDj+kZxEgZmkROg0HaPEtHHgrfpcAhlqs0dP3TM91paSpoEDA9glIE862KkJu2yEeS+XUwlQz4hT2Fwo/d6jzNBJ2w9U72SwyrPfwseQF0ZTRE2xwAGaqLSQvImAWmlf1fQ9ZR+G3zRhK202i+/tu7txoQxdhYfJApP9SIxwPReEJhOkadRL3mTEP07V6yqlZg333FEuFwPv5ifeJbnzzSvaEk1eNq3QTWWC+sWqbeNoL91K0hxtc6rdTU4uwJ3ZH0Ykrm+prvw/s3Sdd6EuCkDTysTI9gBT9DlbrnxJU8feMKT/h57MVlSfXbL8MfLBculrxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+9WZjy5F7PusrEVl4Su0FdKXHVLnHdK7HoqebY51as=;
 b=A1nncQDPpNYLrxy6sbIATa5nmqTgWBEDMFBLJuK2Dy8ivI9TZXibsjeXeVEO8uZ8zvdOxx2bIZFW2SwlU2r4N/JXgP7MHq2kvBGfDS4K/V8H5j5f5sSVgxr9jz6UrmBuwWGY6d2Yz5+S1hPIZG5LQncZy48bEf0Ca+ZGchZDqWA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by CO2PR05MB2678.namprd05.prod.outlook.com (2603:10b6:102:9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.14; Mon, 20 Dec
 2021 19:05:42 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc%4]) with mapi id 15.20.4823.014; Mon, 20 Dec 2021
 19:05:41 +0000
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     linux-scsi@vger.kernel.org
Cc:     namit@vmware.com, srivatsa@csail.mit.edu,
        shmulik.ladkani@gmail.com, Alexey Makhalov <amakhalov@vmware.com>,
        Matt Wang <wwentao@vmware.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH] scsi: vmw_pvscsi: Set residual data length conditionally
Date:   Mon, 20 Dec 2021 11:05:14 -0800
Message-Id: <20211220190514.55935-1-amakhalov@vmware.com>
X-Mailer: git-send-email 2.11.0
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::31) To MWHPR05MB3648.namprd05.prod.outlook.com
 (2603:10b6:301:45::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b0b3d58-d0f5-43e7-316b-08d9c3ebb7a1
X-MS-TrafficTypeDiagnostic: CO2PR05MB2678:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-Microsoft-Antispam-PRVS: <CO2PR05MB267809F494C816434A5C7F71D57B9@CO2PR05MB2678.namprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qII0qVepqbNHor077VSvib3fMPsbg2f2g0gf/a4zmDBylwX0YGIcJ9/1oq1Ht28ZIz8DTOC4TahdObufL5JJmwLuUkVjSa2M3/xcspIplYgqk5e4kOgSbftDD3PgAvFNMfc0KhYtu7AnaYQktM5GdggedFXes3EIi+uRqZCf6A4FZs8ElLtBrtddegSbmbZmo7vOkiQ3IC0URTz3NCWIrrfogRycfqq/wW3S00ERG3E2qz1x1l3N6Pbq36+nsEwfsZuVfgf4AL5QVFb9Hz1oy7RVyWvo9gCmjmKpa26eSXp0HK7eTzREyjQWGrQnR7gZfQs4Q3S0nlsJhovH+fJ2B50TKW9E3Y1qp0x8xHTftTFgBEBtxI/qltpQ4ciH8lb4/LwxoYcKjXims7dNMVnVgVihuzEV+ErJGgCPFsmcLZ4s6L4IH1XHvntXzHGR3Dmh7byubMvdmEKs1tyUsrtWKVp1ylufi7VVjri+cT9avekX3F1dUPeYkfTDN/lhK7HZ1saS4mhILD+64AkG8A1qEyUDOD9eGwM2+eTjLTKKjUAW83IwXjYTdhHtFNBvK6+ChyfhOKbgwwWp5wP/GqgmEdu5Epmz3CoSgwSHRDe839Q+uNX1T+oWzfb/8U3QrlRwWAaS5Ye9cUqxPa0xOflCcI/dT179mvXmzDgEiSMkHde2E3+gIp8IcZUUX8S3Hy9+jESvWfYTzWq4G8E4T1cxvPRNTYEN9h8RHDcGFFz4hl1hzNTKQJba6pG2V9yWOr9EqtDNeCqMCAJv99316NfsYMx1ws48elZBIPTH7wnMG5k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(5660300002)(8676002)(186003)(54906003)(66946007)(508600001)(6916009)(966005)(316002)(6506007)(8936002)(2616005)(4326008)(66476007)(52116002)(66556008)(86362001)(6512007)(6486002)(26005)(6666004)(83380400001)(2906002)(36756003)(38350700002)(38100700002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wRcEHvQThcZ7rPOCK8QH0OD1ZQ7rqAGe5HQmH88O1Ga2Y/7iDjxviFjiWMJD?=
 =?us-ascii?Q?R3+wbI6hs/7Yxq1aRVjZ4yPR0E3b48CRrH0W0IqcSFMZqEyUSddd5QTQlQ01?=
 =?us-ascii?Q?a0AAiwRmxJYmTBFLA/vyFH3pNn/3MemPTEtr5y3WrJZZm7Z4GHw1hAwrzLrR?=
 =?us-ascii?Q?jlbiwQROmX9WY13bvNuomt1qibxF921IkfJURXg5bxa4XeslOKLBGr1L3956?=
 =?us-ascii?Q?XIslWOzVb2FrEj6JEzAirql4zA4oTvfj4JL7jd1EK81JMQXcFHbBQEQ1lf+S?=
 =?us-ascii?Q?QlKFN04mdqPqe10szxoqskIRJFOpSTG5Pol9jX+013AfOxtCzI0x2o8XGB6T?=
 =?us-ascii?Q?EezH1G8WPwWD2gOCeBJG1bE55W+qcby/PgkuEnSiYO1syUYSXq4bdGE9Kr4f?=
 =?us-ascii?Q?pzVcUWl4JEDLPDg4TdYQOWHBZU+pq8d/rQJMaufwyfhx4GGYvhgIZc7gklOw?=
 =?us-ascii?Q?oqv50pAXCQEmhymc+Xc9xuN6XPTtfXnnZNzuSvDlgVtlMUqm9aSIhL5v9vFK?=
 =?us-ascii?Q?1VPvgWPGAzKehNqli27y1417HerlBZNn9XEUCEFzC7+owyccReqa1wAdOqXu?=
 =?us-ascii?Q?5T7jrbYOIgei/5HjwarUPGrEj0CxdEpdLWEFLEc9vK/lPNSdb/BjdPzMTvQh?=
 =?us-ascii?Q?ZdsiiSAtWSMjXRqDSchQSz8r3YbDJUv0xJm7exN+hGhJfjZ6MY1eK0Q6RYhY?=
 =?us-ascii?Q?u867RD7o/BV18AIIp/i0ef0Cn31fQRz2iCdcibClPHvx0IqQDv2YsCXwVOog?=
 =?us-ascii?Q?9cTtJpc5ff7fSX/dopIkRayCDyV106XUcElVpkZy+BDlB6FQuhOlY4zYgYuj?=
 =?us-ascii?Q?mYeeWFCXEI2ymcAFNfgDQkvn5MFkdbR0uGw5JvwPzb2GtJ+yD2e/OoGWlNrZ?=
 =?us-ascii?Q?cZJUW2m98RMVQ5tLgs3ACK37rtTZl+w2/57ruVjk5b1cnuh9l7XycC/EkS72?=
 =?us-ascii?Q?GDvK9oPb3MafxsuUN7+HYen7iiWyf5+TViwC3LJawmbq/V2R7GhPkdxFOPlD?=
 =?us-ascii?Q?y3xR4IlzKH08Z/38ZgiN2/rOGKzen6NQkNmSOFLQLZTZwEHeK+ozznha5pBP?=
 =?us-ascii?Q?RaxmlkwP6KQ7LhBdXdODxi7BmNuEUxR3Sg6hvsCyJirZTKOynaJ7DdayaUQH?=
 =?us-ascii?Q?CWrs6Kkto+QmmK4MJjgR36Io1phEf4lUha9n0aUXf2pONGLaqgxEWNPuWjI9?=
 =?us-ascii?Q?hg8cZEhdnIaeFASiLd1QPZ2yCxoJsiAHYsEGG9bbbrCPTsSeu8mA7G/220ZT?=
 =?us-ascii?Q?bfAQlAbhcEfRZbAvjTkkHGr+NG3GdTVIgvG6nhwjfdQCFFf9qwwFGGcQTqMt?=
 =?us-ascii?Q?COmbb/8TK/K5NDHVaBtvIorP7uHO7dil2p1PLmN6GNEALPRDR9ga/cnNsmhW?=
 =?us-ascii?Q?EL5nRVhsMwKud/PChM7qPqcSrG7Q5Mm980VMPa+Dcari2zsyNKBMbafQOC6E?=
 =?us-ascii?Q?+xMifJasLlzlmhHeszK4ZwewlLXbDJKE5ZmHqsfj/QPx8kn6CXpESHejkTbH?=
 =?us-ascii?Q?mY+cDtmSZm5bJUbCwWC0gpSBgqNHaSSXftb0+tAjQ/u5QO+zJba0k4VmUxeT?=
 =?us-ascii?Q?mRZ+oj25InOZ3WTh8n4cZW21z70Fr04CxsWQ+Q6ccOtmznyD4sgfhrcMgWIE?=
 =?us-ascii?Q?euYhd2emseEoLNsWG7zpXS4=3D?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b0b3d58-d0f5-43e7-316b-08d9c3ebb7a1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 19:05:41.8598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q6P8CFOEBU/hpwLeaweY903gT9z49cvOr3WfJqD7eq9rnSu57LM/PZA2hCXTJQ0kZeFfXdTeMPstrbX0GLopLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR05MB2678
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PVSCSI implementation in VMware hypervisor under specific configuration
("SCSI Bus Sharing" set to "Physical") returns zero dataLen in completion
descriptor for read_capacity_16. As a result, the kernel can not detect proper
disk geometry. It can be recognized by the kernel message:
[    0.776588] sd 1:0:0:0: [sdb] Sector size 0 reported, assuming 512.

PVSCSI implementation in QEMU does not set dataLen at all keeping it zeroed,
leading to the boot hang, as was reported by Shmulik Ladkani.

It is likely that the controller returns the garbage at the end of the buffer.
Residual length should be set by the driver in that case. scsi_lib layer will
erase corresponding data. See commit bdb2b8cab439 ("[SCSI] erase invalid data
returned by device") for details.

Commit e662502b3a78 ("scsi: vmw_pvscsi: Set correct residual data length")
introduced the issue by setting residual length unconditionally causing
scsi_lib layer to erase the useful payload beyond dataLen in the mentioned
above cases.

Considering existing issues in implementations of PVSCSI controllers, we
do not want to call scsi_set_resid() when dataLen == 0. Calling scsi_set_resid()
has no effect if dataLen equals buffer length.

Fixes: e662502b3a78 ("scsi: vmw_pvscsi: Set correct residual data length")
Reported-and-suggested-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Link: https://lore.kernel.org/lkml/20210824120028.30d9c071@blondie/
Cc: Matt Wang <wwentao@vmware.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Vishal Bhakta <vbhakta@vmware.com>
Cc: VMware PV-Drivers <pv-drivers@vmware.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
---
 drivers/scsi/vmw_pvscsi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index ce1ba1b93..9419d6d1d 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -586,9 +586,12 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 			 * Commands like INQUIRY may transfer less data than
 			 * requested by the initiator via bufflen. Set residual
 			 * count to make upper layer aware of the actual amount
-			 * of data returned.
+			 * of data returned. There are cases when controller
+			 * returns zero dataLen with non zero data - do not set
+			 * residual count in that case.
 			 */
-			scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
+			if (e->dataLen && (e->dataLen < scsi_bufflen(cmd)))
+				scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
 			cmd->result = (DID_OK << 16);
 			break;
 
-- 
2.30.0

