Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7217C46A2B2
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 18:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237724AbhLFR1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 12:27:49 -0500
Received: from buffalo.u-blox.com ([195.34.89.137]:53008 "EHLO
        buffalo.u-blox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbhLFR1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 12:27:48 -0500
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2021 12:27:48 EST
Received: from mail_filter (localhost [127.0.0.1])
        by buffalo.u-blox.com (PF_LO_10026) with ESMTP id DB6373A1FA
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 18:15:44 +0100 (CET)
Received: from ASSP.nospam (localhost [127.0.0.1])
        by buffalo.u-blox.com (Postfix) with ESMTP id B343639E44;
        Mon,  6 Dec 2021 18:15:44 +0100 (CET)
Received: from unknown ([127.0.0.1] helo=anyhost.local) by ASSP.nospam with
        SMTP (2.4.7); 6 Dec 2021 18:15:44 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEgOpf9xbMB/J9BzX5gzwSlI/0mue6wGe6f6ddIosXZ/f/lA+LKUX4mUHKwNuGHbl9e5dc+h4pkoAu0Mu4tUtc82KCICQCHKrfYvJ6jMnaRlXG1qVL5zA7Hj4/XGFUtSuSu2JviB2OfV3/RIZKazyOizd+Ar0ea8HUFvAlnx5AmuO1naJAzo0ljxaUCeL0fsHeGVf+2YbUG2lvJP6zhK8vMrBKmHbc1e81VonFL4mY3EiHY18zjc130Qe7wnZ4xIrh3cmLV9TSJSQjKI2zerAxvlFETGRkR40qptgTladCPvx0z3d0/cJ7TyUgosPxLnxWL0pzGWkN9AkHqv6JdZ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aygLCurVC6gEQqLifn3GKr6z1eUEATg2vYrN5a6b1Dc=;
 b=Ey48ClcU0iwgW1xOi5OhtXyiJOs5rwZmpjI8MrlXQhDN2HUD2UFPSfNXuIS7k0NR3YVZYZcnr8keXMw76VAdO0xR5ZAzlI2kuz6uY4jlPciTZDR/B+/+fMk0yG4bCKb7AOxgOCN/LzCz+2w6iMkYNarDDmYe+LPFFZKFcJnqnUqxipG2HHg3/IdpOMFfYB+UfRphZf2I2wQvrMra/edHAnP2aZejmVjbxTZWUdWY97jK7OMQqmVV1xK2WI31OPn3XAT5YREW16siYoTcMD0Yo5LyFBm9JtfK2T8+OC9mXNJJ6vMRyj74jZ0EBkyPpy6yviHC6e68bfkzmQ7VXJeCNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=u-blox.com; dmarc=pass action=none header.from=u-blox.com;
 dkim=pass header.d=u-blox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=u-blox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aygLCurVC6gEQqLifn3GKr6z1eUEATg2vYrN5a6b1Dc=;
 b=ftWy17QlJFtWzLVkKahjguPsIKE5YjYXPRo4pEvO17P4o/PCdg3tZEDTxNaUiFg8Es/4i1ToOdjQGLyfklDGKgKUNgTZzon2xov7ufZJnm1rl4nXshEEb5UOIEBFKoAtaWLDm55vB8lNVi9pYTf5bBq3sMfGlV9qSXo/1Eq59cU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=u-blox.com;
From:   Patrik John <patrik.john@u-blox.com>
To:     <stable@vger.kernel.org>
CC:     Patrik John <patrik.john@u-blox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] serial: tegra: Change lower tolerance baud rate limit for tegra20 and tegra30
Date:   Mon,  6 Dec 2021 18:14:57 +0100
Message-Id: <sig.0974db5058.20211206171457.1639733-1-patrik.john@u-blox.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8P189CA0010.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:31f::9) To CWXP265MB2072.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:7c::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abafb560-3324-4263-3b9b-08d9b8dc05bc
X-MS-TrafficTypeDiagnostic: CWLP265MB2113:EE_
X-Microsoft-Antispam-PRVS: <CWLP265MB2113FD6B614D47C1B4129F03CC6D9@CWLP265MB2113.GBRP265.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:262;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zdhRvShhmyaLTKaf+pqp2tAUYvevFZmpPpyqkVdtbvDwvDNp6KcyY2KhfFZGigsF1m0+D62IPNvIgZIoxGUqqaxMoo9jk+bXGvWnlNGaLGCqYhQqyMju8ZyQh82qaoGo0K2uDnO6kmLh6rfKhqVrWp/Vw+FVzp4akBlim5hIbd3NXbM7ctvFljYiJBTyCmj8xs+loFmXaEkHU047WwoYzR/IVnF9+F7/xKp3RuJGfb/fgboE1ShEzIcE6bxbdnfQur8bDiEOsLgNI6IWVilmK40UINXmtpLUN9EIqNFiBL/8jMQNp+1Fq1DaplxDsMMy4i2lxh9tk2fyJPz6cocPWKR4QsoTk6j7hvqYqQnArniAFv5qOgSB2AvnhprGPJI2/rtv+/CyGL4IeDMCoxShMm5dAhcbVAu2YD9x++GgnssyoqO4rZvC4U3er89wjFipvDVjozl6yQkq6Dt6nkrnX0CDR9FFHECqNsAY+MhWus0VvEV5vyUxDaK9mTPBDKa2rSofSZYwcMygt/04IXCdpeTz7LX+2XZw/tuCmBlou/mRgTlgwCuuzit52AKmp0a5jjYdLl2Mnoxe8TLaWJ3TW+CeE4VtnsO2oy/BfEuuAo9lASiPKfV6tcn67gGNTWT2ogVn8lN7o72HQQm4Zdi/RRJ654OFjQGUXjCvctG9PwCIBVmFED6r+PLlD3kXBTfTLs7lQx4Gu+YJ9hWLehp3W06T4bVBPxCly5q9M381HoGugKwPQvdoEuGJINjndp1KgJ8b3sJXAv427aAwb6ZoRJFFBvnZCxo5XkZpgjUa8DGy9Zlu0r+X+5JKffJgHjio
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP265MB2072.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66946007)(6486002)(966005)(508600001)(26005)(6506007)(66476007)(6916009)(1076003)(38350700002)(36756003)(6512007)(38100700002)(186003)(2616005)(956004)(44832011)(86362001)(83380400001)(5660300002)(6666004)(4326008)(2906002)(316002)(54906003)(8676002)(52116002)(8936002)(16453003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ata7G2Jb0KdEmnR6cJwa/Nl5UmOYhSmPjGU8EHC7G7AzsENcLYvszli8s9CL?=
 =?us-ascii?Q?PJUg3RBfmzix4WXW2JhrD0QC8jGkU2RfnWR4yZ6Wp6349iDwgky+l+2Sq8jM?=
 =?us-ascii?Q?CvUtjRBbgBvZmVGWuhI8rlCYYs5Qq1bQLxSTuRD4tm39KXjnPq1BfPJFHRXP?=
 =?us-ascii?Q?egGLAtDZ23bQueQhuwaSFBQazZOYl6pcHk8vl13mCpjtL4akcWUqVvVSHbSv?=
 =?us-ascii?Q?SuH+OKQ/nHI0/Su6TSQJkS5AasFCK5CJoM9j8D2e9kp8V9w/ZU5eDKkgX+HY?=
 =?us-ascii?Q?3Y3ugHut6xpQhNOIzVTvG/TXh0kpLHJnHwIoRMcRpaysR2nw2PUx85jtAQJF?=
 =?us-ascii?Q?cbrGqfmmY/jTWzegTcluHBvYzYVRRARcQpSmMQBM0fsZji7Z8YhZo75aAPjt?=
 =?us-ascii?Q?h7qwi17IvKgWDfYiR4EByQwtSpKVoeENRXgNVfbtZ3mpOMHmpPYUcugH7dSC?=
 =?us-ascii?Q?uwY0GXSeSPzvXYvQ5Re69MgKSylfOyID8JuUIq9gJYG9dDbuUoDXJNTJ94a7?=
 =?us-ascii?Q?/RhiyqMMfC5XQ285nwsPsytkp9X/u3zhNn1u5I+n7n6IzXeR+t5QOrOdIRD3?=
 =?us-ascii?Q?jo+MJUNvwGHlRifCdVYgh6NRVkFRUzsdmR9xoZDQSpWn0mv03xT2ctl7A9jO?=
 =?us-ascii?Q?x7VfEEBiZStNr40imaORWtUe1BCMrBLxaMAUJdMbRt59yqDiGNMjTy3NZIJb?=
 =?us-ascii?Q?xixFlhDLKaYth4jDEts4hhkJEfU/7QYyT7ku8dYAj5+seCfgl77DbL+FLIEt?=
 =?us-ascii?Q?IqBZwWjea+62ZhJRGuxA47QAuea2/wvLxZsz6abvUNzkOeRUAEmBAkAoS8RT?=
 =?us-ascii?Q?moaM5NagMIIrDDaiIjV6Rwsr4oQaKrVeJHZfLqOrsNNK2zY0DDhq5ng3V73N?=
 =?us-ascii?Q?Vn2QGh0H4zNufeO03Pn0SRIUecNVLuyez9FRKRvXznLOxd0RsPw9ZbPh6/eA?=
 =?us-ascii?Q?FUaP+7xyOruNdG7zRtXIZmy+aWLbJZGgYsBbN0NbpQ6UuU9C4RLvjIrT8YHI?=
 =?us-ascii?Q?seNaQGozYyXj+fRNBld7cm29AJrwdN1nDwBFxOaRLcrMOXj6V4rUuQSzJSfe?=
 =?us-ascii?Q?jj0b9+CdPw0jtvb2PM/GsWOWPTwhrPBE4MicI4F+ALAnOw89ncWm7oLnWdT9?=
 =?us-ascii?Q?mBVC0adpA9sV2mEas9rlsYL+60jzZLW2f8aLqs5l8+3POHukmTNZk5gNBAh4?=
 =?us-ascii?Q?Cg5+QEPD+c4wCInyVrswDR6JZv8QwsTEsFbFqtbQJ7NIGkI5VlhlJyRS6Az8?=
 =?us-ascii?Q?i1nuqrYsOX8J4OwOcELlsCZPrHTnsS07lyUcCyU0c61kPJBAxHeXHPAkOQNy?=
 =?us-ascii?Q?NAWFtApPT99qwJETOhAUApTr4O1x1gtDUU2hh6rCIVt8+ChTlCLICK9VOdKH?=
 =?us-ascii?Q?no3pZ0ezlH39G+tZpqHU0hhirEnPlp5mXasTTzrrrmVHkdcI857xUFO3u5zc?=
 =?us-ascii?Q?Z2xzDmCyKonZnsNynIO1lT3mutDUSsJVM5NG1Sk6DZdyifBkM4QlAZXPMhuD?=
 =?us-ascii?Q?fL7mqFECT2ZWA28C74BXxncqhUDmRlnjt7p/W4y5ylyfIfjjfOTxsODvHf48?=
 =?us-ascii?Q?4N76rYvG/Pc3e5KYThj0iQy+XIYdqiF5E3rdl4v/FdwZ3R7e7Zd6JaCIm0gY?=
 =?us-ascii?Q?tY0iSzauyysqf+USOjgDx/k=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: abafb560-3324-4263-3b9b-08d9b8dc05bc
X-MS-Exchange-CrossTenant-AuthSource: CWXP265MB2072.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 17:15:37.9049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 80c4ffa6-7511-4bba-9f03-e5872a660c9b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2oWItdji/V8JJxot7CgICxyQUv4Mt2OM2X1Q7ocakSMwEX5F44XiuepvevkhK2CCxH/+f+xe/hlYry2r1UFMlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB2113
X-OriginatorOrg: u-blox.com
X-Assp-Version: 2.4.7(16004) on ASSP.nospam
X-Assp-ID: ASSP.nospam 10944-06953
X-Assp-Session: 84838FC0 (mail 1)
X-Assp-Original-Subject: [PATCH] serial: tegra: Change lower tolerance baud
        rate limit for tegra20 and tegra30
X-Assp-Client-TLS: yes
X-Virus-Scanned: clamav-milter 0.99.4 at buffalo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b40de7469ef135161c80af0e8c462298cc5dac00 upstream.

The current implementation uses 0 as lower limit for the baud rate
tolerance for tegra20 and tegra30 chips which causes isses on UART
initialization as soon as baud rate clock is lower than required even
when within the standard UART tolerance of +/- 4%.

This fix aligns the implementation with the initial commit description
of +/- 4% tolerance for tegra chips other than tegra186 and tegra194.

Fixes: d781ec21bae6 ("serial: tegra: report clk rate errors")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Patrik John <patrik.john@u-blox.com>
Link: https://lore.kernel.org/r/sig.19614244f8.20211123132737.88341-1-patrik.john@u-blox.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Backport for 5.4-stable 

 drivers/tty/serial/serial-tegra.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 64f18bf1e694..74c21152367a 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1494,7 +1494,7 @@ static struct tegra_uart_chip_data tegra20_uart_chip_data = {
 	.fifo_mode_enable_status	= false,
 	.uart_max_port			= 5,
 	.max_dma_burst_bytes		= 4,
-	.error_tolerance_low_range	= 0,
+	.error_tolerance_low_range	= -4,
 	.error_tolerance_high_range	= 4,
 };
 
@@ -1505,7 +1505,7 @@ static struct tegra_uart_chip_data tegra30_uart_chip_data = {
 	.fifo_mode_enable_status	= false,
 	.uart_max_port			= 5,
 	.max_dma_burst_bytes		= 4,
-	.error_tolerance_low_range	= 0,
+	.error_tolerance_low_range	= -4,
 	.error_tolerance_high_range	= 4,
 };
 
-- 
2.25.1

