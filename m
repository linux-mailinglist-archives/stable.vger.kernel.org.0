Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4A86DFEBC
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 21:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjDLT3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 15:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjDLT3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 15:29:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A981709;
        Wed, 12 Apr 2023 12:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681327792; x=1712863792;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=N7z1ZtvF5cm33qmhqPxqaZLpjsvZSUjjOuxC0vgHU2s=;
  b=A9zdp4iBsdklfzxfGgl3dg94qY39kSoXODlPCcD6zlg/tbP+hsYU5Sdq
   btEeGgGV1gzxMjq/rklRMQMVYTHosDf0xQI5SVMepWgdzZpX5pKh2MMxb
   LZ/laS66V4p10YGC1cQCb0iSI5c9U/Sq0BMfKK8JbuxfYKHujsKObqfGu
   ILfawxMhc4yQdVkFHaSfCzFM2oTGNHi6zqKUmgugtv12RFhZJ7h4n0lsb
   H3ALMzix9C8kqtbfrkBMbCwWkyZogYOqk8n4EaKVe8/MC9njPBmIc39wl
   suqeuA1PeC4HYOwwRN5smyCqjI/NI0psB/pau1mTN/WYD8yVAhpWGY3kA
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,339,1673938800"; 
   d="scan'208";a="210123141"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Apr 2023 12:29:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 12 Apr 2023 12:29:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 12 Apr 2023 12:29:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jg7DUoMk2dim1cQHy4vDwXS5nTeCNW3oR7rwsBPvKSMe15t+6Ee/s0pLw2ugG1CTJU+vjbwbIYG2kpcuJ36gGiVcMt91B4xlgxrs0i/o7vAq++BO+VodVJ5/ABi8+xSwGjbjF1MfZNhQxOCFzsfYVNEfid3fC6Wg2S6yCf8MSgGFNwwtoKBdEnsSMGJQ1imvKAZ1gtb93XKfs3d83Bt68iB9EMsSC1nEquPe8F/VdWvxPYTqarXLOnvihc8ZHnfu3esHZsC66UP561FGMrxH++s6sE2EnLAIkokbO+SFzDqvuXXHv02Hsg7DWKxQD1gd5BMXgBom34FKeXdaok5iJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N7z1ZtvF5cm33qmhqPxqaZLpjsvZSUjjOuxC0vgHU2s=;
 b=ESKgKslmEfmUDleZOjy1C2eiY6hyoGX2N4gCc8GVDQ42IKz9/ffebOcsDr/w9O2SSvaLXPcy8H3kE/wBVUSPbNNIajBdHseAX+5Zsrv2EuaVRxAe20zc5TkntVxmpyYQoMOo2c0bfvsQSqWMo74Gy6Sd6udp5z9KW9bqqAUhYWk2Pk0ft4iHf37BtlVpfT3xd/OUOQrDXDsNLiH8F835A1q3+FFY1mcAGTOasNOa6t6rwhjyKyqTnifWiqyKGJzLOtOSrAMDU4uKiUz4qFj2luOE/BvII+lXj6H/R2CdxyWgT91h/rUWl9bzEbYWUnyKzD8xWtuUEPLOuTNkmnAhbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N7z1ZtvF5cm33qmhqPxqaZLpjsvZSUjjOuxC0vgHU2s=;
 b=XbcM9zr5y8FBn0gj0K19M/yBc2DKYsjxa4yMlCAedU0K0sG7N54bzmnZ/nyu1yXNYQhz3TpjuEP3+he4WWNoOoaFQOX39WS0bEws134TK6rTMLg8ylrKaZ+c5d+GnspYh6u7nGhaL2dzLbeOB5M8ZYhyZJtEkOKi9Aqbyt20+EM=
Received: from BYAPR11MB3606.namprd11.prod.outlook.com (2603:10b6:a03:b5::25)
 by SN7PR11MB8261.namprd11.prod.outlook.com (2603:10b6:806:26f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Wed, 12 Apr
 2023 19:29:47 +0000
Received: from BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::d838:54c1:6d00:d064]) by BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::d838:54c1:6d00:d064%6]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 19:29:47 +0000
From:   <Sagar.Biradar@microchip.com>
To:     <john.g.garry@oracle.com>, <Don.Brace@microchip.com>,
        <Gilbert.Wu@microchip.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <brking@linux.vnet.ibm.com>, <stable@vger.kernel.org>,
        <Tom.White@microchip.com>
