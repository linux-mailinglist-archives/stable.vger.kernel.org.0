Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31116686439
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 11:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjBAK0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 05:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjBAKZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 05:25:52 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F5353542
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 02:25:41 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311A45d2025063;
        Wed, 1 Feb 2023 10:25:25 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ncrx3c938-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 10:25:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAByPX+QIwwKjivEH81ZTlmx0A5XRAAl2IzryllnAbjQAeIpzRk+6xkzENxMGjpckyklqwqsUNeE+er6BtK0uqEG+MEsPqk7L/SDMthQTdCBe3iMMaG9Gmb56gzZBzNv5TeFJS1QDieAdz2QPQt+/VYn7Df3rkFSreyvNVr7+Cwi7LagiyZpCTUWnbpmsZdPrAKK2xx06qhQimxO+HPrbTNZTql4L+Yhm1tmVzOewX/TTjZOygvi3PjZxXWEx4kw3UIDpr+yIlv1lmroBsqoM9ykdlDNHnwTJfXqXi2lOf0fQb1LriBUoxpK7LHRPmIkqDm+BT+L3LsZuUto0vPVUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yJ7Blhdn2Ys3dN6rK2vV5zYs/TmtfSxGT3MxXrO3f8=;
 b=MbvFiCSblLVQsNZStI6TOju7gF9sbgLzbry/o2xPuRK0zgqtd1VgppKG+JqVkIcolDmHVBL/WXpBfj6A6zuf6/2n5g0+9nYb5WGqEiT26Ec4/oPSZzBAHIEVAzFsMFR6nTAW1g1V2S+QBXBVsRnaqIxBOsH+G1rWBRQxH5q2ZWCNfwtLXH0ZgigOT+wU/GxB4Qt4oBE6+PyeTbcvlfaVjXnFbpA8fIxIaMu8vNaewbyGIuTV5OdE019Stvj0QvV09WdxINUoW05R43LWIb56I/1PFLXxPyVguOFatahtx50iZKlaq3TvNXAWKNjhMrGyOsozeNnqDro2VExDTUoD0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=eng.windriver.com; dkim=pass header.d=eng.windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by IA1PR11MB7811.namprd11.prod.outlook.com (2603:10b6:208:3f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 10:25:19 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::31f8:d3d4:2c0b:cec4]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::31f8:d3d4:2c0b:cec4%5]) with mapi id 15.20.6043.038; Wed, 1 Feb 2023
 10:25:19 +0000
