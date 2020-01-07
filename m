Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1315131F6D
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 06:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgAGFp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 00:45:58 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:56263
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbgAGFp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 00:45:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5WVQUTNgs8S+/INA0ZtyjH6Wxv30EKgo13k0ggYnw8fYUdWbpXCDxy5Nsyq4EsGiqB5kq8R36jaJbsa5wWll1jExF4iWYFRsdHfGyMxftHhUj53BiUGE9hYnvhTlMSgweMywKYRoIo0Wh2g4dLvVhVsgLBiHcqRThw0+O/zv1JsYbz7QQG+31KWh9k68jdk3XU6cGhET8CO6pGDA9gmFpkbL8YQ7OLFGvvn/EJiEyae5+NHgviSsASTPxvQhHpAB9JtGJlY2NdTj+xQ34AGjh6IPs+Ioe96CF0vSTN3G8OZokh5KSFA0miglRhyctFEcVdGYY4mYTKQJazms/HbFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0taP77OPtAKrcY4WTj9JPhLA4605sD22Jf61WJQddQA=;
 b=oHzQA2lceEc2Q0SX/wElh9akpR9DWdpbHS86+pGzeOlv65S0ga1FpkeR94cb4HiJ8pB14fJT78ARh9CrrewNM+pZ907pDE0y5x1XKBGsYWKfqpihtwy63E+/DeKE5Y7eCmaLIhmyRcWDy7Wls6jxyu0g6xX4o2QDjgL++5+Fxth5NVPgPpCNuCWwavTAneYtttEfuGYfg1TPsu28EjZLXOdXp50/X8fzYxRLG66bBiMe9j8VysXVm/MwY9WM30OZkWtsgV4s7DXYtYUb64KABIxIK0ysg/XRwV/AXOFeXfWCyoj/4LkEFoDe/Kq6qv5VFMWnBdkodcHdJoVA0JZffw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0taP77OPtAKrcY4WTj9JPhLA4605sD22Jf61WJQddQA=;
 b=OZMO5laCUEXHYHSPh8wwn00eCN8nfB8oJqoFmS0DtYvobygnXuGL+aqMnbj9oMu2LF+swEYVs65doPKCiCBfLBKLKxEOi6K0hJ+rKTCnNqCIleT03YaVj3nYgiJTpOfme0vms1N2y03j0y9iqF2v9/I9mgFVh6vE5lhY7hDNsao=
Received: from DB7PR04MB5242.eurprd04.prod.outlook.com (20.176.234.25) by
 DB7PR04MB5035.eurprd04.prod.outlook.com (20.176.234.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Tue, 7 Jan 2020 05:45:54 +0000
Received: from DB7PR04MB5242.eurprd04.prod.outlook.com
 ([fe80::bce1:71a5:299f:f2ff]) by DB7PR04MB5242.eurprd04.prod.outlook.com
 ([fe80::bce1:71a5:299f:f2ff%7]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 05:45:54 +0000
From:   Ganapathi Bhat <ganapathi.bhat@nxp.com>
To:     Brian Norris <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        huangwen <huangwenabc@gmail.com>
Subject: RE: [EXT] [PATCH] mwifiex: fix unbalanced locking in
 mwifiex_process_country_ie()
Thread-Topic: [EXT] [PATCH] mwifiex: fix unbalanced locking in
 mwifiex_process_country_ie()
Thread-Index: AQHVxOKzzKY3R1cUp0qpKstXsSvPEqfesJ8Q
Date:   Tue, 7 Jan 2020 05:45:54 +0000
Message-ID: <DB7PR04MB5242BEB1F917B1FDB21DF3DF8F3F0@DB7PR04MB5242.eurprd04.prod.outlook.com>
References: <20200106224212.189763-1-briannorris@chromium.org>
In-Reply-To: <20200106224212.189763-1-briannorris@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ganapathi.bhat@nxp.com; 
x-originating-ip: [92.121.64.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1fe76047-1faf-4f86-ad94-08d79334dcb0
x-ms-traffictypediagnostic: DB7PR04MB5035:
x-microsoft-antispam-prvs: <DB7PR04MB50357FD3DD8BBBDC6B6874398F3F0@DB7PR04MB5035.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(199004)(189003)(51914003)(316002)(8936002)(558084003)(2906002)(33656002)(478600001)(52536014)(26005)(76116006)(8676002)(81156014)(66446008)(64756008)(81166006)(66556008)(6506007)(7696005)(71200400001)(186003)(9686003)(4326008)(54906003)(55016002)(110136005)(44832011)(5660300002)(86362001)(66476007)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5035;H:DB7PR04MB5242.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GIflOm31oy4GzZPXMKkncSYdX0DKFjYoemE6ylVM3H3uveiy1D/OkZ7QZe69srhX9VZGVVFNjFh5zwHG0L+mhDCqrLtsLoSGfGcUr0PPnh5NiWFr+YraAuDpmisBNf4OaJNH1x6/orXeWKl5GQ0HvplPrj4eUPvD5B7TUnmw4FXs8v82FlBc87DOs862q4VmkwxQT6p4WmuB9qbMMq0AAkDjnFergIzN6/jZK0FeqlaIYiTafxMwcew6+l5T+rRMY8cVPgABnuTQMmnQI6BzfDqAFHSLtIcSSSBh3YVxTR7xAKLXwGnWFpmR7IGOtTBDH6GEL2lPO1b4tFYUnPSfsnTTKoFCI3FyV2P9hNI+7D1nIy+tD6rRKIm3PdVtlk+NtZYw9UhV1Ww5TBIm3KS+Y9bynGipFIdBB+5N5ajkqqTOnx7xzf6l0fQ9Uzxgv4sy21NEPfA5toTmwyqlPIWPYeOnvxc9N7cSGUKj6m/HNePRq6U3FsT+UYj8DyK92Wev
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fe76047-1faf-4f86-ad94-08d79334dcb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 05:45:54.4954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IcjVNtA868YmOwpl8u550M80fbdYzlAIbBJurhqPS+dGrOjpjV+n+96F7Qz7YBVottKmsegaE9f0qjUUo87ebg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5035
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Brian,

> We called rcu_read_lock(), so we need to call rcu_read_unlock() before we
> return.

Right; I should have at least checked the previous *return* statements in t=
he same function;=20

Thanks for the fix;

Acked-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>

Regards,
Ganapathi
