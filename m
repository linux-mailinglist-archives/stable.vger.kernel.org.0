Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CED549D1EC
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 19:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiAZSmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 13:42:17 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23036 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229478AbiAZSmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 13:42:17 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20QIfNxY002958;
        Wed, 26 Jan 2022 18:42:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=V26pdmaJFpOu6REntK2SAL/N82/O1GrGJMt9xkdv5DA=;
 b=khYHf5bR6wOov+KNHtz/eQ+G03i7rQpa9l9VPlivw2L0QFJhg6ip94hj+x0dptoqKrz1
 Af+d5b9bKgsiO2hCr0fxqxwr2XlOzt4bpdqYSV0+jPJ4rhFvhU7wUAjXjapOAeUnjbFE
 d0t+/miyj+hWj3z9ef9q6ftGP8ONh/CkyAeyeZJU2XoZniaoGjf8Ea7JeiSMpUwCp9yq
 EyAfwcK6VDbBjShGZUKy17E1jvLH0m+Lc0UDGUIvbLbxG5T2WKgqZ6E2LnHZsGg5X8y2
 vi4gkrPu2lJRgYilULUbQ0WptZrNTyQz6dbNnCuxEkywLoX1Hs0vDoNC7zUDak0l1EEE OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dswh9q9mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 18:42:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20QIQola104631;
        Wed, 26 Jan 2022 18:42:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by aserp3020.oracle.com with ESMTP id 3dtax8xy4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 18:42:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2VifCezt7X5EwuEyEgNuQcQXCPtnc2XF2aUPqjkPLEHca3Kvj0zp63zD65JcCDUhQoB5X6fBddVouVah9k+zHxD+jd/q67/kbe1F65wQM2WvqQZdB4Z9V8X8pd+pi8GnTyC7WDViAKDZh9n9pv9tCW4eRpnLef8rU1sh0R+vKnOlp3WXM3Gh+cSR7/stzZuU3EHlFY3GpUmTESrpFRkCramw9jqNNuLuzhXScjZcXczNPpXoiIJWCSc+cXN5oqPlesBrGLeObxtLPbzVck1HUsgzN/Sk/nBdXi7CX0d1k/pqGL8nTbThpAikBzJ4kEpszEbP6VxYP87HunS/pA9zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V26pdmaJFpOu6REntK2SAL/N82/O1GrGJMt9xkdv5DA=;
 b=oLryhKShiIk5wl9po8yjeYKTSARQhgbpbrSh/ImqqJ3yVzixeWpGecPZdg/9fBQ6yVDbKLiZhtRs+VZFge3PnPbQ4QsN5paBSMlqHx2EwYiAu6pKFWaQffMF0EUtFCNLaFZbx32kr/2u/tgcMdrf2fCRQzZ9jlbAN3O2e5BNuKz15MH5n6AEzzYqhPfzsMYbKExcYDdb6pztxaHB7jVIB0wqd1b+zsQHdQINqXbQr0zo+ragGUxR0tOBUJy7yaHipl12DBf5LWNEjtq022bO2GxXPGjGgk1xr39WgFDAIAgms8mdKuVHCrnQdHvXSDJ+ysDaI5Y2L+XWkTs+KRO8AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V26pdmaJFpOu6REntK2SAL/N82/O1GrGJMt9xkdv5DA=;
 b=cTv2RP6nkeeu8DGU1PBSFx5G0uK57fFysLBRYZSbpRicbg0JRtC+p7HVl+dVpEBP25y5THRvYAN7DRVjq1CJJT4+pXplzEjOPz8dTU/nzszWsR9bcW/34w9s9rb6EpVa+5eVCOvGkYC+M9GscdCHB6QGkZOxSIgvhaCoSMdic90=
