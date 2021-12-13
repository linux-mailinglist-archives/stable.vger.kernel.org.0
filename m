Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128C747302E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240012AbhLMPL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:11:28 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46514 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231924AbhLMPL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 10:11:27 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BDEnVjX001157;
        Mon, 13 Dec 2021 15:11:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=oxuGCzhwfUy1ort52vvi5r6K65iym64aSzWRlG1u610=;
 b=FH7EZ/IJjyyUYLTFb3UtNzn3e1+5gvT/GsQly4pCfuvHPLs0qp55xlsF/t0RF7XI2mr4
 7v7QUfgxm0anekaQbSRiGI2rGMcabaneszE9VkuYhIGUKHOnjHJ8XDlMR26mmPxK5HDX
 1XvULMqT7p/ZNFl87R0oZrcCCwo6XlKoYKT+OkGB4R8E87yHmtxIA2AIO7fe6ofkDhyf
 vOVBevK9Pl9R2iqBL5aoNP7/S+mpfZMd4hNX5ljNUWaw2wBBTwruIaq6Wz7sKBU//Pzs
 t9jByyu5gKGwTNXJn/0cWGMOnwKjqVpP2gSfc/sPSjLxdZLG07VAZGpuICXoeYDFpT/0 rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3uk8rmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 15:11:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BDF5V1t191685;
        Mon, 13 Dec 2021 15:11:24 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by userp3030.oracle.com with ESMTP id 3cvh3vm3db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 15:11:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KvyQIgSS8SU+TMMr7/zH/6XrUjXURUyHUQUkOHAHELjqME5/7m9owWWFeTnWnrucIWYIOrIwL7s48lHAaiqgMPRbRsB/2rJA21l4X/Vcqh54J/X2Cm6JvbUMkoDwd9Lbg4RdWxTRkixeNhfTzjaJrLK3EPVkZNMhoZRt6wisFzNA4eOCzz7mOKNw50M4jNW7d7P2tQNUPvhhBCx90q0EVSWYVpqEIraOo6ovjrCBXSC187ap8Xm/M9nyF1CZKPnVK86zMTEdRagOlgjuZTo2+D7f5t20qB65S6DLNRZw8PcA2Sh9wrk/A/sZk8lJU0PJryDU0wONQRub1gjrxF49/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oxuGCzhwfUy1ort52vvi5r6K65iym64aSzWRlG1u610=;
 b=OcyQ74VVPNiBwvKsWvKqPtq/dUIoSi6PHWiBBTkHvBbnj6JlrNzKh1Vqag59RWLvP1WUN3YPLeLIB6SNalRJqg3oWuumm5aR3HjUmYqfc9TUMYd0Hf55LZFGk7BJHWyweMcLuWKrO+UlhDVhJW7TJaUhYgpNFyLIW+52X9RnodJIumZ4wkvkKdm9iA5XcWUFqTWRgKgdLZ3exuWtjpv6TZ+0z/s19NW4mJWbcQOxO8uD7Fa8uUTjIAhZnWj9wT2Mt2n88ybboeD7dEYPH43udZT53BhrmqYHt9QgksQSlaZns7P4G/OK/mn9l03eHIlE/m+ZLf2MwGY+8Ene1EGSmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxuGCzhwfUy1ort52vvi5r6K65iym64aSzWRlG1u610=;
 b=dArgbRd3Wl1diyVEq1PwZM0j5EaLc5nwEUPO6fZ6TEUvOZgUIL5Gjs5zRRxvh1Et35hzp1ui0q2B5IaOB5m9ATBR7yPLLDa/YgL4N2vEduj0eg162Aqtf8k2x49bBDTR0tcLwiShFussXL8y1XmqzJ6FiQQb4Nc1GuEB1CBXtxU=
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN7PR10MB2564.namprd10.prod.outlook.com (2603:10b6:406:c7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Mon, 13 Dec
 2021 15:11:21 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c%8]) with mapi id 15.20.4778.018; Mon, 13 Dec 2021
 15:11:21 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     damien.lemoal@opensource.wdc.com
Cc:     george.kennedy@oracle.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH RESEND] libata: if T_LENGTH is zero, dma direction should be DMA_NONE
Date:   Mon, 13 Dec 2021 10:09:24 -0500
Message-Id: <1639408164-4210-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0079.namprd04.prod.outlook.com
 (2603:10b6:805:f2::20) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6399f004-2965-4495-8d89-08d9be4ad272
