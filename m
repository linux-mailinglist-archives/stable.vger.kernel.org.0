Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBB0635918
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbiKWKGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236161AbiKWKGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:06:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2DC12522A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:56:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85430B81EF0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8357C433D6;
        Wed, 23 Nov 2022 09:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197389;
        bh=Bh+0qot04Uekb+x/srQItX55tmV87W73TraLf0NtkqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNK06R7aj5hnHDyvpa2uVUj5ah7Q1qG8Sh9JsHpC5YcI1qiUIkhJ8ERmqBZqvAYqz
         F5G8tYWqb3nb2CHmkNQ2Z94PU0xuut/VJFfzGlxqOMftHdqH3yeN+8GddiToxcvxYn
         05DAgS9kixffaukkZqs3Jx0Fm3oM/mimo6M/cQkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 6.0 281/314] nvme: restrict management ioctls to admin
Date:   Wed, 23 Nov 2022 09:52:06 +0100
Message-Id: <20221123084638.276777129@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

commit 23e085b2dead13b51fe86d27069895b740f749c0 upstream.

The passthrough commands already have this restriction, but the other
operations do not. Require the same capabilities for all users as all of
these operations, which include resets and rescans, can be disruptive.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -764,11 +764,17 @@ long nvme_dev_ioctl(struct file *file, u
 	case NVME_IOCTL_IO_CMD:
 		return nvme_dev_user_cmd(ctrl, argp);
 	case NVME_IOCTL_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		dev_warn(ctrl->device, "resetting controller\n");
 		return nvme_reset_ctrl_sync(ctrl);
 	case NVME_IOCTL_SUBSYS_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		return nvme_reset_subsystem(ctrl);
 	case NVME_IOCTL_RESCAN:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		nvme_queue_scan(ctrl);
 		return 0;
 	default:


