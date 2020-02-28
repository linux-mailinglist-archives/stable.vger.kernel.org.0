Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68B517331D
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 09:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgB1Imd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 03:42:33 -0500
Received: from mail-eopbgr70119.outbound.protection.outlook.com ([40.107.7.119]:36289
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725877AbgB1Imd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 03:42:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfBzK537LSF3eX1M3KauZHJ7HiCKgOed07kILEsJMXbY8X7jo1HU4CyI22KUlcvXEKsDLB3o9V4snPCBh8nonVVh42py8ATe6Cl+C8Nm3VPFg8CN+q5ErX/9Y2MHhbRvTSJ4KexW7esNB7uIymcrVe+f/fMfiYS9mQw6X4wIM61kCk/FzJiL3d0VVncTKgaHpsLfoVg/ueB3EGL4/txDGw7ZAGVkVzhXbdfqIkkrwfJwrLfmch/fx8ay6v+MXQfhkD4esaS1ViPHaWMYOuSY1K0NlqeXZaGiYw2W27FlTjFgs6g5apKh+7piA3G7aOzFMIAMHz4lg77m0Xfgun8uZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knvowosbv4iaeSg07t2TRgITO0gRFVHrFW6OinWE4dk=;
 b=aBFBPhIO4367Is5ZP1OrfGwHEmuQSpc3QlBoeL7qQv0qQXeFXLsBgvQuEHHQ6IM0z14j9QUVqTfvPkn6YzOQSflSiwVbg8Chyqc1Nzu56Ri8MdrR5ImR++oK9F7uWRqQuvjJopPBWwrPpeHqLMp0Np/jDwNgES7VnnLhGANGqsEfTm1JMQynJXc/ZLJXHZ7az8qkSab1AqOFOMV5ggjVN8oJQ3EE40vNV8qudCrCgsVxLuDUa0HUrPkiuI8aTK2Qo/0kBknoZDK4N73gr3PZfoUsyFupDLJ7vkj4hypw1s40JD+tNN8FaTCeBbqdrdNG9FzX+s3V05hT63FKDBclhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knvowosbv4iaeSg07t2TRgITO0gRFVHrFW6OinWE4dk=;
 b=RhWLgJDSyU3v9o+j/hv9Fsv46FYSZgwC+18NDG+AJt3j5FwIyug+ycd+yKNqRYuTQzS5v+KCDt3o+dPiKytksdx5SFhkfVjlukKPOM4n+F2HGF+aSaQpZoM9GFb2Z/wQzC5N800Hjz8AmH6QgXkA2acc/emaLKa2Epf02giP8yA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=tommi.t.rantala@nokia.com; 
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com (10.167.127.12) by
 HE1PR0702MB3628.eurprd07.prod.outlook.com (10.167.126.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.13; Fri, 28 Feb 2020 08:42:28 +0000
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87]) by HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87%5]) with mapi id 15.20.2793.003; Fri, 28 Feb 2020
 08:42:27 +0000
