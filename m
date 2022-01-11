Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B563348A634
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 04:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245410AbiAKDUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 22:20:33 -0500
Received: from mail-mw2nam10on2073.outbound.protection.outlook.com ([40.107.94.73]:31457
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347010AbiAKDUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jan 2022 22:20:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euwKkksb1TInQXHRgn9k3S7ZTz0pFVDRarXyZqNzNfbAQpkLYz9tDrKKzwnXUVxMKZz18rNRCMbQXFS+ndbhpaFLNip8CajtOy5smyJ09yRWSAXOH1K0iIkLSbmQL7g0Sy3TDjQA0mEr+qwBe3jplNqOzJoENrdkmATz3LjjCrLIS2Lb706BCe6kqTLD8T7yon1UaialpudVrb0PmiIsBBHiSh/8uBLLg+ubNmio6nIxAcuOjbEff2g9d8eDabUsojRhR/DuzYeVOyO8lJW3kH+ICQXvZeyY/+84kZxLUKiYCHFXhfTazc+58t4MhnlgdsjpWmhmnTbzNvJxscrTig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfUmWFde+7uyxS+ZkU21hK/9ZhuOH+Z9z1SOBxdYDqQ=;
 b=Fe4s/PZp8zd/l1IkVg0I3YBPDi7XrD9F7i4BhRjKGRcrgHL2ulgq6Ms2nMvLfrIN7lUTUCA8Y/whnKaUT4TucxQIBZ7RPXpEYMbk/YLTtEGLzWPLe/VHq7mEPUHHwmvpcwSx6nmKhtn3e2c/O5cOyN0IlVzTGhaHyDyxzQRmZXQxIgcBOKnCLhcHDLZf4hum9Dd/W2lgvUhOwlswrrkRVryhh6Hh8G4y78ZXgPLB8dngSHsIrVNcmy4/FVwFG3ycqb2JroH/X5QblIJ+sT6wrQFAiHHV7NA+zY5CZNi9JVf82vsdNqyOYXmrTTcUsEj0xW92EYJszPBe1F0wZgt9kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfUmWFde+7uyxS+ZkU21hK/9ZhuOH+Z9z1SOBxdYDqQ=;
 b=M0e/HTY1+ZMEq1n+uxOzYuaajoah3r5BN2n1+sGaOIg0J2JI8LBy3h5HEtckSeyRDosdcLL1fYNllnmbiYFTtBmHd6/4+XMz8KqnePm41WhXNFf9nEfACWx4TdlprU/83DGwiPeVDcuDtY5kEgVAtLOsDDD1lkTEE8hZvMkO9VA=
Received: from BL0PR12MB2465.namprd12.prod.outlook.com (2603:10b6:207:45::18)
 by MN2PR12MB3918.namprd12.prod.outlook.com (2603:10b6:208:162::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 03:20:23 +0000
Received: from BL0PR12MB2465.namprd12.prod.outlook.com
 ([fe80::65bf:c277:8d56:e18e]) by BL0PR12MB2465.namprd12.prod.outlook.com
 ([fe80::65bf:c277:8d56:e18e%7]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 03:20:23 +0000
From:   "Chen, Guchun" <Guchun.Chen@amd.com>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        Len Brown <lenb@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "Grodzovsky, Andrey" <Andrey.Grodzovsky@amd.com>
CC:     "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH REGRESSION] Revert "drm/amdgpu: stop scheduler when
 calling hw_fini (v2)"
Thread-Topic: [PATCH REGRESSION] Revert "drm/amdgpu: stop scheduler when
 calling hw_fini (v2)"
Thread-Index: AQHYBYR7DRufUzDbFEKYJq1cwZoF96xcbYsAgAACNQCAAAKtgIAAs8iA
Date:   Tue, 11 Jan 2022 03:20:22 +0000
Message-ID: <BL0PR12MB2465DC4AC9C28B4B950CDB42F1519@BL0PR12MB2465.namprd12.prod.outlook.com>
References: <8ab406c8bb2e58969668a806a529d5988b447530.1641750730.git.len.brown@intel.com>
 <BL1PR12MB514403767AC6BC6CD617674DF7509@BL1PR12MB5144.namprd12.prod.outlook.com>
 <2e3fbfe8-e7a1-2483-dbbd-ebb3824fc886@amd.com>
 <BL1PR12MB51441B895F9846A11D6268E2F7509@BL1PR12MB5144.namprd12.prod.outlook.com>
In-Reply-To: <BL1PR12MB51441B895F9846A11D6268E2F7509@BL1PR12MB5144.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-10T16:24:38Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=90ae8098-4147-46b6-a228-648f64a07498;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-11T03:20:19Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: e2b575da-dd92-4f5d-8ce6-bde27d0a2ddb
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20af25df-dd08-4448-5a13-08d9d4b14dff
x-ms-traffictypediagnostic: MN2PR12MB3918:EE_
x-microsoft-antispam-prvs: <MN2PR12MB3918CA137D6FE4486056A613F1519@MN2PR12MB3918.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hBfSqwZeZlHvkTP61yWjxhe0gPRdi/aFgPBejbxPusz8zfiWU+HmIfJXxJkcdHssegdmKRjHQsv2iEdwjqEoa6bPwNvFtyld246A82fQVPcyvPIt9ep7aE7UfGU82upHqvcgAYGtKpL8oBB71vel9b66qME1UYL204ZAb/FnyjjNnKwbxLK/VmpkCK06JC3dPV4+oUL6TNLzsOm3CByKnptKpMrsunLrI50yxqu4mctNqtP17QiT4Q5P3HDRxQ2DC83bNzwXy+mtu4vSZ47c+19DXDI40jrG0IiTBfkqIFwfaEP3veTaVLUOGcx06d16aTNGmEAgog46oalqRPK572ui2Jxia42Om/0cp+2Fph++CfOsBU+mSWbqcsrAWDHPVZsZCIBdxV0j6B9qpPkA766HPXG4n/d/TjASoF00SAkYv8KW2Kj07+ZIOAZcK2fx3w5qGtcrKKbT0CPWtC6+IFjTTl5RlajFTskCyIEUEYQ7VxvbfSFf3c6Zir6MQYrVOzsEU7cl98/H+BM548E84Jkie6P/zV5MdPD27Y358FK+Nc/tutVQYMIKxQzCe1whN9M4X+2M/k5jicYxNbh03A9/QCfrB9DObupczTP8H/bzDQUylwd7nN6131ba96EBjhJRq0tY0HWEDcRfiksaHPlJbqGTZ4pCYvttJGp6cYaVeUYIdLqwNbxn20JYfJwcklLj5qK3wRyzVzdPhbpmX4ybmFgu+xb52Yr8Kjt/YA5+65gGqdYotyhpgtQOj1i2Yvh5dJvvmamiWbl2yALW6hu+G39y4Wb1DuDPrqXnvB/m/g6tqV0KOXSB02U2s24JUCYSNNSxRry4m2dmD1sPgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2465.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(33656002)(54906003)(8676002)(64756008)(66556008)(66476007)(53546011)(6506007)(5660300002)(86362001)(8936002)(316002)(7696005)(83380400001)(66946007)(6636002)(55016003)(110136005)(66446008)(26005)(76116006)(9686003)(2906002)(38070700005)(966005)(52536014)(508600001)(122000001)(38100700002)(4326008)(71200400001)(45080400002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmpUTDM0czNQdWN1QStCcHJCc0VzRVVCV3l3TERUSGtqdy9Jc3JRaUVoR1ZI?=
 =?utf-8?B?N3RiNDJTTThQUi84RUMxeXlSOFpERm5MalZCMTgvbSs1N0NWRE5iNGhJeVZ6?=
 =?utf-8?B?dkJ4aVdMOHFSMEpFeGRNZzM3cE9MZ0VDZXFiSFRsbXBDREFYS05TWGhnSW40?=
 =?utf-8?B?bWppT0hONG4wYTU0L3N0NEVoSEdDZFpKVlFqYjhuQmFZbmhURUVDc0lsd0Iz?=
 =?utf-8?B?NURCMHc4bkZURHM4dVZqbDFyd2pIMVhaQUd0TFZGOXJ3TVNIMkFOZmZwN3E0?=
 =?utf-8?B?aWZCd2lHWUNrYWcrZEZlcXpLTU5BRTZjSzJiSGNhc3JmKytHRlJNTWNEd1RM?=
 =?utf-8?B?UTlRWU5CaERyUWJMOGpCd21KQ1VjRCsvZEM3bEk3YzZzMHg4Z3owbEg4NmF6?=
 =?utf-8?B?NGQzdUM5cHVybVdya0ZNVjZ2V1hHRzl1L1V0ZDgwY3NHNGJpRktxdVdLSDUz?=
 =?utf-8?B?NzlHWXViMThXWkdRT3V4YXNYY3BmNzExQVVnQ0JDbkhxaUNibkNHU1RmWTNa?=
 =?utf-8?B?SjQ3Q3pEamRpNjF2aWR4U0J3NW9CYWdSeTFkY2hXd1lXTnAwWWNUeVdZdE9l?=
 =?utf-8?B?cFh0WC8xSGNaK3V6U3V5a2VTSGVIUkdFSUFscFVqSm1tQXgvZzlIQVIyTFRE?=
 =?utf-8?B?QURrbXYvenRGc1Q0NW9BZjhLSHpySTFJMXNtY0VTNGw2N1Y5UHVaNG9GOWlL?=
 =?utf-8?B?SDNROTlOeHhxYUFXaWswSzJ5N002MXVlUjhLUy8wYzNxOTc3L0tHZlRzYk5a?=
 =?utf-8?B?SzVBR3JxRjhhWkVjd0o3akNBUXoyckh1bVZVNG8xaVg5RFF2dUYwOU1WK2xV?=
 =?utf-8?B?QmsrM2FYNUkrVVhmNXRsSkdaWUR0VlBVTDV0VVd0c0pFYWFjeW51YlNobnNO?=
 =?utf-8?B?U3gvS1RicHUzSXVBbEwrdE9RcDIzQnBnUjlITTdhajZvVXZMaVp1UklsdjBH?=
 =?utf-8?B?N2ZQVCtzRVMrYlZobjNvTFpyalpWTC9oUmxNcndQV3FMaTc2b0grd0RucGpv?=
 =?utf-8?B?eDNJTEthV2J0TkkyUkhXZXVqTEhiQVA0WEFrRTBRR2cvR0FCNXluTjIzWits?=
 =?utf-8?B?VkZmb2dEYjNJWWpId0tSMGlNYzR6azVhTy82VjZVR2JaVHFnUFdId2lxSjF5?=
 =?utf-8?B?aU1aeGJxYkkrMVZhR1h4L3F2bXNwNGEyYnVZNTdEMDNlbGYyVTdRMFBVSUk2?=
 =?utf-8?B?bDlBYS95dllMTnpJbkQvTDhhbWdXSlhsdFpTdTBBSGNPaURwUUVOM2hIVkpJ?=
 =?utf-8?B?THIyV3ZadTVLR2ZjaDN2eVdBNXdmT0hZbStPN3pFYWJMeDI1N0VRR2phNGFl?=
 =?utf-8?B?MWYycHk2RXhGaGJEM3hjSG1Qd0wzWE1sV2ExVmFkTW5vSDgwdmlCQTZSSWJu?=
 =?utf-8?B?K0lwL1NFemFWTFNsbnpGT0RLK0xhMGMzaklCdTRWWVVFeWhTVkJzQ3BOa3ha?=
 =?utf-8?B?V0FlRnhZeFVqUVVTMTdhbHA4VFhlUFFmazhlbkpEbTVPcEQ0VTNRek02Y3RY?=
 =?utf-8?B?empUTWlNbXVpbFlRRjR1M1dxSDVNcHdMVTN0c1R3eDdkRm9RK24wMzREQisw?=
 =?utf-8?B?a29pYU1tN2hWb05LL1RqZlh5OHRZNWpYTjYvZ3B4Tkh3cnpOMitHU2s0TXVq?=
 =?utf-8?B?dmVraFJoWmNrZG9yd1Q0U0xpdFM5ZFFVNG5RTlFRWVIra2FrSldDT0w4cktG?=
 =?utf-8?B?a04zUTE0M3R0Z1BUKzJVUHpTTG5pWGpPNGJXYXRUaDFDQlVOMU84RHBqaUFa?=
 =?utf-8?B?WnBsSWFhRDc4b1dNc0lSblZJaXQzZTBpZVFBWjY3WENLNmlhbm1rMEZnQUJN?=
 =?utf-8?B?Q1VMS2xaS3pMQmRKSHExUGVTZVhCSEZmZFlUUDBjYk5iMkU5eUxEZnI4UjUv?=
 =?utf-8?B?OGljbURQOUU0MEZVb2xlWncwZ0VUMUpuQmc3Tks4bHN0d1hRTkUvd2g3VGxt?=
 =?utf-8?B?RkRGK2RFdG1sNUExZGcrQ01yZGM1TlpHdmhjcXZhbGtaV2Y1amViYTZYQWNi?=
 =?utf-8?B?UkdoM2dGRFd5U1NnZ2hDWVVzNzBKbkg4RTV0T3ZZUXdyWnh1SWVSZHFGSE95?=
 =?utf-8?B?SE5iQ3JvQjM2N2NSZDBoZmpYMy81RkxPeDFoZ0lPUzg1UjdEYXREYzJlM3o3?=
 =?utf-8?B?bEJSQVYzNlV4bHl4aGQ0VjVQSkVYYzBWajdVN2Jza0Fjd2Fhc0g0ZjdXZWp5?=
 =?utf-8?Q?t63RbGxDerPLB6fOgYRYLlg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2465.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20af25df-dd08-4448-5a13-08d9d4b14dff
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 03:20:23.0016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QDCHkT0D6WOfQwetCUzCWFYh7i5xnJgc3s9LgGNgt5nsEGAxh0i8e8hwdMpIoMWbmAto2y9XnjeHCBgmcGsu/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3918
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KSGkgQWxleC9DaHJpc3RpYW4sDQoNClRoaXMgcGF0Y2ggaXMgdG8gcHV0IGRy
bV9zY2hlZF9zdG9wIHRvIHN0b3Agc2NoZWR1bGVyIGJlZm9yZSBhbWRncHVfZmVuY2Vfd2FpdF9l
bXB0eSwgb3RoZXJ3aXNlLCB0aGVyZSBpcyBwb3NzaWJseSBhIHJhY2UgcHJvYmxlbSB0aGF0IGRy
bSBzY2hlZHVsZXIgd2lsbCBrZWVwIHN1Ym1pdHRpbmcgY29tbWFuZHMgdG8gaGFyZHdhcmUgaW4g
c3VzcGVuZCwgc28gYW1kZ3B1X2ZlbmNlX3dhaXRfZW1wdHkgaGFzIG5vIGNoYW5jZSB0byBnZXQg
ZW1wdHkuIFRoaXMgaXMgYmFzZWQgb24gdGhlIGRpc2N1c3Npb24gd2l0aCBBbmRyZXkgYmVmb3Jl
Lg0KDQpJbiBCcm93bidzIGNhc2UsIHdpdGhvdXQgdGhpcyBwYXRjaCwgaGlzIHRlc3QgY2FuIHJ1
biB3ZWxsIGJ5IGEgMTAtaG91ciBkdXJhdGlvbi4gSG93ZXZlciwgd2l0aCB0aGlzIHBhdGNoIGFw
cGxpZWQsIGlzc3VlIG9jY3VycyBpbiB1bmRlciBhbiBob3VyLiBJIGd1ZXNzIHRoaXMgcGF0Y2gg
ZXhwb3NlcyBhbm90aGVyIHVuZGVybHlpbmcgcHJvYmxlbSwgYXMgaWYgaXQncyB0b3RhbGx5IGZh
dWx0eSwgdGhlIHRlc3Qgd2l0aCB0aGUgcGF0Y2ggYXBwbGllZCB3aWxsIGJyZWFrIGluIHRoZSBm
aXJzdCByb3VuZCBzdXNwZW5kL3Jlc3VtZSB0ZXN0IGluc3RlYWQgb2YgZmFpbGVkIGFmdGVyIHNl
dmVyYWwgcm91bmRzIHN1c3BlbmQvcmVzdW1lIHRlc3QuDQpodHRwczovL2J1Z3ppbGxhLmtlcm5l
bC5vcmcvc2hvd19idWcuY2dpP2lkPTIxNTMxNQ0KDQpBbnl3YXksIHdlIGNhbiByZXZlcnQgaXQg
Zm9yIG5vdywgYW5kIEkgd2lsbCBjb250aW51ZSB0aGUgaW52ZXN0aWdhdGlvbiB0byB0aGUgcm9v
dCBjYXVzZS4NCg0KUmVnYXJkcywNCkd1Y2h1bg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KRnJvbTogRGV1Y2hlciwgQWxleGFuZGVyIDxBbGV4YW5kZXIuRGV1Y2hlckBhbWQuY29tPiAN
ClNlbnQ6IFR1ZXNkYXksIEphbnVhcnkgMTEsIDIwMjIgMTI6MjYgQU0NClRvOiBLb2VuaWcsIENo
cmlzdGlhbiA8Q2hyaXN0aWFuLktvZW5pZ0BhbWQuY29tPjsgTGVuIEJyb3duIDxsZW5iQGtlcm5l
bC5vcmc+OyB0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZzsgQ2hlbiwgR3VjaHVuIDxHdWNo
dW4uQ2hlbkBhbWQuY29tPjsgR3JvZHpvdnNreSwgQW5kcmV5IDxBbmRyZXkuR3JvZHpvdnNreUBh
bWQuY29tPg0KQ2M6IGxpbnV4LXBtQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsgTGVuIEJyb3duIDxsZW4uYnJvd25AaW50ZWwuY29tPjsgc3RhYmxlQHZnZXIu
a2VybmVsLm9yZw0KU3ViamVjdDogUkU6IFtQQVRDSCBSRUdSRVNTSU9OXSBSZXZlcnQgImRybS9h
bWRncHU6IHN0b3Agc2NoZWR1bGVyIHdoZW4gY2FsbGluZyBod19maW5pICh2MikiDQoNCltQdWJs
aWNdDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS29lbmlnLCBDaHJp
c3RpYW4gPENocmlzdGlhbi5Lb2VuaWdAYW1kLmNvbT4NCj4gU2VudDogTW9uZGF5LCBKYW51YXJ5
IDEwLCAyMDIyIDExOjE2IEFNDQo+IFRvOiBEZXVjaGVyLCBBbGV4YW5kZXIgPEFsZXhhbmRlci5E
ZXVjaGVyQGFtZC5jb20+OyBMZW4gQnJvd24gDQo+IDxsZW5iQGtlcm5lbC5vcmc+OyB0b3J2YWxk
c0BsaW51eC1mb3VuZGF0aW9uLm9yZzsgQ2hlbiwgR3VjaHVuIA0KPiA8R3VjaHVuLkNoZW5AYW1k
LmNvbT47IEdyb2R6b3Zza3ksIEFuZHJleSA8QW5kcmV5Lkdyb2R6b3Zza3lAYW1kLmNvbT4NCj4g
Q2M6IGxpbnV4LXBtQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
ZzsgTGVuIEJyb3duIA0KPiA8bGVuLmJyb3duQGludGVsLmNvbT47IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBSRUdSRVNTSU9OXSBSZXZlcnQgImRybS9hbWRn
cHU6IHN0b3Agc2NoZWR1bGVyIA0KPiB3aGVuIGNhbGxpbmcgaHdfZmluaSAodjIpIg0KPiANCj4g
QW0gMTAuMDEuMjIgdW0gMTc6MDggc2NocmllYiBEZXVjaGVyLCBBbGV4YW5kZXI6DQo+ID4gW1B1
YmxpY10NCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBM
ZW4gQnJvd24gPGxlbmI0MTdAZ21haWwuY29tPiBPbiBCZWhhbGYgT2YgTGVuIEJyb3duDQo+ID4+
IFNlbnQ6IFN1bmRheSwgSmFudWFyeSA5LCAyMDIyIDE6MTIgUE0NCj4gPj4gVG86IHRvcnZhbGRz
QGxpbnV4LWZvdW5kYXRpb24ub3JnDQo+ID4+IENjOiBsaW51eC1wbUB2Z2VyLmtlcm5lbC5vcmc7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IExlbiANCj4gPj4gQnJvd24gPGxlbi5icm93
bkBpbnRlbC5jb20+OyBDaGVuLCBHdWNodW4gPEd1Y2h1bi5DaGVuQGFtZC5jb20+OyANCj4gPj4g
R3JvZHpvdnNreSwgQW5kcmV5IDxBbmRyZXkuR3JvZHpvdnNreUBhbWQuY29tPjsgS29lbmlnLCBD
aHJpc3RpYW4gDQo+ID4+IDxDaHJpc3RpYW4uS29lbmlnQGFtZC5jb20+OyBEZXVjaGVyLCBBbGV4
YW5kZXIgDQo+ID4+IDxBbGV4YW5kZXIuRGV1Y2hlckBhbWQuY29tPjsgc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZw0KPiA+PiBTdWJqZWN0OiBbUEFUQ0ggUkVHUkVTU0lPTl0gUmV2ZXJ0ICJkcm0vYW1k
Z3B1OiBzdG9wIHNjaGVkdWxlcg0KPiB3aGVuDQo+ID4+IGNhbGxpbmcgaHdfZmluaSAodjIpIg0K
PiA+Pg0KPiA+PiBGcm9tOiBMZW4gQnJvd24gPGxlbi5icm93bkBpbnRlbC5jb20+DQo+ID4+DQo+
ID4+IFRoaXMgcmV2ZXJ0cyBjb21taXQgZjdkNjc3OWRmNjQyNzIwZTIyYmZmZDQ0OWU2ODNiYjg2
OTBiZDNiZi4NCj4gPj4NCj4gPj4gVGhpcyBiaXNlY3RlZCByZWdyZXNzaW9uIGhhcyBpbXBhY3Rl
ZCBzdXNwZW5kLXJlc3VtZSBzdGFiaWxpdHkgDQo+ID4+IHNpbmNlDQo+ID4+IDUuMTUtIHJjMS4g
SXQgcmVncmVzc2VkIC1zdGFibGUgdmlhIDUuMTQuMTAuDQo+ID4+DQo+ID4+DQo+IGh0dHBzOi8v
bmFtMTEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUy
RmJ1Zw0KPiA+PiB6DQo+IGlsbGEua2VybmVsLm9yZyUyRnNob3dfYnVnLmNnaSUzRmlkJTNEMjE1
MzE1JmFtcDtkYXRhPTA0JTdDMDElN0NhbA0KPiA+Pg0KPiBleGFuZGVyLmRldWNoZXIlNDBhbWQu
Y29tJTdDY2Y3OTBiZTQ4MjdmNGRmOWYyZDgwOGQ5ZDM5YjgxYWYlN0MzDQo+ID4+DQo+IGRkODk2
MWZlNDg4NGU2MDhlMTFhODJkOTk0ZTE4M2QlN0MwJTdDMCU3QzYzNzc3MzQ4NzU2OTQ0MjcxNiU3
Qw0KPiA+Pg0KPiBVbmtub3duJTdDVFdGcGJHWnNiM2Q4ZXlKV0lqb2lNQzR3TGpBd01EQWlMQ0pR
SWpvaVYybHVNeklpTENKQg0KPiA+Pg0KPiBUaUk2SWsxaGFXd2lMQ0pYVkNJNk1uMCUzRCU3QzMw
MDAmYW1wO3NkYXRhPUFYMFRYa3lvTWh5JTJCWnFFDQo+ID4+IFZnUlNXTWtLZDVuUGE0V092JTJC
MUZaSExTRXJTdyUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiA+Pg0KPiA+PiBGaXhlczogZjdkNjc3OWRm
NjQgKCJkcm0vYW1kZ3B1OiBzdG9wIHNjaGVkdWxlciB3aGVuIGNhbGxpbmcgDQo+ID4+IGh3X2Zp
bmkNCj4gPj4gKHYyKSIpDQo+ID4+IENjOiBHdWNodW4gQ2hlbiA8Z3VjaHVuLmNoZW5AYW1kLmNv
bT4NCj4gPj4gQ2M6IEFuZHJleSBHcm9kem92c2t5IDxhbmRyZXkuZ3JvZHpvdnNreUBhbWQuY29t
Pg0KPiA+PiBDYzogQ2hyaXN0aWFuIEtvZW5pZyA8Y2hyaXN0aWFuLmtvZW5pZ0BhbWQuY29tPg0K
PiA+PiBDYzogQWxleCBEZXVjaGVyIDxhbGV4YW5kZXIuZGV1Y2hlckBhbWQuY29tPg0KPiA+PiBD
YzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgNS4xNCsNCj4gPj4gU2lnbmVkLW9mZi1ieTog
TGVuIEJyb3duIDxsZW4uYnJvd25AaW50ZWwuY29tPg0KPiA+IEBDaGVuLCBHdWNodW4sIEBHcm9k
em92c2t5LCBBbmRyZXksIEBLb2VuaWcsIENocmlzdGlhbg0KPiA+DQo+ID4gQW55IGlkZWFzPyAg
V2hhdCdzIHRoZSBjb25zZXF1ZW5jZSBvZiByZXZlcnRpbmcgdGhpcyBwYXRjaD8gIERpZG4ndCAN
Cj4gPiB0aGlzDQo+IHBhdGNoIGZpeCBhbm90aGVyIHN1c3BlbmQvcmVzdW1lIGlzc3VlPw0KPiAN
Cj4gSSB0aGluayBHdWNodW4gd2FzIGp1c3QgdHJ5aW5nIHRvIGFkYXB0IHRoYXQgd2UgcmVtb3Zl
ZCB0aGUgc2NoZWR1bGVyIA0KPiBzdG9wIGZyb20gdGhlIGZlbmNlIGRyaXZlciBodyBmaW5pIHBh
dGguDQo+IA0KPiBOb3Qgc3VyZSBpZiB0aGF0IGFjdHVhbGx5IGZpeGVkIHNvbWV0aGluZyBvciB3
YXMganVzdCBhIHByZWNhdXRpb24uDQoNClRoYW5rcy4gIEknbGwgd2FpdCBmb3IgZmVlZGJhY2sg
ZnJvbSBHdWNodW4gYW5kIEFuZHJleSBhbmQgaWYgdGhleSBhcmUgb2sgd2l0aCBpdCwgSSdsbCBh
cHBseSB0aGUgcmV2ZXJ0Lg0KDQpBbGV4DQoNCg0KPiANCj4gUmVnYXJkcywNCj4gQ2hyaXN0aWFu
Lg0KPiANCj4gPg0KPiA+IEFsZXgNCj4gPg0KPiA+PiAtLS0NCj4gPj4gICBkcml2ZXJzL2dwdS9k
cm0vYW1kL2FtZGdwdS9hbWRncHVfZmVuY2UuYyB8IDggLS0tLS0tLS0NCj4gPj4gICAxIGZpbGUg
Y2hhbmdlZCwgOCBkZWxldGlvbnMoLSkNCj4gPj4NCj4gPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Z3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV9mZW5jZS5jDQo+ID4+IGIvZHJpdmVycy9ncHUvZHJt
L2FtZC9hbWRncHUvYW1kZ3B1X2ZlbmNlLmMNCj4gPj4gaW5kZXggOWFmZDExY2EyNzA5Li40NTk3
N2E3MmI1ZGQgMTAwNjQ0DQo+ID4+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2Ft
ZGdwdV9mZW5jZS5jDQo+ID4+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdw
dV9mZW5jZS5jDQo+ID4+IEBAIC01NDcsOSArNTQ3LDYgQEAgdm9pZCBhbWRncHVfZmVuY2VfZHJp
dmVyX2h3X2Zpbmkoc3RydWN0DQo+ID4+IGFtZGdwdV9kZXZpY2UgKmFkZXYpDQo+ID4+ICAgCQlp
ZiAoIXJpbmcgfHwgIXJpbmctPmZlbmNlX2Rydi5pbml0aWFsaXplZCkNCj4gPj4gICAJCQljb250
aW51ZTsNCj4gPj4NCj4gPj4gLQkJaWYgKCFyaW5nLT5ub19zY2hlZHVsZXIpDQo+ID4+IC0JCQlk
cm1fc2NoZWRfc3RvcCgmcmluZy0+c2NoZWQsIE5VTEwpOw0KPiA+PiAtDQo+ID4+ICAgCQkvKiBZ
b3UgY2FuJ3Qgd2FpdCBmb3IgSFcgdG8gc2lnbmFsIGlmIGl0J3MgZ29uZSAqLw0KPiA+PiAgIAkJ
aWYgKCFkcm1fZGV2X2lzX3VucGx1Z2dlZChhZGV2X3RvX2RybShhZGV2KSkpDQo+ID4+ICAgCQkJ
ciA9IGFtZGdwdV9mZW5jZV93YWl0X2VtcHR5KHJpbmcpOyBAQCAtNjA5LDExDQo+ICs2MDYsNiBA
QCB2b2lkDQo+ID4+IGFtZGdwdV9mZW5jZV9kcml2ZXJfaHdfaW5pdChzdHJ1Y3QNCj4gPj4gYW1k
Z3B1X2RldmljZSAqYWRldikNCj4gPj4gICAJCWlmICghcmluZyB8fCAhcmluZy0+ZmVuY2VfZHJ2
LmluaXRpYWxpemVkKQ0KPiA+PiAgIAkJCWNvbnRpbnVlOw0KPiA+Pg0KPiA+PiAtCQlpZiAoIXJp
bmctPm5vX3NjaGVkdWxlcikgew0KPiA+PiAtCQkJZHJtX3NjaGVkX3Jlc3VibWl0X2pvYnMoJnJp
bmctPnNjaGVkKTsNCj4gPj4gLQkJCWRybV9zY2hlZF9zdGFydCgmcmluZy0+c2NoZWQsIHRydWUp
Ow0KPiA+PiAtCQl9DQo+ID4+IC0NCj4gPj4gICAJCS8qIGVuYWJsZSB0aGUgaW50ZXJydXB0ICov
DQo+ID4+ICAgCQlpZiAocmluZy0+ZmVuY2VfZHJ2LmlycV9zcmMpDQo+ID4+ICAgCQkJYW1kZ3B1
X2lycV9nZXQoYWRldiwgcmluZy0+ZmVuY2VfZHJ2LmlycV9zcmMsDQo+ID4+IC0tDQo+ID4+IDIu
MjUuMQ0K
