Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309F75FDEC8
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJMRSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJMRSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:18:35 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2799D2CE5;
        Thu, 13 Oct 2022 10:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665681514; x=1697217514;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EuXBDDNFsYSkbNTHcq2sGGeItRNtdLE2toEebqp1/dA=;
  b=cNOcErOiuoq9Kw7jPU6wYUrKH+eMuCboPgTGNh3C2gxdc9RKOh9tg98+
   EEOrllI9AO5cIS/7eFi2TiiHckpSit2nHQqkKVRQjJEdGg0h9gm2ufxxb
   RmAG11B74ahXohLpk383FibpUI6dnczGM1bIyir7y8DGlkXZmrjv/NI3T
   xbsyhFC/ajpAk9mzzeWFJThakyYvluNW8P4tCW3XVSMVA0gFhW9iA0fji
   x4xtNDtgXmkc5reQAhnZ4kyZ7nqD5u8rxhLnFPf0Av7Eo1d2xbNS9hjkf
   G9o1unZXfzqmoL4uVjKnZiGZFwMI66G0BCRBQttu3g3T16DMJtxnHGmDA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="288431882"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="288431882"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 10:18:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="731956214"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="731956214"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 13 Oct 2022 10:18:33 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 10:18:33 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 10:18:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 13 Oct 2022 10:18:30 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 13 Oct 2022 10:18:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STV700XLH23HAOpmVa+guFlvbdxG4mJkRAHEYutJI973PmVJKXuJURpDP1IAgzD9/ZkE/u7t69a9hkpzzngmCnyPtw+HYx/gu15GRZQfa9Z1bOWnlJBQhaKriMHmK+3xKVVxk60FtzxDDpL5QdP24ZZwVqnrR7qSTYYTiQOG5bHjNeAtPsreo07BL6p3EmNDjRaJSfLizBJ8EKNcYWqlfrL1qhc6cWoE8SRDlM6WPdNeJVOQCU0Goz9pCJcocbhm/q1Rfk6yhi431CaZP8kXlUZDtlsy8SV6NYGnG0SPvbxSzMaEDvfN1tmEVmy9TEHuSLCidI+hmxeiEsPIRivcMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EuXBDDNFsYSkbNTHcq2sGGeItRNtdLE2toEebqp1/dA=;
 b=AtnpLTLrHmQun+7CSMQpQUmGEhu6P1ZmGApHDBfgHeQ2QNJfVaJZugk/BmeoaLMZb5LyLaZdrp7NayAm2Y2wCzI/WVjdZeoUDLn4rHRmRiBcytyiWqyr2UWvhVCYsHw5cfUkNHH9cNGTw2GDJbzv3DnVq6UaaA0IEII22RMa1nDmATPkhpZnQnNlCeQhy6/dTih+7NGpcWj7h0vCn6xGjndoTO2c+3iOJC6smYOPMQP8uodZ9ktCgtnuSHMzgTz+mpqNaFvjG27NfAyMgkX3WWLHEKuZvz83wF6vus5RThOfy9tvu15YDyks45n3dZLtHZQWSX5HmL7nv8w6UKVEhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by BN9PR11MB5323.namprd11.prod.outlook.com (2603:10b6:408:118::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.28; Thu, 13 Oct
 2022 17:18:28 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::10a6:b76c:4fb1:2d60]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::10a6:b76c:4fb1:2d60%5]) with mapi id 15.20.5612.022; Thu, 13 Oct 2022
 17:18:27 +0000
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Shuai Xue <xueshuai@linux.alibaba.com>
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
Thread-Index: AQHYz+pWnxyJgYboZk+A8TiiA+I2Ca3u0zyAgALE/YCAAD4LsIAA0nMAgBlb5oCAAKghQA==
Date:   Thu, 13 Oct 2022 17:18:27 +0000
Message-ID: <SJ1PR11MB6083F89F430B664FC10270C6FC259@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20220916050535.26625-1-xueshuai@linux.alibaba.com>
 <20220924074953.83064-1-xueshuai@linux.alibaba.com>
 <CAJZ5v0jAZC81Peowy0iKuq+cy68tyn0OK3a--nW=wWMbRojcxg@mail.gmail.com>
 <f0735218-7730-c275-8cee-38df9bec427d@linux.alibaba.com>
 <SJ1PR11MB6083FC6B8D64933C573CAB64FC529@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <79cb9aee-9ad5-00f4-3f7a-9c409f502685@linux.alibaba.com>
 <8313d192-f103-35fc-2931-de0a8eb927ff@linux.alibaba.com>
