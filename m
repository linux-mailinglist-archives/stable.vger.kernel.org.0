Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232EF6E5725
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 03:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjDRBuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 21:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbjDRBtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 21:49:40 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0EE7A85;
        Mon, 17 Apr 2023 18:48:09 -0700 (PDT)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33HKwJ3a003506;
        Mon, 17 Apr 2023 18:46:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=CB5MlItyirDvx6SVwyyMU0It5WMKDNSTddmR5Lu6R98=;
 b=bmL8pZVR/sdJg0qoioaa+P3dtTvMbOECam9JEZp0OrYUYxJUZ3/OSuNzLk8vC0hOKt1D
 1WHYM5vCND38Za07qG8bBVIBVQGVZFlfIbjxRwtE1/bAvBOO91I/MSI34v1C5zR9UuW0
 pG9INX8EOzZY9x4KHDeFlvJynQ+yjfaJpMWtRSQuU7k3+HiDK3jL7/9wiD5uWUP7WRe5
 Ze85ih83p/m1rqTbMG0Q68l1fZlBiN71//+BGUMk3Mg5/78x8YBY1Dz0v7D9y/tnwFQ9
 zY7Xux5b2pk/Eijv9RQ2o91GPOtvVtnWeqY2GJw7S2ms3jByiigq407Pe6JNbg0Ys+MZ AA== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3pyu66134y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Apr 2023 18:46:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1681782413; bh=CB5MlItyirDvx6SVwyyMU0It5WMKDNSTddmR5Lu6R98=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=HNGzvWCM7wCeLnUVkwYAb0oOXGyfXfY7yqcswYoKbkbbdQWH4GyYMq6BizUV7Tu90
         vo7urSSTHhegy4XuS+zqwu5jrA2cUW8gA1vIfm8tpbLvlWA2x7/uD3eiWcysUGH7nR
         MvWTBS1qkMiWuKRI39GRUHNP+ePuvIhj6CoKrJqCaFeI+ubdA96HHwRv18sZuQiveA
         gtFDEFSjrhGs8Cn18H+Bdc/y2Or2eNngn8VOw+Ccv6KsY0e3No2U11IxeuR7Ykvcg6
         7BUTdxs6LUPDEtX14xe1kq5kfF48l+8bq/+mlxvNG2oTX1W+fz64T5mR7LMXyeUgGL
         Ui49W6UpkNXWw==
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits)
         client-signature RSA-PSS (2048 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6337740565;
        Tue, 18 Apr 2023 01:46:52 +0000 (UTC)
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id ABD3CA007A;
        Tue, 18 Apr 2023 01:46:52 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.a=rsa-sha256 header.s=selector1 header.b=D/7gjXIR;
        dkim-atps=neutral
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 925B440DE2;
        Tue, 18 Apr 2023 01:46:51 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDgxAdKz1/ISP/TAjsNL3W80wAilLRi6FWXprjB34rhbijraqKsO29PRaywFlx4fUxxrdb/TqJT3iKSB+0zodtN5S90jdkb2J7nqxRoGBzqScobJCyUIXMb5jmEZBG5GSt6WWLBbDlOEzR3CKNqcUvPV1wrVYc4DQE7zlN0TTwVV0R05KKxhdhdJcwPwmNsSIlTTlV5nv08IG/TR67tGwxmGOTmr/gqZfeSddnUTmUadaB7w2EKtYtn1cOPAhdVbLVaGxLg2t/iARpsqM+s7filETm3SugntgW1vsDizm3pkFAion8ZgZTDv6/c4KTTOiB8QrPuRh/NQJ1TU8QOdcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CB5MlItyirDvx6SVwyyMU0It5WMKDNSTddmR5Lu6R98=;
 b=YI5s4uc8/G4+aGdzwK5l6u92m0FkXUoTrOez03o4UTuDRKIKmluBGFZPlNnAGO+T2pk60RWZLydR3ZvRGW7qrDJWTBu9bEwaYlsvmgxAYGSm0NwfDvL7H2ZCzwwcx27pPAKNIfUBFAyr3YbYexhEqtLN9hRuHoHmmJf+ibkRiCxix1GOx7WVxh2/OBjdD7dgQj2buxMDPpoGPymzrhTcg7YaoxQH9+q9hXKYO6G9fZvBw5QFkdkqC0eXZ0o+cV7vXkfYnpXpPd1aWNxFqb+UpPK3bHV0brXdWp5G/vPYtx020X3kftL8kaHnlds7DDMJRdT4Xf6Db6/Sh61SBpJDyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CB5MlItyirDvx6SVwyyMU0It5WMKDNSTddmR5Lu6R98=;
 b=D/7gjXIRDD85DNp/kNhPsMNpDhWjQbubFvElMuVQL5bizEzR5RlAOgAXlMb44/aUXzsGiOPOaYb32Z/8UBohqXfmQdCXIcP0AHVsIX3xaepAI2cMcDL7D+L8p1a4u6qSWcs/t/jwP58GJEGQz4QyL8AEmgSC8E9dWfrIjAe24XE=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by CY5PR12MB6108.namprd12.prod.outlook.com (2603:10b6:930:27::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 01:46:48 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::3103:ba85:b667:315d]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::3103:ba85:b667:315d%6]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 01:46:47 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Wesley Cheng <quic_wcheng@quicinc.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] usb: dwc3: gadget: Stall and restart EP0 if host
 is unresponsive
