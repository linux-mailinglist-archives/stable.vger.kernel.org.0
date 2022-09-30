Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEABA5F0F49
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 17:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbiI3Pwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 11:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbiI3Pwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 11:52:45 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7651B7DA3;
        Fri, 30 Sep 2022 08:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664553163; x=1696089163;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gOEtfWCwDfjLAI18yXQkHrOVDOObO1aGcGdJ1Zc2ecA=;
  b=AEMZprh+HS584xU4ukDj5CoLNOsbPbQ0hOv90PwO77ynAndN6SsTvj2M
   00WM+HRo1LGrpCeTz0We8gYfXurTHt59xijTo2ULwheqd/Ie/YNUTHPce
   J2ZOMONAqnQIPHRg34+pLysjwyfn4Jb5m8Y08ObCab6jtMke27jYEauZ7
   9WIrUTeYmdPJiUh+ApALd0mVECdI2JAKwuLszwwJrgqUIycDSf9+kWS6L
   ce3tJeCYAQzmsa47MNX5ayU9u0yFwvxoodpJSz4EItwaWnFCZexCrIkNd
   UmxJ26BUxM1QiqSG6s/OFTDBlde2/V43IGstIeoTmclkhPtuza+Hxr69+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="388500303"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="388500303"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 08:52:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="618025288"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="618025288"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 30 Sep 2022 08:52:41 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 08:52:41 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 08:52:41 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 30 Sep 2022 08:52:41 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 30 Sep 2022 08:52:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=na7w0Am7YtKsLOMHXxiRnNTXukqhyy5nHv37PTMFuztjtjcP+ifDFprHE+QZ33NSZMZ4IfUFqRz3G5QiGxUJr4qksZUDqNUzV/zMiOPzSfS+zLorfk+wEkTluR3bB+y8C7fFIGT55MpeHO6SQMrTuuoIYNIx6lkDd75Q+G/yoNmXuxFf8Q3C0TbrUNGZysBVL8QVKne2S5fVGPsd/KnIqG8pa/mq1k9StpWdvcCYUrDGCOY07xAi5Vmj0QD6loiX1X1OzZWCRs/9IpPXDYgKAcr9n4WKqnN7ef+uIhx+oOmGelAuiJZLR9XPIv6fo1hh/D1YJ6YAPiMZKWS2ohU0Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOEtfWCwDfjLAI18yXQkHrOVDOObO1aGcGdJ1Zc2ecA=;
 b=geVuFh/q1SfIMWpaH1MquQFSmydWchjpAkiIao5MYZcFgntIOTlfMNag6tY2qIOvfHogSn8lq0twnXC0YvcCrP2gOTbaNkNfN9afvp6cwRFwOzkwaiXTEBNd2dnxw05dFvSIR0EiVZSBCLlt5+1CK8CyznCZklpl9YmeauqbjCjQcpw/hBlIaP6om3fvPnLdqcpkQW0dag4hKGZN4j1RZ2KbKt6oOGYUSMqf17WJutdP7XpvsfvlDlHZW2YjRk3WwhzjNrvSbY6BK2JwWEKud5QLMCXl56iPLLNSg858ApNgOPj2UBA6ikuPsKvAOREhxGRlQ2+uxYDl50GW02OpqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MN0PR11MB5961.namprd11.prod.outlook.com (2603:10b6:208:370::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Fri, 30 Sep
 2022 15:52:39 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::10a6:b76c:4fb1:2d60]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::10a6:b76c:4fb1:2d60%5]) with mapi id 15.20.5612.022; Fri, 30 Sep 2022
 15:52:38 +0000
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Shuai Xue <xueshuai@linux.alibaba.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        James Morse <james.morse@arm.com>,
        "baicar@os.amperecomputing.com" <baicar@os.amperecomputing.com>
CC:     Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?utf-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?= 
        <naoya.horiguchi@nec.com>,
        "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stable <stable@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "cuibixuan@linux.alibaba.com" <cuibixuan@linux.alibaba.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhuo.song@linux.alibaba.com" <zhuo.song@linux.alibaba.com>
