Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F93D47457A
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 15:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhLNOrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 09:47:14 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32146 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232975AbhLNOrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 09:47:12 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BEELelt004133;
        Tue, 14 Dec 2021 14:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=qzt0eWqUiGXfGKOaOY7doiTelAwouTBFoXlfduKCNxU=;
 b=we8rO/naAUw9UlUN6m7HzBHYm5sclU+Q0/S9PKFn+3i5L+bJqE1wuSExOObxxO1AwOHL
 7voWpVJ1D6qYWMHSp/mt6XlGbxyCDzRQdiZhIOtiZZLnrSgcZh7ozd5GgtbYsgV9n22E
 T/GKxApX06lzEnQWaBrVIfP+V/QNXRZ13pDMc7ZzL3bBcwqe4umJ9WnmUCHH+F9LPwwJ
 t9wtIGjdEUo0NWI6kOM5cXEO3t8jjyJ4lLP0NENXljcFebIUvS+QeTX0IGV+Z2GFfVed
 /Y9ZUoUtT4lPXYRfx1K3gIPGT9vDCMaLcUEv2bDfEZ7tsI0B9mcpUT+ewZ44vtsx/KBp Dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3py3xpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 14:47:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BEEj5ux142045;
        Tue, 14 Dec 2021 14:47:10 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2176.outbound.protection.outlook.com [104.47.73.176])
        by userp3020.oracle.com with ESMTP id 3cvneq2vhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 14:47:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YwuJaOlLXTGMdIHtxsT7K+WE6keErpdQGpDYY6Z/9T327nsQFN6NuxC9mPMf6SxWPH0w59RzUfPylYXpnP3d8qFlEBm0fFI4SrlRekiRoZqb+7LWlG+f2t0H6Ooin452/N1dUQHv7mGfKYLkedjP7G8s1OutCj0VLa+fVSduC6WOOWDDNupFWoipGrNiPhAY5M3boaaPJ+3Isr29oTeJXZ+V1WF5yrUS7G+jeB9gsQhQTyWaChou+ZVpwcaVnzKXRM3bKA4pGOAuZdiGvWuHFy7LozXCpjXcrepK28y44qESCi9f/7AgDuO0+i0dzurcnEEKAFxPksOHWrbebbVHTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qzt0eWqUiGXfGKOaOY7doiTelAwouTBFoXlfduKCNxU=;
 b=K/KWbCNL5e1ysLj/mFq2YjEx5TVnCTUqLH1kXG1/GdjZUcUm9QkptgWUBrdb1ZdggZxFdNi58XF7GZw2pRpEvBkoStXk1pVAgEB9yRtKb+Gv+IPrXvYW83h2sKiSV97cHpLzGtunzgStjTxyfbbtBJugivLX6m6cgeunHo9aD6l+VeATgAbv4mgYJlRlzoGpgE4JVhpSWvBAogjeLxvwlrCY+t6nIUdLLY7fo1j8Dv69G2xH0RgHQhRl3vUwQNZ1fJjpa7aYr6bYL5gE2d8uRuMKpeLA0PRoPs6u/YR/hBMq2n6dQxgiTnmVbRHyXTumOty9eVSKRvaoHO9a1OYpKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzt0eWqUiGXfGKOaOY7doiTelAwouTBFoXlfduKCNxU=;
 b=Gy/Lts2Xs3Pr80tSr1993X1t6pQJTIeJLT3/VeFH5WGAMqAeUbHbDDnGI2HzHzki06lAUfSkY6u6PisqJUhbjoI7xAUFchMSIQHnGtsM0ibAbWKMyjXQ97u5KkFRVE13s7AjQAM3MrrWEEr8o/fhiEckdiD87EphcG5Z/YiEnVI=
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN6PR1001MB2387.namprd10.prod.outlook.com (2603:10b6:405:31::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 14 Dec
 2021 14:47:05 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c%8]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 14:47:05 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     damien.lemoal@opensource.wdc.com
