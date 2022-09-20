Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEE65BDE0F
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 09:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiITHYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 03:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiITHYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 03:24:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E685D0ED
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 00:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663658655; x=1695194655;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aRbrSqqAXXKDhTkI2aDmckrLUGp9kWuEm4dfG6Bo2e0=;
  b=MfKmMn1mNLBngw9fNrEixYlDJU4Pg1wK8yq0h0s3YISUE8RF4+smt/jV
   ceQDguuGpbnfS7PLbNWYuHEw8b8YTSZAL5/TOAUJ0BNZbE6qdtOh/yUrU
   WH8PSYbEOsNqZx7tb0xXBIaLeMPhCMABV0zUgNLxBGL3Jr9qlcfjkGjXk
   eKbC7uKVUJLQG5CN6kWwy43zGt/zVsuDp+HqBdw/f5e6e/uA0ahylOEKc
   BqxkdXmYMg09YzDTQIfTao+xiAQHI08w6htPJ+EWytB5qrNrlt8ZeUksG
   thk+xKeB79LkydwcRbSbUXhyMnt9oeOvAZBfh2wNXIqdw9G/9yp7I+UHP
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="298346791"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="298346791"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 00:24:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="863872773"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 20 Sep 2022 00:24:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 00:24:14 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 00:24:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 20 Sep 2022 00:24:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 20 Sep 2022 00:24:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ki5H0SSv+sb8M6Q05dpCeaTEpeB+Tb8HoK1007jFmrbPOPyrjwZPqDJxHW3ssN8l1LoB/fEk8yLqdiSqpCx0GilSTEYPFoIk4W8/otuaTDKQBStJ6Le/jC9o4m8+kehS6fevVSUHa/Otzp+Rxb5zfb2uHgObA2hQ3U/TV0AFscwQQTZA2irHkRGmePiVM4cQkObEZf79de2tzNBhcCw2+/bTe+phJyFGS0EJGtFF9YuUNrFTi97rYmM6Ie+p8Rgn3WOJQ/Wy0SdTORBOWQAleWvefsNKYqou77DWWN4e/wjJyJsqqapyOTmP0Z9RmEqx+3Snvb6OZarAEfVMcqIBAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRbrSqqAXXKDhTkI2aDmckrLUGp9kWuEm4dfG6Bo2e0=;
 b=lt2v1pDdeBG2CrsHOYdWTH86YdZMlv+pgWRBxf5oc/7zToE7tu1j0coSMU868uMDQWfBWasorR+YSytqMJ4SxzKSIhLyrbItuz1oIbESXQrnQcCMIV/UVVjG+fiY1Imh7GOFSDegUZpc6Xg45oLIqcSwsEzn66bSo+Z4Wnofuuy+gOhOoyLMMOlcvYltTTKolFk86ISDo+a86b2WBfbpq5lALn0bK/xsV9I9D9M/bOvCLPwiPOX1KvxafGwQdSS8zIg6eE0cTGMWvLu/tfu9CHqKj8eK8gwL0QXV6YBqkebvJBc2GZSMcWijMYaCuttfdPSnYKZGkLP1p9nxkE8mrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB7279.namprd11.prod.outlook.com (2603:10b6:8:109::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 07:24:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%6]) with mapi id 15.20.5632.019; Tue, 20 Sep 2022
 07:24:07 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>
CC:     "Lu, Baolu" <baolu.lu@intel.com>,
        "Srinivasan, Raghunathan" <raghunathan.srinivasan@intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/2] iommu/vt-d: Check correct capability for sagaw
 determination
Thread-Topic: [PATCH 1/2] iommu/vt-d: Check correct capability for sagaw
 determination
Thread-Index: AQHYyZusCgntlOv4NEq+TiOZAmUin63n8JYQ
Date:   Tue, 20 Sep 2022 07:24:07 +0000
Message-ID: <BN9PR11MB5276649A6230B072078B4D148C4C9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220916071212.2223869-1-yi.l.liu@intel.com>
 <20220916071212.2223869-2-yi.l.liu@intel.com>