Thread-Topic: [PATCH v5 1/3] usb: dwc3: gadget: Stall and restart EP0 if host
 is unresponsive
Thread-Index: AQHZbkJuxQdOpGs9mk+Ptv8y4biCtK8wUrMA
Date:   Tue, 18 Apr 2023 01:46:47 +0000
Message-ID: <20230418014636.d6wk6zbdmdxgwdpc@synopsys.com>
References: <20230413195742.11821-1-quic_wcheng@quicinc.com>
 <20230413195742.11821-2-quic_wcheng@quicinc.com>
In-Reply-To: <20230413195742.11821-2-quic_wcheng@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|CY5PR12MB6108:EE_
x-ms-office365-filtering-correlation-id: 18ec7c0e-3b45-4d83-fc8d-08db3faec5a2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kWaKBLmS7Qg46F7i0MDeWeaj9TW8OvoUw3iEJXVBiEVXcFYJMmmm1Xj0SmWNIBaKWryBf2LDGjiN/NDuLQj78f/VLVWj2fdAdkty3BsXH3HL3XHF1SgYCgQLf0Gpr1ZVhDbwfrCPYZFE/Cv6Gwtgc+tdQF2WXqj32iNIuSlMojIxs4xcqDsXoYlCP7zGsRS75BIved5iyBMP7P6rv6RLi6ln8yT+BxUKbTFSrBPdj80V3PxIGp+q55jt93CSPzCpCd+bSahDUEnZ3a0BLq0fLuEN22uFdtGP4ok7buIDDoVEIsnmjxiOBMFKUXBAVItzM7jGQ5HwJpbtsXl5OwQaY1KxboqrICGrjD8IBPcZxkAj9YmwH8GU/spTWorHBIRQigMTLff8E1JTZZAaUWRU3VlnYmVd8/VVZtv3mORSuLqp7BrFFuleJxfYYfEt/nV2/d1VfkmsgeIpTQ1Eih5+mn8hn5hbl33KvrfU2cMAYanEUxSeivVENBBC05S0+k//QAM/47NkVXNMTNx2nq/GAbSAIoOyueKAdJJdQ/2D5LEti0xYs2cUEP1jCkVOeOLiSV11o7N0b2gytwPiS4vgXigK4H3cQPatyjPSt+aGJh1GkkYz4ipPa2NPgQUWuF5yhOH1Y3Z9olw4TcVJGs/xyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199021)(1076003)(6506007)(6512007)(186003)(26005)(2616005)(83380400001)(6486002)(71200400001)(36756003)(54906003)(316002)(41300700001)(5660300002)(2906002)(4326008)(478600001)(6916009)(38100700002)(86362001)(38070700005)(8676002)(8936002)(66556008)(122000001)(64756008)(66446008)(66946007)(66476007)(76116006)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VllydEhIVUVuMmpBTzQ3cWdub080QkdXcUQvbi8yeVdtekR5UXVYNHoxcVhk?=
 =?utf-8?B?ZEl3WjJMd0IrTCtPajE0WlZCNnBxbHpEQklvMkhVWDlLNEhoWmdSeVhjNHor?=
 =?utf-8?B?UTd2R1NtZjlHOGlFcmhTSmEya0dsVHVnTDR0cG5YVm43cTJRTzh3QWxsWW91?=
 =?utf-8?B?aFJvZ2J1MEMreG42YVpRc0hLaElrLzgycmNzTmpJQlE4ZDlIRDE2bU82MHN4?=
 =?utf-8?B?dEV0ZEh2Y1lpWUMvVXdGWFZONlpxK0ZKRGQ3SDA2UFVkcGQ5c1M5amI2UXc0?=
 =?utf-8?B?alJiNTNzQWpPdjZsUVpGcUZzdGF0NEVTTWdmUFBVdDN1bkJGdm1DYkhNbzlW?=
 =?utf-8?B?QXIzRWNWRjBWNjBCMThHSE9seHA3S0pSTzlYcVBrTmtmbDhvNkdkVGZLRGhY?=
 =?utf-8?B?N05EM253Y0p3cXVhdUlENWNYZXdzekpNYzdIVW03bWpDNUVib2VRUDUxdExK?=
 =?utf-8?B?aVdkN3Q5SlhlcERmMnRnZE1EbW13MXk3S0NXVkRVVUpqWWlvakdaL3FPb3ha?=
 =?utf-8?B?bGYwa3NqSFpuMDF0VUMwY2tWbElWV0sxMHFVLzREdW5NckFDS2tOMzZQSi9P?=
 =?utf-8?B?OTVHdVRZNTY0K3hZVnZNN3NzZ2xqbjcxaVNmRTVMeFllQUIycFZBZ0plODZZ?=
 =?utf-8?B?VVpuRlV6RkxFMXJ4MDB5Sm5OVi9XZUpXVXRJVTdSaSswR1l1aHZOZUdDNVJ5?=
 =?utf-8?B?T25VMlBWcWRpSXZSaVpSbXVPb3hIUytsQytNQ0NlZ0tpWlZhMjRGM1FobjRi?=
 =?utf-8?B?OXVDbG40TkxXNTV2ZkZTUVhpcm0zcmtlYUZkNnFvSEcwTFR5RlY3TlJJYUhE?=
 =?utf-8?B?bnEwYXhNYUlWai8xYXFlVW1aV2ZuSUtWOUt1czYycXZmUWtvNHA2STBuVFE2?=
 =?utf-8?B?VURxUHNaTjcvZjkzWUVidjdWSml1SzFkSSsxQVB6akw4a0g5UDRlUHl6OHBn?=
 =?utf-8?B?U053bjBkeG85THMwWWM5TGV4aklIaHRURllwRW83c29RN25jWVVMNHU4eHRr?=
 =?utf-8?B?bHdvd25YNWNzZmhNdVpxZmFJVXIyVklJNzFqSEZyQXdnUzJmcm5OR2s5eUhN?=
 =?utf-8?B?YjlaQ1RaeE13WXpFcXE4MjNxWTJnclc1MTArT0Z5TDkyT2hYb2ZHbXRaYjZB?=
 =?utf-8?B?eE9RTnBBU2JQQ05YR01Ra1g5dnlZcy9oQ0g3MERzVDk5UjJlVmtNUWRzRFZY?=
 =?utf-8?B?WldsT2tEL1pTNWRrcUN2am92VTFtUEx4UWZrQ0g0Y0NrZ1F2SjZUeEN0V1hp?=
 =?utf-8?B?cFI3Mm01R244YVFWU01YS2ZEN29uM0ZkUzlPOXR0cjAzVi9Da2hqZU1uc0RG?=
 =?utf-8?B?L0Z1cFlGS0RYcUdUbjBHSWhscWx3OGdjSXVFN1FGM1pSZGM1Qjl5T3hXS1U2?=
 =?utf-8?B?UERqSzhocmJLcVU4dGZRc3ZPVXQ5b0plSExpR3hJV2lndlRJaHNnQkhOZXFG?=
 =?utf-8?B?aFJPdGtvRWZMcFhUMkMxekhtMU04S0ltNjFSWHNucC8zVFc0VGdGZ3RuZkN2?=
 =?utf-8?B?YSsya09GZ0FOMjkwZklVU3ZzakdqbGRucy9mVGk1RDNWeUJwV2JxV2VwWG5j?=
 =?utf-8?B?cC90TmF5azhEKzI0VFhmV2dJZlYvOGE1c1FCQnpyRmRwK2M4VU9Gb2tDNkkr?=
 =?utf-8?B?T2lBTGlQRldDZFFYbGtzRC9OY2dFU0pCUUVtMkdzYWZmaFZhMHJTalJGVE1H?=
 =?utf-8?B?bUhTRmhQTW5sTU1STXR0QjNvcEdXZEdneUhFakJGVkt5TDdzdWFKNjFGOFZL?=
 =?utf-8?B?bXRnQnU2Uzh4Y3dFRHBjSFlDcDZpOUk1bkkxNG96cGxOMTV1dEhxTm94TUpv?=
 =?utf-8?B?dlFMRFl1SHYxaW1lOEN0K0VXaGZaUjVWY0VZNmdxWnU2eFcwM0pGUFV0Rmpo?=
 =?utf-8?B?UWxKTW9oeDgwSVBPaEt5QVJCNlIvM0xBaTg4dU9BR0VpRnpWd2NvdGw4aE43?=
 =?utf-8?B?eXAvSXNKeW1SQWZjNjZXa0VWMWdvRmdqNVUybkhYOUpsbXV6bUducndTYVFh?=
 =?utf-8?B?OHVxZUJCVDF5RGhBRlE5dllHV3VYOGJOS1dGK3lZdUo5WkNlMndTK0pKRldW?=
 =?utf-8?B?WmdjZWZjcDZNdUlCcWZxTFl2V0x3ZHNlaVBtUlo4ZWNBU092eGFxa2NMb01O?=
 =?utf-8?Q?LiYEuHkCNHZT/18VHR1H8zU+U?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F20C15A1EA6EB448867373450D8D1A20@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: b4XaRWfaAZfHaDCYtXa7ZhYTbBOSAT0QURdVqGPhbP4+d2oxOZGUq1N1kB8GSP/Dp3ZgJDgfmEnZ+xsmG9YLUIWBaS0vNji0tL/txsvgC0LGuc+p2nTZL7tenN/Xt7Cn+sj02IlIGp/9RVCmyLKByn40r8GRZrqxrJBThLEuMqwk22fflXGMyEVVk7fC696PiNY/PnT3dq2/VlrZLUwkf6cNRY5lzFB32EYeWhJOdriyyxTS7XnRRVmQI7+fDV3WAIgbTmyJkvgnfOW77WxmmRYoy0iEcG34kFWHvpusYXflQvzLLmsitE98NrrcspTNHDNswOd0NPdDT3F+WZkZf6ffx8IlsvKnBn+dQMq0jZSbc++c6qTAKd210I3DUe4/YvBJNzzT8OeChADbwkM8cAdz3HxO9liUkWjwGXAHw0xNOSj72tqA8NvT3LZXYW+COOWi0GJa2dh4usrFp6uTN8GRZI1YMIgmAePzfoVbnRCCZkPDGRX80k7Bo6pCiCYqf2zUD1WJ3qNR5REIFgPgIgKqHl5hi3GWm9RpcUm+0segncarjscMRf3n9R2WDCCZxcr/qo7s0ENYdzrP9M+iTXTjh4qJlqN1n+OwD1cEXbUFi/oQoT6dTv24WU8mqBTuyH6PxPTtWM6QT7z9wsLayUyrwv3PeBm5rB0hPf7wQ7Djx1XUEbxTqf4rmsPr7VG9/fti56rSE3bnC4WmZLO/dh9b1i38U0lrn1kzF9kzHT22WcSE4dVxTEOPKyP6qCZoKSqUZbW8XML9FoQgf4AqAPkjWQheg9DlM+vufZqQA0KixCebIV6ThS/cGJ5Rl1QioJ4A02FF0pkqQrr/x9ikfDIBhWbH4gsu/HHEYnM3bADgFn5I8jgt8602Hia4oVDpHrav4tekbfMkfT05EWmzfw==
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ec7c0e-3b45-4d83-fc8d-08db3faec5a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 01:46:47.5337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o3eZGA67HBREODCoN3BwIg+t+d9rnSyR/b458SC2wqVSr5kzWDjz+qHSOQUtb3SPhJgtHZO3w0No/kJoi103sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6108
X-Proofpoint-ORIG-GUID: FpmDDbxWXHrbKYxDTOC-PRaQFN9_xEka
X-Proofpoint-GUID: FpmDDbxWXHrbKYxDTOC-PRaQFN9_xEka
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-17_14,2023-04-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304180014
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCBBcHIgMTMsIDIwMjMsIFdlc2xleSBDaGVuZyB3cm90ZToNCj4gSXQgd2FzIG9ic2Vy
dmVkIHRoYXQgdGhlcmUgYXJlIGhvc3RzIHRoYXQgbWF5IGNvbXBsZXRlIHBlbmRpbmcgU0VUVVAN
Cj4gdHJhbnNhY3Rpb25zIGJlZm9yZSB0aGUgc3RvcCBhY3RpdmUgdHJhbnNmZXJzIGFuZCBjb250
cm9sbGVyIGhhbHQgb2NjdXJzLA0KPiBsZWFkaW5nIHRvIGxpbmdlcmluZyBlbmR4ZmVyIGNvbW1h
bmRzIG9uIERFUHMgb24gc3Vic2VxdWVudCBwdWxsdXAvZ2FkZ2V0DQo+IHN0YXJ0IGl0ZXJhdGlv
bnMuDQo+IA0KPiAgIGR3YzNfZ2FkZ2V0X2VwX2Rpc2FibGUgICBuYW1lPWVwOGluIGZsYWdzPTB4
MzAwOSAgZGlyZWN0aW9uPTENCj4gICBkd2MzX2dhZGdldF9lcF9kaXNhYmxlICAgbmFtZT1lcDRp
biBmbGFncz0xICBkaXJlY3Rpb249MQ0KPiAgIGR3YzNfZ2FkZ2V0X2VwX2Rpc2FibGUgICBuYW1l
PWVwM291dCBmbGFncz0xICBkaXJlY3Rpb249MA0KPiAgIHVzYl9nYWRnZXRfZGlzY29ubmVjdCAg
IGRlYWN0aXZhdGVkPTAgIGNvbm5lY3RlZD0wICByZXQ9MA0KPiANCj4gVGhlIHNlcXVlbmNlIHNo
b3dzIHRoYXQgdGhlIFVTQiBnYWRnZXQgZGlzY29ubmVjdCAoZHdjM19nYWRnZXRfcHVsbHVwKDAp
KQ0KPiByb3V0aW5lIGNvbXBsZXRlZCBzdWNjZXNzZnVsbHksIGFsbG93aW5nIGZvciB0aGUgVVNC
IGdhZGdldCB0byBwcm9jZWVkIHdpdGgNCj4gYSBVU0IgZ2FkZ2V0IGNvbm5lY3QuICBIb3dldmVy
LCBpZiB0aGlzIG9jY3VycyB0aGUgc3lzdGVtIHJ1bnMgaW50byBhbg0KPiBpc3N1ZSB3aGVyZToN
Cj4gDQo+ICAgQlVHOiBzcGlubG9jayBhbHJlYWR5IHVubG9ja2VkIG9uIENQVQ0KPiAgIHNwaW5f
YnVnKzB4MA0KPiAgIGR3YzNfcmVtb3ZlX3JlcXVlc3RzKzB4Mjc4DQo+ICAgZHdjM19lcDBfb3V0
X3N0YXJ0KzB4YjANCj4gICBfX2R3YzNfZ2FkZ2V0X3N0YXJ0KzB4MjVjDQo+IA0KPiBUaGlzIGlz
IGR1ZSB0byB0aGUgcGVuZGluZyBlbmR4ZmVycywgbGVhZGluZyB0byBnYWRnZXQgc3RhcnQgKHcv
byBsb2NrDQo+IGhlbGQpIHRvIGV4ZWN1dGUgdGhlIHJlbW92ZSByZXF1ZXN0cywgd2hpY2ggd2ls
bCB1bmxvY2sgdGhlIGR3YzMNCj4gc3BpbmxvY2sgYXMgcGFydCBvZiBnaXZlYmFjay4NCj4gDQo+
IFRvIG1pdGlnYXRlIHRoaXMsIHJlc29sdmUgdGhlIHBlbmRpbmcgZW5keGZlcnMgb24gdGhlIHB1
bGx1cCBkaXNhYmxlDQo+IHBhdGggYnkgcmUtbG9jYXRpbmcgdGhlIFNFVFVQIHBoYXNlIGNoZWNr
IGFmdGVyIHN0b3AgYWN0aXZlIHRyYW5zZmVycywgc2luY2UNCj4gdGhhdCBpcyB3aGVyZSB0aGUg
RFdDM19FUF9ERUxBWV9TVE9QIGlzIHBvdGVudGlhbGx5IHNldC4gIFRoaXMgYWxzbyBhbGxvd3MN
Cj4gZm9yIGhhbmRsaW5nIG9mIGEgaG9zdCB0aGF0IG1heSBiZSB1bnJlc3BvbnNpdmUgYnkgdXNp
bmcgdGhlIGNvbXBsZXRpb24NCj4gdGltZW91dCB0byB0cmlnZ2VyIHRoZSBzdGFsbCBhbmQgcmVz
dGFydCBmb3IgRVAwLg0KPiANCj4gRml4ZXM6IGM5NjY4Mzc5OGUyNyAoInVzYjogZHdjMzogZXAw
OiBEb24ndCBwcmVwYXJlIGJleW9uZCBTZXR1cCBzdGFnZSIpDQo+IENjOiBzdGFibGVAdmdlci5r
ZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IFdlc2xleSBDaGVuZyA8cXVpY193Y2hlbmdAcXVp
Y2luYy5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYyB8IDQ5ICsrKysr
KysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDMy
IGluc2VydGlvbnMoKyksIDE3IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvdXNiL2R3YzMvZ2FkZ2V0LmMgYi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+IGluZGV4
IDNjNjNmYTk3YTY4MC4uYmU4NGMxMzNmMGQ3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3VzYi9k
d2MzL2dhZGdldC5jDQo+ICsrKyBiL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gQEAgLTI1
MjgsMjkgKzI1MjgsMTcgQEAgc3RhdGljIGludCBfX2R3YzNfZ2FkZ2V0X3N0YXJ0KHN0cnVjdCBk
d2MzICpkd2MpOw0KPiAgc3RhdGljIGludCBkd2MzX2dhZGdldF9zb2Z0X2Rpc2Nvbm5lY3Qoc3Ry
dWN0IGR3YzMgKmR3YykNCj4gIHsNCj4gIAl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiArCWludCBy
ZXQ7DQo+ICANCj4gIAlzcGluX2xvY2tfaXJxc2F2ZSgmZHdjLT5sb2NrLCBmbGFncyk7DQo+ICAJ
ZHdjLT5jb25uZWN0ZWQgPSBmYWxzZTsNCj4gIA0KPiAgCS8qDQo+IC0JICogUGVyIGRhdGFib29r
LCB3aGVuIHdlIHdhbnQgdG8gc3RvcCB0aGUgZ2FkZ2V0LCBpZiBhIGNvbnRyb2wgdHJhbnNmZXIN
Cj4gLQkgKiBpcyBzdGlsbCBpbiBwcm9jZXNzLCBjb21wbGV0ZSBpdCBhbmQgZ2V0IHRoZSBjb3Jl
IGludG8gc2V0dXAgcGhhc2UuDQo+ICsJICogQXR0ZW1wdCB0byBlbmQgcGVuZGluZyBTRVRVUCBz
dGF0dXMgcGhhc2UsIGFuZCBub3Qgd2FpdCBmb3IgdGhlDQo+ICsJICogZnVuY3Rpb24gdG8gZG8g
c28uDQo+ICAJICovDQo+IC0JaWYgKGR3Yy0+ZXAwc3RhdGUgIT0gRVAwX1NFVFVQX1BIQVNFKSB7
DQo+IC0JCWludCByZXQ7DQo+IC0NCj4gLQkJaWYgKGR3Yy0+ZGVsYXllZF9zdGF0dXMpDQo+IC0J
CQlkd2MzX2VwMF9zZW5kX2RlbGF5ZWRfc3RhdHVzKGR3Yyk7DQo+IC0NCj4gLQkJcmVpbml0X2Nv
bXBsZXRpb24oJmR3Yy0+ZXAwX2luX3NldHVwKTsNCj4gLQ0KPiAtCQlzcGluX3VubG9ja19pcnFy
ZXN0b3JlKCZkd2MtPmxvY2ssIGZsYWdzKTsNCj4gLQkJcmV0ID0gd2FpdF9mb3JfY29tcGxldGlv
bl90aW1lb3V0KCZkd2MtPmVwMF9pbl9zZXR1cCwNCj4gLQkJCQltc2Vjc190b19qaWZmaWVzKERX
QzNfUFVMTF9VUF9USU1FT1VUKSk7DQo+IC0JCXNwaW5fbG9ja19pcnFzYXZlKCZkd2MtPmxvY2ss
IGZsYWdzKTsNCj4gLQkJaWYgKHJldCA9PSAwKQ0KPiAtCQkJZGV2X3dhcm4oZHdjLT5kZXYsICJ0
aW1lZCBvdXQgd2FpdGluZyBmb3IgU0VUVVAgcGhhc2VcbiIpOw0KPiAtCX0NCj4gKwlpZiAoZHdj
LT5kZWxheWVkX3N0YXR1cykNCj4gKwkJZHdjM19lcDBfc2VuZF9kZWxheWVkX3N0YXR1cyhkd2Mp
Ow0KPiAgDQo+ICAJLyoNCj4gIAkgKiBJbiB0aGUgU3lub3BzeXMgRGVzaWduV2FyZSBDb3JlcyBV
U0IzIERhdGFib29rIFJldi4gMy4zMGENCj4gQEAgLTI1NjMsNiArMjU1MSwzMyBAQCBzdGF0aWMg
aW50IGR3YzNfZ2FkZ2V0X3NvZnRfZGlzY29ubmVjdChzdHJ1Y3QgZHdjMyAqZHdjKQ0KPiAgCV9f
ZHdjM19nYWRnZXRfc3RvcChkd2MpOw0KPiAgCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmR3Yy0+
bG9jaywgZmxhZ3MpOw0KPiAgDQo+ICsJLyoNCj4gKwkgKiBQZXIgZGF0YWJvb2ssIHdoZW4gd2Ug
d2FudCB0byBzdG9wIHRoZSBnYWRnZXQsIGlmIGEgY29udHJvbCB0cmFuc2Zlcg0KPiArCSAqIGlz
IHN0aWxsIGluIHByb2Nlc3MsIGNvbXBsZXRlIGl0IGFuZCBnZXQgdGhlIGNvcmUgaW50byBzZXR1
cCBwaGFzZS4NCj4gKwkgKiBJbiBjYXNlIHRoZSBob3N0IGlzIHVucmVzcG9uc2l2ZSB0byBhIFNF
VFVQIHRyYW5zYWN0aW9uLCBmb3JjZWZ1bGx5DQo+ICsJICogc3RhbGwgdGhlIHRyYW5zZmVyLCBh
bmQgbW92ZSBiYWNrIHRvIHRoZSBTRVRVUCBwaGFzZSwgc28gdGhhdCBhbnkNCj4gKwkgKiBwZW5k
aW5nIGVuZHhmZXJzIGNhbiBiZSBleGVjdXRlZC4NCj4gKwkgKi8NCj4gKwlpZiAoZHdjLT5lcDBz
dGF0ZSAhPSBFUDBfU0VUVVBfUEhBU0UpIHsNCj4gKwkJcmVpbml0X2NvbXBsZXRpb24oJmR3Yy0+
ZXAwX2luX3NldHVwKTsNCj4gKw0KPiArCQlyZXQgPSB3YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVv
dXQoJmR3Yy0+ZXAwX2luX3NldHVwLA0KPiArCQkJCW1zZWNzX3RvX2ppZmZpZXMoRFdDM19QVUxM
X1VQX1RJTUVPVVQpKTsNCj4gKwkJaWYgKHJldCA9PSAwKSB7DQo+ICsJCQl1bnNpZ25lZCBpbnQg
ICAgZGlyOw0KPiArDQo+ICsJCQlkZXZfd2Fybihkd2MtPmRldiwgIndhaXQgZm9yIFNFVFVQIHBo
YXNlIHRpbWVkIG91dFxuIik7DQo+ICsJCQlzcGluX2xvY2tfaXJxc2F2ZSgmZHdjLT5sb2NrLCBm
bGFncyk7DQo+ICsJCQlkaXIgPSAhIWR3Yy0+ZXAwX2V4cGVjdF9pbjsNCj4gKwkJCWlmIChkd2Mt
PmVwMHN0YXRlID09IEVQMF9EQVRBX1BIQVNFKQ0KPiArCQkJCWR3YzNfZXAwX2VuZF9jb250cm9s
X2RhdGEoZHdjLCBkd2MtPmVwc1tkaXJdKTsNCj4gKwkJCWVsc2UNCj4gKwkJCQlkd2MzX2VwMF9l
bmRfY29udHJvbF9kYXRhKGR3YywgZHdjLT5lcHNbIWRpcl0pOw0KPiArCQkJZHdjM19lcDBfc3Rh
bGxfYW5kX3Jlc3RhcnQoZHdjKTsNCj4gKwkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmR3Yy0+
bG9jaywgZmxhZ3MpOw0KPiArCQl9DQo+ICsJfQ0KPiArDQo+ICAJLyoNCj4gIAkgKiBOb3RlOiBp
ZiB0aGUgR0VWTlRDT1VOVCBpbmRpY2F0ZXMgZXZlbnRzIGluIHRoZSBldmVudCBidWZmZXIsIHRo
ZQ0KPiAgCSAqIGRyaXZlciBuZWVkcyB0byBhY2tub3dsZWRnZSB0aGVtIGJlZm9yZSB0aGUgY29u
dHJvbGxlciBjYW4gaGFsdC4NCg0KQWNrZWQtYnk6IFRoaW5oIE5ndXllbiA8VGhpbmguTmd1eWVu
QHN5bm9wc3lzLmNvbT4NCg0KVGhhbmtzLA0KVGhpbmg=