Cc:     george.kennedy@oracle.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 RESEND] libata: if T_LENGTH is zero, dma direction should be DMA_NONE
Date:   Tue, 14 Dec 2021 09:45:10 -0500
Message-Id: <1639493110-15900-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:208:c0::49) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e171871f-f216-4775-9eb3-08d9bf10988c
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2387:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1001MB238727A62563A3E5EDEEB75BE6759@BN6PR1001MB2387.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: daRuME6o5GItPAHPBVnL8c/wOKoMGEgZt69YN00kRPmxwY/GDtCuVKty9A1W+BgEk156++nwzePFs18OtAspQeoTi8CReTNbCZoIjtslqqYi32g42kJKnQq5ZwreIxv4pLxWg8uMdHjLXu1aLyzUBiIA0fmWYR9nsg2QXLZcmVLVdNqrguMBXUS14PFABT4O1f/0Q6AmOEVBiLIzdEsks1N/Hjie2kSKtY6lg+Oce3/8OkoFxz7amZw56lJnr3pi7kDbbzCocI6sqJmLusggsiCSPe15VC9+hZPphTWFcIMlE+X+nd7ox451Y9mcZd2kRJ5VFTtytrOneuOG+A9afAHYeWamkOkD52cf1fmejNE6D8yoviXDOqVDXL5WF5Ar5pynJR7Q38/jPb2EngVjdsFnIqjPvfOWvlJeblck1tWvizjJeOX38FML8CxxLk9HwjFKDlTfFMsfbFvJ0vApFmuuhoPv1F2DNc1lOQQ5LvmUntKATMeqJb6Pk2J7n4kfTsfI/spE9StjqWoO3atnckFTSh2oJ/P++Awlb780rlwBBpTrY4n9DZnVWT0hffgGQIDsETwL6emCYzj7G3giYwnZlwvS6ORy+wsB1OjrJ7cCOwQgrDcVRFWq4FbrxTki7vU2Y6YPGKL4TW5wGzk4wcDGAPoe31D/uQXeKd1r3gm4J40Wb7YDG7e3n0cQUx84lpMfjNZKXuYyb4UfV/67Og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(66946007)(6486002)(508600001)(36756003)(5660300002)(44832011)(66476007)(2616005)(2906002)(83380400001)(8936002)(8676002)(26005)(6916009)(4326008)(6512007)(6666004)(66556008)(38100700002)(186003)(52116002)(316002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nK14zH1Xdqb0lp5nvJ5ikDThjyVV/+wL7lYzaY6gXIRarv/deeiQNOqnOjQp?=
 =?us-ascii?Q?IUZaXokvHyI9UpYnPPCM8SHxaFweW2VPURqQ6jHkg4iLz+vE/ZAKQ8Uv0DdX?=
 =?us-ascii?Q?sG9thbhnmi4xd0izT5MTXRT8LyxI3j/JI/o+1Xe2H9ZvCsHiyDkQpQ03NojO?=
 =?us-ascii?Q?+5OUbIhbNLsMqEkxawMxkuH0Z4VtRzyhiK72asM7UbO6+WOHTablbWCVy0sG?=
 =?us-ascii?Q?QwJNH6nSNRMnN+ZoyO/srlq2Tt2HpX41CUWOTByoOOWLm1kn6WdQAU52WbWn?=
 =?us-ascii?Q?9VlcQe87fsLKiXCzE8towa4IZHEEYso9oBXHgnaYi00ESCRcrrEli3nZdXZJ?=
 =?us-ascii?Q?VOG6CudML6O9AcpzpiIaHd0Tu0Jq3qUfWaCOdmA/KK+b9i1/jekXYQVw+MH2?=
 =?us-ascii?Q?NJQdekNOU57AiCZlNu02FKniEiyk2B4CNa4lHTGABQlpft9kXa0L/Rq+bvoe?=
 =?us-ascii?Q?3Pdf8ZFsb5xkZHxnTE0p4X62ZOKBEHwzGdObzDQFaID/0/3yCcmDSI3XHwI/?=
 =?us-ascii?Q?7SAMr04iILn/eV788qJwTsfoPaQxwsyPlNfgb4klgiVIoKngEJO83VFI9jlG?=
 =?us-ascii?Q?mrRHNmonrMyr9uZbRmVYMPrbiXQxv6cI6NzXjhS6ktUstccH1IFgqR69qBBU?=
 =?us-ascii?Q?VvNYI1Ai1rnWeZ+8LlxJufftJxmF9i88hmgkGlAuV9CnZvY9SBIFNV7KmBxt?=
 =?us-ascii?Q?eRD1fn2se4NXEZvya83fRu6uRZSgkcegoY7gle2vSwcunP9gwLYdspNT9cqH?=
 =?us-ascii?Q?kwBq0cxySLexNE3bxpOGdT75kzUfvVjEdR3tNKRvtHI7P3pWfc+BGWYAO/9B?=
 =?us-ascii?Q?ebxmp42WRhC+e0RnbfdMjn77iy81m0Kpv1MkG4nLAiffWtZgjReuWD/tQkbv?=
 =?us-ascii?Q?pcmI40N7CTkGN2LAgsponinriUm8LuVU0rfecqRCGrVE7uU/AkcbUMI5dGyd?=
 =?us-ascii?Q?VqvTcs8VRI8ZATWyVEDReTy5B7TG5Ig8+8yWcKaHa+HcvxrfmmXvyvPxR6qS?=
 =?us-ascii?Q?8Ifmxa909dGPy1ClXIXkGpGbPTTp/2+GwRRU4Wkn5UTqW/Zc4TYo+7b7YkBE?=
 =?us-ascii?Q?q7JSL0sJY69847IkFvHALYVKECyslRpMt91GtRLiAMsaZ42LWZEAnEG0F1sy?=
 =?us-ascii?Q?tC2rMp01iLdGRPbmB1wj4B1XwJN+dhtgryeyCgq2pq3lYtkyrqSxeytoHV5D?=
 =?us-ascii?Q?7EJeBnLV3MI6uJ4IBv4fJ9sM4Q0M3Ig1i0QEcdNJuHOWmjzjB5paEnuQPpah?=
 =?us-ascii?Q?gaAb0sDrze08TCQ/YDiNeynHc1JDroWma8RIbiKoiP9S9uC8LaAigjI7V16t?=
 =?us-ascii?Q?rfKr8nsSsOY7/Of5glWqKbP2+B1hOYTP9iFCTrbfaek8Gk1gNtiLlxT5kpsg?=
 =?us-ascii?Q?LJtg6H96VhNP7vc0PUmxMK8XUl2jOUrLDANKVO1EBNucHFq6++a6VMVhnFZn?=
 =?us-ascii?Q?PR0NsCEptIJO6fQtG4qqc+rU6BQhNYSFtr8TSReqpBTYUk/ahFBDWfGZ5Drt?=
 =?us-ascii?Q?8xqZkPwOgo3yc5m2SXiM1j2HcHNvtWNbVgswPkUbmAj0rjSlgGhpjlfbU6F/?=
 =?us-ascii?Q?nIV9T+5q84QPlRWcnuSoHbagHMe7ZUgLh4GhpPxfClsYFp7T9fYAaBadOAiP?=
 =?us-ascii?Q?2JPFhyvEaqSrJXl1KnYVIBtEfgIbxOCYyQx77bVX2P2RZCvdGbOWmOwI+cY0?=
 =?us-ascii?Q?1wL06w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e171871f-f216-4775-9eb3-08d9bf10988c
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:47:05.0620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: noWnEP57BO8rkNtnZV7MP2NwsTD/A3PXx7tERi/WUqbioI+ON/5xtxmZkhOnhsdKNk8MqQy2/XzRQKUu+iJnkx/CujOdL6+EwFoRk8U4qag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2387
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=967 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140085
X-Proofpoint-ORIG-GUID: mgLnlRdVu-VbXJHc2qG-iGCxJAk0DEY1
X-Proofpoint-GUID: mgLnlRdVu-VbXJHc2qG-iGCxJAk0DEY1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Avoid data corruption by rejecting pass-through commands where
T_LENGTH is zero (No data is transferred) and the dma direction
is not DMA_NONE.

Cc: <stable@vger.kernel.org>
Reported-by: syzkaller<syzkaller@googlegroups.com>
Signed-off-by: George Kennedy<george.kennedy@oracle.com>
---
Used the Maintainers suggested fix.

 drivers/ata/libata-scsi.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1b84d55..313e947 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2859,8 +2859,19 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 		goto invalid_fld;
 	}
 
-	if (ata_is_ncq(tf->protocol) && (cdb[2 + cdb_offset] & 0x3) == 0)
-		tf->protocol = ATA_PROT_NCQ_NODATA;
+	if ((cdb[2 + cdb_offset] & 0x3) == 0) {
+		/*
+		 * When T_LENGTH is zero (No data is transferred), dir should
+		 * be DMA_NONE.
+		 */
+		if (scmd->sc_data_direction != DMA_NONE) {
+			fp = 2 + cdb_offset;
+			goto invalid_fld;
+		}
+
+		if (ata_is_ncq(tf->protocol))
+			tf->protocol = ATA_PROT_NCQ_NODATA;
+	}
 
 	/* enable LBA */
 	tf->flags |= ATA_TFLAG_LBA;
-- 
1.8.3.1

