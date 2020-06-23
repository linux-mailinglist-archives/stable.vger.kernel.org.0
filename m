Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A2220585F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732958AbgFWRRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:17:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14226 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732565AbgFWRRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 13:17:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NHFWVt018225;
        Tue, 23 Jun 2020 10:16:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=pdbQaThxotdgmElPl2xBhY7R3w1TbO/x3yZosk8if/g=;
 b=r2rT3O/fZOdLiky5FOCFSSSQ592p/93jSxAiI9x7A7X0gplRJQX+u0pYK7LCr/smJNFi
 rsSEhf5nC4AJRQxk6PW80ACarI3HoAT5Jket7QBGj76ybfW2LynZxLSEfZnGLGjiHFy8
 ZrbBTQ0JkODHGeP23pb2hL83OUz/P+IPMqMeRMfYaHsxx+ac087fWcdtG0wfQ4YlCLS3
 vs2SiO+DRYpp6ymKMpxkXsED/lFh/fyNeOaQF7eN7DGInPBG9gSiooQaro5EMeW/iDSA
 8Iu4ZcaxR6EU8MKCjLz9bPkkj7xJmWz/4AG/MLVw/24b/sscMWDVgu9Qnk9z2jVyTRqi AQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 31uk2j10da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 10:16:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 10:16:46 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 10:16:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 23 Jun 2020 10:16:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiV/X2Bt2KAM0HkuZtyroWbstsfRijeohD6dLvJCe+kPIjIRWKIh+HY61ssASJuQh2yEjm3owhv5WzUTF51LUpQCLeOH+uLqVHN23kwML4vrVjCVX9Dv6s80iAeEcYJUHUcbTGgDw+RKo4AIo8dRcZLOSM26gF8hT4xisy3m9nZpPpQPWosrDWx90KTeYrLFcW+ThV8hwkOZwxfaPaenfhZ8eWWTqJW9NuN4pqpHM8qMrw6W7zUcxKX5r775UBDDVa4xXHoiRErt3K0quBqSgJtkg/845TY2eNwR+RYas/k+PlDiWg6M38o4kx4i680WB+rYMhczKvzQboGOdsZFyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdbQaThxotdgmElPl2xBhY7R3w1TbO/x3yZosk8if/g=;
 b=RcoHNDoFV7JSCbjOURuuTwohygwaGQmGEqrnoqimq2Zi85QgRp6zmrxa8RbvwWWo8kM3oJzXjxf4CZ7EqwiWodvbV2BHZa14TQZ3YB7vC1qy9bT87R7tVlqytBn/Whio5/d5euwsdyeCs1VBWvaXrt9FNHMiIhGrBhZ5gsEJelmn6HBVOJ+Zkji4rK81pw/kW8dbjxkfQYZHbznQnAZk/U0DcdsF5cJEwlO+zuXxOP+w8G/z+cOYdQiWyMqhr2t5IQr2MyI1epdZxLahYPazNostNzKDvTkgWed6OzZpWtCEGGH70PzZagoIXl2nLOXgL55A6Y90Av/1QH7abi2Yfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdbQaThxotdgmElPl2xBhY7R3w1TbO/x3yZosk8if/g=;
 b=p3w2OtWfXvMsdm2p29wErQGRHPzOHvjesxOlGS549UiBcDEEs8miBZt+1OGDW6vDHMa/Zg0VOiRXP6LUby8QBc6RaKc9NbZymaE2qrjG1O95vxGoRo3FexG+MVZZq8VJRs+McDJVdstLHbXDMtan6oHuFiOoBNruPV0AJP23aDY=
