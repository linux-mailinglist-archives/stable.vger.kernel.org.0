Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08846692C6A
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 02:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjBKBGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 20:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBKBGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 20:06:05 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7D375F56;
        Fri, 10 Feb 2023 17:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676077564; x=1707613564;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qx2R+mkFnEf/WFU6ygZXkgLosuNf1yMYOQBPxKddLK4=;
  b=Ny7bXOxUDqv6u4TaGMoBWtNvMQOSJhoVaqUnGnFSxMhl1ZCJ0MB4a9HU
   ptX8Uax7fo1ySIyMVB5mJPL+rJ9ScVOUJPTJy42hTVnI7azNqmLVlmngD
   lmpWIz73UCp4LOxYpem4sYe+eouRyLWbeaGVGzmVHFyvOZuJjRrBofcSQ
   Ofn7ErwkNAtoZc6A7RQqsUWkrcrvOPe8t+AP7ywc0n1m50k7PHXZ+0Y6J
   5aEEIYhGx56+hz8gqIK7ezzOlTbOO4MYbH+tig8AJAktoOrFBLulPs2MB
   NwU3HeGpWNwPT1Gdcz0wS+vbZMReTmTXPEHP5vJw/MF6LmyIb6XdbefW1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="314209477"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="314209477"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 17:06:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="997124870"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="997124870"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 10 Feb 2023 17:06:02 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 17:06:02 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 17:06:02 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 17:06:02 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 17:06:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7m7UUZsh3IqYVXQURkFitfckOgIWBLKjbzdPqQSMFty/TFqMTxFJSLfcv5da0SWLl5gMgSmkH9bA3BreHp+IWpGpbFiPsJhu3QZ78k+bULAp/JfZSXzfFVpBGoM10DwOKZz9wZZg75uWWkmEvLz1YEJxUmCRa4djofGZhWyrm/X0GZYHxu/48jwR1K6VJ+Ft/9FBsc3srDooe0z6x01aR3fBXONfYkwi0XNATyAIrOHeAC33M3XvewucWf852FLlu96du5w0+12vRzmM+7uyg0fPf6Gcfv1h+eFhHBggo/LdIMxi9ZEE7ADrBOal+EY8eeHpNK16LVvIydN9yBQuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qx2R+mkFnEf/WFU6ygZXkgLosuNf1yMYOQBPxKddLK4=;
 b=ZnxsuI19cvjY15g6dTJ8mpFePStEFE5uXnQTjwRCEiQNhKMLTIOa7zbzSX9A+YfwQHIPOScD6luHsTG+U9EgQDbX7vdv7MoxcCI4R7LSX0ZqPrGFQISKsW2HgB0muqaohhuNUBHMpRIL8ojUXkPbGnWHnd6mfbu5TVIqOr202IEx8wNhNwT/M9GcE2EZSirFZnEzcQZZd+4m+WXGwQssa50Jdjly6z0L4CLsaTayb95XQ3PMaSL59U2m5S6QqBW3DfQe+n0ThuKshU89Fyv90+U/rYZ/Eqq74kPlc8WshsjKBNCq0KYVay2FmDqLR1PpKpjnSKl/Xm/UVyhGS553Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6171.namprd11.prod.outlook.com (2603:10b6:208:3e9::13)
 by CO6PR11MB5585.namprd11.prod.outlook.com (2603:10b6:5:356::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Sat, 11 Feb
 2023 01:06:00 +0000
Received: from IA1PR11MB6171.namprd11.prod.outlook.com
 ([fe80::52f:ae62:7fbd:600e]) by IA1PR11MB6171.namprd11.prod.outlook.com
 ([fe80::52f:ae62:7fbd:600e%9]) with mapi id 15.20.6086.021; Sat, 11 Feb 2023
 01:06:00 +0000
From:   "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
To:     "Luck, Tony" <tony.luck@intel.com>
CC:     Borislav Petkov <bp@alien8.de>, Aristeu Rozanski <aris@redhat.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Xu, Feng F" <feng.f.xu@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] EDAC/skx: Fix overflows on the DRAM row address
 mapping arrays
Thread-Topic: [PATCH 1/1] EDAC/skx: Fix overflows on the DRAM row address
 mapping arrays
Thread-Index: AQHZPIrEiNCcPcg1/UefCINIyHIFLa7G3zIAgADo76CAAKGyAIAAhlfg
Date:   Sat, 11 Feb 2023 01:06:00 +0000
Message-ID: <IA1PR11MB61710A47690BD5DA2826F29389DF9@IA1PR11MB6171.namprd11.prod.outlook.com>
References: <20230209133023.39825-1-qiuxu.zhuo@intel.com>
 <SJ1PR11MB6083CC9171E90537D09CB9B4FCD99@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <SJ1PR11MB617933E74BB2D538C0426A9589DE9@SJ1PR11MB6179.namprd11.prod.outlook.com>
 <SJ1PR11MB6083F2E23723D45E52614E51FCDE9@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB6083F2E23723D45E52614E51FCDE9@SJ1PR11MB6083.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6171:EE_|CO6PR11MB5585:EE_
x-ms-office365-filtering-correlation-id: 63eb2c1c-a035-486b-5a82-08db0bcc2395
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mWCv1ksIomQloooi4etrr9eAXmwZ1A/AE8sII3sZ0ZPd82lUn2wlZfABKwo5nZsPtjfONwCkNCBuREaZSCXk9pirOo0wi6OqQS792alUG6ooAGtn+xRqHcDKh8Th6xzSFdRTaA9LzSXcnZDLk2SdPsftBIFrUSk8kP+GwFff8PXGEOZLFRNCZ90NOSF6k6DFqvSvBQ6wvY8Nx2rhu4J2zi5hlOTO8wqmksbsAbDEfpfc6c25ZGQ9Rh8deU1UAPhuHTg1Y9pBCkNDu5Z1U4nosy37UrfKQL0l9zRG2H77aia2+jJNe2puGLL5J/N8vKIfORor0VlbEx7GfBVI12LdX44xOFSu/D8nQSUheQAQoQ2gBN8wiHRuP+C6pJ7Vq6aBUsgfFYm8VAO7gPDgAxkX/9FUfyFQwj03eI5v/g2uOcgMkE9wcCuOnXTMCO0QrcZ3ROVy0qc0t4F6mTChSYrkKQb5D+GDt9LPAvKelSmecYxXWlwSUpmiRdesnD+kzN4PyfBC9TM7Ojdp4c0MQykPbWDqtiI/dihNRYsdbGOmNOKB4qi5/faICWDL4ZExRoL98XlDER60V1BTFsvZ7WoI06TNgWiZImDkfl2rXS86nPlVvHG+XCp2AE5j/Vjhjn7D8cxYApyamMnRWeGAEeO80g1P9M+9JFc1VRn1Q94XuFQCiglBiiLPV/gwYaB28lrH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6171.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199018)(6636002)(86362001)(52536014)(26005)(316002)(5660300002)(54906003)(9686003)(186003)(7696005)(478600001)(55016003)(6506007)(4744005)(33656002)(71200400001)(6862004)(2906002)(38100700002)(38070700005)(82960400001)(122000001)(41300700001)(66446008)(66556008)(83380400001)(76116006)(64756008)(66476007)(66946007)(8676002)(8936002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2NiNURQME1SZ2JRU0lGV2d2OEMrMnQ5QjNLSHlYdE8wUFZER2pvaHIyN2Vh?=
 =?utf-8?B?VHphVDZUTFFiSU5JaWtMd1IwcTFjNjBhUE1HVkVMN3oxT2ZhRm1sSTRiM1BV?=
 =?utf-8?B?MmF2YUxxYkI5eG9vY1ZIanM1aGFFMkE5eGl3SGRIdjZad0pFU0RZYWlDR3Br?=
 =?utf-8?B?SjhFaXNPWUhZeHZRK01XZno1cFJoSTA0MStQQXpqTy9WUHQwdVdKb2pWcEZs?=
 =?utf-8?B?dWVMcVFoOXJUOUJqWVVQSWU0QmhEZk1IeGRWWE1ULzlFL0RTak41SXdKTXZG?=
 =?utf-8?B?dUxJNXU3UWY2RkptbEFRZDZwa21XKzg2MGlVN1E0UDNZaWxsU3p1OGpUd2Q2?=
 =?utf-8?B?a1lzTVVVVjBITmo1SnpDdnZKZ2JUVnNiM3NmSEEyUVg0L0UwVWRwNzRmeGFh?=
 =?utf-8?B?NU9qZ1pWL2xqamlYamRyeHZQbVNGaDFxTWx5clpnN2VuY295SHRsckNVekwr?=
 =?utf-8?B?TzNoeFFhTStndDZPWFB3cHFaZTN5VERRMDZvallhaXpmMlVWYkliRDlxb3hO?=
 =?utf-8?B?YzlTRFRUc1FsZlZUaUJ0Q2RrQWpFZVpHaEovY0NsRkhxaEVIUUhzdnF2MVE4?=
 =?utf-8?B?MHpyUXVNbzI4ZTZVclgyWE9XNDhOSUV0ZSsybXkrWm5vQ25nYlZ0bVJiMm54?=
 =?utf-8?B?TVBQQ0JkY2MyVGRYcjUxOU5jS3NrbzRlV2tjTk9uMExjN2p3cDB3akxyUFdH?=
 =?utf-8?B?RlAzWEV5VHNndjdoYS91TWl1cmJDd3g2d1NFKzVqU1dhZ0Z1b1V3YlYyOStq?=
 =?utf-8?B?YUpiMlc0dzZuL1pwVmU3WkNEb0pzMkFkUDJCYmN5cXNlQVlZZXZMTUNtZlc2?=
 =?utf-8?B?dFZKQ3NLTzRJazhmWWIwUlNHTjR1Y0p4REJpQmJzSzFxaExUVVFBS1ZCL1Bm?=
 =?utf-8?B?Tzh5bGRFbVJ1WVVWUmd6V2ptRytVS096UVNUNUNwYWptYXVnVnlxN28vNjVq?=
 =?utf-8?B?ZjVKV08wZG5pT2RDaENZVFZRNUdqckdjcDcrRFc4a29GS0hsUk5lY3hPNkcw?=
 =?utf-8?B?eFJvQVJodEFEZkwxYnB6R2VxZEhiaVNuVTVZcHJ6a3JickR6QnlGRmxFOFFt?=
 =?utf-8?B?b2xwS0FDY0FvSGZWMmFDM3NqTjBrZy9HSzN1Q01FWjZMWmgwNThzcm5wUXN4?=
 =?utf-8?B?VTBZVzIwN0NoU3NTRzNqaG8zWkh1S1BrOWpBWld0L01OdmorUnpPbi9MU3RY?=
 =?utf-8?B?ZVUyMDRvZzlIME8yR2kwbUVHenNIZ2FDaXF0VU1USHRoamh5blliMGk1LzNs?=
 =?utf-8?B?N2RkNmVSTEJSbXR2RnRzM0VZb0VJMjJ5bWdSaVQ2SXYraTZ6UURlVjFvR1pO?=
 =?utf-8?B?SVhMQmlKWmtxME9CQ0VsdnAyYVpaVXIrbGNEdUxPTlpDT1ViSS9QbHFTTWhP?=
 =?utf-8?B?MUw0SFJKNGU1RHpUVzZLSWY2a0RJaTBpZTNHQjh5d0F1bXp0R3hLcmhwVktL?=
 =?utf-8?B?NisrWkhRTFpsSE4yVUM3WU51S00zY252MjVTVmZNRFZlMVpTZWo2aFcwRFY5?=
 =?utf-8?B?dUUzOEhJTTdsT1VHWnBPWWMxL1IvS0lZVE5VekZEazVubEczQ0NjemRMZ1Bu?=
 =?utf-8?B?elJxS3NCVHVvb2YwbEloa0JFSjRSVk1LQ29GYWdOTmNjU0hsR3VPNTM2U0JV?=
 =?utf-8?B?RXpaVDQvcUo2UmpnL3RiaWdEcytWeWptMURIRFNhbnIreWFjMVNIMDNBa0pM?=
 =?utf-8?B?NEJuK1dDUU44ZjhQeTBHVTZBZmFObjF6SW53RTF5Uk1KQkxQNU5EUDBkaHA1?=
 =?utf-8?B?d2RvaExWR2kxZHBBYUVTc1Rpcjk3ZW10VnpNRG9ybmFPbEFYVGhsWW02eGJK?=
 =?utf-8?B?NGZqb2VDQmtxSytZSUpFelNOaTVqMUZ1aU9GTlpZYytNaXNTczZOWStIZnNX?=
 =?utf-8?B?MEZvaHRDWXU2Q1RueDQ3VS9qRXJhTEdpQnMySE90R0p1MjRtb3pmQ1FraGt5?=
 =?utf-8?B?aGFKTnE1TTByV2YrWlZacld6S3NyT0hEcXpyTlA2WCtqWkdnSFpJb09KKyto?=
 =?utf-8?B?ZGl4bkNOQ2hLQ3A1YkVxUlBtNkFZK0hBL3h5dmpvR3NZcVMvWXZ0S2NqK0pr?=
 =?utf-8?B?K1B5YlU1R3hjVVU4NElUMk94b08wMnA4L0JvQktQamJSdjFEbERxSzIxdllz?=
 =?utf-8?Q?rnnthY5OI/syAaWprkMT50mhB?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6171.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63eb2c1c-a035-486b-5a82-08db0bcc2395
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2023 01:06:00.0813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vyeH+CUlpDbVpPUDkqx/XS9PU+lDx+OREK15Vu7BOMwMlm5PVqFCB0KN8AruRKEkn2Rh8n+iM7Vjg62Q/W4yLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5585
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBMdWNrLCBUb255IDx0b255Lmx1Y2tAaW50ZWwuY29tPg0KPiBTZW50OiBTYXR1cmRh
eSwgRmVicnVhcnkgMTEsIDIwMjMgMTowMiBBTQ0KPiAuLi4NCj4gPiBEbyB5b3UgdGhpbmsgdGhl
IG9yaWdpbmFsIGNvbW1pdCAiNGVjNjU2YmRmNDNhIiBvZiB0aGUgZmlsZSBza3hfZWRhYy5jDQo+
ID4gKHRob3VnaCBpdCB3YXMgcmVtb3ZlZCkgaXMgdGhlIHJpZ2h0IGNvbW1pdCB0byBiZSB1c2Vk
IGFzIHRoZSBGaXhlcyB0YWcgZm9yIHRoaXMNCj4+IHBhdGNoPw0KPiA+DQo+ID4gICAgICBGaXhl
czogNGVjNjU2YmRmNDNhICgiRURBQywgc2t4X2VkYWM6IEFkZCBFREFDIGRyaXZlciBmb3IgU2t5
bGFrZSIpDQo+IA0KPiBUaGlzIGlzIHRoZSBjb3JyZWN0IHRhZyAodGhpcyBwcm9ibGVtIGdvZXMg
YWxsIHRoZSB3YXkgYmFjayB0byB0aGUgdmVyeSBmaXJzdA0KPiB2ZXJzaW9uIG9mIHRoaXMgZHJp
dmVyKS4NCg0KVGhhbmsgeW91IGZvciB0aGUgY29ycmVjdGlvbi4gV2lsbCB1cGRhdGUgaXQgaW4g
djIuDQoNCi1RaXV4dQ0KDQo=
