Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4625EAC9B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiIZQdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiIZQdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:33:20 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B1183BE6;
        Mon, 26 Sep 2022 08:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664205704; x=1695741704;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y0dLB+RyRhGKKZa3QnvPNJOT2FdEg+AWCvm6z0CYV90=;
  b=leUW68qgMl82fALtDipgqnQDKhzjIN7WMwJbXkzAziUXASvhyn/JZQ8x
   azJ4yByMOZLDlZLlowAYqc6js6pe2fegpS8ya2a6/kgt/Q+BaNfrSlUOV
   s/CdcwWxp9j/PhHa87LIqxPCbvYT0uKkEGIMxliaokfJuWE5OI5P3GpDV
   k3wGuAwI67y8GjWhT+yPjJnK1acHln+BoO7voHk87hdkf6I+ZGYQkZ6/2
   aPOqGFey31GAyLlp4IaAmFDTKLZCPniyXeayru2xMDT+qGR0gjjuO0/On
   P45ULcm8VItEqADmGRoxQhIqCNxqimsLVqxVNbxI5imQoRGztqdm5W5KV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="281431158"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="281431158"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 08:20:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="725084390"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="725084390"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2022 08:20:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 08:20:40 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 08:20:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 26 Sep 2022 08:20:40 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 26 Sep 2022 08:20:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+i8DeAvs1ywCUdp8OIYwZitLmlpaTXDVYQzC7WEmL2Twx6JDu7rjc2DK/oItF7jv225VQjxAZjLyLVO3qD14m+ryuSBME4/6C433tokUJbVYcN92Mn/f8/XP4UEMlzfixtgiUZnwROJ+nByLoh2/olFVX+0jAnSFwRc0MDKLVVEyqHBTC8djAhWv46/IhFN7ij41hc6XQDPucNHWQMYx/DSgtLFQrTGa3KGraXP6a6j2lJe0vAV9SFPk6/uJXN/p/o0uPEywSMVewyiIDww7nnyI13xyKJeThNCqOkvwwFuLDV/DJP6opxQauIjQgYH9LuwsDlkOq/w8X17eC/Row==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y0dLB+RyRhGKKZa3QnvPNJOT2FdEg+AWCvm6z0CYV90=;
 b=K2/mxOmKBx+bNIn/2d1jqwvnD+V1dAEkVR2inpZSpHSH7ngD3Ue3X8mKSHwzI8JkSWFFNpbipn4QUyyuerrCs/ox85BTywjrBR5dlb3joSb9c5xR44vDGeRb56w5p/c7DBkbXiyFWvZtdISTLe7u3+8H4SDFOfBDJgrYpJgrRBjXrfc5F86eldxXGQqQg6aTo20naUlL12Qmt2zaFp5YoAIK8I7zz5zwY1A4PZyNFDjQesrmammUyfZmhQwThAgsRQmQi8v2U8c+XvosyDj6lLGL2RyFGRhLexnsqhmC4tDbCv6pN1xAIL9KvXN1iCW210qi7Xgs1oXuQ421ugusoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA1PR11MB6735.namprd11.prod.outlook.com (2603:10b6:806:25e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.22; Mon, 26 Sep
 2022 15:20:38 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::10a6:b76c:4fb1:2d60]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::10a6:b76c:4fb1:2d60%5]) with mapi id 15.20.5612.022; Mon, 26 Sep 2022
 15:20:38 +0000
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Shuai Xue <xueshuai@linux.alibaba.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
CC:     Len Brown <lenb@kernel.org>, James Morse <james.morse@arm.com>,
        "Borislav Petkov" <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Jarkko Sakkinen" <jarkko@kernel.org>,
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
Thread-Index: AQHYz+pWnxyJgYboZk+A8TiiA+I2Ca3u0zyAgALE/YCAAD4LsA==
Date:   Mon, 26 Sep 2022 15:20:38 +0000
Message-ID: <SJ1PR11MB6083FC6B8D64933C573CAB64FC529@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20220916050535.26625-1-xueshuai@linux.alibaba.com>
 <20220924074953.83064-1-xueshuai@linux.alibaba.com>
 <CAJZ5v0jAZC81Peowy0iKuq+cy68tyn0OK3a--nW=wWMbRojcxg@mail.gmail.com>
 <f0735218-7730-c275-8cee-38df9bec427d@linux.alibaba.com>