X-MS-TrafficTypeDiagnostic: BN7PR10MB2564:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB256425E18F7A5B0F2FB5CB98E6749@BN7PR10MB2564.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nwioWk8Igyf/3MAajGZDKSva6oTvM3o8K48VDU0E4BlecoqJeRk93p5dh7uu4fxc8hONiOBkr6B5HJ9I5BEveCLziooQeMpxLAMNw9YBcqzA5wEltXCWi8OuJ+0nJviznChqJhD2Szczj+On+LHD0cAwncIRvyU/DOBppA9R7u+DPDIpk4oIJRhxvSqLU0xOdqHYo0R/Y0jkx/VaO9K+lATjVvNE8jB5p+4RfB/Vuia4RCRMU2lnSRzTEv4QFXcLrks+z53CXS7LwuqAU+9ucKs+Vx/Xve0Bn3x0Y0Ky39t+7PEtlvqKOtP4paX/QW1QjC+BfWU2qnE7r0rsxbuSaJ1AaGHq+rzDhxm5bMJ3ysiDzAy/4zmRsXAOzatAn5E21UkJfiCZhmtYNw6L7r5wcrXb5zlYv6/AtFn8Q0wcrMP2Ee65YTfhu8nlagkNa1rmkV9IywkSG7ZJFpmEo/hgVoMXx6GDhhmJZ91yagTcQ9siehRf75BEdnxmXoSaz986Ybr6qrJvepIQVgdUhF3sux74XlkO+Euy+eKjG3Pl1dLAL9EEfdi9Byp2sC0J1gfLoZwvntcdEMmwetEuQKyn0Q37qqchWSpeN4z2o0sdeQs7Ik7+nxraXWKDfQNJ68a9bUFNoUew2H2p8HdQTYCxtGnaFID0PuNuV2UbN3hitWSSgyVnJ2qgaVUT7WEV0C0IEi2tB7WBHH3+xqsqUob+1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(86362001)(52116002)(36756003)(6506007)(2906002)(2616005)(66476007)(508600001)(66946007)(186003)(26005)(66556008)(6916009)(44832011)(4744005)(6512007)(5660300002)(4326008)(6486002)(8936002)(38100700002)(38350700002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mcDHww3MQtMaLPeZb1isR3JCV7z21LqLkdjy/NFD1Q/EYWqwqTjgvk9ZfoOJ?=
 =?us-ascii?Q?H+V4VncHbW6Jy+KNj3VQVd9imvnMhLcYNr8xKMVgqySojjWa3DBvcnmCNyeO?=
 =?us-ascii?Q?iIeLwOljeNScLCGuPsn3Q/ZXK7C9lAr2Qz3wV7A7es2UcE/r5SOCfdGTjMhM?=
 =?us-ascii?Q?3NkHxP34oVcSny4Fix1QdKleF7a6FVeGDJd8676uRm2L6pxjcdClWE8yC4vY?=
 =?us-ascii?Q?jbAnP55K8TJyOg1oQdpxWjXEqRapiY0ulaL4MQwh/Ia3sw4Sfwd4zVTd7P1M?=
 =?us-ascii?Q?Q/nHuuoK6BOuSr5XVnWv4QeW1zOpdTRwdiFe756J+yUnfmNlWyrV0yCTNLYT?=
 =?us-ascii?Q?AYZ4i7IXgxJk4z+50eRtT6OO08Sw6Ff7Znme3jVtsrwvXZVWOKYaUrTtIlYn?=
 =?us-ascii?Q?f5ls3Y+W0O6LWpC56rSlNvbbsX7wwKM5z4jj3Y8SNtsFcSt5VCw/sSu+FfyB?=
 =?us-ascii?Q?urhdyAdoTvYIUwuRACe2OLr8q28qFSMSgd4pzPhNLogNkO/2Nd+Fv2aUCemK?=
 =?us-ascii?Q?3hhAaoGtHYpjuNG0+GQL0rPVZvyxKc77BiaYEuY/KCx82YBQqRAGVjdmfd24?=
 =?us-ascii?Q?C3RjB/TYF29KgobIblDW4O9pM1V96F2J5sSL/7QFgGSScDipK3rx/E59tn13?=
 =?us-ascii?Q?6FjhDqjtECUy0YKqZcdW5uT2eX7LKaHhFuKTkVAzL6k7VggFSk5+mCbzHO4B?=
 =?us-ascii?Q?OqoN3scUKjw5eHlD6Nr7rYAsdj+i6aH7juk6V2Ie2nEEegxRENQUI+1z4aU3?=
 =?us-ascii?Q?VZWPUTDVnxQcfEYhBAieK1VyC1gahZI3fNMQF+WEopHcTE47ABSmGPoVCdIp?=
 =?us-ascii?Q?5TSW27GSZCX8xAl8r96zBRnPYCpAUxKSwGAewrt1LfQub2Gib7qZK052RFgc?=
 =?us-ascii?Q?Q0oaSNfa+gZfJSmRZ12s8eq5+EufBmvH0j2/hpIKIaIDa3oesBnimxyfKQDr?=
 =?us-ascii?Q?JyB33dmBDI8z3Ibvux3hZqwElHqr3Y/iNek+foLjVFwW4XAdFnxcOfL7AFlk?=
 =?us-ascii?Q?Njxp6kWC09d570SPwMx5ZIRHS4B6g8MDskrVUtIBS0VRTGPiba6KMAzbMXAU?=
 =?us-ascii?Q?hy5v7sdmo7IJtmqV6xSuvDI9kkE2bWhMaxeZg1fuxQHVYrIuchrD73hlzZWH?=
 =?us-ascii?Q?5n4YC0ZRnf/6DM4Ye6nVRu++wpG7XxNqvgJ/YA1GU7ynH3lIdKMI/q5t7KgV?=
 =?us-ascii?Q?tOSRIzaUr3GcVqfLqrnEcQXH/IrcU5GKqNv8Vy5Fp9GCH8f4Tc1ms1k7RJ/C?=
 =?us-ascii?Q?JCMzr2UQZN+myryzxWzPIOHoXKx948ovHR/yAhWNBJH5pYrJEvWLCkt2Ip2E?=
 =?us-ascii?Q?yoDnp/xkqfxKrm1HQGFGcrNjpkCqFQyNVa4s/yTrvwXnTScdaKV92oMmwuEr?=
 =?us-ascii?Q?JTeZHkMFn0/h4vRsN9JzBBuLwF205i2f9VQw2Een+UZGUIef4Xc91HDjc+OW?=
 =?us-ascii?Q?g4XteBcyj8jC0xuPT3OUoZkNfHUGGobQfN/b9jw9r6w73gTOPOK9Jet0mc1z?=
 =?us-ascii?Q?f4aW+RQDtzJe60ch18uoJZpW19xmrPxdSwjG2cc++6+qDH/ZWXA1Qtw7xvUm?=
 =?us-ascii?Q?fo7/8P3chtf+IKzu3bfSGLcgjC3Hp4Xwzdpeflcp04zwDU0/sMtZ/Mo3yMnJ?=
 =?us-ascii?Q?xj6Up++dbAvR/xAoyyYdDKX9t+ZxUsPAjFIlZ3U0tgbVtFP4CFaEhmzgMBhG?=
 =?us-ascii?Q?22bukQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6399f004-2965-4495-8d89-08d9be4ad272
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 15:11:21.8621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mXdtfAWnxzqb/tNgqnNUiw/6mEKx/GLEaZXfZDwrW8MJrev9+a6U78NC9+p4SQogT/XYFJXQI+aML8REZ1mNwFG4b2IWNNEORyEhE001dE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2564
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10196 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=974 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112130097
X-Proofpoint-GUID: sZN4a20NpPEhBImvFVM_EgZafLZGSOoG
X-Proofpoint-ORIG-GUID: sZN4a20NpPEhBImvFVM_EgZafLZGSOoG
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Avoid data corruption by rejecting pass-through commands where
T_LENGTH is zero (No data is transferred) and the dma direction
is not DMA_NONE.

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
---
 drivers/ata/libata-scsi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1b84d55..d428392 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2859,6 +2859,12 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 		goto invalid_fld;
 	}
 
+	/* if T_LENGTH is zero (No data is transferred), then dir should be DMA_NONE */
+	if ((cdb[2 + cdb_offset] & 3) == 0 && scmd->sc_data_direction != DMA_NONE) {
+		fp = 2 + cdb_offset;
+		goto invalid_fld;
+	}
+
 	if (ata_is_ncq(tf->protocol) && (cdb[2 + cdb_offset] & 0x3) == 0)
 		tf->protocol = ATA_PROT_NCQ_NODATA;
 
-- 
1.8.3.1

