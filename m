Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A617347ADB9
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbhLTOyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:54:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43646 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236485AbhLTOwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:52:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63406611A5;
        Mon, 20 Dec 2021 14:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFA3C36AE8;
        Mon, 20 Dec 2021 14:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011932;
        bh=TQu3W0rMeGA1efmmn8RVxCfFt0dZ0/rnkNJfyqDla5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFChsYoA+TmK78VdBCH8isz3wI6Ypa7E1VETOtdkx6AE8UEzgm48tJ3oFtNSpLNvF
         eZeL1nU75GW7PcNQ5S7teHpgftWNkb3Qoa1ydJ/aV3JPebmmMRkmor5pE/PO4H/6C1
         UJEKIo3fw/Xh6K6RQO0uSNn9wUP7hni9XM/AXtsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.15 020/177] vduse: fix memory corruption in vduse_dev_ioctl()
Date:   Mon, 20 Dec 2021 15:32:50 +0100
Message-Id: <20211220143040.759576672@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit ff9f9c6e74848170fcb45c8403c80d661484c8c9 upstream.

The "config.offset" comes from the user.  There needs to a check to
prevent it being out of bounds.  The "config.offset" and
"dev->config_size" variables are both type u32.  So if the offset if
out of bounds then the "dev->config_size - config.offset" subtraction
results in a very high u32 value.  The out of bounds offset can result
in memory corruption.

Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211208103307.GA3778@kili
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -975,7 +975,8 @@ static long vduse_dev_ioctl(struct file
 			break;
 
 		ret = -EINVAL;
-		if (config.length == 0 ||
+		if (config.offset > dev->config_size ||
+		    config.length == 0 ||
 		    config.length > dev->config_size - config.offset)
 			break;
 