In-Reply-To: <8313d192-f103-35fc-2931-de0a8eb927ff@linux.alibaba.com>
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
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|BN9PR11MB5323:EE_
x-ms-office365-filtering-correlation-id: 254abb71-4a65-445f-2e28-08daad3ef198
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: efEGbBPZv4ofp+DiMu4UbbbqIc/isvWHSxSTBqKlffTg2FZDy/FJHkgIqRZ40Q5Y/aZVjsLAJn7vgdr9BA+T53Smsh0euPXjcl5e5hxZUcwQmLJCiw1N4NMZJSnjxzoUyMoKLFqjJPS4HfypS31e7oK1B8AiHfWzhHpBtTXyOWTdNmH9K258IWsiVZoExO48ysYK8N/41TpAEA6NSYnaWFDavi7cHf3+n17kRyH2/xzFkdU8o49ERwDbw/dqvvOABEilraGz93TzFSP4IV3oVKho/Yc3NNQH7S6Iu8vUeEBFb+TOXndzmtIEujA6xgduWit20zpeaDjfDQTII0ZXN8OnA9ZTHKkF0Dj//hp9FQIkRYwCSq3NDINMVM0UeM2YrsmSiWYolGItJELDGp8WpcX/dyL2gXv40l08CgnpMxACf2Me3EQqavAwaLLNEoa9tKSZPljhFP/Mhk6ISKO1ZDbepuV0MyjnokCmNJKSIvDrq7uWMNB61EYaRmIFqlPXQbUWtYDL5pwxP5CQvN52RwZsulZU9i3nox/laGryzdDLiYqC77yTLEk15tpyVpZqeXcMIZQzxi4ffTNuPj7D5+X52HzAnHwpwv7dI/m6YtfwFjc6DZ1MnPrGxV48SK4TDAIm/epvSbwScuYgO4xFmEa9ufVD6dHte6rX7WLpc75bUQUYCQYQmMqNiYzk206Z5bdf4uov30SxEq8wET4RvYTA/AGdbPsIFlnkIMW6ZXeQGXhIPlTuF10KjuFTGFuQe8uShDBJf4kHbYfX9QCIvbBGCbe9QXcEhsF1FnuHBdU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(39860400002)(136003)(376002)(451199015)(83380400001)(33656002)(66476007)(52536014)(8936002)(316002)(66446008)(86362001)(66946007)(8676002)(76116006)(54906003)(6916009)(66556008)(64756008)(186003)(9686003)(2906002)(55016003)(122000001)(26005)(4326008)(41300700001)(966005)(38100700002)(71200400001)(5660300002)(7416002)(38070700005)(7696005)(82960400001)(478600001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2c2dkk1UW9qeDM2WUtmQk03dHo0L1NLTE13Z0R2SStoUE5tbTBPallMYkhk?=
 =?utf-8?B?RWpFYXRlS3dBRDRMaFBDWVZqa2oxL01INnoxN05EdzNka1JaYXRVcS84aUxF?=
 =?utf-8?B?bytlWlZ4MEZDU2l5czEvMnFadEVEWEpBT0NEWkM0Rm5USFhseEtJd3Iza3R5?=
 =?utf-8?B?blQrZUNFc09UbDRpSC9YM1drelk3NXpjc0J6cDQ3cmsvZVBpbERLajFFckMr?=
 =?utf-8?B?VWFDUFFpUjZnMXVyc3YrSERPQlZEUEhUeGpHMUJOR3ErOWZ1ZHdIdlB5d1FP?=
 =?utf-8?B?b0ZJMjRXaStrM0RmWkFmK1lyQ0NZL1R4c3prSFZybTlQbFFQeUM1T1NPUW44?=
 =?utf-8?B?TTVvSW51MTIvSk1kdU4xQUJ6Q2x6VXg5eDR4SW5Rdko3YlljVDIwdnRYSlJ6?=
 =?utf-8?B?TFN1SU15cGhUZ2s5VnRlWUdBSm5oMDh5ZGZ0SS9UdFYwSlJBWjJpdUpuRGtH?=
 =?utf-8?B?RDFEY3VGUnkzK3JIdFBlTzcvYWdGbVNKMVNLa2ZKVjkxcW4wMmU5UzFWZE1q?=
 =?utf-8?B?UjhaQ1BzWE5QeEtYNVdodGFwcjdaTmt3eUxaNGZTMzdDUEx1WGMwZzdmY09h?=
 =?utf-8?B?U256RjVzODZMaUJLMHR6UlBZM09JVkpBeVNBclBoVGJvbDltSHBTM0kwVWg4?=
 =?utf-8?B?bmlQQmIydU95YmxEcnprSW9oWStLZnZrL3VOLzRXdnc3NEJ1WWZPa1ltdGhn?=
 =?utf-8?B?WURraXQ3VzNtbmNLelNmdTUvL1ZqY0F2VDN0WE1XU3NGZUl6czk1bGhBWUxq?=
 =?utf-8?B?Y3llNjdhRW5XTkJPai9JU2ZnWDlqMHhmbFErbUM3b2s0MGk3c0tTd3E3UjFn?=
 =?utf-8?B?QmI5VXdXa25qSEJwWjgzSTBQL1V5VHVwamFIZ1huR013WkNPUnhGY2txY2Uv?=
 =?utf-8?B?SWZXQnFUOE4zWU92djErUXZTaENzTE1TT25XdVpjUGJZVHAzQWxLSlV6MXdr?=
 =?utf-8?B?NUNsZG1YNVJBN3pITndyTzhEb1Rva254K3Bja3luTnNncUg0dnk4Rk5JNGM5?=
 =?utf-8?B?Qlhvdm0wN1p2MU80YkVhekJneEdZWVRCZFlzNzhKSkIvRUxTWHorelNPYm93?=
 =?utf-8?B?bUdZTUtEejFDS1crWW0zYzRuZG9uWW9JcS9laXpyNVRZdE9iR3M3ZW5xMWw1?=
 =?utf-8?B?N2FZZVlOZFhYV2xVNWlUVTF5MyszM3o1Ky8rQW1KYUozTlQrREtJWjBtcHJZ?=
 =?utf-8?B?THZUN1FyQ0NHZm15azgvd251cVpZUmtQVXY4a1F2SFJLdTNONGh3N0ptQVBO?=
 =?utf-8?B?OC9jbjRVOCtFWUlPcXlzUFprdUJpcDBvQWRpS3h3MmYvOFI3OXNmc0NQTEJh?=
 =?utf-8?B?RC9nekxMUCt1L3dvZGZRS0FUSWF1Y2c3NVo0WDhDZnduN25icFptQjVRaDFm?=
 =?utf-8?B?RjBRYlZoZUJVTFhjUVkxNm1SQlQ1OTl3OG13V21YYWZSSDFDc0k5R0dWNUJa?=
 =?utf-8?B?SFZtaTFpWFZ2djZ1S09aZ01WcGloU1lxWXRFa2ZyUW44SXpUeWtydGF6VENX?=
 =?utf-8?B?WG1hb05WcEtZWm5aMTVGc0ZkSU00TVl1MUgraTNDeUtZN3MzR2pVbUFxWmFs?=
 =?utf-8?B?OVZEM2hRaUhkSk9UTVpNZ0hRYlhjcVFSQW9tSnBqVmw5NHdPbnQ4VjIwcGkz?=
 =?utf-8?B?eVIyWjF6VUh0Sm5rangwRGNoRnBSK2VzS2RMcURjTllhbGFoQ0QwY0s3Wmpa?=
 =?utf-8?B?aXVGVVVEWitwNkkzVHZZeVQ2ejN2YzlFRklDVU54eUEveTEzZkE1aEFSZHB2?=
 =?utf-8?B?ZnZNUGY5eTcvT3Fta1FCcEVlam5lNkpycE83aERpOWtkTlZKTTN3TzJFVHlR?=
 =?utf-8?B?aUVka2QrdXUveCtvT09DWFpRaDh4RDJjSmJHWE9LbFZQYVlGWlpDenFwQnI3?=
 =?utf-8?B?bDZ4c1VoY3pWRlZKdW0yMmVVR1lKYS9jZzdQQ0k2a2Q5dTZib1RpZVphcjJE?=
 =?utf-8?B?NnRuUHQ0bFltcnBhYmtiRVB3ZVBhR08reEVTOUhhMC9aMG1lVGVTUy9JamVn?=
 =?utf-8?B?WFV6Nlh0RWVHU1RHcmN1YUN1V21xVVFsajN3VDdrQ0thSzNkT0Y0TGwzNGtZ?=
 =?utf-8?B?WEk2UmRlQnRQa1ZoOXlzZTI3elNoTTVVNStmSG00NW0wZkJYcnlTbFhjRUZ6?=
 =?utf-8?Q?dmOOJX1LOB5WrHjxY/JAwp+wS?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 254abb71-4a65-445f-2e28-08daad3ef198
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2022 17:18:27.8737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hS4G9p0dYEai+bKhepUltt1khWOYbbOeHgO8AofNcfd/bgBMGRS7nkJKlH+0jVjHSeNmMsyoZyUOWXzhubDOrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5323
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBUaGFuayB5b3UgZm9yIHlvdXIgcmV2aWV3LCBidXQgSSBhbSBzdGlsbCBoYXZpbmcgcHJvYmxl
bXMgd2l0aCB0aGlzIHF1ZXN0aW9uLg0KPg0KPiBEbyB5b3UgaGF2ZSBhbnkgaW50ZXJlc3QgdG8g
ZXh0ZW5kIHJhcy10b29scyB0byBBcm0gcGxhdGZvcm0/IEkgZm9ya2VkIGEgYXJtLWRldmVsIGJy
YW5jaFsxXQ0KPiBmcm9tIHlvdXIgcmVwbzoNCj4NCj4gLSBwb3J0IFg4NiBhcmNoIHNwZWNpZmlj
IGNhc2VzIHRvIEFybSBwbGF0Zm9ybQ0KPiAtIGFkZCBzb21lIGNvbW1vbiBjYXNlcyBsaWtlIGh1
Z2V0bGIsIHRocmVhZCBhbmQgQXJtIHNwZWNpZmljIGNhc2VzIGxpa2UgcHJlZmV0Y2gsIHN0cmIs
IGV0Yywgd2hpY2gNCj4gICBhcmUgaGVscGZ1bCB0byB0ZXN0IGhhcmR3YXJlIGFuZCBmaXJtd2Fy
ZSBSQVMgcHJvYmxlbXMgd2UgZW5jb3VudGVyZWQuDQo+DQo+IEkgYW0gcGxlYXN1cmUgdG8gY29u
dHJpYnV0ZSB0aGVzZSBjb2RlIHRvIHlvdXIgdXBzdHJlYW0gcmVwbyBhbmQgbG9va2luZyBmb3J3
YXJkIHRvIHNlZSBhIG1vcmUNCj4gcG93ZXJmdWwgYW5kIGNyb3NzIHBsYXRmb3JtIHRvb2xzIHRv
IGluamVjdCBhbmQgZGVidWcgUkFTIGFiaWxpdHkgb24gYm90aCBYODYgYW5kIEFybSBwbGF0Zm9y
bS4NCj4NCj4gSSByZWFsbHkgYXBwcmVjaWF0ZSB5b3VyIGdyZWF0IHdvcmssIGFuZCBsb29rIGZv
cndhcmQgdG8geW91ciByZXBseS4gVGhhbmsgeW91Lg0KPg0KPiBCZXN0IFJlZ2FyZHMsDQo+IFNo
dWFpDQo+DQo+ID4gWzFdIGh0dHBzOi8vZ2l0ZWUuY29tL2Fub2xpcy9yYXMtdG9vbHMvdHJlZS9h
cm0tZGV2ZWwNCg0KU2hhdWksDQoNClNvcnJ5IEkgZGlkbid0IGZvbGxvdyB1cCBvbiB0aGlzIHBh
cnQuICBZZXMsIEknbSBoYXBweSB0byB0YWtlIHlvdXIgKGV4Y2VsbGVudCkgY2hhbmdlcy4NCg0K
SSBkaWQgYSAiZ2l0IGZldGNoIiBmcm9tIHlvdXIgcmVwbyBhbmQgdGhlIGEgImdpdCBtZXJnZSIg
b2YgYWxsIGV4Y2VwdCB0aGUgUkVBRE1FIGFuZCBMSUNFTlNFDQpjb21taXRzIGF0IHRoZSB0aXAg
b2YgeW91ciByZXBvLiBUaG9zZSBJIG1hbnVhbGx5IGNoZXJyeS1waWNrZWQgKHNpbmNlIHRoZSBs
YXN0IHNlY3Rpb24gb2YgeW91cg0KUkVBRE1FIHNhaWQgImNsb25lIG9mIFRvbnkncyByZXBvIiAu
Li4gd2hpY2ggbWFrZXMgbm8gc2Vuc2UgaW4gbXkgcmVwbykuDQoNClJlc3VsdGluZyB0cmVlIGhh
cyBiZWVuIHB1c2hlZCBvdXQgdG8gZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9r
ZXJuZWwvZ2l0L2FlZ2wvcmFzLXRvb2xzLmdpdA0KDQpQbGVhc2UgY2hlY2sgdGhhdCBJIGRpZG4n
dCBicmVhayBhbnl0aGluZy4NCg0KLVRvbnkNCg==