Subject: RE: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to
 avoid memory leak
Thread-Topic: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to
 avoid memory leak
Thread-Index: AQHYz+pWnxyJgYboZk+A8TiiA+I2Ca3u0zyAgALE/YCAAD4LsIAA0nMAgADpGLCAAiYcAIABMbYwgABl9wCAANmeQA==
Date:   Fri, 30 Sep 2022 15:52:38 +0000
Message-ID: <SJ1PR11MB6083F02E240B6E8B8CEE1EAFFC569@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20220916050535.26625-1-xueshuai@linux.alibaba.com>
 <20220924074953.83064-1-xueshuai@linux.alibaba.com>
 <CAJZ5v0jAZC81Peowy0iKuq+cy68tyn0OK3a--nW=wWMbRojcxg@mail.gmail.com>
 <f0735218-7730-c275-8cee-38df9bec427d@linux.alibaba.com>
 <SJ1PR11MB6083FC6B8D64933C573CAB64FC529@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <79cb9aee-9ad5-00f4-3f7a-9c409f502685@linux.alibaba.com>
 <SJ1PR11MB60830CBCB42CFF552A2B6CF0FC559@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f09e6aee-5d7f-62c2-8a6e-d721d8b22699@linux.alibaba.com>
 <SJ1PR11MB60837ABF899B5CF1F01D68D1FC579@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <0f23cee8-9139-742c-a9d1-01674b16d05c@linux.alibaba.com>
