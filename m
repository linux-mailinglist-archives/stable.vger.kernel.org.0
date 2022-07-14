Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E5757558A
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 20:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiGNS7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 14:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiGNS7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 14:59:38 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80087.outbound.protection.outlook.com [40.107.8.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E8C3D595;
        Thu, 14 Jul 2022 11:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOy62OH+KXH7lP8gHHZ0Grkk7r7b88xakv4Sntm97Dlk+/tKuItJjgHyfYUJEK0urHo6qPNwBIp5WRaeu2FXJYLshOngoO7OaN/yMpt/Bm5kNwCHXB25aAAIDrTC4nqpi7untatgo+Cht993zsMrNJbFSoPoODtRab4miTmP2/TDjvWrSpQlzuad9hPFXbbG//MKh7HPa3wNMGF3uiwHMdy+8BFOeZv28Yf0D7kRkXJf0GYIMJvHyMicJ9e3pZJjS4AEZ49y3yQplSmk3rEAdkJVfchdOUgbm7tGQc930CAiamlu9vc3GbhEqq8qbqNUAoLncF9W9gyLWhYX3EFVzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jWUkBBEIXWlAopE5NG1kMV4gvJ7nnlZ2fzJwc5wDdlk=;
 b=DGyb2GYiKxz1Z1bJmlv9o7aDaqNjvIx8VkpBqs/gb/dua/wXr7/O9i9VJ85to2b7Xvp0oDCug0C9kGWXRCccxuXmVdHnRU7yQISWTzIopvJ7M0K3Q9zMQlQq4MuEE0bHqpJbUyq4bRVktMEeL3ONM+cXfZcALTcpyhnCtHpXWf4GhzHxQzQ3IK/YJGrCnhJUz5vy/1YRH9yDNb15Zt08dtOfl4vSCB49EDFz81DIkoaAik7JgN6gbVvcqjoAWmXsgagHeYdXuupvSWzXFwOU1YtATJjDPjV0iqwLP5l1uIiTJc/iROqQmlIXpoNS8cbOx4gfMTscaB8pZaZ1sUIV2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWUkBBEIXWlAopE5NG1kMV4gvJ7nnlZ2fzJwc5wDdlk=;
 b=jmpSO+wDBz3NpMLn42iqsHM7wD/C4fGLoZelADzACiBuUpZoit8rnDpqki7UbV5sQM0tywmkTGhfu5iMIs/m88q47BtSp57kGmm30kU1U0IJksw5bJ6xA1fwUUbj2gyD7PIaH1sQdE/qx8d1Nfqu3XQsdq+xkPjiJVehhjMZVNc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8274.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::23)
 by AM6PR04MB6181.eurprd04.prod.outlook.com (2603:10a6:20b:b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Thu, 14 Jul
 2022 18:59:35 +0000
Received: from AM9PR04MB8274.eurprd04.prod.outlook.com
 ([fe80::34eb:6533:85f0:5ed6]) by AM9PR04MB8274.eurprd04.prod.outlook.com
 ([fe80::34eb:6533:85f0:5ed6%9]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 18:59:35 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-serial@vger.kernel.org, stable@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH V2 1/1] serial: fsl_lpuart: zero out parity bit in CS7 mode
Date:   Thu, 14 Jul 2022 13:58:58 -0500
Message-Id: <20220714185858.615373-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:a03:180::37) To AM9PR04MB8274.eurprd04.prod.outlook.com
 (2603:10a6:20b:3e8::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99da6998-1c0a-4fbd-f58f-08da65cafe75
X-MS-TrafficTypeDiagnostic: AM6PR04MB6181:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZsxcfSHTN3/PvKU0JjvglYE+XEErJfPRnTL7rPWdsVWV0JRJ8YwQvuyMJGj3TR3gAX0T6R+qOWmUIA4VHcrj9pqEpm64wB1+FifeavChWA3pWE0JlnG+HF6O6H0TEOoCwMnhDCBn8cC87wJHtR1Pzc/o5Ulj4QTpJ2kWj2RvjbNAXWZTH+XDwgdkTY+v7+Frgk598DeFfMA2TmWWkRo+p98oCcod4lleXyRseQwPi7jLZQmMfcQKk45iwieANpuKkwGodftWgCUjhcukGOpVOHIsAi5v64U2+zO6Z0CaQ5wDCitE0jwuP43XyFABmlFrPFWX0GGb+GahlNy5PowGcj3DuKJtstmQhUmXgzzMMFyoCqbr7wg/++lFi5udTPD3cXBbRnaxF82n7wsOswP9xYCartexybVT2tcHVhPFfoYH5Fp19m9aJAkLT7bJLOvbWTyhzXxPgtq9V9z4IPxRCYhgT4TtHJRLWOS3ber/EcFnIzw95nel6s9DJTI4brsw27Bj5fbILIRKpuOp8sHnHX63feXbPKJZnBB9XNGCaq6QENnmnhWlQms52q3C4/RVoCwlK1Xb48plz8q3Ip1ZsELdJi2JqFBq2jyD9woyeQ6ATfW70btLA3RHACv4vnR/fZzQC2g7tRpDKkERXPJZJd8QMe0Hk6rxwnxtCPIgkTWArpbO5SVKIgkSLWq/xPq2g1qQjKHnJjzrcIh1qR6EW9/ePb9CfZmEH/lg9unzeRYjvsGzPkwmZ32LTZBVlkbJ/lcg80Su0rzwDNk/6dPiA9QuOAgNaJi2jTRuFjKdo9BMNIaJfmOGElIpyiUWpGO/CyFfmIuqICW10vXFmLh4lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8274.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(66476007)(6512007)(6916009)(26005)(6506007)(6666004)(41300700001)(6486002)(55236004)(478600001)(52116002)(2906002)(66946007)(4326008)(66556008)(8676002)(316002)(8936002)(5660300002)(38100700002)(38350700002)(186003)(36756003)(86362001)(83380400001)(2616005)(1076003)(47402002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HLkStPd7PKOz9byWgOJcwhrqnI6OtPOOcoqBI+BFdFTszUfoQdzO9icQ3PAr?=
 =?us-ascii?Q?iLquaxXKkOxRiKNWu/n3J+hedWeKBUwMCke8ZID1QCBhiS4Yjkq2hjo13ydw?=
 =?us-ascii?Q?fggHvOYW0vJurRmsylBx4bxcu3rkM0e4ydWkEgerAZgNd4jC6Y0Ur4XgrKp6?=
 =?us-ascii?Q?LPY6blP7y4gA+kIjy3znkucgLh1CknzFKZ1zLGuh9pA3YiegogscLllWlnxn?=
 =?us-ascii?Q?3cwIq7DjyO6G0ZvCeTJI2pCtJKVAS9pRekqgs2CGyNf3fd2EzNJ18jS7ySEe?=
 =?us-ascii?Q?2pYlt13c7M9FzEpR/LhWkA4TcCR8tL92j9zaaP+91fOa2f1nRiMekL+F5OnO?=
 =?us-ascii?Q?g/+FgYPXv/DqHNHZJcCVOj0qCccTeJG3BCCc0X3n4qq1JUb5iz/eU4CbYfHC?=
 =?us-ascii?Q?aNceO2GG6JEGBLl6fIBS7l+bTe2yDcG3+Bwq8+g54ONd+W5+m7lFc2UL9FdQ?=
 =?us-ascii?Q?31S1XgU64Saiziiz8ZANq/z/VLCg8BrERabCTKNIgwkZNoDdFU8F3t2jrY6Y?=
 =?us-ascii?Q?acNjC+/OVsDwP593tquLsgDD6jyk5NRwm52wRPE5n7E+YH9cRn4nzwIGH+TP?=
 =?us-ascii?Q?ApBOvUhmf9AOEzTK0U8qn7QHapZ3onJgRx8e8DlDSh5IR5T/cYvVTa1flpvq?=
 =?us-ascii?Q?Ya7Qeq+W1PsGzPj4RTvPkMUMjhcWSdztWHEG+BxZrZ9bNT32dJi+ug2CPhjm?=
 =?us-ascii?Q?6XGCJ3No4QvGFxpd1GIl01JFsxCPavlORgSsCfLlxcpbNgbkobOHLBrEjd1j?=
 =?us-ascii?Q?ygrok3yXmPh2T2mNp9/9ywYO+pXwuziva5o+Tq4/1u31D3A8HbwlMtoflO63?=
 =?us-ascii?Q?698aPRym9XQt0Z4/4CAQoEcnK4oy/sBZy4I3RDCS5qxUnlntjiKl5pUbLR0V?=
 =?us-ascii?Q?x0gLIYj9ZEo9lAiq8ki4zgLytDyW5JlWSwyT30YKXqs6Qyl74mPr5IHO884v?=
 =?us-ascii?Q?p11hKWdXO/aj76skE4kVkEdX/5f7LQP/UGKynyZF9WEDNF1VpdMyO+7THpEK?=
 =?us-ascii?Q?8kr+ZtIVqaEwZMkaCMzs16vKAyo1ODvoySm5jJYFrVfrTIgYzQbZe9oFfqWM?=
 =?us-ascii?Q?SARPSuADjtyJ26/SUnF33e/NpYLyU8prXgKBxvGdnRkmKROClYZ5tiKlXGFg?=
 =?us-ascii?Q?GZt7r/m0mbj9if+2L0AoHfqnZF6hU8Tr2eo2FkF7yrtY9Lk2PnVbvpf2r0H/?=
 =?us-ascii?Q?UeeuPSsTO3gayb1jSryXMRBQy/tFjyXgM/2fhSPy0txY12DtvaTTPx5OpRrD?=
 =?us-ascii?Q?HAPl6ztzc/C/X/MLR+eZRc0KQk98zy72XqhjQUcNOwSH+MJQD4TAf/eacP8M?=
 =?us-ascii?Q?XAJLYNtuXmF+O0aT5YD14++7KliDVzKzinKBcs48b4y89RqdqS2ZHSPo3UJD?=
 =?us-ascii?Q?tHn2ZSp/ioNRb9CeOFUXumeCYz8WUO5xwxObT3j+f8DquloAUW0es8zzOHCk?=
 =?us-ascii?Q?sgWFJ059u05ke/e1iTImesV6FAQzOSjJKUbcrqatY1+gukq+E9/5iRYpDafm?=
 =?us-ascii?Q?6aP0302y/mYAIJSjtz1AVHWO71VFZdr/4a3D/KriqSzaYJ7baSsAOjQ7xch6?=
 =?us-ascii?Q?sFc7IuESQOUDZsxdVEjKrtiQrPzJR4xlEhWFrikC?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99da6998-1c0a-4fbd-f58f-08da65cafe75
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8274.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 18:59:35.3913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GSYMnBp8kNGFqoAk16qJG5bVBsPRY+ZvwP9TPpgPszqbdEyeNB+GhSFJ+HKTaMVdnK5KwSnvqVZ2oXvkfl3gBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6181
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,TO_NO_BRKTS_FROM_MSSP,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The LPUART hardware doesn't zero out the parity bit on the received
characters. This behavior won't impact the use cases of CS8 because
the parity bit is the 9th bit which is not currently used by software.
But the parity bit for CS7 must be zeroed out by software in order to
get the correct raw data.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
changes in v2
- remove the "inline" keyword from the function of lpuart_tty_insert_flip_string;

changes in v1
- fix the code indent and whitespace issue;

 drivers/tty/serial/fsl_lpuart.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index fc7d235a1e270..afa0f941c862f 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -274,6 +274,8 @@ struct lpuart_port {
 	int			rx_dma_rng_buf_len;
 	unsigned int		dma_tx_nents;
 	wait_queue_head_t	dma_wait;
+	bool			is_cs7; /* Set to true when character size is 7 */
+					/* and the parity is enabled		*/
 };

 struct lpuart_soc_data {
@@ -1022,6 +1024,9 @@ static void lpuart32_rxint(struct lpuart_port *sport)
 				flg = TTY_OVERRUN;
 		}

+		if (sport->is_cs7)
+			rx &= 0x7F;
+
 		if (tty_insert_flip_char(port, rx, flg) == 0)
 			sport->port.icount.buf_overrun++;
 	}
@@ -1107,6 +1112,17 @@ static void lpuart_handle_sysrq(struct lpuart_port *sport)
 	}
 }