From:   Ovidiu Panait <ovidiu.panait@eng.windriver.com>
To:     stable@vger.kernel.org
Cc:     Soenke Huster <soenke.huster@eknoes.de>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Subject: [PATCH 5.4/5.10/5.15] Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt
Date:   Wed,  1 Feb 2023 12:24:56 +0200
Message-Id: <20230201102456.1385087-1-ovidiu.panait@eng.windriver.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR0501CA0008.eurprd05.prod.outlook.com
 (2603:10a6:800:92::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|IA1PR11MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fabb980-8bf6-4694-58a4-08db043e9df6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A5z1fioR4mQpSvnFL74PIcsxsExSt/O10OJB+hUvG+BIXmppl6X65xeza6UgU65eA6uPmm2l2K+eCoJAKEJ0CZCKONpu17RMU8sm7c+CHrP+l+Ua53fXI929YJW84b7X31YqMjq7We3QdMEEHpySBFsoY62U7bI3SCsk6DyPn8t3/9vouxLcJK9JoxwS1aol6hXpd+fFyiEFmgukkFl4RBJBC1RiAAemsKZ+rfZg+w0kysewVkpB+hgZlxc+ORuouWNq3YCAsZBYKCMK+TVTQf0uRB+kb1Ln1g3RXAdA8HNMARFttCjdtyjJJvp/Qt2C+eT5jTJxLksIz3dxwjLUfPXFkjnRu29uHmF6LQ6Jsc5htiqn1uf3i233qxj8O6audiXxNSwB5MHckCjmJH9N6uTVkPoGQJ58rINDGsAEa0STHYU+YGJ4F1sFf49OfPqK132zEfVDVtwX5mx60DIc+/kNMquvQ1kAj7ieXayptBVakPETlmr6rnBURc02Xghn9y7EuLARLVQASyGs1BaEgKAhFjnz9K1A8NL+P5caFaYQeR2eHKcxCv8uqR9wuf/4FFi9pjWR557+HNuPr6iIJHKwFUzRZFwAhBJYW5IlTm3TKkBcnotnkiicAg/Df+P1wPS8MzOAgtasbKaWQJsTkekrIYf7wqfmVSkWqbxMg7URBb5vc10lxKSe4nUM8SATDfjuAml/bwrMIue8S5Zbzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(396003)(366004)(39850400004)(451199018)(316002)(54906003)(5660300002)(2906002)(8936002)(44832011)(83170400001)(38350700002)(66946007)(4326008)(8676002)(6916009)(66476007)(66556008)(83380400001)(41300700001)(478600001)(38100700002)(2616005)(6486002)(52116002)(6666004)(107886003)(6512007)(186003)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4bDYhYn1vLwWjic7xtGMGnK8a5Y8oiLo5lvAw0KNXzzQY45Tj7KSQTxmPWax?=
 =?us-ascii?Q?t3jpTkQ6Q3k4eMMcdSqtpKrgiuymud5OPjRv1bgABSpO36Te7oo0ELSUgpAW?=
 =?us-ascii?Q?4XKM++3wBONpS9g20p1DdhRGeJ14x3Z5zucBlZ8bmIytoVQT4b5xBjoVal47?=
 =?us-ascii?Q?0Jc4pLq1MfGcalzxq7taeS+5BgUBMEMfZs9GChRlv32R9BbQOUsaeezjjB2q?=
 =?us-ascii?Q?dBULn9CZVKy8sBXC7e0w7w46JleUMV6gqB3iuEcEwp89waGW8KCWEFAzv4AQ?=
 =?us-ascii?Q?OG8BQeDt4DxpIPxSeMWDeEZxgLwtruFjO8njYPbhzHqI3uFHg2XPFHUSYw8x?=
 =?us-ascii?Q?lWHRu4nSDa8HUB77wiF4HQe5PI0vRcBVgJfjcA5IJotWqdCWC3LB6/t6xIaX?=
 =?us-ascii?Q?zc0Fmrhl5aAQtNNONO14u9InVajGI2rCeeiVof71jFEBx5iJlI+Yadhe+2tM?=
 =?us-ascii?Q?Q8GUGY7aceccHntLNR94s8v3k6s24OOsYvrhqT3nmpO546YJdSdbcmqEZJc8?=
 =?us-ascii?Q?dhG86cCv2bygJtxftL7Hdj+iywRprB78XNUG2zS6T/DHWmHrOGrmY3fMT1mB?=
 =?us-ascii?Q?wFQNDV3qTMsDIMnEqCOIlTZ5USiKQyBtV8OJcqHJMr1WGXy9PSfAWGsripuz?=
 =?us-ascii?Q?gw65mVamapkqSl3riOzzejUKyiAoFVvGFQub0vlg18UjW/4X+hDVzoAYZcIR?=
 =?us-ascii?Q?w0hBfFvvsLmcwfkmmC6DvRbDvfLTsgYoB0G/wLW3XOFh/bdO7EBnVNYq9M6R?=
 =?us-ascii?Q?8g1qrpaW+JaxGwpQhffiWNu8MLoudXY6ERl0POSSxzxgYhcOorR/1ixg0mwB?=
 =?us-ascii?Q?k8m+NWQiqX8Jh57o34loyLZbodKYCDhukdSUGmJLThhGw/P0r1UWBKv/JVDS?=
 =?us-ascii?Q?rdaulkPzpS+oEsM2rdFpacGsJ1w2cPfxFaYsLIQfUQzw6UUTCrDvARCZgEc4?=
 =?us-ascii?Q?yfrVBsDaiJrNzcJKXkjjWZh4aQtNOhIv2sE26yH5lzzu2fAEzBeIXYZTaAg5?=
 =?us-ascii?Q?N7lSck9ijKR1DXha8nCifapwiocxQrt6dns8deYtaphvdog040AURmbkpEmE?=
 =?us-ascii?Q?/nrnTVIAq2M+FFUv7wD38bEvX6ItSttAQotKElC9YzIXtkQC/hkUTAXOuwx0?=
 =?us-ascii?Q?X9RvIqqRcg66IFiTiL/mRfrygGTYwXqNu2Xc7s8JRBLZBakQjNhJujSiKFpQ?=
 =?us-ascii?Q?+YoAGmnlZPhyCSHMOj+9fr9sLCpBH/x2/2Sg0FxE9uUTCDcT+BClB1NElkA6?=
 =?us-ascii?Q?kEijJzOIVhlvo0mf44/osdA4AW4L+GdhJiovkk/fdM+4MCqjTdcZ251l3TGw?=
 =?us-ascii?Q?HpNAOk/ttyurtAZW1O2ivbYpr8e8JPtywczBCgBviyM/uMXX9/J3tZr7p2f+?=
 =?us-ascii?Q?W4ztbtJunoDINlrxp+NJQRSTa9AphB3qeQibI0w9H2+eGk+BAADdQ1PXVIF9?=
 =?us-ascii?Q?HfM5mGlohUO12tl7rODcW1BieUPJgIbCDGuRZdNeXRnhIqMnGPtOzK+pz0fI?=
 =?us-ascii?Q?KLxioe2H1mP99l558ukbMDdnZOY0FHKAW/ZFU/eX1ebLpmf8RtLTLs8b0T02?=
 =?us-ascii?Q?QoOeoy0pCSPIzk4L1L/j9ECXSwkod39TsbTC/NefsCZqlJZZ4tdJThHc1ueu?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: eng.windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fabb980-8bf6-4694-58a4-08db043e9df6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 10:25:18.9895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGywH3Afq/YlIcvu/zEs5jpu3HJDwosbsaIgNGdDSbfOQYUF1eYsFnXlSpKl3EYdv+9fYuJ87YglsD4sqH+hbmruNMfrymKhZuM2ZDo3igI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7811
X-Proofpoint-GUID: WsFdNls7Y1a3frEVFp_SVJhOMdewHXPO
X-Proofpoint-ORIG-GUID: WsFdNls7Y1a3frEVFp_SVJhOMdewHXPO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 impostorscore=0
 adultscore=0 malwarescore=0 clxscore=1011 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010090
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Soenke Huster <soenke.huster@eknoes.de>

commit 3afee2118132e93e5f6fa636dfde86201a860ab3 upstream.

This event is just specified for SCO and eSCO link types.
On the reception of a HCI_Synchronous_Connection_Complete for a BDADDR
of an existing LE connection, LE link type and a status that triggers the
second case of the packet processing a NULL pointer dereference happens,
as conn->link is NULL.

Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@eng.windriver.com>
---
This fixes "BUG: KASAN: use-after-free in sco_chan_del()" issue detected while
fuzzing with syzkaller.

 net/bluetooth/hci_event.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 57bf05253e04..685f89516e1e 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4116,6 +4116,19 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 	struct hci_ev_sync_conn_complete *ev = (void *) skb->data;
 	struct hci_conn *conn;
 
+	switch (ev->link_type) {
+	case SCO_LINK:
+	case ESCO_LINK:
+		break;
+	default:
+		/* As per Core 5.3 Vol 4 Part E 7.7.35 (p.2219), Link_Type
+		 * for HCI_Synchronous_Connection_Complete is limited to
+		 * either SCO or eSCO
+		 */
+		bt_dev_err(hdev, "Ignoring connect complete event for invalid link type");
+		return;
+	}
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);
-- 
2.23.0