In-Reply-To: <0f23cee8-9139-742c-a9d1-01674b16d05c@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|MN0PR11MB5961:EE_
x-ms-office365-filtering-correlation-id: f9937814-5d45-4931-dd08-08daa2fbcd32
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wO+NYGklGympbiid2DlBu8xQYmxkJm5Z+CeSFELQe8SYb3XWWeZlw94QG3MIcGIxJ2KDEIh0lhvFLZAiL8fDCNErMAIWK0xrhui2qmi/gviEPYRun2et3FQ6sDmRERyJ1j+8r9C4DYCh+5mAVdT+UZQnsAVdD5b8HG8hNDQYXtRCxxIzn/KRFqIRXcWREZShXNwYRW/GSGn1NhT5srkn11RVglcvmrjHyq6OyCDEb7Qb4KOOzeMd66dG8QJITEzYD+HM9hH4ssIgWwfql1J6bsbN5qm3BOlOMEnS9K9jw3b/XHqW/0DnVTbx0yKwJn11YyKubIpadVaw1LhCMWhJJwqI7OBXJliKUWgJW43GxjjUxvOFBgko4vn2wsCQmUfRMvI7+7xd13QPBKB7m1xoh/fWzeHwS7xlnSPPJ2OAIjnVHGp+8QlEsxYol1WHmEF2ij11YWKee0ZUzuqu2oLnqC2rE56I7lnNve5aT12tOron00eP/lMX+FAQ4yWEy4c/xNLJIIIGfzoddRzUU8q+IRl6CcDAvuobAITLFMEDkcaeyziC6VSdwU6QJEy1EJ8MJVDASAB7DHEsaVslmT80c6vvvTTPUogZ/IKkXXI+lozVU9+rFVSy5i0z/4GXapnS/8bhhPsQrS8GQE5S5Kl/Mz/XqJxTPx5DAyxY66quH/HSnuRIvIN9YLJ3ey4UJrFxKBUd17onkiSIjZeKfvkDKyaHEyP+V9c/iKQUKyl8DQr7KMKXeJLiFx25iU2tVR7A0ZZ18qAwK1d+TAeLk+Tqlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199015)(110136005)(8936002)(2906002)(7696005)(38100700002)(26005)(76116006)(52536014)(86362001)(6506007)(9686003)(7416002)(5660300002)(55016003)(122000001)(38070700005)(41300700001)(558084003)(66446008)(186003)(82960400001)(54906003)(316002)(478600001)(71200400001)(64756008)(33656002)(66476007)(4326008)(66946007)(66556008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGZ4YWM1eGQrSThHYmVIY1ZSMmlqSEZXNDQrRFRmTmhCM3JweGwwQ2ZhNGJS?=
 =?utf-8?B?elVrUEF1cDdTcHdQdmpBOGtmSFhKOXdzZ1VGekd1eUxwSVFxR1J6Ui9vWWdH?=
 =?utf-8?B?VkV4bDVYZUNsRVNLMkU4ZnQraHZucWc3NGplVURGUTB1Yk5jcVphUVlHRkw0?=
 =?utf-8?B?Sm84anJIOEplQmJvVVR6d2EzODBpODMvYTdjQ0RDZFlCeG5oSFg1ZWI2YWxn?=
 =?utf-8?B?R1p0WTlQMG5McDhhWWhZVHlTZW5XRGRLbHlEZ1FaeHNQZ1RKUFJ2WlJpbVhG?=
 =?utf-8?B?NHhYZmIzajVlK0lZeUZtaG9VdjcrRDk0cnFwNWhnYks1VFRVQnlvZEsweExq?=
 =?utf-8?B?bEhGeHp2U215bXNXTTlZNmpDQm5UQkpBZnA4M2R3M081U1ExVUtBam5OWHZ3?=
 =?utf-8?B?WFJNVHIvM1h5QjZWMzNUcFBtdG1oRWRsdndjdjFYRjcvMTBQM3NyT0lKdGg3?=
 =?utf-8?B?TmQ5QUszL1pRZERrOWFXV2Uwalc1alJRdmZldVVSVVMra0R0R1Uvb1RMVlc5?=
 =?utf-8?B?ZEJyLzQwTGZGR0huZEVOVkZoTGpVYUo1RlJrY3B3UEdMVkNzNDJEYnpQK3FQ?=
 =?utf-8?B?NUhnVjJaK2RkK1V2SkdtTUxJQlZuRWVOcmNJYmZwbCtCeG9USWdOZzhjL3Ns?=
 =?utf-8?B?UWdHSllBU0tpa3poQ1JscTF1YXVSL0VCSWoxZnJUMklKaEo3cnlIeGdzeGww?=
 =?utf-8?B?T0JvbDV0ekV3N1piM2YrdEduZ1M5V3RsYXlGQm9hcGdVZjdjK2lKRlp6bmVr?=
 =?utf-8?B?SjlTZzl4WVdNOVdXc25aWjBvYVFZdG9iVDhiaC9LNllCeVJwaGVsYm5aMVV5?=
 =?utf-8?B?bmhTUkd5MXQ1SHpzZ2xyYmkyeUlKMHpMc2UrSnkrOHBTcTMrbTJhSU40ZkJ3?=
 =?utf-8?B?WkcwWUVVTjM5UStiMS9COTJEK2ljT0svZUJpbVI0NzFTMGlCeHhGZ0pYZTJt?=
 =?utf-8?B?S1lpbWlRS0x0UXNmWC85cFBFS2hhb0hOaEtlZzVPdG9qRjg2a3pkcThGVjhW?=
 =?utf-8?B?d0NqQjRBM2tMK1NDS0ZJMVdZMkxaODVRRHFDZnJLeUNtdFdMbmdMd05CSjlj?=
 =?utf-8?B?Y3orZ2E3UExmRmFFQTE0SjFjZ2NncFRCZ2RqcXg2WjJGUFdLc21BZDhjS0I2?=
 =?utf-8?B?OXFLWjd1U1NOK0xiWlNBTXBLeGlaTDZmRmNoTHJXL0dHbUpmbjNOMEhOL3k5?=
 =?utf-8?B?K3lDeDMxWlhta2xjWTVJMzNTa082aWZvczlRMjIwMlN5MFEwMkE1aEMzcGhF?=
 =?utf-8?B?MTVvM05IQ1lFTjU5VGhqc3N0cm9iNjNVY0hybHNUbHl0RmwzdmM4amRBY1l1?=
 =?utf-8?B?NE5YdW9IOVlwbDNiOFlQVkVaaENadkVzUnBEYUR6L0Rmd2NrRGdxN2haR1Z4?=
 =?utf-8?B?bXNXY2Y5SjBRZlpnekJhaHZ5VG41aHN3RHZ5UDZyZGl1MXI3cC9iekVGQ0FX?=
 =?utf-8?B?TjdaZTFYK1RJWXhnNk1Kd3k4ZFBlQkMrMjRuUXAva29FcXNPWDJOMExnanNr?=
 =?utf-8?B?U3V0aXBrYjY3VExuaXYwcE9md29SYmVMSEFDZDZqMTNreTQxT2w4dFdSTUpz?=
 =?utf-8?B?MVVDQ1gzaW53ZnZlN2RTQ1pjUU1wV1c4MEZpdTd0bVVSRTh1TC9adGdRY0NS?=
 =?utf-8?B?cGxqZ3Y5THhRQ0hRVkppSnNaMlhlRHpRNlpSZzVDY2h5VTZ6VzB1RlpLNVNy?=
 =?utf-8?B?ZGFaRytDczZoeUNhalY0cXFUN29mcGpaTDIyLzBwZFZtVGZ3akU2Z1g0N1lO?=
 =?utf-8?B?U2dXUURVSFNzaW1XNysxQ3BLbDVndTk2cFg2TmxBVlN2WGZrbUEvbGNtU05n?=
 =?utf-8?B?K2FuWUFLQzlTYXQ2QXV4Q3hVd2NRb3VnZVBIYVFTZEFjdWhGVWJjczVPUUEy?=
 =?utf-8?B?QTU2RXkxR2svbnRuOUlVUlFQYUViRWQxTXpFR2VNd011cmU1cWNwaTJJRzdM?=
 =?utf-8?B?eHNSOTdoaGFMbkxCUXlEZEx4QXErcGRiZXFteXZETkMxQ051enlSbm00NGRP?=
 =?utf-8?B?UE94cjI3ZytMUjNDb1QxZ0gyU0FoMGI2Ymd2SmpOTUZwM1psNUxGK09BVjAz?=
 =?utf-8?B?YTZrdm5Zek9kMTVGYmhYNXVnczVHV1hEVTA2VkRFa2NIZmpJUUM1OU9GcE1m?=
 =?utf-8?Q?ifnc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9937814-5d45-4931-dd08-08daa2fbcd32
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 15:52:38.8875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XLTCfpiqB1x0wuLXR+rMOa0nnQrfmjU28Sb1msd02lDxPmb6a8AVr4rE93ivFuo4/CdLQIMQExQ22F1m1Ujw4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5961
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBZZXMsIHRoZSBlcnJvciBpcyBhY3R1YWxseSBoYW5kbGVkIGluIHdvcmtxdWV1ZS4gSSB0aGlu
ayB0aGUgcG9pbnQgaXMgdGhhdCB0aGUNCj4gc3luY2hyb25vdXMgZXhjZXB0aW9uIHNpZ25hbGVk
IGJ5IHN5bmNocm9ub3VzIGV4dGVybmFsIGFib3J0IG11c3QgYmUgaGFuZGxlZA0KPiBzeW5jaHJv
bm91c2x5LCBvdGhlcndpc2UsIGl0IHdpbGwgYmUgc2lnbmFsZWQgYWdhaW4uDQoNCk9rLiBHb3Qg
aXQgbm93LiBUaGFua3MuDQoNCkZvciBSYWZhZWw6DQoNClJldmlld2VkLWJ5OiBUb255IEx1Y2sg
PHRvbnkubHVja0BpbnRlbC5jb20+DQoNCi1Ub255DQo=
