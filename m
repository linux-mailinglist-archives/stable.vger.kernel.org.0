Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9477CCAD8F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbfJCRrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:47:11 -0400
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:49520 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729585AbfJCRrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 13:47:10 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Oct 2019 13:47:08 EDT
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 27113C04BC;
        Thu,  3 Oct 2019 17:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1570124275; bh=aeANNgRg3iMwAT8T0uxdfYPMW1x8xLS6hW/eI2xTXKg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Ucn6iufrNAKrcSAuDHpAEtNHsLtZINBnxHviIEfzJ1rNGK/y6rFBlG66FrgrlyoSF
         i37hDUsWJWJnLLvv6D0aUM4P7XFsa/1l3MxM3/455kN1cTKA7eik72CBnWOwCOH+P1
         VswzCIxTZAoLSKfyrSCRpWbHE7Rh2wPeuspx45xEKZWQr+Hi4sDVLEhI6kOEw9Leyq
         p0xFGNhE/73wGIq4+BuNjN6eLo/NI6ljg78Zykx0KiVll+g6OQ0URsEsqeOo4Oz6Ek
         ihOEtDslpAbk0KOY+deT5hre4w3CCsFShSoPYZ8N3/H+8824gdaBYkdYuyilWmo6lW
         Grs56HsTnXoPQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 1CB59A0070;
        Thu,  3 Oct 2019 17:37:50 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 3 Oct 2019 10:37:43 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 3 Oct 2019 10:37:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fD1JzrymzLh9PSaKRCPo8h+nu2Ul/Khqx45RnpfLn9MLU/Oe5uEXAFeznVA4YtJzIsU7AesiJoeA9DCJXycLg4k+lEkgIiergJ/qxNj7oxMmeIERAg7fjjM79b2a0jbBOxkEwTKHYekslUxjXxOUNs2lBQRa9ktng6o+5YKapDZg/voptDhu2cKbE7wVs4MbswwUyy3ONYBqVgL4eXCg17M0g9KXCQ+lgSTkD8nsrqf6SiSlLaaBzjvBSvDJxh3dOoTFLHTwmWZrmlLrp/+31hu2BrjKO2DxOtUMD4axjKawdqwgI1rTQ4U8pL82lbg924HNwS+sjQrv8UC4MPslkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlYy2SrDKXLWZ8oBzIpjAAI9/FUOImsCLllufFCafKE=;
 b=gXNvxjI6kLFnjYbR+M8GwILxvELo//5u9R3N4uffq1e6lwS2zRdzpchkuU8eu0GS82C6u+u7We69wcWpm8jdigqgoePLKSPQyecQttVeqFoEM/p4ALMNKxzVRHgrxycaRw+kiy/Mt26Yf8HPbGxHBVUeCo/N8j2a7RaWYhqn1sqv1a51ZtGM2cDFPk2LcWuyZw77qTpryJ8tmTptYUuo17DD7rYzaIMLgBvleLeLv2r5X5whJiWut3nCMnqp1duUXdclw0LXAVjgBflenNKabSxpCAQe4rV70sZps7Xc/9u+G32X2eJRjjeWpnHXjPG1qbglM3/tabP3od1ebVgxRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlYy2SrDKXLWZ8oBzIpjAAI9/FUOImsCLllufFCafKE=;
 b=nkoebF18r7mHaJjpEM7Pi1Lhq8nHg3oExSKKmWLwaHQUj0hdMs3hJn6HKdOYFExUlc5QUa+pGg7Ad0/GggpRGjacwcCTrIITln8pE+mLANula4K1gkGxEJiEZpcJfgJ433EB5JQLIXXX0yQkVJNmmkrb2yPd9FzZ0vOLSryiJEw=