+static int lpuart_tty_insert_flip_string(struct tty_port *port,
+	unsigned char *chars, size_t size, bool is_cs7)
+{
+	int i;
+
+	if (is_cs7)
+		for (i = 0; i < size; i++)
+			chars[i] &= 0x7F;
+	return tty_insert_flip_string(port, chars, size);
+}
+
 static void lpuart_copy_rx_to_tty(struct lpuart_port *sport)
 {
 	struct tty_port *port = &sport->port.state->port;
@@ -1217,7 +1233,8 @@ static void lpuart_copy_rx_to_tty(struct lpuart_port *sport)
 	if (ring->head < ring->tail) {
 		count = sport->rx_sgl.length - ring->tail;

-		copied = tty_insert_flip_string(port, ring->buf + ring->tail, count);
+		copied = lpuart_tty_insert_flip_string(port, ring->buf + ring->tail,
+					count, sport->is_cs7);
 		if (copied != count)
 			sport->port.icount.buf_overrun++;
 		ring->tail = 0;
@@ -1227,7 +1244,8 @@ static void lpuart_copy_rx_to_tty(struct lpuart_port *sport)
 	/* Finally we read data from tail to head */
 	if (ring->tail < ring->head) {
 		count = ring->head - ring->tail;
-		copied = tty_insert_flip_string(port, ring->buf + ring->tail, count);
+		copied = lpuart_tty_insert_flip_string(port, ring->buf + ring->tail,
+					count, sport->is_cs7);
 		if (copied != count)
 			sport->port.icount.buf_overrun++;
 		/* Wrap ring->head if needed */
@@ -2066,6 +2084,7 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 	ctrl = old_ctrl = lpuart32_read(&sport->port, UARTCTRL);
 	bd = lpuart32_read(&sport->port, UARTBAUD);
 	modem = lpuart32_read(&sport->port, UARTMODIR);
+	sport->is_cs7 = false;
 	/*
 	 * only support CS8 and CS7, and for CS7 must enable PE.
 	 * supported mode:
@@ -2184,6 +2203,9 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 	lpuart32_write(&sport->port, ctrl, UARTCTRL);
 	/* restore control register */

+	if ((ctrl & (UARTCTRL_PE | UARTCTRL_M)) == UARTCTRL_PE)
+		sport->is_cs7 = true;
+
 	if (old && sport->lpuart_dma_rx_use) {
 		if (!lpuart_start_rx_dma(sport))
 			rx_dma_timer_init(sport);
--
2.25.1