Received: from SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17)
 by BN6PR10MB1474.namprd10.prod.outlook.com (2603:10b6:404:45::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Wed, 26 Jan
 2022 18:42:03 +0000
Received: from SA2PR10MB4665.namprd10.prod.outlook.com
 ([fe80::5c:9564:93b9:5654]) by SA2PR10MB4665.namprd10.prod.outlook.com
 ([fe80::5c:9564:93b9:5654%5]) with mapi id 15.20.4909.019; Wed, 26 Jan 2022
 18:42:02 +0000
From:   Dave Kleikamp <dave.kleikamp@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        James Bottomley <jejb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] KEYS: trusted: Avoid calling null function trusted_key_exit
Date:   Wed, 26 Jan 2022 12:41:55 -0600
Message-Id: <20220126184155.220814-1-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 2.35.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0007.namprd04.prod.outlook.com
 (2603:10b6:803:21::17) To SA2PR10MB4665.namprd10.prod.outlook.com
 (2603:10b6:806:fb::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b650bedb-73ab-41dc-78ae-08d9e0fb8b0c
X-MS-TrafficTypeDiagnostic: BN6PR10MB1474:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1474DF2E0E3125B232D32E7687209@BN6PR10MB1474.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EfKNys9UDW5cxEgH+c+LSOKfhMXZcK+HXvnZCkZ2tRo0PKKEnE1s0DWeLdelv2jN6zkvy60nU5nMM4oKIg94e6K2v19SYgMVx2szKK3nHJorTU3NKCZaeKMolX0qx8IIOGLqruJBpXSH4fi3+9eCmczhQjRudBf9H6rMSsZxvcFqQpZLF9qVYPGGQzJphakf6lHIQUatLR6HDs6H+tVMSJ8+Ufv2Dv6YrGeGNOTKw1vsurN+PqKmgz0DCnVAKtowaO3HtGiCO6wC96MkvybnVZTfk2pB1jpoWgg4xURNXtTEtpZ2GNVHqAKyM8b8VWootx3qTLtZU1cXfIuc4zWcCjvIjdTgnHzdI199k13kVCSDAM8hpgIBHhXPCoBRkMuWYnQ0D8yA1VYQpEMTp/T4Z1B0rTfBZpZU7Im5wL4d5aB9j7c8oYnqOEe9xv73jIs20mwsDy5JpJEWCy002BCXH93GYY5D2CO2W3QnBqbtYQPBRwj7epoxtdgUYvId/jcZQgxgyGzfyqpNCWgYUDfDkOFF1IqfRRTkkZkNGdycbivmWNm+ZeKGUIT6K2r3FU00IoZ5+6QCkULD0O8fFyZt+s859pCusQKaW4fmXHYqqMoxfLXVbLI65jltLnSZy6Gj0yJiiDLEedb1tElPmU1GNvQXxvEuIHTNocJwhMW6t0T2YaFMWGQi64q1DCt9tWnG4I9VhhksvTjoxh0Prp2Yag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4665.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(5660300002)(44832011)(4326008)(52116002)(6916009)(508600001)(54906003)(6666004)(6512007)(316002)(6506007)(8676002)(83380400001)(38350700002)(2906002)(66556008)(26005)(186003)(1076003)(2616005)(8936002)(66946007)(66476007)(6486002)(36756003)(86362001)(38100700002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5PKAGwIpnDARXfEu/yS14R87vJnC5jI3Info2Gp+EMJ9XR9I5uqm5jPioKOj?=
 =?us-ascii?Q?NOArOtuVkxfp66ii+T4bq6iDUj2jh676oAx3d4O5dAQJmUwnTfTcbsHpQ07s?=
 =?us-ascii?Q?JCIEdPobnpdCEtpCUX4SMegJb7WWmkuG/8OqjJ5R/q7dNsJWmPNn6MFDzcbZ?=
 =?us-ascii?Q?JRw8J16t6P0CPFZYLG5o5IwhZ23rKgTrAkBW2eYheY1JXGu6n7zEHn2mzjmI?=
 =?us-ascii?Q?7vB0IZvEYoVKylTtsUy951ZvFRgO91APf02flcEbieX5JCh+qC6DmeE2Hk9y?=
 =?us-ascii?Q?nv9sWxs8jAOUX+yIH6x7TbNI4swoZOHDYLWm/PoeHqf5bVLPw4h/LhpYzeDk?=
 =?us-ascii?Q?wV+qoBygipFaSl5O37tbUumfp9CSndFMsafHBcL86iQZwpnBBSnhEF4ov9EV?=
 =?us-ascii?Q?cJeYjYfkXg/OLKocTVhfNrnIOGwdiYQD5FKgmS4DE7Lqi76IzTbJiHB4ljpb?=
 =?us-ascii?Q?28ft4D+nzt8pnfeCvq8rIjmT7Trqf2NKAJPKpElJ4MRyrkwBZcgFAcviCDky?=
 =?us-ascii?Q?s2hwTBGf0zWJpE3kUAzurNGu0IyqcRQaZw+hNQ9kdJ3eDrdOOA2JSp0U7kiJ?=
 =?us-ascii?Q?qzArz5Hb53Wev9FMPCSfk55UoFUyk7pPxeVx2NnWV4mBub4WcWLRnBTymBWx?=
 =?us-ascii?Q?XWeTt5/mxCLwkKiLQ1mxew49JSJMIKFv/SIksnDPISNntO3+8R0Tlzd75MbQ?=
 =?us-ascii?Q?rQZozk/NCx1+GsxnMoDywMmosBl9xVfcNYj4N/RZCf7A5iDtwS9sXXpzwcDb?=
 =?us-ascii?Q?E8YTh26Tmed4+uiFcqu0HWcezA+0BErN2y2+mlyI0pQqCWwFuc0/2pnTkmuS?=
 =?us-ascii?Q?+9eFGY+pNUUbSoCcmMxrEmO4MCyxQGjwPbC+jYuU2+aCfrmJCwciMwq/YR/G?=
 =?us-ascii?Q?qLreF2bYYNt/fQykkVdPwatI/FwoGoZmGsrm1gF1ZZRuNsI9u5WHeX0pxvhj?=
 =?us-ascii?Q?TcOndnXPu4l4IMUnoy4Ohu5A9Y7dj6jyXJgUefmERr+9t+AspzTH0rW+4IDY?=
 =?us-ascii?Q?f9myaV8LWz8DzPW98N1TRG6YlrGeAoW3xSoXzthQuEQaT3kK+PX5gQP8PZZR?=
 =?us-ascii?Q?y22zSnWoBbowt8pSh4nuR9keQ6X8MrofgLRTBwxwdqEbalMSdAoZgf8/zV75?=
 =?us-ascii?Q?HZEPxN2/C5o6a2vVvFrWeIzKnATlsSo+kMz0NjfN+AWqb6oWAtcrxlZTqJUg?=
 =?us-ascii?Q?4eOg/roQxfAmiYt2PoBgduuhLEvW+rundSNcDVndsRyfDuwVUzxXFeVwlbmP?=
 =?us-ascii?Q?hL0HjRStudca5Z+NqhiXJ6S1OYNioX/81rPmBuEs4ikxIV0ZvSKY3UnTs2ef?=
 =?us-ascii?Q?4dLo8+WIqRlHFMG+A0B2JOSeRWiacNW2CZNQBtpbAof5cb6ekuZ1KWq7VBdl?=
 =?us-ascii?Q?KR5Lw400oG3tmKfk69fIPrB8hd+fqziOXyAqe48TyJF5k428HLYTKlJekJbR?=
 =?us-ascii?Q?V2o2nd5YyuZXPAypmv+EpHiCGE3jypY1wLzQbybmDvnnOUjwgU8BfXeC4rXK?=
 =?us-ascii?Q?DHYJo1pyxLpo4AVn3ldq1JlXeHqBEJzstA/c3ecQF7KanHBazt1ptRUtX6JX?=
 =?us-ascii?Q?AXmOU2LNkyj5jNqRiO8p/cswWYdfvH1PMq24S7I78RGa4wngbjyE0llJ76qZ?=
 =?us-ascii?Q?XgC9NOXXlDPNXEUPWHDfO0fisrDcEUyuN4YUpwD5HRlSP8cShgHsTb3RewZ6?=
 =?us-ascii?Q?ifFltw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b650bedb-73ab-41dc-78ae-08d9e0fb8b0c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4665.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 18:42:02.7335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YubJ6jnMD/0ihNjUadwlhxGT+2Pm8g5MybF151RBbgqCZJFU09lyqxTqFhj/7t9DlroM6FXUGjzCBx4/LG2O/JpU6JQ6zASym56FJFmWUbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1474
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10239 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201260112
X-Proofpoint-ORIG-GUID: low1Ae3vaR5lbdRn8mQ-CuySEK2zgA8l
X-Proofpoint-GUID: low1Ae3vaR5lbdRn8mQ-CuySEK2zgA8l
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If one loads and unloads the trusted module, trusted_key_exit can be
NULL. Call it through static_call_cond() to avoid a kernel trap.

Fixes: 5d0682be3189 ("KEYS: trusted: Add generic trusted keys framework")

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Sumit Garg <sumit.garg@linaro.org>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-integrity@vger.kernel.org
Cc: keyrings@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: stable@vger.kernel.org
---
 security/keys/trusted-keys/trusted_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
index d5c891d8d353..8c14e04e2112 100644
--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -351,7 +351,7 @@ static int __init init_trusted(void)
 
 static void __exit cleanup_trusted(void)
 {
-	static_call(trusted_key_exit)();
+	static_call_cond(trusted_key_exit)();
 }
 
 late_initcall(init_trusted);
-- 
2.35.0

