Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB6212B05B
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 02:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfL0BpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Dec 2019 20:45:08 -0500
Received: from mail-eopbgr60057.outbound.protection.outlook.com ([40.107.6.57]:14916
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726193AbfL0BpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Dec 2019 20:45:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obhCQfLfmiFywLtHQlEGYYrTeeZndRtdC2gHC/RkhYS4JiW/32LO0z7dpSP6qcI9GRu5trggodGg3m0vGsW/B/yxSAL004g0c3Hyxi88w96kfTekKLdt2Ddc922sUSsvvpYVVeZd29POod6wcqgWln2Vvu4EN92cpXHc5c6ACfoD5OWg8hlZOUux2nOEfYuE2qfPwCZ4X76KmwrykPN6XMqXbHMhZjt/sx/bwJuygskms4/6L13nh/amoKBr3KpM5yo1mY1ST4HCfwzPGZB5bYkuRodVSfbWD32adqlYHCmnXzoi4pfVqV4jnojTs8AbGIODzXUPAgfYKw+ng2ygAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXwSoMnnGm+oy+7j9oOIyaHdYEq/UhDHP/RKh2qT4GE=;
 b=TXcgqACpyhhsUZwqomTL+E5wm+ejlHHuY8gVHW7OhcAvhMU9pt7+VS/jOtrqjHQOlkoW5ySL8kj+wrl4KACWCR9OnsXf8vDBntcJ65OlSv6hPpbtFomHYbjs9wv6x0E092Ek5z/XzhPv5tx5E1pH6t/A3dfEcedo8Kj6spjC+sU5vel6vzRJrJq31LlhZT5xe5RbghMUDSMpnBf33vMCQAg3MWClLDCdixBlWEmwJqxko0+AkGvX0EZwE97UNlX4dkZD6I2HRaiN+/00CDlor+nom13fw31/7IK1/wiQ5Um9PBvrKQbIOqmzy+ay2kwy5iDZCmH9vgi+PjS4KFaIOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXwSoMnnGm+oy+7j9oOIyaHdYEq/UhDHP/RKh2qT4GE=;
 b=WfGHDCEQs0Vp3DsMkNlI135bZXj3zOxTb3ghuVZ9VO2G6TqsVV9erw19CYy3uIZ+bAm/hcfci7n7FfAiTcSuwdV2S0fq3vR/A3TMWN2FbWt7g/HWGvU+30IrvHEpMCxiNKVugcrOVvNHZl661dz7evTHDq55WCWmPykooT8Q+GA=
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com (20.177.51.23) by
 VI1PR04MB4318.eurprd04.prod.outlook.com (52.133.15.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 27 Dec 2019 01:45:03 +0000
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::c7d:58a2:7265:407e]) by VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::c7d:58a2:7265:407e%6]) with mapi id 15.20.2581.007; Fri, 27 Dec 2019
 01:45:03 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Alan Stern <stern@rowland.harvard.edu>
CC:     Guenter Roeck <linux@roeck-us.net>,
        Peter Chen <peter.chen@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: chipidea: host: Disable port power only if
 previously enabled
Thread-Topic: [PATCH] usb: chipidea: host: Disable port power only if
 previously enabled
Thread-Index: AQHVvAVIstmi2Z+Az0y8RyzR9GDiKqfM0jmAgABkPAA=
Date:   Fri, 27 Dec 2019 01:45:03 +0000
Message-ID: <20191227014459.GA5283@b29397-desktop>
References: <20191226155754.25451-1-linux@roeck-us.net>
 <Pine.LNX.4.44L0.1912261428310.6148-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1912261428310.6148-100000@netrider.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.chen@nxp.com; 
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8167a86d-e6bb-4175-5d78-08d78a6e6471
x-ms-traffictypediagnostic: VI1PR04MB4318:|VI1PR04MB4318:
x-microsoft-antispam-prvs: <VI1PR04MB4318B3C0F1E2E9D895A303928B2A0@VI1PR04MB4318.eurprd04.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0264FEA5C3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(199004)(189003)(81166006)(8936002)(33656002)(66946007)(81156014)(1076003)(33716001)(91956017)(66446008)(53546011)(8676002)(6506007)(26005)(66556008)(64756008)(478600001)(66476007)(76116006)(186003)(6486002)(2906002)(6512007)(6916009)(316002)(44832011)(54906003)(71200400001)(86362001)(5660300002)(4326008)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4318;H:VI1PR04MB5327.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 35LIt9sJBfbWJruPFhdj9SFJQs6uPiV+FcwaS0ipD6v4Rbr9sFrDYZ/gXObOEEV/tT89S4Qh9ZtrZzQdKnI51/tXbK09S+zyheTpbVWtkjW+sZPFcOpCi9f4qkYoR9XGUusdkNAMFU6aOIFpHmqMFK/hq6S1ZNBcmE03O7IJFuWwLKQMLbawAxBTBab5lllLo48LgZ02cJKNpZ6lWAAnw8gweb2S7lhkdsn78DJS4yU4ZUzo2vV1KeXEfw16BTtSF2cJNk1giWNvejQUDibtPNWfbvBmnLc6UaJqS2v/L/YmiCjjexAIt48EWDw/WwtcXpH8heH096yOut0aQezIRh5sK8Le7GZ4/z2EEDQGgDGoYwxD114D7WKcl7RtmsG/lnBoI1vwFJDc49cuuMcMvv6p764GwJD6FRSKh2fAcQQDAfFA9NryXx1uqdnDvdE3
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31E716C9DA2B6A42927990659E931A94@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8167a86d-e6bb-4175-5d78-08d78a6e6471
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Dec 2019 01:45:03.0592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zotjv6AD48N277r3QDGvVghcZWUO/dphOtPCFfiMRWVIgqy5+Mj4hgRdefufcDkxmffPPwOce31aNMAAmL3abQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4318
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19-12-26 14:46:15, Alan Stern wrote:
> On Thu, 26 Dec 2019, Guenter Roeck wrote:
>=20
> > On shutdown, ehci_power_off() is called unconditionally to power off
> > each port, even if it was never called to power on the port.
> > For chipidea, this results in a call to ehci_ci_portpower() with a requ=
est
> > to power off ports even if the port was never powered on.
> > This results in the following warning from the regulator code.
>=20
> That's weird -- we should always power-on every port during hub=20
> initialization.
>=20
> It looks like there's a bug in hub.c:hub_activate(): The line under
> HUB_INIT which calls hub_power_on() should call
> usb_hub_set_port_power() instead.  In fact, the comment near the start
> of hub_power_on() is wrong.  It says "Enable power on each port", but
> in fact it only enables power for ports that had been powered-on
> previously (i.e., the port's bit in hub->power_bits was set). =20
> Apparently this got messed up in commit ad493e5e5805 ("usb: add usb
> port auto power off mechanism").
>=20
> Now, the chipidea driver may still need to be updated, because=20
> ehci_turn_off_all_ports() will still be called during shutdown and it=20
> will try to power-down all ports, even those which are already powered=20
> down (for example, because the port is suspended).
>=20

Hi Alan,

When the port is suspended, why it was turned off? If it was turned
off, how could respond wakeup event?

--=20

Thanks,
Peter Chen=