Received: from CH2PR12MB4216.namprd12.prod.outlook.com (20.180.6.151) by
 CH2PR12MB3893.namprd12.prod.outlook.com (52.132.231.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 17:37:40 +0000
Received: from CH2PR12MB4216.namprd12.prod.outlook.com
 ([fe80::9cde:1aac:8caf:c5d4]) by CH2PR12MB4216.namprd12.prod.outlook.com
 ([fe80::9cde:1aac:8caf:c5d4%3]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 17:37:40 +0000
From:   Vitor Soares <Vitor.Soares@synopsys.com>
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Vitor Soares <Vitor.Soares@synopsys.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-i3c@lists.infradead.org" <linux-i3c@lists.infradead.org>,
        "bbrezillon@kernel.org" <bbrezillon@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pgaj@cadence.com" <pgaj@cadence.com>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 2/5] i3c: master: make sure ->boardinfo is initialized
 in add_i3c_dev_locked()
Thread-Topic: [PATCH v3 2/5] i3c: master: make sure ->boardinfo is initialized
 in add_i3c_dev_locked()
Thread-Index: AQHVY0hlo1rLTrTwUU+xfuLExhNXqKdJJ22AgAAWKlA=
Date:   Thu, 3 Oct 2019 17:37:40 +0000
Message-ID: <CH2PR12MB42162C4459E31D85FD60FB79AE9F0@CH2PR12MB4216.namprd12.prod.outlook.com>
References: <cover.1567608245.git.vitor.soares@synopsys.com>
        <ed18fd927b5759a6a1edb351113ceca615283189.1567608245.git.vitor.soares@synopsys.com>
 <20191003162943.4a0d0274@collabora.com>
In-Reply-To: <20191003162943.4a0d0274@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc29hcmVzXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctN2M2Y2Y4MTktZTYwNC0xMWU5LTgyNWUtYjgwOGNm?=
 =?us-ascii?Q?NTlkN2ZjXGFtZS10ZXN0XDdjNmNmODFiLWU2MDQtMTFlOS04MjVlLWI4MDhj?=
 =?us-ascii?Q?ZjU5ZDdmY2JvZHkudHh0IiBzej0iMzkxMyIgdD0iMTMyMTQ1OTc4NTYzNTUz?=
 =?us-ascii?Q?OTAyIiBoPSJsK0oyU2ZuQy9KRGZ3dHVJcDZ1TmRNdGM3V0k9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFCUUpBQUJ1?=
 =?us-ascii?Q?NnNZK0VYclZBYWd2QjRVNTIvUHVxQzhIaFRuYjgrNE9BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFDa0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQWt4V29sUUFBQUFBQUFBQUFBQUFBQUo0QUFBQm1BR2tBYmdC?=
 =?us-ascii?Q?aEFHNEFZd0JsQUY4QWNBQnNBR0VBYmdCdUFHa0FiZ0JuQUY4QWR3QmhBSFFB?=
 =?us-ascii?Q?WlFCeUFHMEFZUUJ5QUdzQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdZQWJ3QjFBRzRBWkFCeUFIa0FYd0J3?=
 =?us-ascii?Q?QUdFQWNnQjBBRzRBWlFCeUFITUFYd0JuQUdZQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFaZ0J2QUhVQWJnQmtBSElBZVFCZkFIQUFZUUJ5QUhRQWJnQmxB?=
 =?us-ascii?Q?SElBY3dCZkFITUFZUUJ0QUhNQWRRQnVBR2NBWHdCakFHOEFiZ0JtQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCbUFHOEFk?=
 =?us-ascii?Q?UUJ1QUdRQWNnQjVBRjhBY0FCaEFISUFkQUJ1QUdVQWNnQnpBRjhBY3dCaEFH?=
 =?us-ascii?Q?MEFjd0IxQUc0QVp3QmZBSElBWlFCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1lBYndCMUFHNEFaQUJ5QUhrQVh3?=
 =?us-ascii?Q?QndBR0VBY2dCMEFHNEFaUUJ5QUhNQVh3QnpBRzBBYVFCakFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVpnQnZBSFVBYmdCa0FISUFlUUJmQUhBQVlRQnlBSFFBYmdC?=
 =?us-ascii?Q?bEFISUFjd0JmQUhNQWRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJtQUc4?=
 =?us-ascii?Q?QWRRQnVBR1FBY2dCNUFGOEFjQUJoQUhJQWRBQnVBR1VBY2dCekFGOEFkQUJ6?=
 =?us-ascii?Q?QUcwQVl3QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHWUFid0IxQUc0QVpBQnlBSGtB?=
 =?us-ascii?Q?WHdCd0FHRUFjZ0IwQUc0QVpRQnlBSE1BWHdCMUFHMEFZd0FBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFD?=
 =?us-ascii?Q?QUFBQUFBQ2VBQUFBWndCMEFITUFYd0J3QUhJQWJ3QmtBSFVBWXdCMEFGOEFk?=
 =?us-ascii?Q?QUJ5QUdFQWFRQnVBR2tBYmdCbkFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnpB?=
 =?us-ascii?Q?R0VBYkFCbEFITUFYd0JoQUdNQVl3QnZBSFVBYmdCMEFGOEFjQUJzQUdFQWJn?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUhNQVlRQnNBR1VBY3dCZkFI?=
 =?us-ascii?Q?RUFkUUJ2QUhRQVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFB?=
 =?us-ascii?Q?QUNBQUFBQUFDZUFBQUFjd0J1QUhBQWN3QmZBR3dBYVFCakFHVUFiZ0J6QUdV?=
 =?us-ascii?Q?QVh3QjBBR1VBY2dCdEFGOEFNUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFC?=
 =?us-ascii?Q?ekFHNEFjQUJ6QUY4QWJBQnBBR01BWlFCdUFITUFaUUJmQUhRQVpRQnlBRzBB?=
 =?us-ascii?Q?WHdCekFIUUFkUUJrQUdVQWJnQjBBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBSFlBWndCZkFHc0FaUUI1?=
 =?us-ascii?Q?QUhjQWJ3QnlBR1FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFB?=
 =?us-ascii?Q?QUFBQ0FBQUFBQUE9Ii8+PC9tZXRhPg=3D=3D?=
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=soares@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcc906a1-ff7c-4870-dd87-08d7482863ca
x-ms-traffictypediagnostic: CH2PR12MB3893:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB38933452FB067DA7848E32E6AE9F0@CH2PR12MB3893.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(39860400002)(346002)(136003)(199004)(189003)(6116002)(6306002)(4326008)(102836004)(9686003)(81156014)(8676002)(81166006)(8936002)(229853002)(33656002)(6506007)(6436002)(14454004)(99286004)(256004)(14444005)(52536014)(6636002)(86362001)(76176011)(478600001)(11346002)(110136005)(966005)(486006)(5660300002)(476003)(446003)(54906003)(316002)(7696005)(305945005)(55016002)(186003)(6246003)(7736002)(2906002)(66946007)(76116006)(66446008)(64756008)(66556008)(66476007)(71200400001)(71190400001)(66066001)(74316002)(3846002)(26005)(25786009)(70780200001);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR12MB3893;H:CH2PR12MB4216.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +tyyRAF3odOpzXmT5Hrtg6aeyuNEq8BCXRFvoK/oW/3t/2NZrM7OekihNidX12ja6xlYoL9nTxsOOu2wsW0F+BdJKSbcccjY0O1URwwVfq36L5LBgdRK93Ka2/jPv3yZKfb1oJv/GpOX8wC88S3OUy9oAufxVJcEyPadXBcqGykiWp026RliKYs7hQTxgK7ECmyUUqHRy8Zhe1p3W8TqJ9dc4rwH9zq7Qql8PgpLBcekjB8JylEUh9srV3SY5rLZ+XogE5TTP3l8Bw6OHG9rkEhB00U2r/wB+0wI9aRwIiuX7hG849dwqvYvAz9VMO/edUc8WxEpWEP17zeUPPxdOiv1RrhtXgDT2dstadFNsDyQB2KsaiuseU3QPrifxjJcqFC3FCEnwT/Y2yszx2DNVU/RaSz2JgT6TABRZtKmy0a96fzBZXoqHdwS0bSBQqZWq6nHvk4a2PKJggoDHp7ZaQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dcc906a1-ff7c-4870-dd87-08d7482863ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 17:37:40.5374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FnsWLFJC+ld3XIDqmZo/Zki77OZmg7RFJSy8QrMPG2KaZma/uLwFKM0M+lbIJbHJ4BCH6wjse/l9pFOXteMbBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3893
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Boris,

From: Boris Brezillon <boris.brezillon@collabora.com>
Date: Thu, Oct 03, 2019 at 15:29:43

> On Thu,  5 Sep 2019 12:00:35 +0200
> Vitor Soares <Vitor.Soares@synopsys.com> wrote:
>=20
> > The newdev->boardinfo assignment was missing in
> > i3c_master_add_i3c_dev_locked() and hence the ->of_node info isn't
> > propagated to i3c_dev_desc.
> >=20
> > Fix this by trying to initialize device i3c_dev_boardinfo if available.
> >=20
> > Cc: <stable@vger.kernel.org>
> > Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
> > Signed-off-by: Vitor Soares <vitor.soares@synopsys.com>
> > ---
> > Change in v3:
> >   - None
> >=20
> > Changes in v2:
> >   - Change commit message
> >   - Change i3c_master_search_i3c_boardinfo(newdev) to
> >   i3c_master_init_i3c_dev_boardinfo(newdev)
> >   - Add fixes, stable tags
> >=20
> >  /**
> >   * i3c_master_add_i3c_dev_locked() - add an I3C slave to the bus
> >   * @master: master used to send frames on the bus
> > @@ -1818,8 +1834,9 @@ int i3c_master_add_i3c_dev_locked(struct i3c_mast=
er_controller *master,
> >  				  u8 addr)
> >  {
> >  	struct i3c_device_info info =3D { .dyn_addr =3D addr };
> > -	struct i3c_dev_desc *newdev, *olddev;
> >  	u8 old_dyn_addr =3D addr, expected_dyn_addr;
> > +	enum i3c_addr_slot_status addrstatus;
> > +	struct i3c_dev_desc *newdev, *olddev;
> >  	struct i3c_ibi_setup ibireq =3D { };
> >  	bool enable_ibi =3D false;
> >  	int ret;
> > @@ -1878,6 +1895,8 @@ int i3c_master_add_i3c_dev_locked(struct i3c_mast=
er_controller *master,
> >  	if (ret)
> >  		goto err_detach_dev;
> > =20
> > +	i3c_master_init_i3c_dev_boardinfo(newdev);
> > +
> >  	/*
> >  	 * Depending on our previous state, the expected dynamic address migh=
t
> >  	 * differ:
> > @@ -1895,7 +1914,11 @@ int i3c_master_add_i3c_dev_locked(struct i3c_mas=
ter_controller *master,
> >  	else
> >  		expected_dyn_addr =3D newdev->info.dyn_addr;
> > =20
> > -	if (newdev->info.dyn_addr !=3D expected_dyn_addr) {
> > +	addrstatus =3D i3c_bus_get_addr_slot_status(&master->bus,
> > +						  expected_dyn_addr);
> > +
> > +	if (newdev->info.dyn_addr !=3D expected_dyn_addr &&
> > +	    addrstatus =3D=3D I3C_ADDR_SLOT_FREE) {
>=20
> First, this change shouldn't be part of this patch, since the commit
> message only mentions the boardinfo init stuff,

This is not an issue, I can create a patch just for boardinfo init fix.

> not the extra 'is slot
> free check'.

Even ignoring patch 1, it is necessary to check if the slot is free=20
because if SETDASA fails the boardinfo->init_dyn_addr can be assigned to=20
another device. That's why we need to check if expected_dyn_addr is free.

> Plus, I want the fix to be backported so we should avoid
> any unneeded deps.
>=20
> But even with those 2 things addressed, I'm still convinced the
> 'free desc when device is not reachable' change you do in patch 1 is
> not that great,=20

If I'm doing wrong I really appreciate you tell me the reason.

> and the fact that you can't pre-reserve the address to
> make sure no one uses it until the device had a chance to show up tends
> to prove me right.

This is a different corner case and I though we agreed that the framework=20
doesn't provide guarantees to assign boardinfo->init_dyn_addr [1].

Yet, I don't disagree with the idea of pre-reserve the=20
boardinfo->init_dyn_addr.
I can do this but we need to align how it should be done.

>=20
> Can we please do what I suggest and solve the "not enough dev slots"
> problem later on (if we really have to).

I have this use case where the HC has only 4 slot for 4 devices.=20
Sometimes the one or more devices can be sleeping and when they trigger=20
HJ there is no space in HC.

Best regards,
Vitor Soares

[1] https://patchwork.kernel.org/patch/11120841/
