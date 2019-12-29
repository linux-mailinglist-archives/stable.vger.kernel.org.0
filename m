Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE6212C921
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731909AbfL2SAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733164AbfL2R47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD5CB206DB;
        Sun, 29 Dec 2019 17:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642218;
        bh=0T3IJT93N5Anr4WNVXlXzLO8Ah8HVONpz677hD+2zY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqJWFCp57gUI3mqZucZWTjoRTnBpmD7NmJibiIOK4wPfN9jKLbmwGsWTuqb2VHxkR
         bJaG4BXfZwoLAYyn7Jzft8abTgzuSR/ICH0o8Vx1oI8rG8X4uXUMczPnHt5IPXYkik
         XK4Tyvqq+YZMwHdq5d38Np+2lARPKfjeFVGP82BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 391/434] spi: fsl: dont map irq during probe
Date:   Sun, 29 Dec 2019 18:27:24 +0100
Message-Id: <20191229172728.269250404@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 3194d2533efffae8b815d84729ecc58b6a9000ab upstream.

With lastest kernel, the following warning is observed at startup:

[    1.500609] ------------[ cut here ]------------
[    1.505225] remove_proc_entry: removing non-empty directory 'irq/22', leaking at least 'fsl_spi'
[    1.514234] WARNING: CPU: 0 PID: 1 at fs/proc/generic.c:682 remove_proc_entry+0x198/0x1c0
[    1.522403] CPU: 0 PID: 1 Comm: swapper Not tainted 5.4.0-s3k-dev-02248-g93532430a4ff #2564
[    1.530724] NIP:  c0197694 LR: c0197694 CTR: c0050d80
[    1.535762] REGS: df4a5af0 TRAP: 0700   Not tainted  (5.4.0-02248-g93532430a4ff)
[    1.543818] MSR:  00029032 <EE,ME,IR,DR,RI>  CR: 22028222  XER: 00000000
[    1.550524]
[    1.550524] GPR00: c0197694 df4a5ba8 df4a0000 00000054 00000000 00000000 00004a38 00000010
[    1.550524] GPR08: c07c5a30 00000800 00000000 00001032 22000208 00000000 c0004b14 00000000
[    1.550524] GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 c0830000 c07fc078
[    1.550524] GPR24: c08e8ca0 df665d10 df60ea98 c07c9db8 00000001 df5d5ae3 df5d5a80 df43f8e3
[    1.585327] NIP [c0197694] remove_proc_entry+0x198/0x1c0
[    1.590628] LR [c0197694] remove_proc_entry+0x198/0x1c0
[    1.595829] Call Trace:
[    1.598280] [df4a5ba8] [c0197694] remove_proc_entry+0x198/0x1c0 (unreliable)
[    1.605321] [df4a5bd8] [c0067acc] unregister_irq_proc+0x5c/0x70
[    1.611238] [df4a5bf8] [c005fbc4] free_desc+0x3c/0x80
[    1.616286] [df4a5c18] [c005fe2c] irq_free_descs+0x70/0xa8
[    1.621778] [df4a5c38] [c033d3fc] of_fsl_spi_probe+0xdc/0x3cc
[    1.627525] [df4a5c88] [c02f0f64] platform_drv_probe+0x44/0xa4
[    1.633350] [df4a5c98] [c02eee44] really_probe+0x1ac/0x418
[    1.638829] [df4a5cc8] [c02ed3e8] bus_for_each_drv+0x64/0xb0
[    1.644481] [df4a5cf8] [c02ef950] __device_attach+0xd4/0x128
[    1.650132] [df4a5d28] [c02ed61c] bus_probe_device+0xa0/0xbc
[    1.655783] [df4a5d48] [c02ebbe8] device_add+0x544/0x74c
[    1.661096] [df4a5d88] [c0382b78] of_platform_device_create_pdata+0xa4/0x100
[    1.668131] [df4a5da8] [c0382cf4] of_platform_bus_create+0x120/0x20c
[    1.674474] [df4a5df8] [c0382d50] of_platform_bus_create+0x17c/0x20c
[    1.680818] [df4a5e48] [c0382e88] of_platform_bus_probe+0x9c/0xf0
[    1.686907] [df4a5e68] [c0751404] __machine_initcall_cmpcpro_cmpcpro_declare_of_platform_devices+0x74/0x1a4
[    1.696629] [df4a5e98] [c072a4cc] do_one_initcall+0x8c/0x1d4
[    1.702282] [df4a5ef8] [c072a768] kernel_init_freeable+0x154/0x204
[    1.708455] [df4a5f28] [c0004b2c] kernel_init+0x18/0x110
[    1.713769] [df4a5f38] [c00122ac] ret_from_kernel_thread+0x14/0x1c
[    1.719926] Instruction dump:
[    1.722889] 2c030000 4182004c 3863ffb0 3c80c05f 80e3005c 388436a0 3c60c06d 7fa6eb78
[    1.730630] 7fe5fb78 38840280 38634178 4be8c611 <0fe00000> 4bffff6c 3c60c071 7fe4fb78
[    1.738556] ---[ end trace 05d0720bf2e352e2 ]---

The problem comes from the error path which calls
irq_dispose_mapping() while the IRQ has been requested with
devm_request_irq().

IRQ doesn't need to be mapped with irq_of_parse_and_map(). The only
need is to get the IRQ virtual number. For that, use
of_irq_to_resource() instead of the
irq_of_parse_and_map()/irq_dispose_mapping() pair.

Fixes: 500a32abaf81 ("spi: fsl: Call irq_dispose_mapping in err path")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Link: https://lore.kernel.org/r/518cfb83347d5372748e7fe72f94e2e9443d0d4a.1575905123.git.christophe.leroy@c-s.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-fsl-spi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -736,8 +736,8 @@ static int of_fsl_spi_probe(struct platf
 	if (ret)
 		goto err;
 
-	irq = irq_of_parse_and_map(np, 0);
-	if (!irq) {
+	irq = of_irq_to_resource(np, 0, NULL);
+	if (irq <= 0) {
 		ret = -EINVAL;
 		goto err;
 	}
@@ -751,7 +751,6 @@ static int of_fsl_spi_probe(struct platf
 	return 0;
 
 err:
-	irq_dispose_mapping(irq);
 	return ret;
 }
 


