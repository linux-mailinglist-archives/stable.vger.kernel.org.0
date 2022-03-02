Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551A04CA265
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 11:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238453AbiCBKlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 05:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241105AbiCBKlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 05:41:11 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80139.outbound.protection.outlook.com [40.107.8.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24437BF519
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 02:40:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVGJsa9HSUK2jZgiPN8tzLk0XE2UilR5pCxXPhYQVoA/TvYxCheThON+tz/OG2zBmdCTaj9hrWAOSGl1a4kPonmj6jlSpfMDdjUGMngc+OEBtQp8YDiWUiox1VpihN4PSRAs0lS4sy8YM/l/9jn+CBg1bUn3velLhnFWrZHCkU5ALPFJ0XFhz4sgwazfE7WbxXMKWFJNCdLx3q4b7c120zQJkYJjRiQBU9E+iIsuanTeX9uCqpkC0uDQCQvOx65T8p9Kl0stEdOQn8jmedO1uJH3bKSH9f0JakBccKufu/W4Isvax9R4CNjYZOtPIpsPRiGQaIYEvgZYHVffMQEdqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/cfKR9Q2wEhkLoDORJYsOckClUuKWWP5DBSVv/o2Sk=;
 b=YPxfeSWVgeFROarqughOMWURFt7SFaqrNDfb0Ld3fkxl6DRQdDfTpYZtyw28reXLphsvb0XdmajzJqGMrarzu1jXst4hUn77YiUksPWCyw6c10pIO5g+Zp1M7VYgjFsTk6PPz98ecCZckQu0OVvt0ZvbFAlBhpuz2yD/tLT3RH3GByN1p8UOMPB3jtUC8SDLCZaBIbnZuNicH4zKTOSYKFuZIHE26b1RSECSiDF+/bAfoR3XxpagySqHo6azBHt/hQfBApwpiruKPFRl8u3LBc7rfzCd9/qhleO9zEYSBFrNnIj3M/8H4ROGuLFWXpI9RbyktAH5I2Pa5u/btIkPuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=secomea.com; dmarc=pass action=none header.from=secomea.com;
 dkim=pass header.d=secomea.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secomea.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/cfKR9Q2wEhkLoDORJYsOckClUuKWWP5DBSVv/o2Sk=;
 b=hw8hpxfBAnI1awZT33XlxzP0nlTY4nKI9v30IzEgi7ZQYGNEOFbLXsOSn8AEU0hVZkNcLIQ6Ctquh+zeUqFJijBVLPlXfq143rT2a9pEACCEV4kSBZedDPOHRzON1L3OuZnEZsQqxqQWd2T7s0yExjORO/o81dvft09ZHpP6SyE=
Received: from DB7PR08MB3867.eurprd08.prod.outlook.com (2603:10a6:10:7f::13)
 by DB9PR08MB6585.eurprd08.prod.outlook.com (2603:10a6:10:250::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 10:40:21 +0000
Received: from DB7PR08MB3867.eurprd08.prod.outlook.com
 ([fe80::216e:9d9:ffd1:7af1]) by DB7PR08MB3867.eurprd08.prod.outlook.com
 ([fe80::216e:9d9:ffd1:7af1%2]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 10:40:20 +0000
From:   =?iso-8859-1?Q?Svenning_S=F8rensen?= <sss@secomea.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Resend: "[PATCH] net: dsa: microchip: fix bridging with more than two
 member" for 5.16-stable tree
Thread-Topic: Resend: "[PATCH] net: dsa: microchip: fix bridging with more
 than two member" for 5.16-stable tree
Thread-Index: AQHYLiCtsJ3RpEYR60KENqOjseRkww==
Date:   Wed, 2 Mar 2022 10:40:20 +0000
Message-ID: <DB7PR08MB3867B6632107AB7449591CDEB5039@DB7PR08MB3867.eurprd08.prod.outlook.com>
Accept-Language: da-DK, en-US
Content-Language: da-DK
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 5f2090bb-6d08-c0ba-dfab-06af3b4a99b2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=secomea.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c03bc5a-aed5-41f5-4307-08d9fc390ceb
x-ms-traffictypediagnostic: DB9PR08MB6585:EE_
x-microsoft-antispam-prvs: <DB9PR08MB65850B53A58F4BCBD8B54522B5039@DB9PR08MB6585.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h11CSqrnDFU5+s0wXPmhk6eAoEB+HSmD+SG2VN9qnocN00lyzcIFQh9J9Rx3OUEU7IrYtlt52pcfgnyQl8NIXwxQcvIqVMfTaUDFY/aAOERlL/errB6hFFMCYqnDFysnCYJZLAGov8kzDVpbF3Z1eyL6AUFQUypvrWzZ6lvXclB52utjo2y0xFxsAqFZYfCiokjgA0oSmhdwyNTkj71QGbsScuxrTLWmlrM0kG7Ca74vJZzyL4yotoY1mNxVWWNEb8GsxPYv5aUWAOxHgODBKZWtioL1T6JUa6WyI9k5jiypUBO9jvkH/Caba9nDs1xbOKY0F9pI6GAK63C9cEtltp12m638kCQjokNpGyZ3R9EuaC87OL4s3UHK4zBHCbD4fTdwvKHSPNAKR2kWylUCVBjv1q56xoeqNUUgp0riGoi9+7hsPcxrak1xgn4SNtmC2JtjC4dd0eLFeTHNXObpLT/ZaokkZdNfCpYelQ5Ba7TnShLBPUa64QoB6aH+TIJB7kob3y29S2MF1bokV7GlWIpLBtnKxK9nphHNo2NjceIq1XzfG+EMojuNROpeGfdIHk8IqJBM5grLp6atoPIc2A5JbI9PjZXFD9q78XTOA2wlvPLkzEwqKe3CAh7VKnzMt2lEbyMQEAfkM6vprzIZP/K25J4e+X851+i06LxE7/L6HWn1VqlRJKdJThKqDQ0oIolNqBU00QB0mu2Li3SPqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR08MB3867.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(39840400004)(366004)(376002)(346002)(396003)(136003)(55016003)(54906003)(33656002)(508600001)(38070700005)(5660300002)(6916009)(26005)(316002)(2906002)(66574015)(186003)(71200400001)(86362001)(66476007)(83380400001)(9686003)(66556008)(91956017)(7696005)(52536014)(38100700002)(66946007)(6506007)(76116006)(8936002)(122000001)(4326008)(8676002)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?zJAl/HJnRAnoNMUHHEEM9b8uZ1+e2cNranFBVIqf0gs/ULJmYALQL4kvW6?=
 =?iso-8859-1?Q?oVz6fgJ5mrgyMTMuO+QRY7mCG6SShDUB37OHrUJNdgSt/sHPMI5HWb0bpP?=
 =?iso-8859-1?Q?lNjlnkN1/nwGGUmy8dX6s9qQdRGCEOthdnKt7IM2nlGZqG0NngD4kY0bRA?=
 =?iso-8859-1?Q?wQGBGNFNouqY9mio1rinBkQ0h5bn79VqQME1yk2RDFug7YrD14zwu/d0gE?=
 =?iso-8859-1?Q?vAwzOc/UW5hvm/OUnaG7XyIOTb0OmyvHU2MDLwtah6ESRoTT5nnjRu8uQk?=
 =?iso-8859-1?Q?yhe13Ofey0BRZtGEhMuaU0n5s1SC7nNM9P9eqIX80h0gpBN1j+DhEMOP6g?=
 =?iso-8859-1?Q?5NToMyMCq6+OG4japIQzF2BM+r+NdSamdNDP8QM6C50N38jKvFfhL4105Z?=
 =?iso-8859-1?Q?ozQ5Z6rfnrWlWUWfZR3u41QjQXxHazJndGFTMdVufzwXTm0bCtNTrUrY2o?=
 =?iso-8859-1?Q?LKzJiN7IXyF8QMbgeWTgK6gX4y9BwTd1tpGqMygH5yVgUEO+FEyQ1SvA/u?=
 =?iso-8859-1?Q?y0JrxHlbZ1N2kWIN8bAfM0yj6cUbyIwhNsLfYxGzBkhYpkFy5u8Tf/7jN0?=
 =?iso-8859-1?Q?4A9rfQW2JDO2hPjg+PIk9NLv2sWIGfAdNBk8iGKUTMohlovUWXYA4/1mT6?=
 =?iso-8859-1?Q?r6bdAppGOR1n3+YZuhgwVv0ne10FgGCHX/lwzfxM0KIQAgXvHKmOIkR59E?=
 =?iso-8859-1?Q?iRhqyY/4qnb3k5D8tucWW3IzzpUJWdJoGqzLAufVlYaiWz/172rxnG8jZC?=
 =?iso-8859-1?Q?fLgVl4gc83r2ZlyfyaVToSG5p0YqlqxQ/ZX5PHF1DrhKB21L4TAFhlapWv?=
 =?iso-8859-1?Q?rTlcoNJ04rr0JozAInafBl/EyTRQaSvu2JhsFu6qxo1xmN8+wN1m2FX5uE?=
 =?iso-8859-1?Q?TXRZcaf2nmLoXx3v1CcL9pGCzcn7ruHogJ4M2RllFyom5WWia46fTVj73B?=
 =?iso-8859-1?Q?NFo4P3BRul2pN+lEcArwib6ZjuQf0o85EQRcCZsIoIRY9pl7qxyKvChwFl?=
 =?iso-8859-1?Q?4IVOctpHi3OiL436Re4voigWIPJbF6trmO8awsXbmVAAIXvzkc8dwoGtzp?=
 =?iso-8859-1?Q?DsKNZAAZ/StW5tGxlOA48a+oyJFZ/Lo84RYOZ+GxGSUu94tdhbjNrX6tx9?=
 =?iso-8859-1?Q?70EwWOPRWtLK856F/12eDW6xayWvaBrxKy1tw34E0DPDp5UwkWoiz5vS4z?=
 =?iso-8859-1?Q?K90djyws4aHuuDYwp95GJlVOw2CChjyqeEWQwWOi9UXpZ3/uk2RYqmGn7L?=
 =?iso-8859-1?Q?1oTe7l/eRe5Wspwfak/LP4nFvNMa5seqQPJQtCVwOw9wTTZWF5tTr0Gzko?=
 =?iso-8859-1?Q?czeeo2SFRMWg6a0hEArwt6r8dMmnSPtFn/7pDKrK2ckthZ/ZQdcJy2lx2x?=
 =?iso-8859-1?Q?n+RddYzIcqNCNGPZL6Y1YzpwBW4AuQdHSr6UWDzlB4N4EIlREK4mUry8ka?=
 =?iso-8859-1?Q?IGBBzZ04UYGWJoAfBmnNoWd0NYXphishXeSGzVFwutldAxF3nD4ZA16XkY?=
 =?iso-8859-1?Q?kBJB4sG8NyFirSj6QfybNt35QZgKuhRjXZlXFEiGrUDpWiMN9FB6kjXcUb?=
 =?iso-8859-1?Q?Php18Ku5HBlEysqG24Ab4sG/WKJgMJ+MkCqbvlESydm/Ah+Yfg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: secomea.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR08MB3867.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c03bc5a-aed5-41f5-4307-08d9fc390ceb
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 10:40:20.7372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 979261ea-5b3f-4cae-9a49-3a7da1f4fb47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q/qhFam7TxuPozXZ4mjifeduuxvdDOSEFg19Hn9GSQ2Fh3ulcaPn7MJ6LCI7Ddsu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6585
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")=
=0A=
plugged a packet leak between ports that were members of different bridges.=
=0A=
Unfortunately, this broke another use case, namely that of more than two=0A=
ports that are members of the same bridge.=0A=
=0A=
After that commit, when a port is added to a bridge, hardware bridging=0A=
between other member ports of that bridge will be cleared, preventing=0A=
packet exchange between them.=0A=
=0A=
Fix by ensuring that the Port VLAN Membership bitmap includes any existing=
=0A=
ports in the bridge, not just the port being added.=0A=
=0A=
Upstream commit 3d00827a90db6f79abc7cdc553887f89a2e0a184, backported to 5.1=
6.=0A=
=0A=
Fixes: b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")=
=0A=
Signed-off-by: Svenning S=F8rensen <sss@secomea.com>=0A=
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>=0A=
Signed-off-by: David S. Miller <davem@davemloft.net>=0A=
---=0A=
 drivers/net/dsa/microchip/ksz_common.c | 26 +++++++++++++++++++++++---=0A=
 1 file changed, 23 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/micro=
chip/ksz_common.c=0A=
index 8a04302018dc..7ab9ab58de65 100644=0A=
--- a/drivers/net/dsa/microchip/ksz_common.c=0A=
+++ b/drivers/net/dsa/microchip/ksz_common.c=0A=
@@ -26,7 +26,7 @@ void ksz_update_port_member(struct ksz_device *dev, int p=
ort)=0A=
 	struct dsa_switch *ds =3D dev->ds;=0A=
 	u8 port_member =3D 0, cpu_port;=0A=
 	const struct dsa_port *dp;=0A=
-	int i;=0A=
+	int i, j;=0A=
 =0A=
 	if (!dsa_is_user_port(ds, port))=0A=
 		return;=0A=
@@ -45,13 +45,33 @@ void ksz_update_port_member(struct ksz_device *dev, int=
 port)=0A=
 			continue;=0A=
 		if (!dp->bridge_dev || dp->bridge_dev !=3D other_dp->bridge_dev)=0A=
 			continue;=0A=
+		if (other_p->stp_state !=3D BR_STATE_FORWARDING)=0A=
+			continue;=0A=
 =0A=
-		if (other_p->stp_state =3D=3D BR_STATE_FORWARDING &&=0A=
-		    p->stp_state =3D=3D BR_STATE_FORWARDING) {=0A=
+		if (p->stp_state =3D=3D BR_STATE_FORWARDING) {=0A=
 			val |=3D BIT(port);=0A=
 			port_member |=3D BIT(i);=0A=
 		}=0A=
 =0A=
+		/* Retain port [i]'s relationship to other ports than [port] */=0A=
+		for (j =3D 0; j < ds->num_ports; j++) {=0A=
+			const struct dsa_port *third_dp;=0A=
+			struct ksz_port *third_p;=0A=
+=0A=
+			if (j =3D=3D i)=0A=
+				continue;=0A=
+			if (j =3D=3D port)=0A=
+				continue;=0A=
+			if (!dsa_is_user_port(ds, j))=0A=
+				continue;=0A=
+			third_p =3D &dev->ports[j];=0A=
+			if (third_p->stp_state !=3D BR_STATE_FORWARDING)=0A=
+				continue;=0A=
+			third_dp =3D dsa_to_port(ds, j);=0A=
+			if (third_dp->bridge_dev =3D=3D dp->bridge_dev)=0A=
+				val |=3D BIT(j);=0A=
+		}=0A=
+=0A=
 		dev->dev_ops->cfg_port_member(dev, i, val | cpu_port);=0A=
 	}=0A=
 =0A=
-- =0A=
2.20.1=0A=
=0A=
Hi Greg,=0A=
I'm sorry about the crippled patch in my last message.=0A=
Unfortunately, I have no other means than the MS webmail client to send mai=
l,=0A=
and it seems it corrupts plain text when replying to a thread.=0A=
Therefore, I send this as a new message - I really hope it will work this t=
ime.=0A=
=0A=
Best regards, Svenning=