Received: from BYAPR18MB2805.namprd18.prod.outlook.com (2603:10b6:a03:108::25)
 by BYAPR18MB2885.namprd18.prod.outlook.com (2603:10b6:a03:10e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 17:16:45 +0000
Received: from BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b]) by BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 17:16:45 +0000
From:   Shyam Sundar <ssundar@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        "Arun Easi" <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        "Himanshu Madhani" <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: qla2xxx: Keep initiator ports after RSCN
Thread-Topic: [PATCH v2] scsi: qla2xxx: Keep initiator ports after RSCN
Thread-Index: AQHWO0mLCnxi3iS+kkOWu/lglbF/I6jmjY8A
Date:   Tue, 23 Jun 2020 17:16:45 +0000
Message-ID: <4791A081-0A81-454C-921C-EF7EFB6D80FC@marvell.com>
References: <20200605144435.27023-1-r.bolshakov@yadro.com>
In-Reply-To: <20200605144435.27023-1-r.bolshakov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
authentication-results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2600:1700:6a70:9c50:d453:77be:a8:43ec]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5b90a46-341d-43dd-db38-08d8179934cb
x-ms-traffictypediagnostic: BYAPR18MB2885:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB288596F17D7071424F50ED19B4940@BYAPR18MB2885.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4UBKaOgb91k7Jcycqvtp9IIBNz7yyxERkcupUStWZsi17qNYYlv+l7fOTZ92FzmXtE+OkbAq+nKrbbUEE0YBNMJmbiVsrTNiH5d/cFv56vuZgEGF4rIdwLEJLjGumLlw44YfTwpa4S9v8DxIKWE3UBokqRX210ZjmxSKTfyJrRSxv3fC3MOGwTDtQrLyWiFeTASFWhqIMfXXOO4pKjpkyJrlGZdUTfYdw85GAJlHDYBZI4QOXVehJKMKDXcFpEVxxXRRJ29v4g2rd9KUHAyyveUA2h219pRVBsPQLyO2yHSJ9VxAqEj6jcstG6POdXpD0Esd7Dxq+XRZFvboAdb+4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2805.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39850400004)(136003)(346002)(396003)(376002)(66946007)(76116006)(71200400001)(4326008)(5660300002)(478600001)(6916009)(33656002)(8936002)(36756003)(86362001)(66556008)(64756008)(66446008)(66476007)(2616005)(8676002)(54906003)(558084003)(53546011)(6506007)(6486002)(186003)(2906002)(316002)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: CZJGToOsAf4v6WH9zWePWTYV7KT/VJv30Ev5cB3UbHLEeBF7etc60fa4yxeB1bFn52ZEF/24nBPvNIO+sIU7yJY6KuRuZGSUt1vmWWAMdFNM5R3S6rT1BlMA68Xvv7OM6ti5/6ukEb3Zs1VW382LyxZezxO+NoT4zyEaRRmTPnRUuLoyyiVRCK1neav6h8vfVdO1MQEGQ3H/DJiQohFWKnipEQAk+kla5Ddoy/aoWsGUY8i0pL0UKoeRIN0ABqYCoY5XlZiXusH0jWvt26NG2MV01qi2ifY42flwsr79Gka+7J5DEegDGcbljpkLI2+Rw2+SV7TVC4d+Z0PvPZkrUJMT1GZCejjwjxOgiTVB3rjYjyQzCMUlC1DUJx0qMNUJENtxEi0cHhExCXWbonS/vU7vvsYR47An/8+oV12+G2n3vLBqPwCder9zjZEU10XZKf89jfDrBtnWF/GoHPjuF5CeVSuXwuK48suIqcMn0/tf+tHJCPIoGXV5lvoAonc5iYKOzsLOT6IqzPC3HVRk6UMHuPOQAuTQ5VLvPsvhJ60=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8E01A5EB6AA95F43A507491F130DC170@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b90a46-341d-43dd-db38-08d8179934cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 17:16:45.4976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iFl3qw+Oz0Sxk6xGhCpezz+t7qsFh4QCb3QR8BBIuNBekHKBw4wzs4HJ3Q9ci3cMbhqqC8FoaYhtCrs7OMXAtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2885
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_11:2020-06-23,2020-06-23 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good.=20

Reviewed-by: Shyam Sundar <ssundar@marvell.com>

> On Jun 5, 2020, at 7:44 AM, Roman Bolshakov <r.bolshakov@yadro.com> wrote=
:
>=20
> qla24xx_async_gnnft_done