From:   Tommi Rantala <tommi.t.rantala@nokia.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4.14] tuntap: correctly set SOCKWQ_ASYNC_NOSPACE
Date:   Fri, 28 Feb 2020 10:42:16 +0200
Message-Id: <20200228084216.15816-1-tommi.t.rantala@nokia.com>
X-Mailer: git-send-email 2.21.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HE1PR0402CA0022.eurprd04.prod.outlook.com
 (2603:10a6:3:d0::32) To HE1PR0702MB3675.eurprd07.prod.outlook.com
 (2603:10a6:7:85::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from trfedora.emea.nsn-net.net (131.228.2.19) by HE1PR0402CA0022.eurprd04.prod.outlook.com (2603:10a6:3:d0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Fri, 28 Feb 2020 08:42:27 +0000
X-Mailer: git-send-email 2.21.1
X-Originating-IP: [131.228.2.19]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0c0ce852-c867-4e11-79d2-08d7bc2a23f8
X-MS-TrafficTypeDiagnostic: HE1PR0702MB3628:
X-Microsoft-Antispam-PRVS: <HE1PR0702MB362870D41C4F51700FDDEEF9B4E80@HE1PR0702MB3628.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(199004)(189003)(36756003)(6486002)(6512007)(5660300002)(6506007)(2616005)(26005)(478600001)(16526019)(956004)(66476007)(66556008)(81156014)(4326008)(66946007)(8936002)(81166006)(8676002)(6666004)(316002)(2906002)(1076003)(52116002)(186003)(86362001)(103116003);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3628;H:HE1PR0702MB3675.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3WswW6+WRm5OAYFqrbZT9mb0nIbj7VAc683iGgsGxzVqv1p7ARn4Q+a/75E8vEnxnhs9CBqXHvsHZAIKEKGa5gdA+GxaDFBLox1CQ95B0wXSLQq0HMYVF4gnbN5GrBKKAaHr3gr+EmY7sCFs46hi+5tzgi5W//yiAKKCDlMrXa+7IbvPOTEX4wWC6sWPTR90/CMFjx9pdulYx0BBQInF+AMfy957hdUYCz08BFihp4YP2UKuKWt9ykoPm5TkgpD8GyqWI3HXliAzy4zyIDdmCVpUiRwdrYHXt7xMuuxG0e0wqKdg0PP6477A2j59r/1RHCx33aG1tQ8wp32EVm6/hOYW2u40Ih/l9sMXYw6fFOW8cNXxby6taJhfhlBLzGhTbVboluJj3CoWtaEDhz6DQjUrAlpKOtqHluuVdIVYipEpZIjnvL9YgR8p0Jx4P+fu
X-MS-Exchange-AntiSpam-MessageData: 20pr1PgoOZTrJinTCm5eLNg5eT6o955qZLviud4eUvtT1VLZ/s9Mw2wjTXUyKdrvxUCG3lrhSDlEZAAsOvs1qSsAyLIjznXYLR0JPPbfe+z9bBP8F1pCRm15i6//imJuAsRdRo+pfUA2Y3627+2oWg==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0ce852-c867-4e11-79d2-08d7bc2a23f8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 08:42:27.5658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d/G1myJFD1JdMZH8p0TmtjQEXilCnnp0sbHhzVdd8EhNclllKHtC8lirQXS0Jt1nN9GLll0C1jvlFj27hGxozMStSjOz7dCNIs5UvSmBH5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3628
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 2f3ab6221e4c87960347d65c7cab9bd917d1f637 ]

When link is down, writes to the device might fail with
-EIO. Userspace needs an indication when the status is resolved.  As a
fix, tun_net_open() attempts to wake up writers - but that is only
effective if SOCKWQ_ASYNC_NOSPACE has been set in the past. This is
not the case of vhost_net which only poll for EPOLLOUT after it meets
errors during sendmsg().

This patch fixes this by making sure SOCKWQ_ASYNC_NOSPACE is set when
socket is not writable or device is down to guarantee EPOLLOUT will be
raised in either tun_chr_poll() or tun_sock_write_space() after device
is up.

Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Eric Dumazet <edumazet@google.com>
Fixes: 1bd4978a88ac2 ("tun: honor IFF_UP in tun_get_user()")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
---
 drivers/net/tun.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3086211829a7..ba34f61d70de 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1134,6 +1134,13 @@ static void tun_net_init(struct net_device *dev)
 	dev->max_mtu = MAX_MTU - dev->hard_header_len;
 }
 
+static bool tun_sock_writeable(struct tun_struct *tun, struct tun_file *tfile)
+{
+	struct sock *sk = tfile->socket.sk;
+
+	return (tun->dev->flags & IFF_UP) && sock_writeable(sk);
+}
+
 /* Character device part */
 
 /* Poll */
@@ -1156,10 +1163,14 @@ static unsigned int tun_chr_poll(struct file *file, poll_table *wait)
 	if (!skb_array_empty(&tfile->tx_array))
 		mask |= POLLIN | POLLRDNORM;
 
-	if (tun->dev->flags & IFF_UP &&
-	    (sock_writeable(sk) ||
-	     (!test_and_set_bit(SOCKWQ_ASYNC_NOSPACE, &sk->sk_socket->flags) &&
-	      sock_writeable(sk))))
+	/* Make sure SOCKWQ_ASYNC_NOSPACE is set if not writable to
+	 * guarantee EPOLLOUT to be raised by either here or
+	 * tun_sock_write_space(). Then process could get notification
+	 * after it writes to a down device and meets -EIO.
+	 */
+	if (tun_sock_writeable(tun, tfile) ||
+	    (!test_and_set_bit(SOCKWQ_ASYNC_NOSPACE, &sk->sk_socket->flags) &&
+	     tun_sock_writeable(tun, tfile)))
 		mask |= POLLOUT | POLLWRNORM;
 
 	if (tun->dev->reg_state != NETREG_REGISTERED)
-- 
2.21.1