In-Reply-To: <f0735218-7730-c275-8cee-38df9bec427d@linux.alibaba.com>
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
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SA1PR11MB6735:EE_
x-ms-office365-filtering-correlation-id: 98b4d717-eb13-4ab8-c3e9-08da9fd2ab06
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d8R5UJkPLlF41ePSxfQ9l07WOSVMemk1WR+KS/0MzX+1EmrS/NFcNUzskkds0ZerwZpHKCfNha4E9ekYGj/RRMJsMIv9dmIvt5WGSbRghXX3BC28A3TcORfgDdFz72Hko5yXHobQxZ/5hjhJk0Jd0CuTSMHdJlnI2WTKzACEFFgY0Jo1i13N3fJYRvdpGQSPRJR/ml62X01lPXDO1HzBCTFr64CfVazdArXF9NeoB7JvYjIfxmJ1kqtSUMhpEvV4YMh1j28c1Iol4KZskhAds0fZPf8vRLS4C/vq8x7zjkpmzIw/QRhI0WGbhFxKiUu6DBO7eF+zJHZROW8yimvEUXX9w0NLMRISTIs+j9ENZ27aqBc2bpCaVwjMJqC4+p23SsngBW+PbJLR3OkKfgM6f/orrqtw99DbBVuwSkLsEqo+uAPmy3JY2ByGmeNn25Ul70bhspfol7g6PtJBHaiA70hgPFfNmh2mbKz6rqKAWOEpnG6PmiasAsHXZLkItYfCnjyNaaeKXh9LNjLD4Zg7G5CMI/oPOdSQheDrdenN8eGIDrDGTcVXl40X8KHfiZmkPP41IC+uU+Qccb9wKQn3VdpuoC+liESX48j45aL0ejoqtxoofmpqReZ15MRcFjAjIV2YNausYEWQfeUhxoFvVVLBTSJhlPi2aTTSqQ6ZrPuGfASGaKBp14QHNc0Is4wEKYn0wUGtYhXscM0M6xQ7umlfGeSKcCbf7kvwcH9jYzBbyfj0nHUjoCktol0/ty5l/kegSzmF04/UAUaNDI/KSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199015)(76116006)(26005)(7416002)(66476007)(4744005)(8676002)(64756008)(4326008)(6506007)(66446008)(66556008)(7696005)(8936002)(5660300002)(9686003)(52536014)(41300700001)(38100700002)(82960400001)(33656002)(122000001)(38070700005)(55016003)(66946007)(186003)(2906002)(54906003)(110136005)(86362001)(316002)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmF5TXB0L0FNVFNRUFRnUGorTEFhQ1JuWGlaVGptc0hkZWREbmgzTDl4U3Zq?=
 =?utf-8?B?dHFUNldyS2tRN2trbE9HbVRuWGVBVDlzR1FvK24xVkxlUmg0OFBoK0pPaEFL?=
 =?utf-8?B?UW13TVNIZzBJQnV2NitERUdqcVpxTE8xUTUzOTM4SzNNbUJxSU9yQ3ExdWhC?=
 =?utf-8?B?ZTRwZWthaUZHSXNvcnZ4ZCtNNEc5OFhzWXBmMzBJRWhwc3hBem1pRG5WWmM5?=
 =?utf-8?B?K3NXRHdGWjQ1U3A5em1FRVNsbXBXZ1hSRWVtb1RHUGlOTUxGWnQvanJKanNL?=
 =?utf-8?B?TDA0ek8wTkVxQW5YdWZrUFZWRVpKK25hamoySDQyNFN4Sng2Qi8vN2dLZWE5?=
 =?utf-8?B?ZXYvdXBDZDFPMk5mY1pONGxsV29pei94MyttcGcrK1RhM05qODQvUWxDOWJu?=
 =?utf-8?B?WE5MZkVpOFlzSWR6cU5aV2VVOThDQVdiVUcySk5mT2lGRDNOZjNJbzQ1amIv?=
 =?utf-8?B?LzdBdFRaaTZpY1J3UHlEOWZVWjM3S3BVUEhLanIrNzlJSGlVSTFSQUFCSko2?=
 =?utf-8?B?WThUNVBUaHlmbDRhWUFiSlRhQUdJQXJPOEJtbGtENm45bFR4QkY1QUM2WkJN?=
 =?utf-8?B?SG11WkRmdUxmQXFRWmRTSmN0aCswTG9Ta3VyZDNTZXZDU2Nqc3Fkc28yaHlz?=
 =?utf-8?B?b0gyWkFGMEFjcmJJT3RrbDU2ZG9ha2JGaTZ1K0t6b2Z6MkJJK1J1Z1BUU3Zr?=
 =?utf-8?B?bk8xM0ViR2d4em9jTEE3NE1JM3g2MVgxaHJWWEFHR3JPY1VsNlJ5ektrVWNs?=
 =?utf-8?B?WjNsM2ZObHR3d0NnSk8zWTdjUDc2NXNTUjdkVVQzeVJTZGw4cnc3aTlITW9Y?=
 =?utf-8?B?WmtWLzZSNytsTmpadDVPRDI3VHNvMWhvdzBxYnB4Rks1WTdWL21FZ2dCb280?=
 =?utf-8?B?UFlRWHBweUFxWXpUT3NiTjRRNWd2cGZrK3VmckIrSkJjc05pUnJNNHNkTjdJ?=
 =?utf-8?B?Z0E5YmJEMWlHVlBjWEUvS2xTL1k3THBoNmtaNWErYXdUS2JQcjNJbGkrZUxI?=
 =?utf-8?B?cXN1N2NjeWJDam5oRkc0b3pBcVRBUHk2eVZZb2p2T3YwdWVLRlY2ajNQZGpC?=
 =?utf-8?B?TVdHVCt5ZmN6WVNQWlM1RlRSUDFjSHF3QndxU1Q0Q05lZU40aGtoYzkrZi9Y?=
 =?utf-8?B?QUorTXhGQTViRjQxTmJ3Ly9yUzM2QUJkRWpHeTc4MnN1K2JqdG80cHB4c3NY?=
 =?utf-8?B?NCt3cmYwVFZHNlhqblBtTmYxcnJOeTdWdHpyRDhXUHJpb1Fzc1J0MlpVWFV6?=
 =?utf-8?B?SWVlYVdPeEI3dklNZW1EbGxXUmtBNmdLZWx1ckFBMVBicU5HNjRXUXFFWFYr?=
 =?utf-8?B?aGwxMnZOaHQybExvQkp5VnhKWkpsRk9aUEdsYW5Dd01SSXNtU3Y2QUNoQXZz?=
 =?utf-8?B?WmFkbzNKQkdpQkpUNmtyeEpGbGppK1FJVW9hZFVhZElRUTE3NDFHRkR6ck9J?=
 =?utf-8?B?eGNNWVJuaDdUZWk2bjBvQXd3NzJVMlVRTytVT1VNNzNkNWhLNDFHK2RWV1B2?=
 =?utf-8?B?aExMbHl3UmhmaExXMnRpVnlwbnB6eTgyVlk0WjNpR2VtbDZHQyt6SHVqWnZR?=
 =?utf-8?B?SnBtY0Y0OHBEcE84TThTREVxeFpNUEJvS05SVkFTc0NNM3NtWFFLMnEzbXNJ?=
 =?utf-8?B?TTlFcEJsd1BXclRwMXlNbVMwQXUrREJISVlSZUlVdHZSc0VMbVFTRDFFeDAx?=
 =?utf-8?B?ZStZQXlsUzFZcFZXbzF4eTNqc0NwY1BPSTBCL29SWnVkT0x1R0NsbTMvbFBt?=
 =?utf-8?B?eEV0bjVJTEZWS0dST0JSUG5XQm5VUVBqUlFlZmhBZEtOdnJ2Wk5KVmZxSXN3?=
 =?utf-8?B?RG1zT2wvZkYvSzRsdXRLeEJzQURJZzhRVzJrZ3NaUGZ3bEJ4NlZOQmloTitJ?=
 =?utf-8?B?cnA4Q3BjM0NtNGUxbDJBL1lyNHhQcDBCdG11MVI3Z0NDTWlHVFJDTHlENFFu?=
 =?utf-8?B?dEpXMGhLZzJEcVdiTXR2L1dGT3dyZmprWEJiRjJncHo2MlN3ZURRVDhUeWp1?=
 =?utf-8?B?c1JncXNVcHcwc1ZHUlhqbGVLUElzc3FHajZjVXFNV1VmMDUyVG81ZmF2UDNS?=
 =?utf-8?B?eDA4UU5zR0tPanhWNUZHT28yNWdkQVJPVWk2YVY1THFtZWhVRUduUGFQTVRV?=
 =?utf-8?Q?KqkA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b4d717-eb13-4ab8-c3e9-08da9fd2ab06
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 15:20:38.7017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mJdLnV5XEBGOcyVbiEu0vkJw/qp/RACK2Fi2Ws3WARKjPzLzlneGTKI84sKoM7qZcF62ydNufYQE3FGVeEKi6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6735
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pj4NCj4+IC0gICAgICAgICAgICAgICBpZiAodGFza193b3JrX3BlbmRpbmcgJiYgY3VycmVudC0+
bW0gIT0gJmluaXRfbW0pIHsNCj4+ICsgICAgICAgICAgICAgICBpZiAodGFza193b3JrX3BlbmRp
bmcgJiYgY3VycmVudC0+bW0pIHsNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgIGVzdGF0dXNf
bm9kZS0+dGFza193b3JrLmZ1bmMgPSBnaGVzX2tpY2tfdGFza193b3JrOw0KPj4gICAgICAgICAg
ICAgICAgICAgICAgICAgZXN0YXR1c19ub2RlLT50YXNrX3dvcmtfY3B1ID0gc21wX3Byb2Nlc3Nv
cl9pZCgpOw0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0ID0gdGFza193b3JrX2FkZChj
dXJyZW50LCAmZXN0YXR1c19ub2RlLT50YXNrX3dvcmssDQoNCkl0IHNlZW1zIHRoYXQgeW91IGFy
ZSBnZXR0aW5nIGVycm9ycyByZXBvcnRlZCB3aGlsZSBydW5uaW5nIGtlcm5lbCB0aHJlYWRzLiBU
aGlzIGZpeCBhdm9pZHMNCnBvaW50bGVzc2x5IGFkZGluZyAidGFza193b3JrIiB0aGF0IHdpbGwg
bmV2ZXIgYmUgcHJvY2Vzc2VkIGJlY2F1c2Uga2VybmVsIHRocmVhZHMgbmV2ZXINCnJldHVybiB0
byB1c2VyIG1vZGUuDQoNCkJ1dCBtYXliZSBzb21ldGhpbmcgZWxzZSBuZWVkcyB0byBiZSBkb25l
PyBUaGUgY29kZSB3YXMsIGFuZCB3aXRoIHRoaXMgZml4IHN0aWxsIGlzLA0KdGFraW5nIG5vIGFj
dGlvbiBmb3IgdGhlIGVycm9yLiBUaGF0IGRvZXNuJ3Qgc2VlbSByaWdodC4NCg0KQXJlIHlvdSBp
bmplY3RpbmcgZXJyb3JzIHRvIGNyZWF0ZSB0aGlzIHNjZW5hcmlvPyBXaGF0IGRvZXMgeW91ciB0
ZXN0IGRvPw0KDQotVG9ueQ0K
