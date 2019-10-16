Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC27D9DC5
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437517AbfJPVxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437513AbfJPVxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:20 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFD9B21A4C;
        Wed, 16 Oct 2019 21:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262799;
        bh=VIgycL42FaxYZvfYvFylTUsM+pW3BJ+crMbYSoZQlCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLCbxOL6yooFWwVOWcVk4vZcUcBQXrTyTCj8TP2dTlgi8EnU8wxhIVegK3sL9DDB7
         kUDIxWwLefjq1CqmgiB+S+E+ldjJrwzwZCGdxlle7flMptoZ4MQVVPrfv/qTPqWWZn
         0ZA1f5ImqUmUao/3P2UmKME1FaVIekyCvJ+Fnsrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sebastian Ott <sebott@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.4 04/79] s390/cio: exclude subchannels with no parent from pseudo check
Date:   Wed, 16 Oct 2019 14:49:39 -0700
Message-Id: <20191016214733.936954745@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit ab5758848039de9a4b249d46e4ab591197eebaf2 upstream.

ccw console is created early in start_kernel and used before css is
initialized or ccw console subchannel is registered. Until then console
subchannel does not have a parent. For that reason assume subchannels
with no parent are not pseudo subchannels. This fixes the following
kasan finding:

BUG: KASAN: global-out-of-bounds in sch_is_pseudo_sch+0x8e/0x98
Read of size 8 at addr 00000000000005e8 by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.0-rc8-07370-g6ac43dd12538 #2
Hardware name: IBM 2964 NC9 702 (z/VM 6.4.0)
Call Trace:
([<000000000012cd76>] show_stack+0x14e/0x1e0)
 [<0000000001f7fb44>] dump_stack+0x1a4/0x1f8
 [<00000000007d7afc>] print_address_description+0x64/0x3c8
 [<00000000007d75f6>] __kasan_report+0x14e/0x180
 [<00000000018a2986>] sch_is_pseudo_sch+0x8e/0x98
 [<000000000189b950>] cio_enable_subchannel+0x1d0/0x510
 [<00000000018cac7c>] ccw_device_recognition+0x12c/0x188
 [<0000000002ceb1a8>] ccw_device_enable_console+0x138/0x340
 [<0000000002cf1cbe>] con3215_init+0x25e/0x300
 [<0000000002c8770a>] console_init+0x68a/0x9b8
 [<0000000002c6a3d6>] start_kernel+0x4fe/0x728
 [<0000000000100070>] startup_continue+0x70/0xd0

Cc: stable@vger.kernel.org
Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/cio/css.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -1120,6 +1120,8 @@ device_initcall(cio_settle_init);
 
 int sch_is_pseudo_sch(struct subchannel *sch)
 {
+	if (!sch->dev.parent)
+		return 0;
 	return sch == to_css(sch->dev.parent)->pseudo_subchannel;
 }
 