In-Reply-To: <20220916071212.2223869-2-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB7279:EE_
x-ms-office365-filtering-correlation-id: 14fa39e2-db82-46da-7120-08da9ad91abe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jPLjSTLCdahu6YQPhCLSvQ4iSwPWI/3EoG9bNa22re8sLah06oCGQCNNwj6ZUM0VD6mUNkR9zTBk5+pHumI2jpcs3fIoReeqqc4usfjz0CRhOqMMRicMNGMHJMkzsuwM87l1IMFP6HjEQA5gKYQ/EWWD/n/5EWxtI0NfZ0vyTcyOE5o4CoPGiqB6aX5ST+q9/BiLDtssjcIRwLNM0QNM7hNJ/JdYJGK2yn4TKf3LAScwPhLidaFfnIr8GGxJyGeT7DiPNPJrKC8DQcta7By7i0IH9M88LgpwjwPqaeJLcXt+WtjWvPuPTKyyNdAdHqLSu4fr5Nq/NcpIVtWjnglupxPVzHnz5JAGi9NLh1288EWJdkAz78Yt+IrZy0ZmGVxMSbIjW+Un62v9bwXxDFSAk2eolRIGIhswoF/sFqVxpoE0uJNfUK8CWSEOytIgrUH3BoK3wP6xEMZo+0aw+eXEFucQe1pUGfptGbcdglJEUyndudFKAoxAw9Lg9AabAySF1WIL69Y8D9oQYbSkdeitNXWR8h9XR95sowBjGawS5nMY/l7dBowr6nUvecrEFqgCxZAh55uoi8RTWsrlDerHVrVBLPT56Yioyevm7M4dIMm02TAL9XpeJOZrVW02N4pXa3rstU4C0zTUX8vX5Fl5S9uvItNqhQjn3CYOG3w0iIPucfWtE9Bi/OwTYduppY6EZUrVTtdM35zw3ykM/jgs7uNeWKLL37cv4+w1tdtEBIBOpu0+X8IaRv9JdnX6b3xk39BCQ6BJs59K9zT1s/5Hbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199015)(52536014)(38100700002)(186003)(122000001)(38070700005)(82960400001)(5660300002)(4744005)(2906002)(8936002)(55016003)(478600001)(4326008)(6506007)(26005)(9686003)(41300700001)(7696005)(8676002)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(71200400001)(316002)(110136005)(54906003)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4SO+7DIeCkJtkNyaadlj114Z0kIk8RibdUT94ZHhCv/gWOznB63OE+Nqx4B0?=
 =?us-ascii?Q?pmq6AhBn6Oot9J3Rv2GD/uT40qqXz+KjVG8yzAm4r/AHwYx7J/uQJ1if1teA?=
 =?us-ascii?Q?Tyt3aUQrbWFVXgNUx1vJHtsFhxtLQ6wG6CfCOIfzSsWjoDMTjRjkgA9kwoXV?=
 =?us-ascii?Q?QvW7JAHVAFqvrWgfkcSbzZjchh5xk5W6kH0UzfRJsRji66d2Yh8M+5V1slBB?=
 =?us-ascii?Q?ogqUhimf7ag5XUH6KVm0fPMrN9Z26vGqBLiHf1EdxrZTl/L2cMCaRjW9hZkC?=
 =?us-ascii?Q?4a8XskLF9w+ZRJFSr6FFJ5UtHugaU2IA3lbntrCzrf4CRoJCS+CXFCMOnL9D?=
 =?us-ascii?Q?1zobVN3wKua6W9xUfzFGktG2dAKtKgABbHhcLZKFw3nxNyLycuAejOvczO7e?=
 =?us-ascii?Q?UT4ocjE7J26KMEnQFoMPeMSZr35tFVeEd/H2o0bP/YV5jBJ5GeajaxO0STDT?=
 =?us-ascii?Q?zRYR/lZiiWJYqqDzo7RncAMcZ0Wx/BCjnjvZ/D7qZuwsuXzwrdvoBcNCHZtr?=
 =?us-ascii?Q?+vQ5/4t8FHbOMhmPnukwvXnB163HZcjTFa40DCEeI+4JVMxfmquhhIVj/ZJJ?=
 =?us-ascii?Q?suy1IG+2AlgUkgN3LtZQ1Gub8O2t0hvwULCHR6Jm9kKPBm8hdZ4oXgNidJdn?=
 =?us-ascii?Q?jdMdpJVjlMqVIk/Tq3A2Acz9v2libtkUGYHzuJIlqPWXZM6eoUF/TEq9vWrZ?=
 =?us-ascii?Q?xPDLw3OWIubOo075b1u6xpRRFOigCV8RaitJHmCf+DTImoRg3coSktbauJmL?=
 =?us-ascii?Q?+BaPSwZ35MZL8qwRCM7Ii3v+IDbiEu6ZNSAn79iaGDOaiXnBxiEEHs72tmiJ?=
 =?us-ascii?Q?N7x1x+v0Q4hweUkGAFMtpGO9MQn76CWskZRW/RaS1OhTWcPkNXWk2bsrHLfQ?=
 =?us-ascii?Q?a/8IiLHJvQNG7j/9YS3pIiYdh065D/o+5GmsLSYxXuXc3HmwqgyrvtAYji74?=
 =?us-ascii?Q?V7JkBTPXcD+14iSMQk1g4tXTkvyBcxhQEKsuhFfOQT8KXE6petPPvK8w+zED?=
 =?us-ascii?Q?WWX8DbdPEYkk6kfyPExXZWcF6QmqbG3+6w1ZKiLf998fygLMVQfPmZwDFsBm?=
 =?us-ascii?Q?JR5LIAuMqW43qWw4KWG3MKjBSnnI1yI0Bx8xg/WA6gkBHGdEuwgDHbRxWlpw?=
 =?us-ascii?Q?5ZYOx7NodCglCDD79hm5EESFf8axBN7idqTzah34rZwFWGPhlXTja6Xmq/tq?=
 =?us-ascii?Q?GyKEjbYbfSRB4QVEtWKE55LQRJqp4evhkwE6jJ4lGnKR0fa4Ay+a0Thp+BC7?=
 =?us-ascii?Q?VJGKGD4mbDrxe1L4TnndCaRSiyv1ZM4ZP0gLd5V2DM4Q4LT2ITG9HDP9D5VY?=
 =?us-ascii?Q?96wo+9Mpm0t5bkDT6jFJem6xqKFVR6O2nIb4A/qnfYH1RpEJBpJk9Dd5WWp6?=
 =?us-ascii?Q?+pQeH9nW/dbP9lB8fduzCtJ9eE1YKPmM54fLpnK/Srr9/4aRV/nD/jYhS8+I?=
 =?us-ascii?Q?YEn775An9ksyPVMkV0ctjeNVdLYHVHaGIwopRCqvBsnP/XPKwUb3By+oWMtQ?=
 =?us-ascii?Q?iIR9ZSw3jJB39G5+76eB2k4BcfQu2KRp6lULm1NDcsIyxLLKgYE75y4kF8O/?=
 =?us-ascii?Q?zssy3W23fDtTXfJVywuU9+bvDe9XqOhBWknW5308?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14fa39e2-db82-46da-7120-08da9ad91abe
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 07:24:07.3459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MBrVZ5RmWgEzYTiRyC1rQ/Xh91AIkZlqELYmxv8HjWkRBe1M73ray9dY8zvaghm6GmdqnTA/+uFltykKFCIE5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7279
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, September 16, 2022 3:12 PM
>=20
> Check 5-level paging capability for 57 bits address width instead of
> checking 1GB large page capability.
>=20
> Fixes: 53fc7ad6edf2 ("iommu/vt-d: Correctly calculate sagaw value of
> IOMMU")
> Cc: stable@vger.kernel.org
> Reported-by: Raghunathan Srinivasan <raghunathan.srinivasan@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