Subject: RE: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
Thread-Topic: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
Thread-Index: AQHZYb4PYBI21vPRIUeRtFcfEd9THa8RVvYAgBPI3YCAAmG6gIAApQoQ
Date:   Wed, 12 Apr 2023 19:29:47 +0000
Message-ID: <BYAPR11MB36066650D56088B1B7EB1D75FA9B9@BYAPR11MB3606.namprd11.prod.outlook.com>
References: <20230328214124.26419-1-sagar.biradar@microchip.com>
 <3bce4faf-e843-914c-4822-784188e3436e@oracle.com>
 <BYAPR11MB3606BFE903D1BBE56C89D31BFA959@BYAPR11MB3606.namprd11.prod.outlook.com>
 <d7abc010-4d02-c04d-64d5-5fa857b0e690@oracle.com>
In-Reply-To: <d7abc010-4d02-c04d-64d5-5fa857b0e690@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3606:EE_|SN7PR11MB8261:EE_
x-ms-office365-filtering-correlation-id: a12ec4a2-bf0c-432a-097d-08db3b8c46c2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +fr01I9LYuIQC36Q1lXsmJK7EH98o42jaG2m+xEkG/2ct1sQTWaTiiMemGmXlxg8BK99FDDlEUgQE3awplIrkKIyPeoEYX08QxZqNYfM2kkJSCGNrpm8yr0ZTggPr/7Dsp9w5M6AUldk+dsaRWGi2C2lAlnPjlk7unW5fi3S/SDvkhfadvujA2laGviTFMKN7s3YoT2XvBzGsdnxUa1QYKJJJgcYWvqOciiVzIhVjvjKuLNvfPmItuwLY5oCv25512mw9Cqg3h5w0p+8Wzxy9ObS/nrvoDNbanbVa9ptHTmUFccVyEZ0CuMPagi6RRQwCdHFHQ/wtImDevKvNs5Q41owOA93BS1TLa72frXIM1AM2e3RQTSF0ODkUYlAmVaZaNYWVO0PwrKDLaL8W8glkNZAlasgu6xKbDT7NdqALyJ8bPF999JDMUHvdl/WbqNCr+5hFFQY2sJFOj0Bp44jTdDcBKa/Ef+DNjlMCEAhdg3/uKkRzCIxioiF6bK2KEGrikoW4GYjzTAwO280a4ytvVhKi7zubb/LIJit9hekvTlp/qdYkFdmvFQSbr6AYakuG2Gi0oQ5o9dTN7ACxtDhzflHgJXI6h2Q5DVQHrM4zgZVouICHsqyV3wXffWLbcSD8JVyHqAGtCZfYyc0xypsgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3606.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199021)(33656002)(86362001)(7696005)(110136005)(76116006)(316002)(41300700001)(6636002)(66476007)(66446008)(64756008)(71200400001)(66556008)(66946007)(966005)(478600001)(8676002)(5660300002)(55016003)(8936002)(122000001)(2906002)(38070700005)(38100700002)(52536014)(186003)(83380400001)(9686003)(53546011)(26005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEI1NWRhSXdWV3FBQjZ0WTVzTEFHazlnS0d4eEdWNVVNU3ljMEZROGVjeHo3?=
 =?utf-8?B?VXF3dlpwcVZSVGljQldYMmNYY3I3T3pWeUpIbm9GM256NFNFR2VzR2dtU2to?=
 =?utf-8?B?cGRQNFZpS3J5VDF1NmI0ckNYU2ZrdXRVMXFxdWtDa1VtRjF1Y29OVGVTazhr?=
 =?utf-8?B?RkxON1p6ZXpxWmVvKzlNTk1PL3FjcFAxemtVaGgva0FrV2NRNUFPM082Ynhv?=
 =?utf-8?B?UzJTbkt4bU1qTEVBS0tRVUlNMER5NHRLc28yT2E0U0ROR2QvTHY1RUd0cTkx?=
 =?utf-8?B?YUowWTdDUFM5dFBVZFRwaVdXeGlPVDVGc0RRSVN0K1BzNTEzMnhBVHhuZ2M4?=
 =?utf-8?B?M05kYjNUVXVFQVVsa1VxS1E2WXZFOGpFTndJWndKRlNsUHdvanEyVWlqYjJZ?=
 =?utf-8?B?Mm03ZGlGcVVhMUtQYWg4anhDaExvWmtHMDRBWGN2Y3VWR0paWXUzNndnUUNv?=
 =?utf-8?B?eFVibTFEYW9nTmVsWit0emsxdlY3NldYY0dpYlp5RmtxemNSOXBjSGhWSVZa?=
 =?utf-8?B?aWdKVTl5SkprMGo0ampSSHE5WXkycVhrMVhUMU5mN095eGJCRnJuOXU1SVcy?=
 =?utf-8?B?V2tMTm5yRjRZTTVzVnk2bnpLNGdGbXdoWGFMV0dzaXBhWlhVczA5NTFseGRw?=
 =?utf-8?B?WWI0ZEo0VE8vR0FqQnZsWkNUeEdaTnhtVnl1eG9PeXNyQTcxcXR4K2xKOTRF?=
 =?utf-8?B?dHdxcTNnQ3JPZXMxWGI2SnpXbm1uSE5kbG0zckt1bVdiU2RGVHNwMzRENjNj?=
 =?utf-8?B?Mk9NaW1IRXpyTUlkVXh6ZkZRbCttcUdyMDJDRGJDSk9KckVxakxSV1NYUXlj?=
 =?utf-8?B?UzRXQVp3S1AvS1ZJZnhNTkxSSnZxS29BTGp4NkN0WjlRRkZhOGFkanJrZ1VH?=
 =?utf-8?B?ZEQvbE05SU1XZllGMWZTZUE0emRxYWszM3JEVlZic1A3NEJhRmdRVW1vYTNX?=
 =?utf-8?B?NkFTOUQ4TUtSVzZhWFNTelJ4bnM0UHNidEowQmMvUEJIRCtJMS9NY1pmQ0h3?=
 =?utf-8?B?ZWg1ZlNublVJcFhkZkg0ZVNOQkxCaUhLYSt3Z1diODZjZ0swN0tEQnlXYXNs?=
 =?utf-8?B?ZzNxUDVJdnZ0OXo1UEhKRzFYRHZWT3YxVzQyQXcybzVKRUsxeTQvVXVFMDlQ?=
 =?utf-8?B?VG1oMG41Mmo2dS9OcVFiUXdGWFdTL0JXZ1pUang2Rm1SNFpNVVFzWVFnUWZa?=
 =?utf-8?B?WkxNZmtCSW5zS0F4NlpXQ3YrT2w4T1pHZUhMQTVpSHBjVFIrZ2dyVlVqOWw3?=
 =?utf-8?B?MEVZelNIeFB2WGlqVUVMNU42UzkwNjBNMGdvRGo2NmdZL2pFcFd4allqTDVk?=
 =?utf-8?B?c1VOS0hOUjJEZ2QvU01iL3RMajJvNnY3ZDlTWmlRck9aUmpueFYxdDBIM01a?=
 =?utf-8?B?dmFVWWpmb3hvZHZlTFhYOEhmL2ZaN0lJNUNpZEZFaDB5b24yR08vU1ZDZkdi?=
 =?utf-8?B?L2VrbVY4VUFNaW9HTG82ZzJlRWw3ajlNYnUydWptMGEvQXl6SzJmUHdZVUJa?=
 =?utf-8?B?MW45TGl5T1lIcEt1a3RJM1Rrcm5iVE5xcTByRko2UVR2NlhLbjZFNEEwUHkv?=
 =?utf-8?B?ZG5PdE15NjZxQThWMC91b21xTlJYR1lzUW1Sbm1lMjd0T1NxNWhRWmtEY3JB?=
 =?utf-8?B?TWtabjBrUkdqcUlNQnRFNWk1cEVnZUdTaVdtemRzWjIrOEYxalVxYytGbWw3?=
 =?utf-8?B?YVRZZEFGVTNjM09TS3ZHQ2tIN0pOREEyTzRVeWlqTFN5VjBrT0U4M2krMGo1?=
 =?utf-8?B?dW9UMHhuL1RTUnd0RjB4NllXSWhUNU1IakMrYUw3TG5tS2hZMUU2MjNGZXBx?=
 =?utf-8?B?RkFEMW1yczFXbXRNVCtOZTVkcnYxUGVDWUlWZXFkd3VmWEtrcFJmWTlaK2cy?=
 =?utf-8?B?M1JQaTI5N3l2SDdBVHY0Z1k0Sk4yR1FJdnZkNlZ6NGJJSXJERzAzMzZ5SkRI?=
 =?utf-8?B?N1VDMzY4cE5KcUg5b2dja0hGNnMwbHFQWUtkSTl0QjhnaTBHbTdnSlVraER6?=
 =?utf-8?B?VlJLcDNFczhmZ3RQR3l1OTVoK3k0TzZpMmpzZzdCY2pmRFZzNWxvOWVlbGhP?=
 =?utf-8?B?MTRwN3ZESkNVMWlCMWhRQ0M5eTNTNCtrd01CbFJVM0YxQVdnYmJCdnViYm9i?=
 =?utf-8?Q?ORz3ON44NSjKxFxDqe3POAYxN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3606.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a12ec4a2-bf0c-432a-097d-08db3b8c46c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 19:29:47.1466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0MBDaAXRV+D8DVr8Oa4pPyF4MMPk3sXV0aC+6C3wBvDhoLdA/mcQqiEmE2lz8byYkGeACfXHhleLNSJCm5O+Ll/e2onkntjOCiG/15VlNAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8261
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBKb2huIEdhcnJ5IDxqb2huLmcu
Z2FycnlAb3JhY2xlLmNvbT4gDQpTZW50OiBXZWRuZXNkYXksIEFwcmlsIDEyLCAyMDIzIDI6Mzgg
QU0NClRvOiBTYWdhciBCaXJhZGFyIC0gQzM0MjQ5IDxTYWdhci5CaXJhZGFyQG1pY3JvY2hpcC5j
b20+OyBEb24gQnJhY2UgLSBDMzM3MDYgPERvbi5CcmFjZUBtaWNyb2NoaXAuY29tPjsgR2lsYmVy
dCBXdSAtIEMzMzUwNCA8R2lsYmVydC5XdUBtaWNyb2NoaXAuY29tPjsgbGludXgtc2NzaUB2Z2Vy
Lmtlcm5lbC5vcmc7IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tOyBqZWpiQGxpbnV4LmlibS5j
b207IGJya2luZ0BsaW51eC52bmV0LmlibS5jb207IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IFRv
bSBXaGl0ZSAtIEMzMzUwMyA8VG9tLldoaXRlQG1pY3JvY2hpcC5jb20+DQpTdWJqZWN0OiBSZTog
W1BBVENIXSBhYWNyYWlkOiByZXBseSBxdWV1ZSBtYXBwaW5nIHRvIENQVXMgYmFzZWQgb2YgSVJR
IGFmZmluaXR5DQoNCkVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBh
dHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KDQpPbiAxMC8w
NC8yMDIzIDIyOjE3LCBTYWdhci5CaXJhZGFyQG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+IE9uIDI4
LzAzLzIwMjMgMjI6NDEsIFNhZ2FyIEJpcmFkYXIgd3JvdGU6DQo+PiBGaXggdGhlIElPIGhhbmcg
dGhhdCBhcmlzZXMgYmVjYXVzZSBvZiBNU0l4IHZlY3RvciBub3QgaGF2aW5nIGEgDQo+PiBtYXBw
ZWQgb25saW5lIENQVSB1cG9uIHJlY2VpdmluZyBjb21wbGV0aW9uLg0KPiBXaGF0IGFib3V0IGlm
IHRoZSBDUFUgdGFyZ2V0ZWQgZ29lcyBvZmZsaW5lIHdoaWxlIHRoZSBJTyBpcyBpbi1mbGlnaHQ/
DQo+DQo+PiBUaGlzIHBhdGNoIHNldHMgdXAgYSByZXBseSBxdWV1ZSBtYXBwaW5nIHRvIENQVXMg
YmFzZWQgb24gdGhlIElSUSANCj4+IGFmZmluaXR5IHJldHJpZXZlZCB1c2luZyBwY2lfaXJxX2dl
dF9hZmZpbml0eSgpIEFQSS4NCj4+DQo+IGJsay1tcSBhbHJlYWR5IGRvZXMgd2hhdCB5b3Ugd2Fu
dCBoZXJlLCBpbmNsdWRpbmcgaGFuZGxpbmcgZm9yIHRoZSBjYXNlIEkgbWVudGlvbiBhYm92ZS4g
SXQgbWFpbnRhaW5zIGEgQ1BVIC0+IEhXIHF1ZXVlIG1hcHBpbmcsIGFuZCB1c2luZyBhIHJlcGx5
IG1hcCBpbiB0aGUgTExEIGlzIHRoZSBvbGQgd2F5IG9mIGRvaW5nIHRoaXMuDQo+DQo+IENvdWxk
IHlvdSBpbnN0ZWFkIGZvbGxvdyB0aGUgZXhhbXBsZSBpbiBjb21taXQgNjY0ZjBkY2UyMDU4ICgi
c2NzaToNCj4gbXB0M3NhczogQWRkIHN1cHBvcnQgZm9yIHNoYXJlZCBob3N0IHRhZ3NldCBmb3Ig
Q1BVIGhvdHBsdWciKSwgYW5kIGV4cG9zZSB0aGUgSFcgcXVldWVzIHRvIHRoZSB1cHBlciBsYXll
cj8gWW91IGNhbiBhbHRlcm5hdGl2ZWx5IGNoZWNrIHRoZSBleGFtcGxlIG9mIGFueSBTQ1NJIGRy
aXZlciB3aGljaCBzZXRzIHNob3N0LT5ob3N0X3RhZ3NldCBmb3IgdGhpcy4NCj4NCj4gVGhhbmtz
LA0KPiBKb2huDQo+IFtTYWdhciBCaXJhZGFyXQ0KPg0KPiAqKipXaGF0IGFib3V0IGlmIHRoZSBD
UFUgdGFyZ2V0ZWQgZ29lcyBvZmZsaW5lIHdoaWxlIHRoZSBJTyBpcyBpbi1mbGlnaHQ/DQo+IFdl
IHJhbiBtdWx0aXBsZSByYW5kb20gY2FzZXMgd2l0aCB0aGUgSU8ncyBydW5uaW5nIGluIHBhcmFs
bGVsIGFuZCBkaXNhYmxpbmcgbG9hZC1iZWFyaW5nIENQVSdzLiBXZSBzYXcgdGhhdCB0aGUgbG9h
ZCB3YXMgdHJhbnNmZXJyZWQgdG8gdGhlIG90aGVyIG9ubGluZSBDUFVzIHN1Y2Nlc3NmdWxseSBl
dmVyeSB0aW1lLg0KPiBUaGUgc2FtZSB3YXMgdGVzdGVkIGF0IHZlbmRvciBhbmQgdGhlaXIgY3Vz
dG9tZXIgc2l0ZSAtIHRoZXkgZGlkIG5vdCBzZWUgYW55IGlzc3VlcyB0b28uDQoNCllvdSBuZWVk
IHRvIGVuc3VyZSB0aGF0IGFsbCBDUFVzIGFzc29jaWF0ZWQgd2l0aCB0aGUgSFcgcXVldWUgYXJl
IG9mZmxpbmUgYW5kIHN0YXkgb2ZmbGluZSB1bnRpbCBhbnkgSU8gbWF5IHRpbWVvdXQsIHdoaWNo
IHdvdWxkIGJlIDMwIHNlY29uZHMgYWNjb3JkaW5nIHRvIFNDU0kgc2QgZGVmYXVsdCB0aW1lb3V0
LiBJIGFtIG5vdCBzdXJlIGlmIHlvdSB3ZXJlIGRvaW5nIHRoYXQgZXhhY3RseS4NCg0KPg0KPg0K
PiAqKipibGstbXEgYWxyZWFkeSBkb2VzIHdoYXQgeW91IHdhbnQgaGVyZSwgaW5jbHVkaW5nIGhh
bmRsaW5nIGZvciB0aGUgY2FzZSBJIG1lbnRpb24gYWJvdmUuIEl0IG1haW50YWlucyBhIENQVSAt
PiBIVyBxdWV1ZSBtYXBwaW5nLCBhbmQgdXNpbmcgYSByZXBseSBtYXAgaW4gdGhlIExMRCBpcyB0
aGUgb2xkIHdheSBvZiBkb2luZyB0aGlzLg0KPiBXZSBhbHNvIHRyaWVkIGltcGxlbWVudGluZyB0
aGUgYmxrLW1xIG1lY2hhbmlzbSBpbiB0aGUgZHJpdmVyIGFuZCB3ZSBzYXcgY29tbWFuZCB0aW1l
b3V0cy4NCj4gVGhlIGZpcm13YXJlIGhhcyBsaW1pdGF0aW9uIG9mIGZpeGVkIG51bWJlciBvZiBx
dWV1ZXMgcGVyIHZlY3RvciBhbmQgdGhlIGJsay1tcSBjaGFuZ2VzIHdvdWxkIHNhdHVyYXRlIHRo
YXQgbGltaXQuDQo+IFRoYXQgYW5zd2VycyB0aGUgcG9zc2libGUgY29tbWFuZCB0aW1lb3V0Lg0K
Pg0KPiBBbHNvIHRoaXMgaXMgRU9MIHByb2R1Y3QgYW5kIHRoZXJlIHdpbGwgYmUgbm8gZmlybXdh
cmUgY29kZSBjaGFuZ2VzLiBHaXZlbiB0aGlzLCB3ZSBoYXZlIGRlY2lkZWQgdG8gc3RpY2sgdG8g
dGhlIHJlcGx5X21hcCBtZWNoYW5pc20uDQo+IChodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19f
aHR0cHM6Ly9zdG9yYWdlLm1pY3Jvc2VtaS5jb20vZW4tdXMvc3VwcG8NCj4gcnQvc2VyaWVzOC9p
bmRleC5waHBfXzshIUFDV1Y1TjlNMlJWOTloUSFQTHJiZm9FQnZFR3h3MkN2YWhDTDBBUDVjNGY1
Yw0KPiBROGdUMGFoWFZnQjBtU2J5cXhXSjhwZHRZWTBKd1JMOHhaNTlrME5ISmhYQ0JiTXRWV2xx
NXBZTWVPRUhtdzd3dyQgICkNCj4NCj4gVGhhbmsgeW91IGZvciB5b3VyIHJldmlldyBjb21tZW50
cyBhbmQgd2UgaG9wZSB5b3Ugd2lsbCByZWNvbnNpZGVyIHRoZSBvcmlnaW5hbCBwYXRjaC4NCg0K
SSd2ZSBiZWVuIGNoZWNraW5nIHRoZSBkcml2ZXIgYSBiaXQgbW9yZSBhbmQgdGhpcyBkcml2ZXJz
IHVzZXMgc29tZSAicmVzZXJ2ZWQiIGNvbW1hbmRzLCByaWdodD8gVGhhdCB3b3VsZCBiZSBpbnRl
cm5hbCBjb21tYW5kcyB3aGljaCB0aGUgZHJpdmVyIHNlbmRzIHRvIHRoZSBhZGFwdGVyIHdoaWNo
IGRvZXMgbm90IGhhdmUgYSBzY3NpX2NtbmQgYXNzb2NpYXRlZC4NCklmIHNvLCBpdCBnZXRzIGEg
Yml0IG1vcmUgdHJpY2t5IHRvIHVzZSBibGstbXEgc3VwcG9ydCBmb3IgSFcgcXVldWVzLCBhcyB3
ZSBuZWVkIHRvIG1hbnVhbGx5IGZpbmQgYSBIVyBxdWV1ZSBmb3IgdGhvc2UgInJlc2VydmVkIGNv
bW1hbmRzIiwgbGlrZQ0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvdG9ydmFsZHMvbGludXguZ2l0L3RyZWUvZHJpdmVycy9zY3NpL2hpc2lfc2FzL2hpc2lf
c2FzX21haW4uYz9oPXY2LjMtcmM2I241MzINCg0KQW55d2F5LCBpdCdzIG5vdCB1cCB0byBtZSAu
Li4NCg0KVGhhbmtzLA0KSm9obg0KDQpbU2FnYXIgQmlyYWRhcl0gDQpJIHRoYW5rIHlvdSBmb3Ig
eW91ciB0aW1lIGFuZCByZXZpZXcgY29tbWVudHMuDQoNCioqKllvdSBuZWVkIHRvIGVuc3VyZSB0
aGF0IGFsbCBDUFVzIGFzc29jaWF0ZWQgd2l0aCB0aGUgSFcgcXVldWUgYXJlIG9mZmxpbmUgYW5k
IHN0YXkgb2ZmbGluZSB1bnRpbCBhbnkgSU8gbWF5IHRpbWVvdXQsIHdoaWNoIHdvdWxkIGJlIDMw
IHNlY29uZHMgYWNjb3JkaW5nIHRvIFNDU0kgc2QgZGVmYXVsdCB0aW1lb3V0LiBJIGFtIG5vdCBz
dXJlIGlmIHlvdSB3ZXJlIGRvaW5nIHRoYXQgZXhhY3RseS4NCg0KV2UgZGlzYWJsZWQgMTQgb3V0
IG9mIDE2IENQVXMgYW5kIGVhY2ggdGltZSB3ZSBzYXcgdGhlIGludGVycnVwdHMgbWlncmF0ZWQg
dG8gdGhlIG90aGVyIENQVXMuDQpUaGUgQ1BVcyByZW1haW5lZCBvZmZsaW5lIGZvciB2YXJ5aW5n
IHRpbWVzLCBlYWNoIG9mIHdoaWNoIHdlcmUgbW9yZSB0aGFuIDMwIHNlY29uZHMuDQpXZSBtb25p
dG9yZWQgcHJvcGVyIGJlaGF2aW9yIG9mIHRoZSB0aHJlYWRzIHJ1bm5pbmcgb24gQ1BVcyBhbmQg
b2JzZXJ2ZWQgdGhlbSBtaWdyYXRpbmcgdG8gb3RoZXIgQ1BVcyBhcyB0aGV5IHdlcmUgZGlzYWJs
ZWQuDQpXZSwgYWxvbmcgd2l0aCB0aGUgdmVuZG9yL2N1c3RvbWVyLCBkaWQgbm90IG9ic2VydmUg
YW55IGNvbW1hbmQgdGltZW91dHMgaW4gdGhlc2UgZXhwZXJpbWVudHMuIA0KSW4gY2FzZSBhbnkg
Y29tbWFuZHMgdGltZSBvdXQgLSB0aGUgZHJpdmVyIHdpbGwgcmVzb3J0IHRvIHRoZSBlcnJvciBo
YW5kbGluZyBtZWNoYW5pc20uDQoNCioqKkkndmUgYmVlbiBjaGVja2luZyB0aGUgZHJpdmVyIGEg
Yml0IG1vcmUgYW5kIHRoaXMgZHJpdmVycyB1c2VzIHNvbWUgInJlc2VydmVkIiBjb21tYW5kcywg
cmlnaHQ/IFRoYXQgd291bGQgYmUgaW50ZXJuYWwgY29tbWFuZHMgd2hpY2ggdGhlIGRyaXZlciBz
ZW5kcyB0byB0aGUgYWRhcHRlciB3aGljaCBkb2VzIG5vdCBoYXZlIGEgc2NzaV9jbW5kIGFzc29j
aWF0ZWQuDQpJZiBzbywgaXQgZ2V0cyBhIGJpdCBtb3JlIHRyaWNreSB0byB1c2UgYmxrLW1xIHN1
cHBvcnQgZm9yIEhXIHF1ZXVlcywgYXMgd2UgbmVlZCB0byBtYW51YWxseSBmaW5kIGEgSFcgcXVl
dWUgZm9yIHRob3NlICJyZXNlcnZlZCBjb21tYW5kcyIsIGxpa2UNCmh0dHBzOi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90cmVlL2Ry
aXZlcnMvc2NzaS9oaXNpX3Nhcy9oaXNpX3Nhc19tYWluLmM/aD12Ni4zLXJjNiNuNTMyDQpBbnl3
YXksIGl0J3Mgbm90IHVwIHRvIG1lIC4uLg0KDQpZZXMgd2UgaGF2ZSByZXNlcnZlZCBjb21tYW5k
cywgdGhhdCBvcmlnaW5hdGUgZnJvbSB3aXRoaW4gdGhlIGRyaXZlci4NCldlIHJlbHkgb24gdGhl
IHJlcGx5X21hcCBtZWNoYW5pc20gKGZyb20gdGhlIG9yaWdpbmFsIHBhdGNoKSB0byBnZXQgaW50
ZXJydXB0IHZlY3RvciBmb3IgdGhlIHJlc2VydmVkIGNvbW1hbmRzIHRvby4NCg0KDQpUaGFua3MN
ClNhZ2FyDQoNCg0KDQoNCg0K
