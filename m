Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DFD3552A3
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 13:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhDFLtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 07:49:42 -0400
Received: from mail-dm6nam11on2072.outbound.protection.outlook.com ([40.107.223.72]:25217
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232884AbhDFLtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 07:49:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCDfRAApWe8R/kVLjVEF4FUg8CPnjHG2WHrunwluQn3UPog1X60bSY4swDdwnusHP+WW4KlIv/T41/N+o0f85Ofi3QkKfbZNav8ENFGhxBjwaf/BNyucgZPhRp7lWh/y3wHrqZ+0edZV1kp5WuZkhW0EoKFZXWQaSvDpgQ/A0b7wlDKDB4HOxQ2aM+9r25o641Op3VJXx6p3E7w5pnTeQVPiolTyxg0hlMvPiVGVtqmGEpKJVWMHhjfr+hXk0XRHOb3vXVnfvtdmbQlKrekiDaHhrkpFFJpCgWY9FObMfC7am4ax0Rf67JrLnOUdu0IeMgQKEr5QS5QlxCpl7Asiaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbOJ3vhPpCzgKJ/p6F8jumyq4DCPzQgZzb/+Xdn4Bnc=;
 b=eZg54FOAg1EkoSQNdpdCjTQ/fnIFrsDkIOiIgJdKGJ3WnEneNCc8x5UdthVL+xyjDPM+3KUq0f2q5gQrYM20jTeWoYg7Ct/UFeE6/YD11KYj/AbwfIHQgyU5A8tzzYclmbFwXCXo7hmG/K8bN8x7jdORBr1AFg51X3/c2WM3aYrKL2kblqPaSv/C9oa8AvWdM0YOU7HYsM5JmXGg+W7FEDEGgyqY8/Do4UBucwsjNa5O1KQAD/AWumg/AGVMhSisKAdHpYcWavpzqqv+qvQMIXAfFDUNWuNdqKJVJBbTsK1cHuGQpK8BceoTLUAWiqXlv8XAlcY383QcAcoj2u/6aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbOJ3vhPpCzgKJ/p6F8jumyq4DCPzQgZzb/+Xdn4Bnc=;
 b=ujzBeYQoIQcFiXHR/M1EwW22IeejgsIMsr5rrZOkcKLcJW2zFrbD1epo3ro3MXnvdMwUD1QsWHx/tLpTVyegnrBfSWToKB2oCHB9WA79kMHARxUx3LNpzf/XW2KoftIdXqHfjo/2ysfQvJ9df0wpxIXyGkAKSvGJMjX9RI8JmDMlju1PgDp2cs5joPGYBrOhqwN20c+8jfXRJZDhAG0E9QkiVmep0t9iKz43jxc27JN9O4JlFvjv1xtLgETyLhUQ5c6s3OWlEg6w7jZwCzV+bNogQa0FAYVwuEtnJn2RfMr5JfoHWFFK+tmEIP4aUNkj45pWZouQadcWHOz2N2aHVQ==
Received: from MWHPR15CA0054.namprd15.prod.outlook.com (2603:10b6:301:4c::16)
 by DM5PR12MB1259.namprd12.prod.outlook.com (2603:10b6:3:75::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 11:49:33 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4c:cafe::58) by MWHPR15CA0054.outlook.office365.com
 (2603:10b6:301:4c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend
 Transport; Tue, 6 Apr 2021 11:49:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3999.28 via Frontend Transport; Tue, 6 Apr 2021 11:49:32 +0000
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 6 Apr
 2021 11:49:32 +0000
Date:   Tue, 6 Apr 2021 13:50:03 +0200
From:   Thierry Reding <treding@nvidia.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH 5.10 079/126] drm/tegra: sor: Grab runtime PM reference
 across reset
Message-ID: <YGxK64XIou14JBa/@orome.fritz.box>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085033.686284735@linuxfoundation.org>
 <20210405154221.GB305@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3BJ3eVQHxxGmMdDG"
Content-Disposition: inline
In-Reply-To: <20210405154221.GB305@amd>
X-NVConfidentiality: public
User-Agent: Mutt/2.0.6 (98f8cb83) (2021-03-06)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6d9ad58-8dd6-43ff-ce22-08d8f8f20b4a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1259:
X-Microsoft-Antispam-PRVS: <DM5PR12MB125926934F1C2F34E48F2D94CF769@DM5PR12MB1259.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5AeztjTUXBv2cHdrluz1FaQbhBT/V+dtFkBE24xfXku14CpOSebh+sIwlJxaeMUU8ZO8lRwB/MSPKDxRhifBLnPCBd9ibyDfcqJnFHvnorh5pEWQMY/GKYYCpIWREAQNZTUnGf7o5cDXomfPduyhC0GDYpQpQl7kKWOWomr1eovDa+tgz/xxAFhvRm/eySa8PERnqCdkFHVhGMcycooYIKLV8/XzS0lFbVZpGzpS7No2RKLSoqEbphODxVqwoBgp0w0DgjqAa6aO98zaBA525m3X43wIQQp2KVN3aUmWphtnjbPRnsl3C6cdSbBWb+GiCIrJcVLrwtSA2coqAPS4qXE7wt89cjFPp2qIzJuee50wVQXZr1oSlLVlZTJ+ilLAg9w/WGM0KOWwvnK6ZnH5rUP+G838sIPlYAAnBPNQ67cPUBTzQkOC12JkTiZY8bnjRyfhna7kg4jGqf8VYFG/8X8bdmfxoOWIAMU6KVGgiuix+tntwrNyOL7eZtd8fRpxUGoG/3StNsk5nTWWu69DvLCFsU9LmtGVd/0eO7fjCGPrJlpZL+sGVmbr1oKqaJR7Mha5kO3wJs4kiJfbM1ggjusRzk90KiiEZFyG9ZmbQan+++YeJXgcf7upUesSJPslqurAUa/uMj0oaow0WUMIBID4UyI4F9jbESitEQLziOGT/2jqGwaSrKDu2W5aBth5
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(36840700001)(46966006)(82310400003)(336012)(6666004)(16526019)(47076005)(426003)(44144004)(7636003)(186003)(82740400003)(356005)(86362001)(6916009)(4326008)(5660300002)(36860700001)(26005)(107886003)(478600001)(54906003)(2906002)(9686003)(21480400003)(83380400001)(8676002)(36906005)(70206006)(70586007)(8936002)(316002)(2700100001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 11:49:32.7061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d9ad58-8dd6-43ff-ce22-08d8f8f20b4a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1259
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--3BJ3eVQHxxGmMdDG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 05, 2021 at 05:42:21PM +0200, Pavel Machek wrote:
> Hi!
>=20
> > However, these functions alone don't provide any guarantees at the
> > system level. Drivers need to ensure that the only a single consumer has
> > access to the reset at the same time. In order for the SOR to be able to
> > exclusively access its reset, it must therefore ensure that the SOR
> > power domain is not powered off by holding on to a runtime PM reference
> > to that power domain across the reset assert/deassert operation.
>=20
> Yeah, but it should not leak the PM reference in the error handling.

True. However the only reason why the code could realistically fail
between pm_runtime_resume_and_get() and pm_runtime_put() is if we did
not take the runtime PM reference (which would cause the call to
reset_control_acquire() to fail).

So the chances of this actually leaking are practically zero, so I
didn't want to bloat this bugfix with what's essentially dead code. I
can queue up your fix below for v5.14, though, since it's obviously
more correct from a theoretical point of view.

Thierry

--3BJ3eVQHxxGmMdDG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmBsSugACgkQ3SOs138+
s6HF2g/9EPWccihWMPitomnEMTzY1KiU46QRqhIiIxH/KtCEdahPESFbnzs9Pmpl
5RU1XN2dWtTLIVsEhROQ3Gkr/h3YRCAX800jYiLNPEF39hGv5uqbVJACPk+fPztU
vZMF3kreSD5/yl0TXSZ1rPLHy+0DNCY4oMCGXBp0wduhAt1jV4LyzUAkrjNZI5ri
hOzmOmLxdWedsocW/segkyyCRkowU0nBFr/m1Cr80JWsdyM2uKTrdc95Ty2VeeUx
+GQyqdEuT7UdnisLkg7Hy5IuHqeNYzFxQqSsv7fVpsSMnQjriWji4b4hiNfXqEm0
gbsYmmcasVp6v5dMMkrJ/k2b/HNHwp793X6IBSX9yIgMWIaCuH3SJi54Ta9qzi+G
nGmH4OVPMQfVG0oi+MFykzZ3N+H9db8+8VbEcDSRU4jdr4aQ+36Nl4hOmkjWdmuv
VNSe/UXjbqcXOdOVaTLo5jJd19ZRB2TOlKdd/S8hUiSzovA+QQm1yCNC2v9Xte/e
9Wvvr+gXAigzCdHpk0ZNhz/hr8kQsaq1yEQFPezknH37bLo//EDse19Ou/iXNWNU
NabyD29MnTuCQSWs2fVzqv2BGcWCShoY0tjxhjHMljYJaRzWyNGWbQF/Ll6yUoVv
NbxNjWPEKssOHKrNoZ7//13Y67boQJ/uYiG1oen2Tfhd8M24Lmo=
=NKzo
-----END PGP SIGNATURE-----

--3BJ3eVQHxxGmMdDG--
