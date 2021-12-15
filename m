Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11599476304
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 21:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbhLOUSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 15:18:20 -0500
Received: from mail-mw2nam12on2061.outbound.protection.outlook.com ([40.107.244.61]:48224
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235425AbhLOUST (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Dec 2021 15:18:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QC1TiyDMvOncrxvEIi2CtAnaDcLsrHWBbPXVEhkUBK7agBZvwA02gPb9NWqlZC2W3fQLOYf6WctC5/6Ml3WEgYaTzLDjonZVAn1pVNpkbl4jGmNwsOX4L2v6AQh6zk7801x1BnQ8TYeSkzD+XxsFyt1z4LRoIZdkW6T6tvKs4uJYe311MNlPCrbmp1BXFLaCnMFoZo+9zaGKlJZ6dVDNXlViy+CvOSQnGF7Eh9nSL+5Ofxzg9twkWJw2ssnNAIBpR7KKlwgZq/W9nOybrgH1bUuLgc4xulHBxFZhl1dKJvaaetIUZ6lBG9pH17gVaR/5fBtd7jpIVjkiD/EikOppNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kngt6hxi0DZxR21qRjcjfuGExb0rwD3AcjBsWaZvZzY=;
 b=XUaewHYFyoOVqMDUk7nv0Umn8TuNgtyzDgUqE2Z1UOmrmuT5tGmvaa3dTjqGzsxzRKduWGjkyLz9NQ2J49oA5jvHj/fdR5DxmHz48ir2XRbRtUID82jOX06B2oXpnmyIjwQ2nl+Dmz2m42kQ4JDEuubwf23shfLq/gQmeS40kpXuW5KzZqAzdV9AIG8jy+VfGFZ0LilfharPX3aqWnXSjGAFzwOhbWxe379PPVUJYsUUY8Dyfe28QOkHYPtAl8OeRkpWliTXnKlK5Ynm/+HukC+YhwQqLcBrAhFIy8FYSJaV9KR5Az42G9OB0tK24EtUvUnFwmK8w1eY9Pxh5QVsYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kngt6hxi0DZxR21qRjcjfuGExb0rwD3AcjBsWaZvZzY=;
 b=sukr0amMK+IwHiGYBoI5gFMQzGahhl2XRExc8Oqz87cJ9BwLtpI+3O5V1qCo0mVcTHgbjwVA5T2PsCLIjOuOdJlRoCUT0+H7FLFoAjNZmSu+WZeDbWZ51vJszAEhTAQkGqxrK2PKWeZQny27mKwfnoCTkrOoBn1CdbfPRvQNHPg=
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN1PR12MB2365.namprd12.prod.outlook.com (2603:10b6:802:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Wed, 15 Dec
 2021 20:18:17 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::9481:9017:a6a:3028]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::9481:9017:a6a:3028%8]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 20:18:17 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: pinctrl: amd: Fix wakeups when IRQ is shared with SCI
Thread-Topic: pinctrl: amd: Fix wakeups when IRQ is shared with SCI
Thread-Index: Adfx8Jc1mBT85u6fQmOf3Nrtasxjcg==
Date:   Wed, 15 Dec 2021 20:18:17 +0000
Message-ID: <SA0PR12MB4510B2B719F0088CD98DA17FE2769@SA0PR12MB4510.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-12-15T20:17:40Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=daabaf21-690a-4276-a36e-5ab76ade9b43;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2021-12-15T20:18:15Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: c0040e7b-2031-43d1-8d39-e82d33fe6633
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23b988b6-8b3f-4e6e-109b-08d9c00807f6
x-ms-traffictypediagnostic: SN1PR12MB2365:EE_
x-microsoft-antispam-prvs: <SN1PR12MB236532271E2E0AFC5B07A234E2769@SN1PR12MB2365.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a6BCmbg/WyTiWYzywTIPMkkTKyjI5+Z+Zvg75NiGYQJlY87BlLLjAGu4sn1L0aVwns64qxLt7MRlQwgIpcwJlzqWwimSxC8zSfggzdUg9f6muYSTheHBDgRwhefiUgxCiTMlFFQiNZs6aPMw1rXS5EosFJYnOLldVw/N7Cqz9AAOENOegxXg6ddDtnlPGqU3yh5Up3Gtv7DgCDGuU8Z8bq6DI5mYwHow0DrkCMc65JJu2u057zyE2zlLop3PVPg+rn29XfQKdlB+vt+X3noMfosM9rO2ykpmuV8sbmvyVaDVVn8myk7mYI5Vh5aLIFlcYyBd0TJFLtkbiVUN/8R4mKZ935QTCZQbA7a9FV7TrAWGCjv6pJjbSAklKSzcdcj5K8CYKwCkdkFUM220AN5xO86YakstFE1eiAEl9FH5eD7Qr3N2JG5fODZBmb4cL/fXQmKmbHSFbnlWFIPHS/7DS6KlszKr5OnndLPmc/kiJCyyZz+zQNDwuBoPPQzBicXo0Axf3Aqji2cfmAV9yU+qiYpbkvNsnGa4btgGBJDuu/9ehVJ3E7iKjuWlrKKOte8As0XU5+0zruoB+JMU8ph0l4gf3EIhdawiODP6xDF6o8IryZUajI5EqelqPv7Gs4TzxpvwsWhmkp3NyiY5yOSrwIb4BI2/lym9xQ60YYn6H3OZhmqJpcl/Hj6mOEYz2hEQ05YwQ2VIbfCWnKezFC4InA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6506007)(8936002)(316002)(55016003)(186003)(508600001)(33656002)(6916009)(9686003)(7696005)(52536014)(558084003)(122000001)(86362001)(66946007)(5660300002)(76116006)(2906002)(38070700005)(64756008)(71200400001)(66446008)(66476007)(66556008)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q1yfVjPtuT9KJ4b+oBLaA250WiL9V6ZPN4NXpXywH1rt5p9944Q9kKHarYd/?=
 =?us-ascii?Q?V3QVukZ6HizU6erf02PJ9KXRCxiLc+NHg5osHZpK3MFL5rjWDG/5jPStgBkf?=
 =?us-ascii?Q?GdkkPlDrM1AC4IFOR92hNa4WYWUAYlc3UyuFlich1rhYLWCovNt86KK0I8WN?=
 =?us-ascii?Q?8gly3eO+CX525oE6jM9oougnyrJaI17n8cWhvcJy0KRGYNHHbWaXGPz5RJkf?=
 =?us-ascii?Q?yn9/f5irU3ytNkWS3Gd7HzJlizkyL3o4AWvMO4Ywq0eWKlSu1LVua5fGdK51?=
 =?us-ascii?Q?UOoRjTTVgXfDoIKZWvRWU5j5iczeTHncrA3zjhmHqLcB/YDYLtcXmkob6Ie0?=
 =?us-ascii?Q?LfsIIBNKKCrNm+R+WmGNZOHJYpIjc5WLAj1Mh07FQ37iAOQqiiSyOS6xCdaQ?=
 =?us-ascii?Q?IyJ4DRXCc/eruytrW9OfLnHoMJc913mPje6nNO+2vJzPg1vURPeY679xoO3j?=
 =?us-ascii?Q?wJCy1AJNMNHdmOzmEm0JO3DXJRavti5QeP/TNrrEmXW6lGOtDruQyZs/Uh65?=
 =?us-ascii?Q?akmYY0J+/KzXlDpeRb0eVY8jEdA+rmEMkIVSwMlpno9kGllJMUsvy9ceMVEm?=
 =?us-ascii?Q?xvMw5V0entysofsSOkVt8ZSHpwnTRqSswsYSVZMGH6QVQFyC8u9MPUtfv3AI?=
 =?us-ascii?Q?0t9e4gZQpScuZLIBWrPtL47zzXtoSP/i9oasgyySe+/C8MIHN7Z4CrI1BTYJ?=
 =?us-ascii?Q?gHNjNG+oYR9JYp8CADfmFUCJqE/gHuyfhBbcbfJhT/8XECXx/dufFiLuQkK6?=
 =?us-ascii?Q?YC/F1Xshv2F0kXhC1q6TTqKdDtHgdEKTx9hu0dBGD08tfZUaQVsC21gInpHV?=
 =?us-ascii?Q?a6rceM+joHetxqeG9eQwfaot8KmbcNFoDpdzyfmaxvK7E3sUGErGAo18faNL?=
 =?us-ascii?Q?o58SSe5ivfUYDKBD2/5OQESn0POFdJrki9Cg1MP76VHXVZcBLo+CqVwKpTQ2?=
 =?us-ascii?Q?gOyZQG5EsD0wJmnqdavOuE56VmlMuN8Nw6OH/Rmc/VPI6ZNZpaMUGcLNrzwN?=
 =?us-ascii?Q?3Ers2JVRn9TzEy0N/Rv4uDWmY0rsRpdfufMJDMjpWh2HEOdh5ESPAo7OrNgW?=
 =?us-ascii?Q?/u2uLxBZxsbkl41el6uR08TaXfTcucH6pxrnqkahGf9otu9f69uWplUOQDsr?=
 =?us-ascii?Q?rC4l364b9eVUeYg91aWovtckPVQWNUGnPn8tXR+BNMVTWUUJCUPqTKz77I1h?=
 =?us-ascii?Q?WICwZDY79V2BF70AdIHNX02tsy7wC+h9uVt1ppz40xP1RpQiHD6U7O/g7tEK?=
 =?us-ascii?Q?F1c0U8A8KH5gitK0pIZyC7/FZuNrfwsDj2svlFIre1H0ZztrB6XvD59E/T/f?=
 =?us-ascii?Q?ALBn9wSdQaNGH+JWU6GDrAoQue0jZDs75OI3LiRvLyPqOHgNxUKhYryCQ9M3?=
 =?us-ascii?Q?gpdu5AoWcRZnhoZO+IAoX8X+evgJK9l8S7U5YVytuQn6kPKbkoxkgQkAfveK?=
 =?us-ascii?Q?+H+gnzdFAQuKHSd4jdkN9Esu5YS3I5z36YQ81UTr2FCmWYD3/WJ6499IQNPj?=
 =?us-ascii?Q?c8KkfRUmn5VyqVDwN82BN4mLUyHIsFtuq/cpdcSlmZiySnYms+bgudYtFKk0?=
 =?us-ascii?Q?ZkleKgaccPN8FuoCep+skQA5reo7/2+MSL/rq+1CPMFISvGbWj035P5oN5co?=
 =?us-ascii?Q?QJd2JCSL5oQ9Oz0Au4SZDZHXualAVLhbqqOEsre/j72raEELNSwiViKuZOcS?=
 =?us-ascii?Q?+bWebg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b988b6-8b3f-4e6e-109b-08d9c00807f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 20:18:17.4079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WJiYQRPaLXVL92nCa9hV8jwvAnJUqcvdXo1Kqr6lS3sBld4u5EK3DWEpZdSUKqayho2d7n3SPNLHhOPfchhBnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2365
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

Can you please apply
commit 2d54067fcd23aae61e23508425ae5b29e973573d ("pinctrl: amd: Fix wakeups=
 when IRQ is shared with SCI") to 5.15.y?

This commit helps s2idle wakeup from internal wake sources on several shipp=
ing Lenovo laptops.

Thanks,
